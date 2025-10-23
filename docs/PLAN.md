# 📋 Plano de Implementação - Previsor Financeiro v1.0

> **Projeto:** Previsor Financeiro (MVP)
> **Framework:** Flutter 3.x com Dart 3.x
> **Última Atualização:** 23 de outubro de 2025

---

## 🎯 Visão Geral do Projeto

### Objetivo
Desenvolver um aplicativo mobile de controle financeiro pessoal que elimina o atrito do uso de planilhas, oferecendo uma resposta instantânea à pergunta: **"Quanto ainda posso gastar este mês?"**

### Pilares Técnicos
1. **Reatividade Instantânea:** UI reflete mudanças em tempo real sem refresh manual
2. **Performance Nativa:** Experiência fluida a 60 FPS
3. **Arquitetura Escalável:** Clean Architecture preparada para crescimento futuro

### Stack Tecnológica
| Componente | Tecnologia | Versão |
|------------|------------|--------|
| Framework | Flutter | 3.35.6 |
| Linguagem | Dart | 3.9.2 |
| Banco de Dados | Isar Database | 3.1.0+1 |
| Gestão de Estado | Riverpod | 3.0.3 |
| Testes | flutter_test, integration_test | Latest |
| CI/CD | GitHub Actions | - |

---

## 🌿 Estratégia de Branching

### Git Flow Adaptado (Solo Development)

```
main (develop)
  ├── feature/nome-da-feature
  ├── chore/nome-da-tarefa
  ├── refactor/nome-do-refactor
  └── fix/nome-do-bugfix
```

### Convenções de Nomenclatura

| Tipo | Prefixo | Uso | Exemplo |
|------|---------|-----|---------|
| Nova funcionalidade | `feature/` | Implementação de novas features | `feature/calculator-ui` |
| Configuração/Setup | `chore/` | Tarefas de setup, dependências, configs | `chore/project-setup` |
| Refatoração | `refactor/` | Melhorias de código sem mudar funcionalidade | `refactor/clean-architecture` |
| Correção de bugs | `fix/` | Correção de erros e bugs | `fix/recurring-logic` |

### Fluxo de Trabalho
1. Criar branch a partir de `develop`
2. Implementar a tarefa
3. Testar conforme Definition of Done
4. Fazer merge para `develop`
5. Marcar checkbox como `[x]` neste documento

---

## 📊 Progresso Geral

**Total de Tarefas:** 39
**Concluídas:** 27 / 39 (69%)

### Por Fase
- **Fase 1 - Fundação:** 4 / 4 (100%)
- **Fase 2 - Registro de Gastos:** 4 / 4 (100%)
- **Fase 3 - Dashboard Reativo:** 4 / 4 (100%)
- **Fase 4 - Funcionalidades de Suporte:** 4 / 5 (80%)
- **Fase 5 - Primeira Iteração:** 5 / 5 (100%)
- **Fase 6 - Segunda Iteração:** 3 / 3 (100%)
- **Fase 7 - Terceira Iteração:** 2 / 2 (100%)
- **Fase 8 - Quarta Iteração:** 5 / 6 (83%)
- **Fase 9 - Quinta Iteração:** 0 / 2 (0%)

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

---

## 🔧 Fase 8: Quarta Iteração - Correções Críticas e Refinamentos de UX

**Objetivo:** Corrigir bugs críticos no sistema de input numérico, melhorar a experiência de uso do bottom sheet de transações e refinar interações da lista de transações.

**Status:** 5 / 6 tarefas concluídas

---

### [x] F8-T1: Correção - Sistema de Input Numérico tipo Nubank

**Branch:** `fix/nubank-style-input`

**Descrição:**
Corrigir bugs críticos no CurrencyTextField e implementar sistema de input numérico inspirado no Nubank, onde o usuário digita sem vírgula e os valores são construídos da direita para a esquerda (centavos primeiro).

**Bugs Atuais a Corrigir:**
1. **Configuração da Reserva:** Inserir "10056,23" resulta em reserva inicial de R$ 0,00
2. **Configuração de Limite:** Inserir "10000" resulta em R$ 1$1000,00 (formatação incorreta)
3. **Cadastro de Conta:** Campo só aceita o primeiro dígito digitado

**Novo Comportamento (Tipo Nubank):**
- Usuário digita apenas números (sem vírgula)
- Sistema constrói o valor da direita para a esquerda
- Exemplos:
  - Digita `1` → R$ 0,01
  - Digita `2` → R$ 0,12
  - Digita `3` → R$ 1,23
  - Digita `4` → R$ 12,34
  - Para R$ 100,56 → Digita `10056`

**Implementação:**
1. **Novo Widget: `NubankStyleCurrencyField`**
   ```dart
   class NubankStyleCurrencyField extends StatefulWidget {
     final String label;
     final double? initialValue;
     final ValueChanged<double> onChanged;
     final String? errorText;

     // TextInputFormatter customizado:
     // - Aceita apenas dígitos
     // - Constrói valor em centavos
     // - Formata exibição como R$ X.XXX,XX
   }
   ```

2. **Lógica de Conversão:**
   - Input interno: string de dígitos (ex: "10056")
   - Valor real: int em centavos → double (10056 → 100.56)
   - Display: formatação brasileira (R$ 100,56)

3. **Backspace:** Remove último dígito (R$ 1,23 → R$ 0,12)

**Locais de Aplicação:**
1. **ExpenseDetailsBottomSheet:** Campo de valor da transação
2. **SettingsScreen:** Campos de salário mensal e saldo da reserva
3. **AccountForm:** Campos de saldo inicial e limite de crédito
4. **RecurringExpenseForm:** Campo de valor da recorrência

**Definition of Done:**
- [x] Widget `NubankStyleCurrencyField` criado em `lib/presentation/widgets/inputs/`
- [x] TextInputFormatter customizado implementado
- [x] Bugs de formatação corrigidos (reserva, limite, conta)
- [x] Comportamento de construção da direita pra esquerda funcional
- [x] Aplicado em todas as 4 telas mencionadas
- [x] Testes de widget para o novo campo
- [x] Testes de formatação e conversão de valores
- [x] Merge realizado para `develop`

---

### [x] F8-T2: Melhoria - Bottom Sheet com Sistema de Abas

**Branch:** `feature/transaction-details-tabs`

**Descrição:**
Dividir o `ExpenseDetailsBottomSheet` em duas páginas navegáveis para resolver o problema de campos ficarem ocultos quando o teclado do Android aparece.

**Problema Atual:**
- Quando o usuário toca em um campo de texto, o teclado abre
- Campos inferiores (Notas, Categoria, Data) ficam escondidos atrás do teclado
- Usuário precisa fechar o teclado para acessar esses campos
- Experiência frustrante e lenta

**Solução: Sistema de Abas/Páginas**

**Página 1 (Dados Principais):**
- ✅ Valor
- ✅ Descrição
- ✅ Conta (dropdown)
- ✅ Débito/Crédito (toggle buttons)

**Página 2 (Dados Complementares):**
- ✅ Notas (opcional)
- ✅ Categoria (dropdown)
- ✅ Data (date picker)

**Implementação:**

1. **Estrutura com PageView:**
   ```dart
   class ExpenseDetailsBottomSheet extends ConsumerStatefulWidget {
     // PageController para navegação entre páginas
     final _pageController = PageController();
     int _currentPage = 0;

     // PageView com 2 páginas
     // Indicador de página (dots)
     // Botões "Próximo" / "Anterior"
   }
   ```

2. **Navegação:**
   - **Página 1:** Botão "Próximo" no canto inferior direito
   - **Página 2:** Botão "Anterior" no canto inferior esquerdo
   - Indicador visual de página atual (dots ou barra)
   - Swipe horizontal para alternar (opcional)

3. **Validação:**
   - Campos obrigatórios da Página 1 validados antes de permitir "Próximo"
   - Botão "Salvar" só visível na Página 2
   - Botão "Cancelar" visível em ambas as páginas

4. **Estado Compartilhado:**
   - Manter o mesmo `ExpenseFormNotifier` do Riverpod
   - Dados persistem ao navegar entre páginas
   - Componente único para criação E edição (não criar telas separadas)

**Definition of Done:**
- [x] PageView implementado no `ExpenseDetailsBottomSheet`
- [x] Página 1 com campos: Valor, Descrição, Conta, Débito/Crédito
- [x] Página 2 com campos: Notas, Categoria, Data
- [x] Navegação com botões "Próximo" / "Anterior" funcional
- [x] Indicador visual de página atual
- [x] Validação de campos obrigatórios antes de avançar
- [x] Todos os campos visíveis mesmo com teclado aberto
- [x] Componente continua funcionando para criação E edição
- [x] Testes de widget atualizados
- [x] Merge realizado para `develop`

---

### [x] F8-T3: Melhoria - Swipe-to-Delete com Undo no Toast

**Branch:** `enhancement/slidable-delete`

**Descrição:**
Remover a ação de swipe-to-edit e melhorar o swipe-to-delete com padrão de "Undo" no toast de sucesso (similar ao Gmail), onde a exclusão só é efetivada após o usuário interagir em outro lugar da tela.

**Mudanças de Comportamento:**

1. **REMOVER: Swipe-to-Edit**
   - Deslizar para a direita não deve mais editar
   - Edição será feita apenas por **toque no card**

2. **MELHORAR: Swipe-to-Delete com Undo Toast**
   - Usuário arrasta card para a esquerda (swipe-to-delete)
   - Card sai da tela com animação
   - SnackBar/Toast aparece: **"Transação excluída"** com botão **"Desfazer"**
   - **Exclusão NÃO é executada imediatamente**
   - **Toast NÃO desaparece por timeout** - permanece visível até interação do usuário
   - Se usuário clicar **"Desfazer"**: card volta para a lista, nenhuma alteração no banco
   - Se usuário clicar **em qualquer outro lugar da tela**: toast fecha e exclusão é efetivada (remove do banco, reverte saldo/limite)

**Implementação:**

**1. Manter Implementação Atual com `Dismissible`**
```dart
Dismissible(
  key: ValueKey(transaction.id),
  direction: DismissDirection.endToStart,
  onDismissed: (direction) {
    // NÃO deletar imediatamente, apenas mostrar toast com undo
    _showUndoToast(context, transaction, index);
  },
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 16),
    child: Icon(Icons.delete, color: Colors.white),
  ),
  child: TransactionCard(
    transaction: transaction,
    onTap: () => _editTransaction(transaction),
  ),
)
```

**2. Toast com Undo (Similar ao Gmail)**
```dart
void _showUndoToast(BuildContext context, Transaction transaction, int index) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  // Remover da lista local (UI state), mas NÃO do banco ainda
  setState(() {
    _transactions.removeAt(index);
  });

  // SnackBar com ação de Undo (duração muito longa, fecha apenas por interação)
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Text('Transação excluída'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          // Restaurar na lista local (cancelar exclusão)
          setState(() {
            _transactions.insert(index, transaction);
          });
        },
      ),
      duration: Duration(days: 365), // Duração indefinida, não fecha por timeout
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.none, // Não permite swipe para fechar
    ),
  ).closed.then((reason) {
    // Executar exclusão apenas se NÃO foi undo
    if (reason != SnackBarClosedReason.action) {
      _executeDelete(transaction);
    }
  });
}

// Adicionar GestureDetector na tela para detectar toques fora do toast
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Fechar SnackBar ao tocar em qualquer lugar da tela
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    },
    child: Scaffold(
      // ... resto da tela
    ),
  );
}

Future<void> _executeDelete(Transaction transaction) async {
  // Deletar do banco
  await ref.read(transactionRepositoryProvider).delete(transaction.id);

  // Reverter saldo/limite da conta
  final account = await ref.read(accountRepositoryProvider).getById(transaction.accountId);
  if (account != null) {
    if (transaction.isDebit) {
      await ref.read(accountRepositoryProvider).updateBalance(
        transaction.accountId,
        account.balance + transaction.value, // Reverter débito
      );
    } else {
      await ref.read(accountRepositoryProvider).updateCreditUsed(
        transaction.accountId,
        account.creditUsed - transaction.value, // Reverter crédito
      );
    }
  }
}
```

**3. Estado Local Temporário**
- Manter uma cópia local da lista de transações no estado do widget
- Ao fazer swipe-to-delete, remover da lista local mas NÃO do banco
- Ao clicar "Desfazer", restaurar na lista local
- Toast fica visível indefinidamente (duração de 365 dias, não fecha por timeout)
- Adicionar `GestureDetector` na tela para detectar toque em qualquer lugar
- Ao tocar em qualquer lugar da tela, fechar o toast e executar delete no banco

**Fluxo de Exclusão:**
1. Usuário arrasta card para esquerda
2. Card sai da tela com animação
3. Toast aparece: "Transação excluída" com botão "Desfazer"
4. Toast permanece visível **indefinidamente** (não fecha por timeout)
5. Exclusão fica **pendente** (não executada ainda)
6. **SE** usuário clicar "Desfazer": card volta, toast fecha, nada acontece no banco
7. **SE** usuário clicar em qualquer outro lugar da tela: toast fecha e exclusão é efetivada
   - Transaction é removida do banco
   - Saldo/limite da conta é revertido
   - Lista é atualizada reativamente

**Definition of Done:**
- [x] Swipe-to-edit removido completamente
- [x] Manter implementação atual com `Dismissible` (não adicionar flutter_slidable)
- [x] Toast com botão "Desfazer" implementado
- [x] Toast NÃO fecha por timeout (duration indefinido)
- [x] `GestureDetector` implementado para detectar toque em qualquer lugar da tela
- [x] Exclusão NÃO executada imediatamente ao swipe
- [x] Clicar "Desfazer" restaura o card na lista e fecha o toast
- [x] Clicar em qualquer lugar da tela fecha o toast e executa a exclusão
- [x] Toque no card abre `ExpenseDetailsBottomSheet` para edição
- [x] Lógica de reversão de saldo/limite mantida
- [x] Estado local temporário gerenciado corretamente
- [x] Testes de widget atualizados
- [x] Merge realizado para `develop`

---

### [x] F8-T4: Feature - Alternar Dashboard/Histórico na Aba Início

**Branch:** `feature/toggle-dashboard-history`

**Descrição:**
Permitir que o usuário alterne entre a visualização do Dashboard e o Histórico Completo de Transações ao tocar no botão da aba "Início" na navegação inferior, com suporte ao botão voltar do Android.

**Comportamento Desejado:**

1. **Estado Inicial:** Aba "Início" mostra o `DashboardScreen`

2. **Primeiro Toque na Aba:** Alterna para `TransactionsListScreen` (histórico completo)

3. **Segundo Toque na Aba:** Volta para `DashboardScreen`

4. **Botão Voltar do Android:**
   - Se estiver em `TransactionsListScreen`, voltar para `DashboardScreen`
   - Se estiver em `DashboardScreen`, sair do app

**Implementação:**

1. **Estado de Toggle no MainScreen:**
   ```dart
   @riverpod
   class DashboardViewState extends _$DashboardViewState {
     @override
     DashboardView build() => DashboardView.dashboard;

     void toggle() {
       state = state == DashboardView.dashboard
           ? DashboardView.transactions
           : DashboardView.dashboard;
     }

     void showDashboard() => state = DashboardView.dashboard;
   }

   enum DashboardView { dashboard, transactions }
   ```

2. **Modificar MainScreen:**
   ```dart
   // No onTap do BottomNavigationBarItem do índice 0 (Início)
   void _onTabTapped(int index) {
     if (index == 0) {
       // Alternar entre dashboard e histórico
       ref.read(dashboardViewStateProvider.notifier).toggle();
     } else {
       // Outras abas (Recorrências, Contas)
       setState(() => _selectedIndex = index);
     }
   }

   // No body do Scaffold
   Widget _buildBody() {
     if (_selectedIndex == 0) {
       final view = ref.watch(dashboardViewStateProvider);
       return view == DashboardView.dashboard
           ? const DashboardScreen()
           : const TransactionsListScreen();
     }
     // ... outras abas
   }
   ```

3. **WillPopScope para Botão Voltar:**
   ```dart
   WillPopScope(
     onWillPop: () async {
       final view = ref.read(dashboardViewStateProvider);
       if (view == DashboardView.transactions) {
         ref.read(dashboardViewStateProvider.notifier).showDashboard();
         return false; // Não sair do app
       }
       return true; // Sair do app
     },
     child: Scaffold(...),
   )
   ```

4. **Indicação Visual:**
   - Aba "Início" pode mudar ícone conforme estado (opcional)
   - Dashboard: `Icons.home`
   - Histórico: `Icons.history` ou `Icons.list`

**Definition of Done:**
- [x] Provider `DashboardViewState` criado
- [x] Lógica de toggle implementada no `MainScreen`
- [x] Tocar na aba "Início" alterna entre Dashboard e Histórico
- [x] Botão voltar do Android retorna para Dashboard antes de sair
- [x] `WillPopScope` configurado corretamente
- [x] Transição suave entre as telas
- [x] Indicação visual do estado atual (opcional)
- [x] Testes de widget para a navegação
- [x] Merge realizado para `develop`

---

### [x] F8-T5: Correção - Golden Experience em Permissões de Notificação

**Branch:** `fix/notification-permission-visibility`

**Descrição:**
Investigar e corrigir o problema que impede o aplicativo "Golden Experience" de aparecer na lista de apps com acesso a notificações nas configurações do Android.

**Problema Reportado:**
- Nas configurações do sistema Android, em "Acesso às notificações", o app não aparece como opção
- Isso impede o usuário de conceder permissão para o `flutter_notification_listener`
- Feature de captura automática de transações fica inutilizável

**Causas Possíveis:**

1. **AndroidManifest.xml incompleto:**
   - Falta declaração do `NotificationListenerService`
   - Falta intent-filter correto
   - Permissões não declaradas

2. **Configuração do Service:**
   - Service não registrado corretamente
   - Nome do service incorreto
   - Falta metadata

**Investigação Necessária:**

1. **Verificar AndroidManifest.xml:**
   ```xml
   <service
       android:name="flutter_notification_listener.NotificationsListenerService"
       android:label="@string/app_name"
       android:permission="android.permission.BIND_NOTIFICATION_LISTENER_SERVICE"
       android:exported="true">
       <intent-filter>
           <action android:name="android.service.notification.NotificationListenerService" />
       </intent-filter>
   </service>
   ```

2. **Verificar Permissões:**
   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   <uses-permission android:name="android.permission.BIND_NOTIFICATION_LISTENER_SERVICE"
       tools:ignore="ProtectedPermissions" />
   ```

3. **Verificar Inicialização do Service:**
   ```dart
   // No main.dart
   await NotificationsListener.initialize();
   ```

4. **Testar Fluxo de Permissão:**
   - Abrir configurações via `NotificationsListener.openPermissionSettings()`
   - Verificar se app aparece na lista
   - Conceder permissão manualmente
   - Confirmar se service inicia corretamente

**Correções Esperadas:**
- App aparece na lista "Acesso às notificações"
- Usuário consegue ativar/desativar permissão
- `hasPermission` retorna `true` após concessão
- Service inicia e escuta notificações corretamente

**Definition of Done:**
- [x] Causa raiz identificada e documentada
- [x] `AndroidManifest.xml` corrigido com declarações necessárias
- [x] Permissões adicionadas corretamente
- [x] App aparece em Configurações > Acesso às notificações
- [x] Usuário consegue conceder permissão manualmente
- [x] Service inicia e funciona após permissão concedida
- [x] Testes manuais em dispositivo físico/emulador
- [x] Merge realizado para `develop`

---

### [ ] F8-T6: Melhoria - File Picker para Exportação de Backup

**Branch:** `feature/backup-file-picker`

**Descrição:**
Adicionar funcionalidade de seleção de pasta de destino ao exportar backup, permitindo que o usuário escolha onde salvar o arquivo JSON em vez de usar um diretório fixo.

**Problema Atual:**
- Exportação de backup salva automaticamente em diretório fixo (Documents)
- Usuário não tem controle sobre onde o arquivo é salvo
- Dificulta organização de backups em pastas específicas

**Solução: File Picker Nativo**

**Package a Adicionar:**
```yaml
dependencies:
  file_picker: ^8.1.6
```

**Implementação:**

1. **Modificar Método de Exportação:**
   ```dart
   Future<void> exportBackup(BuildContext context) async {
     try {
       // Gerar JSON do backup
       final backupData = await _generateBackupJson();

       // Solicitar ao usuário escolher local de salvamento
       String? outputPath = await FilePicker.platform.saveFile(
         dialogTitle: 'Salvar Backup',
         fileName: 'golden_experience_backup_${DateTime.now().millisecondsSinceEpoch}.json',
         type: FileType.custom,
         allowedExtensions: ['json'],
       );

       if (outputPath == null) {
         // Usuário cancelou
         return;
       }

       // Salvar arquivo no caminho escolhido
       final file = File(outputPath);
       await file.writeAsString(backupData);

       // Feedback de sucesso com caminho completo
       if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text('Backup salvo em:\n$outputPath'),
             duration: Duration(seconds: 4),
           ),
         );
       }
     } catch (e) {
       // Tratamento de erro
       if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Erro ao salvar backup: $e')),
         );
       }
     }
   }
   ```

2. **UI na Tela de Configurações:**
   ```dart
   ListTile(
     leading: Icon(Icons.upload_file),
     title: Text('Exportar Backup'),
     subtitle: Text('Salvar todos os dados em arquivo JSON'),
     trailing: Icon(Icons.chevron_right),
     onTap: () => exportBackup(context),
   )
   ```

3. **Feedback Visual:**
   - Dialog de carregamento enquanto gera o JSON
   - SnackBar com caminho completo do arquivo salvo
   - Mensagem de erro caso falhe

**Considerações Android:**
- File picker abre interface nativa do Android (Storage Access Framework)
- Usuário pode salvar em Downloads, Google Drive, etc.
- Arquivo fica acessível para compartilhamento

**Definition of Done:**
- [x] Package `file_picker` adicionado ao `pubspec.yaml`
- [x] Método de exportação modificado para usar file picker
- [x] Dialog de seleção de pasta funcional
- [x] Arquivo salvo no local escolhido pelo usuário
- [x] Feedback visual com caminho completo do arquivo
- [x] Tratamento de erro caso salvamento falhe
- [x] Testes manuais em dispositivo Android
- [~] Merge realizado para `develop`

---

## 🎨 Fase 9: Quinta Iteração - Correções de UX e Padronização Visual

**Objetivo:** Corrigir bugs na tela de configurações e padronizar a interface do aplicativo com um app bar consistente em todas as telas principais.

**Status:** 0 / 2 tarefas concluídas

---

### [ ] F9-T1: Correção - Exibição de Valores nas Configurações

**Branch:** `fix/settings-values-display`

**Descrição:**
Corrigir o bug que impede a exibição correta dos valores de salário mensal e saldo da reserva inicial na tela de configurações.

**Problema Atual:**
- Ao abrir a tela de configurações, os campos de "Salário Mensal" e "Saldo da Reserva" não exibem os valores salvos
- Os valores estão persistidos no banco de dados, mas não são carregados corretamente na UI
- Usuário precisa reinserir os valores cada vez que acessa a tela

**Investigação Necessária:**

1. **Verificar Carregamento de Dados:**
   - Confirmar que `AppSettingsRepository.getSettings()` retorna os valores corretos
   - Verificar se o provider de settings está sendo observado corretamente
   - Checar se há algum problema de inicialização do estado do formulário

2. **Verificar Widgets de Input:**
   - Confirmar que os `NubankStyleCurrencyField` estão recebendo o `initialValue` corretamente
   - Verificar se há algum problema de atualização do `TextEditingController`
   - Checar se os valores estão sendo formatados corretamente ao carregar

**Possíveis Causas:**
- Provider não está sendo assistido corretamente na `SettingsScreen`
- `initialValue` não está sendo passado para os campos de input
- Conversão de tipos incorreta (double → string formatada)
- Estado do formulário não está sendo inicializado com os valores do banco

**Implementação Esperada:**

```dart
class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);

    return settingsAsync.when(
      data: (settings) => _buildForm(context, settings),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Erro ao carregar configurações')),
    );
  }

  Widget _buildForm(BuildContext context, AppSettings settings) {
    return Column(
      children: [
        NubankStyleCurrencyField(
          label: 'Salário Mensal',
          initialValue: settings.monthlySalary, // Deve exibir o valor salvo
          onChanged: (value) => _updateSalary(value),
        ),
        NubankStyleCurrencyField(
          label: 'Saldo da Reserva Inicial',
          initialValue: settings.reserveBalance, // Deve exibir o valor salvo
          onChanged: (value) => _updateReserve(value),
        ),
      ],
    );
  }
}
```

**Definition of Done:**
- [ ] Causa raiz do bug identificada e documentada
- [ ] Valores de salário e reserva carregam corretamente ao abrir a tela
- [ ] Campos de input exibem os valores formatados corretamente (ex: R$ 5.000,00)
- [ ] Alterações nos valores são persistidas e recarregam corretamente
- [ ] Testes de widget atualizados para cobrir o carregamento de valores
- [ ] Merge realizado para `develop`

---

### [ ] F9-T2: Melhoria - Padronização do App Bar nas Telas Principais

**Branch:** `enhancement/standardize-app-bar`

**Descrição:**
Padronizar o estilo do app bar em todas as telas principais do aplicativo (Recorrências e Contas), aplicando o mesmo design usado na tela de Início, que inclui um botão de configurações no canto superior direito.

**Problema Atual:**
- A tela de Início (Dashboard) possui um app bar com botão de configurações e design consistente
- As telas de Recorrências e Contas usam app bars diferentes ou padrões
- Falta de consistência visual prejudica a experiência do usuário
- Não há acesso rápido às configurações a partir de todas as telas principais

**Objetivo:**
Criar um componente `StandardAppBar` reutilizável que será usado em todas as telas principais, garantindo:
- Design visual consistente (cores, elevação, tipografia)
- Botão de configurações sempre visível no canto superior direito
- Navegação para `SettingsScreen` ao tocar no botão
- Título personalizado por tela

**Implementação:**

**1. Criar Widget Reutilizável:**
```dart
// lib/presentation/widgets/common/standard_app_bar.dart

class StandardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;

  const StandardAppBar({
    Key? key,
    required this.title,
    this.additionalActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
      ),
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      actions: [
        ...?additionalActions,
        IconButton(
          icon: Icon(Icons.settings_outlined, color: AppColors.iconPrimary),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
          tooltip: 'Configurações',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
```

**2. Aplicar nas Telas Principais:**

**DashboardScreen (já implementado, validar consistência):**
```dart
class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: StandardAppBar(title: 'Início'),
      body: _buildDashboardContent(),
    );
  }
}
```

**RecurringExpensesScreen:**
```dart
class RecurringExpensesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Recorrências',
        additionalActions: [
          // Botão de adicionar recorrência (se necessário)
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddRecurringExpenseDialog(context),
          ),
        ],
      ),
      body: _buildRecurringExpensesList(),
    );
  }
}
```

**AccountsScreen:**
```dart
class AccountsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: StandardAppBar(
        title: 'Contas',
        additionalActions: [
          // Botão de adicionar conta (se necessário)
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddAccountDialog(context),
          ),
        ],
      ),
      body: _buildAccountsList(),
    );
  }
}
```

**3. Design System (validar consistência):**
- **Background:** `AppColors.background` (branco ou tom claro)
- **Título:** `AppTypography.h2` com `AppColors.textPrimary`
- **Ícones:** `AppColors.iconPrimary`
- **Elevação:** 0 (flat design)
- **Center Title:** false (alinhado à esquerda)

**Definition of Done:**
- [ ] Widget `StandardAppBar` criado em `lib/presentation/widgets/common/`
- [ ] App bar padronizado aplicado na `DashboardScreen`
- [ ] App bar padronizado aplicado na `RecurringExpensesScreen`
- [ ] App bar padronizado aplicado na `AccountsScreen`
- [ ] Botão de configurações funcional em todas as telas
- [ ] Navegação para `SettingsScreen` funcionando corretamente
- [ ] Design consistente com as especificações do design system
- [ ] Ações adicionais (botões de adicionar) preservadas onde necessário
- [ ] Testes de widget para o `StandardAppBar`
- [ ] Testes de widget atualizados para as telas modificadas
- [ ] Merge realizado para `develop`

---

## 🏗️ Fase 10: Estabilidade, Code Health e Migração (41 Issues)

**Objetivo:** Corrigir todos os warnings e infos do `flutter analyze`, atualizar pacotes desatualizados, e migrar código obsoleto, garantindo um código **limpo**, **moderno** e **sem alertas**.

---

### [ ] F10-T1: Atualização Crítica de Dependências (30+ Issues)

**Descrição:** Atualizar todos os pacotes desatualizados e corrigir referências de dependências ausentes no `pubspec.yaml`, eliminando os avisos de `pub outdated` e `depend_on_referenced_packages`.

**Issues/Grupo Corrigido:**
- **30** pacotes com versões incompatíveis/desatualizadas.
- **4** instâncias de `depend_on_referenced_packages` (lib/data/datasources/local_database.dart, test/domain/usecases/add_transaction_usecase_test.dart, test/domain/usecases/get_dashboard_data_usecase_test.dart, test/presentation/screens/accounts_screen_test.dart, test/presentation/screens/recurring_expenses_screen_test.dart, test/presentation/screens/settings_screen_test.dart).

**Subtarefas:**
1.  Executar `flutter pub outdated` e atualizar as versões de pacotes principais (como `analyzer`, `mockito`, `share_plus`, `flutter_local_notifications`, etc.) para as versões mais recentes compatíveis com o Flutter/Dart atual.
2.  Adicionar **path**, **matcher** e **mockito** como dependências apropriadas (`dependencies` ou `dev_dependencies`) no `pubspec.yaml` para resolver as 4 ocorrências de `depend_on_referenced_packages`.
3.  Executar `flutter pub get` e verificar se novas quebras de código ou warnings surgem.

---

### [ ] F10-T2: Migração de APIs Deprecated e Contextos Assíncronos (11 Issues)

**Descrição:** Substituir APIs obsoletas do Flutter/Dart e resolver problemas de uso do `BuildContext` em contextos assíncronos.

**Issues/Grupo Corrigido:**
- **4** instâncias de `deprecated_member_use` (Flutter Core: `withOpacity`, `window`, `viewInsets`).
- **5** instâncias de `deprecated_member_use` (Testes: `setMockMethodCallHandler`).
- **2** instâncias de `use_build_context_synchronously` (lib/presentation/screens/accounts_screen.dart, lib/presentation/screens/transactions_list_screen.dart).

**Subtarefas:**
1.  Substituir todas as 3 ocorrências de `.withOpacity()` por métodos alternativos como `.withValues()` ou reescrever a lógica de cores.
2.  Corrigir o uso de `window.viewInsets` e `window` no teste de dashboard usando `tester.view` ou `tester.platformDispatcher`.
3.  Atualizar todas as 5 chamadas de `setMockMethodCallHandler` nos testes de repositório para a nova API: `TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler`.
4.  Adicionar verificações de **`if (mounted)`** antes de qualquer uso de `BuildContext` (ex: `Navigator.of(context)`) nas funções assíncronas de `accounts_screen.dart` e `transactions_list_screen.dart`.

---

### [ ] F10-T3: Implementação de Logging e Limpeza de Produção (7 Issues)

**Descrição:** Remover todas as chamadas de `print()` em código de produção e substituí-las por uma solução de logging adequada para facilitar a depuração.

**Issues/Grupo Corrigido:**
- **7** instâncias de `avoid_print` (lib/data/services/notification_service.dart, lib/data/services/transaction_notification_service.dart).

**Subtarefas:**
1.  Adicionar um pacote de logging (ex: `logger`) como `dev_dependency` e criar um wrapper de `LoggerService` ou usar o pacote diretamente.
2.  Substituir todas as 7 chamadas de **`print(...)`** nos dois arquivos de serviço de notificação por chamadas ao logger (ex: `_log.info('...')`).
3.  Configurar o logger para ser silencioso em builds de produção/release, aderindo à regra de lint.

---

### [ ] F10-T4: Remoção de Código Morto e Alertas de Compilação (10 Issues)

**Descrição:** Identificar e remover variáveis, campos, métodos e elementos de código não utilizados, e corrigir problemas de sobrescrita.

**Issues/Grupo Corrigido:**
- **5** instâncias de `unused_field` (lib/presentation/screens/onboarding_screen.dart).
- **3** instâncias de `unused_local_variable` (test/data/parsers/notification_parser_registry_test.dart, test/domain/usecases/get_dashboard_data_usecase_test.dart, test/domain/usecases/process_recurring_expenses_usecase_test.dart).
- **2** instâncias de `unused_element` (lib/data/datasources/local_database.g.dart, lib/presentation/widgets/expense/expense_details_bottom_sheet.dart).
- **1** instância de `override_on_non_overriding_member` (test/domain/usecases/process_recurring_expenses_usecase_test.dart).
- **1** instância de `unused_local_variable` (test/presentation/screens/accounts_screen_test.dart).

**Subtarefas:**
1.  Remover os 5 campos não utilizados (`_accountName`, `_accountIsDebit`, etc.) do `onboarding_screen.dart`.
2.  Remover ou utilizar as 4 variáveis locais não utilizadas nos arquivos de teste (`instance1Id`, `now`, `scaffold`, `tomorrow`, `callCount`, `originalCreate`).
3.  Remover as declarações não referenciadas `_$LocalDatabase.connect` e `_handleValueChange`.
4.  Remover a anotação `@override` do método que não sobrescreve em `process_recurring_expenses_usecase_test.dart`.

---

## 📝 Notas Importantes

### Boas Práticas Durante o Desenvolvimento

3. **Testes Primeiro:** Escrever testes antes ou junto com a implementação
4. **Code Review Solo:** Revisar o próprio código antes do merge
5. **Documentação:** Comentar código complexo e manter este PLAN.md atualizado

### Atualização deste Documento

Sempre que concluir uma tarefa:
1. Mudar o checkbox de `[ ]` para `[x]`
2. Atualizar os contadores de progresso
3. Pedir ao usuário que faça commit da mudança

### Ordem Sugerida

As fases devem ser seguidas sequencialmente, mas dentro de cada fase há alguma flexibilidade. Tarefas marcadas como **críticas** devem ser priorizadas.

---

## 🎊 Conclusão

Este plano mapeia todas as **39 tarefas** necessárias para completar o MVP do Previsor Financeiro. Ao seguir este roadmap, você terá um aplicativo funcional, testado e preparado para uso pessoal, com uma arquitetura sólida que permitirá expansões futuras.

A **Fase 5** representa a primeira iteração de melhorias baseada em uso real, demonstrando a importância de testar o aplicativo e iterar sobre o design inicial.

A **Fase 6** adiciona refinamentos críticos de UX: onboarding para novos usuários, gestão completa de transações, e padronização de inputs numéricos para o mercado brasileiro.

A **Fase 7** introduz automação inteligente e identidade visual: ícone personalizado do app e captura automática de transações a partir de notificações bancárias, com arquitetura extensível para suportar múltiplos bancos.

A **Fase 8** foca em correções críticas e refinamentos de UX: sistema de input numérico tipo Nubank, bottom sheet com abas para melhor experiência com teclado, swipe-to-delete aprimorado, toggle entre dashboard e histórico, correção de permissões de notificação, e file picker para backups.

A **Fase 9** traz correções de UX e padronização visual: correção do bug de exibição de valores nas configurações e padronização do app bar em todas as telas principais para garantir consistência visual e facilitar o acesso às configurações.

A **Fase 10** garante a estabilidade e saúde do código: atualização de dependências, migração de APIs deprecated, implementação de logging adequado, e remoção de código morto.

**Bom desenvolvimento! 🚀**

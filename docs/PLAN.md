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
**Concluídas:** 29 / 39 (74%)

### Por Fase
- **Fase 1 - Fundação:** 4 / 4 (100%)
- **Fase 2 - Registro de Gastos:** 4 / 4 (100%)
- **Fase 3 - Dashboard Reativo:** 4 / 4 (100%)
- **Fase 4 - Funcionalidades de Suporte:** 4 / 5 (80%)
- **Fase 5 - Primeira Iteração:** 5 / 5 (100%)
- **Fase 6 - Segunda Iteração:** 3 / 3 (100%)
- **Fase 7 - Terceira Iteração:** 2 / 2 (100%)
- **Fase 8 - Quarta Iteração:** 5 / 6 (83%)
- **Fase 9 - Quinta Iteração:** 2 / 2 (100%)

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

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
- [x] Causa raiz do bug identificada e documentada
- [x] Valores de salário e reserva carregam corretamente ao abrir a tela
- [x] Campos de input exibem os valores formatados corretamente (ex: R$ 5.000,00)
- [x] Alterações nos valores são persistidas e recarregam corretamente
- [x] Testes de widget atualizados para cobrir o carregamento de valores
- [x] Merge realizado para `develop`

---

### [x] F9-T2: Melhoria - Padronização do App Bar nas Telas Principais

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
- [x] Widget `StandardAppBar` criado em `lib/presentation/widgets/common/`
- [x] App bar padronizado aplicado na `DashboardScreen`
- [x] App bar padronizado aplicado na `RecurringExpensesScreen`
- [x] App bar padronizado aplicado na `AccountsScreen`
- [x] Botão de configurações funcional em todas as telas
- [x] Navegação para `SettingsScreen` funcionando corretamente
- [x] Design consistente com as especificações do design system
- [x] Ações adicionais (botões de adicionar) preservadas onde necessário
- [x] Testes de widget para o `StandardAppBar`
- [x] Testes de widget atualizados para as telas modificadas
- [~] Merge realizado para `develop`

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

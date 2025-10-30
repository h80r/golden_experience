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

**Total de Tarefas:** 69
**Concluídas:** 44 / 69 (64%)

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
- **Fase 10 - Correções Críticas de UI/UX:** 6 / 6 (100%)
- **Fase 11 - Padronização e Melhorias de UX:** 4 / 4 (100%)
- **Fase 12 - Estabilidade e Code Health:** 3 / 3 (100%)
- **Fase 13 - Gestão Avançada de Contas:** 6 / 6 (100%)
- **Fase 14 - Refatoração do Sistema de Reserva:** 3 / 3 (100%)
- **Fase 15 - Melhorias em Ciclo de Faturamento e UX:** 1 / 4 (25%)
- **Fase 16 - Transações de Receita e Depósito Automático:** 0 / 7 (0%)

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

---

## ⚙️ Fase 15: Melhorias em Ciclo de Faturamento e UX de Formulários

**Objetivo:** Refinar o sistema de ciclo de faturamento de crédito para separar conceitos de fechamento vs pagamento, melhorar a experiência do formulário de contas, e adicionar ferramentas de debug para notificações.

**Status:** 1 / 4 tarefas concluídas

---

### [x] F15-T1: Implementar Sistema de Data de Fechamento e Pagamento Separados

**Branch:** `refactor/closing-vs-payment-dates`

**Descrição:**
Separar os conceitos de "data de fechamento" (quando a fatura fecha) e "data de pagamento" (quando a fatura vence) para cartões de crédito. O fechamento ocorre automaticamente uma semana antes do pagamento, criando uma janela de "período ideal de compra" onde as transações não impactam o ciclo atual.

**Problema Atual:**
- Sistema atual usa apenas `creditClosingDay` que representa o fechamento
- Não há conceito de data de pagamento separada
- Usuários não visualizam o "período ideal de compra" (janela entre fechamento e pagamento)
- Ciclo de faturamento usa apenas a data de fechamento, sem considerar o pagamento

**Implementação Esperada:**

1. **Database Migration (v9→v10):**
   ```dart
   // Renomear e adicionar campos na tabela Accounts
   // - Renomear `creditClosingDay` para `creditPaymentDay` (mantém valores existentes)
   // - Calcular `creditClosingDay` automaticamente como paymentDay - 7
   // Migration preserva dados: creditPaymentDay = creditClosingDay atual
   ```

2. **Atualizar Account Model:**
   - Campo `creditPaymentDay` (int 1-31, nullable) - dia do vencimento da fatura
   - Campo `creditClosingDay` - CALCULADO automaticamente (paymentDay - 7)
   - Se paymentDay < 8, ajustar para mês anterior (ex: paymentDay=5 → closingDay=28 do mês anterior)

3. **Lógica de Cálculo de Datas:**
   ```dart
   // Em billing_cycle_utils.dart

   /// Calcula a data de fechamento baseada na data de pagamento
   /// Regra: fechamento = pagamento - 7 dias
   DateTime calculateClosingDate(int paymentDay, DateTime referenceMonth) {
     final paymentDate = DateTime(referenceMonth.year, referenceMonth.month, paymentDay);
     return paymentDate.subtract(Duration(days: 7));
   }

   /// Identifica o "período ideal de compra" (entre fechamento e pagamento)
   /// Compras neste período não impactam a fatura atual
   DateTimeRange calculateIdealPurchasePeriod(int paymentDay, DateTime now) {
     final closingDate = calculateClosingDate(paymentDay, now);
     final paymentDate = DateTime(now.year, now.month, paymentDay);

     return DateTimeRange(
       start: closingDate.add(Duration(days: 1)),
       end: paymentDate,
     );
   }
   ```

4. **Atualizar Billing Cycle Logic:**
   ```dart
   // Ciclo de faturamento atual:
   // - Início: dia após fechamento ANTERIOR (inclusive)
   // - Fim: data de fechamento ATUAL (exclusive)
   //
   // Exemplo com paymentDay = 15:
   // - Fechamento: dia 8 (15 - 7)
   // - Ciclo atual (se hoje é 10/11): 09/10 até 07/11
   // - Período ideal: 08/11 até 15/11 (compras aqui vão para próxima fatura)

   BillingCyclePeriod calculateCurrentBillingCycle(int paymentDay, DateTime today) {
     final closingDay = _calculateClosingDay(paymentDay);

     // Determinar qual mês de referência usar
     DateTime referenceMonth;
     if (today.day > closingDay) {
       // Após o fechamento: ciclo atual vai do fechamento deste mês até próximo
       referenceMonth = DateTime(today.year, today.month);
     } else {
       // Antes do fechamento: ciclo atual começou no mês anterior
       referenceMonth = DateTime(today.year, today.month - 1);
     }

     final cycleStart = DateTime(referenceMonth.year, referenceMonth.month, closingDay)
         .add(Duration(days: 1));
     final cycleEnd = DateTime(referenceMonth.year, referenceMonth.month + 1, closingDay);

     return BillingCyclePeriod(start: cycleStart, end: cycleEnd);
   }
   ```

5. **UI Updates - Account Form:**
   - Remover seletor de "Dia de Fechamento"
   - Adicionar seletor de "Dia de Pagamento" (usando InlineCalendar)
   - Mostrar fechamento calculado: "Fechamento automático: dia X" (read-only)
   - Tooltip explicativo: "Sua fatura fecha 7 dias antes do pagamento"

6. **UI Updates - Accounts Screen:**
   - Expandir informações exibidas no tile expandido:
     - "Pagamento: dia X"
     - "Fechamento: dia Y"
     - "Período ideal: dd/mm - dd/mm" (destacado em verde/azul)
   - Tooltip no período ideal: "Compras neste período vão para a próxima fatura"

7. **Edge Cases:**
   - PaymentDay 1-7: fechamento fica no mês anterior
     - Ex: paymentDay=5 → closingDay=28 (ou 29/30/31 dependendo do mês anterior)
   - Fevereiro: ajustar dias inválidos
   - Dia 31 em meses com 30 dias: usar último dia válido

**Definition of Done:**
- [x] Migration v9→v10 implementada (rename + preserva dados)
- [x] Campo `creditPaymentDay` adicionado ao model
- [x] Campo `creditClosingDay` calculado automaticamente
- [x] Funções de cálculo de fechamento e período ideal criadas
- [x] `calculateCurrentBillingCycle()` atualizado para usar lógica correta
- [x] UI do formulário atualizada (payment day selector)
- [x] Accounts screen exibe fechamento, pagamento e período ideal
- [x] Edge cases tratados (dias inválidos, mudança de mês)
- [x] Testes unitários para todas as funções de cálculo
- [x] Testes de integração para billing cycle com nova lógica
- [x] Todos os testes passando (atualizar mocks para usar paymentDay)
- [x] Documentação atualizada (CLAUDE.md)
- [x] Merge realizado para `develop`

---

### [ ] F15-T2: Melhorias de Layout no Formulário de Conta

**Branch:** `feature/account-form-layout-improvements`

**Descrição:**
Otimizar o layout do formulário de conta para reduzir altura vertical e melhorar usabilidade, colocando checkboxes e inputs relacionados na mesma linha.

**Problema Atual:**
- Checkboxes de débito e crédito ocupam linhas separadas
- Inputs de saldo e limite ocupam linhas separadas
- Formulário muito extenso verticalmente
- Desperdício de espaço horizontal

**Implementação Esperada:**

1. **Página 1 - Reorganização de Layout:**
   ```dart
   // ANTES:
   // [ ] Conta de Débito
   // [ ] Conta de Crédito
   // [Campo: Saldo Inicial]
   // [Campo: Limite de Crédito]

   // DEPOIS:
   // Row: [ ] Conta de Débito    [ ] Conta de Crédito
   // Row: [Campo: Saldo]    [Campo: Limite]
   ```

2. **Implementação de Row para Checkboxes:**
   ```dart
   Row(
     children: [
       Expanded(
         child: CheckboxListTile(
           title: Text('Conta de Débito'),
           value: _isDebit,
           onChanged: (value) => setState(() => _isDebit = value ?? false),
         ),
       ),
       Expanded(
         child: CheckboxListTile(
           title: Text('Conta de Crédito'),
           value: _isCredit,
           onChanged: (value) => setState(() => _isCredit = value ?? false),
         ),
       ),
     ],
   )
   ```

3. **Implementação de Row para Inputs Monetários:**
   ```dart
   Row(
     children: [
       Expanded(
         child: NubankStyleCurrencyField(
           label: 'Saldo Inicial',
           enabled: _isDebit,
           controller: _balanceController,
         ),
       ),
       SizedBox(width: AppSpacing.md),
       Expanded(
         child: NubankStyleCurrencyField(
           label: 'Limite de Crédito',
           enabled: _isCredit,
           controller: _creditLimitController,
         ),
       ),
     ],
   )
   ```

4. **Lógica de Enable/Disable:**
   - Campo "Saldo" enabled apenas se `_isDebit == true`
   - Campo "Limite" enabled apenas se `_isCredit == true`
   - Ambos desabilitados se nenhum checkbox marcado
   - Visual feedback: campos disabled ficam com opacidade reduzida

5. **Responsividade:**
   - Em telas menores (<360px width), manter layout vertical
   - Usar `LayoutBuilder` para decidir entre Row e Column

**Definition of Done:**
- [ ] Checkboxes de débito/crédito na mesma linha
- [ ] Inputs de saldo/limite na mesma linha
- [ ] Lógica de enable/disable funcionando corretamente
- [ ] Visual feedback para campos desabilitados
- [ ] Layout responsivo (vertical em telas pequenas)
- [ ] Testes de widget atualizados
- [ ] Aparência consistente com design system
- [ ] Merge realizado para `develop`

---

### [ ] F15-T3: Remover Página de Calendário Condicional para Contas Não-Crédito

**Branch:** `feature/conditional-calendar-page`

**Descrição:**
Tornar a segunda página do formulário de conta (com calendário de pagamento) visível apenas quando o checkbox de crédito está marcado, eliminando navegação desnecessária para contas de débito.

**Problema Atual:**
- Formulário sempre tem 2 páginas (PageView com 2 children)
- Contas apenas de débito exigem navegação para página 2 (calendário) mesmo sem usar
- UX confusa: usuário vê calendário inútil para contas de débito
- Botão "Próximo" sempre visível, mesmo quando não há próxima página relevante

**Implementação Esperada:**

1. **Lógica Condicional de Páginas:**
   ```dart
   // Em _buildPageView()
   Widget _buildPageView() {
     final pages = <Widget>[
       _buildPage1(scrollController, isEditing),
       if (_isCredit) _buildPage2(), // Só adiciona se crédito marcado
     ];

     return PageView(
       controller: _pageController,
       children: pages,
     );
   }
   ```

2. **Atualização do Botão de Navegação:**
   ```dart
   // Na Página 1
   Widget _buildNavigationButton() {
     if (!_isCredit) {
       // Sem crédito: mostrar apenas botão "Salvar"
       return PrimaryButton(
         text: _isLoading ? 'Salvando...' : 'Salvar',
         onPressed: _isLoading ? null : _handleSave,
       );
     } else {
       // Com crédito: mostrar botão "Próximo" para ir ao calendário
       return Row(
         children: [
           Expanded(
             child: OutlinedButton(
               onPressed: () => _pageController.nextPage(
                 duration: Duration(milliseconds: 300),
                 curve: Curves.easeInOut,
               ),
               child: Text('Próximo'),
             ),
           ),
         ],
       );
     }
   }
   ```

3. **Validação de Salvamento:**
   ```dart
   Future<void> _handleSave() async {
     // Validar que pelo menos um tipo está marcado
     if (!_isDebit && !_isCredit) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Selecione ao menos um tipo de conta')),
       );
       return;
     }

     // Se crédito marcado mas não selecionou dia de pagamento
     if (_isCredit && _creditPaymentDay == null) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Selecione o dia de pagamento do crédito')),
       );
       return;
     }

     // Prosseguir com salvamento...
   }
   ```

4. **Atualização Dinâmica:**
   - Ao desmarcar checkbox de crédito na página 1, resetar `_creditPaymentDay = null`
   - Se usuário estiver na página 2 e desmarcar crédito, voltar para página 1
   - Listener no checkbox de crédito:
   ```dart
   onChanged: (value) {
     setState(() {
       _isCredit = value ?? false;
       if (!_isCredit) {
         _creditPaymentDay = null;
         if (_pageController.page == 1.0) {
           _pageController.previousPage(
             duration: Duration(milliseconds: 300),
             curve: Curves.easeInOut,
           );
         }
       }
     });
   }
   ```

5. **Indicador de Página:**
   - Mostrar indicador de página apenas se houver 2 páginas (`_isCredit == true`)
   - Ocultar se apenas 1 página (débito only)

**Definition of Done:**
- [ ] Segunda página (calendário) só aparece se `_isCredit == true`
- [ ] Botão de navegação adapta-se ao número de páginas
- [ ] Desmarcar crédito volta para página 1 se necessário
- [ ] Validação impede salvar crédito sem dia de pagamento
- [ ] Indicador de página condicional implementado
- [ ] UX suave com animações apropriadas
- [ ] Testes de widget para fluxos de 1 e 2 páginas
- [ ] Merge realizado para `develop`

---

### [ ] F15-T4: Feature Experimental - Monitor de Notificações para Debug

**Branch:** `feature/notification-debug-monitor`

**Descrição:**
Criar ferramenta de debug experimental que exibe uma notificação do app contendo metadados de qualquer notificação recebida, útil para testar e desenvolver futuros parsers de notificações bancárias.

**Problema/Objetivo:**
- Facilitar desenvolvimento de parsers de notificações bancárias
- Permitir visualizar metadados de notificações sem conectar debugger
- Ferramenta útil para testar captura de transações automáticas
- Não é feature de produção, mas sim debugging tool

**Implementação Esperada:**

1. **Adicionar Toggle nas Configurações:**
   ```dart
   // Settings Screen - Developer Options (nova seção)
   SwitchListTile(
     title: Text('Monitor de Notificações (Debug)'),
     subtitle: Text('Mostra metadados de notificações recebidas'),
     value: _notificationDebugEnabled,
     onChanged: (value) async {
       await ref.read(appSettingsRepositoryProvider)
           .updateNotificationDebugMode(value);
       setState(() => _notificationDebugEnabled = value);
     },
   )
   ```

2. **Database Field:**
   - Adicionar campo `notificationDebugMode` (boolean, default: false) em `AppSettings`
   - Migration necessária (v10→v11 ou ajustar conforme numeração atual)

3. **Notification Listener Service:**
   ```dart
   // lib/data/services/notification_monitor_service.dart
   class NotificationMonitorService {
     final FlutterLocalNotificationsPlugin _localNotifications;
     final IAppSettingsRepository _settingsRepo;

     // Chamado pelo NotificationListenerService quando notificação é recebida
     Future<void> onNotificationReceived(Map<String, dynamic> metadata) async {
       final settings = await _settingsRepo.get();

       if (!settings.notificationDebugMode) {
         return; // Debug mode desabilitado
       }

       // Criar notificação do app com metadados
       await _showDebugNotification(metadata);
     }

     Future<void> _showDebugNotification(Map<String, dynamic> metadata) async {
       final title = 'Notificação Capturada';
       final body = '''
   App: ${metadata['appName'] ?? 'Desconhecido'}
   Título: ${metadata['title'] ?? 'N/A'}
   Texto: ${metadata['text'] ?? 'N/A'}
   Timestamp: ${metadata['timestamp'] ?? 'N/A'}
   Package: ${metadata['packageName'] ?? 'N/A'}
       '''.trim();

       await _localNotifications.show(
         metadata['id'] ?? DateTime.now().millisecondsSinceEpoch,
         title,
         body,
         NotificationDetails(
           android: AndroidNotificationDetails(
             'notification_debug',
             'Debug de Notificações',
             channelDescription: 'Notificações de debug do monitor',
             importance: Importance.high,
             priority: Priority.high,
             icon: '@mipmap/ic_launcher',
           ),
           iOS: DarwinNotificationDetails(),
         ),
       );
     }
   }
   ```

4. **Integração com Listener Existente:**
   ```dart
   // No NotificationListenerService existente (de F8-T4)
   @override
   void onNotificationPosted(StatusBarNotification sbn) {
     final metadata = {
       'id': sbn.id,
       'appName': sbn.packageName,
       'title': sbn.notification?.extras?.getString('android.title'),
       'text': sbn.notification?.extras?.getString('android.text'),
       'timestamp': DateTime.now().toIso8601String(),
       'packageName': sbn.packageName,
     };

     // Enviar para monitor (se habilitado)
     NotificationMonitorService.instance.onNotificationReceived(metadata);

     // Continuar com lógica de parsing normal...
   }
   ```

5. **UI Feedback:**
   - Badge "EXPERIMENTAL" ao lado do toggle
   - Texto de aviso: "⚠️ Apenas para desenvolvimento. Pode gerar muitas notificações."
   - Opção de "Limpar notificações de debug" (botão)

6. **Limitações e Boas Práticas:**
   - Limitar a 50 notificações de debug por sessão (counter em memória)
   - Auto-desabilitar após 24h (opcional)
   - Logs detalhados para facilitar desenvolvimento

**Definition of Done:**
- [ ] Campo `notificationDebugMode` adicionado a AppSettings
- [ ] Toggle implementado em Settings (seção Developer Options)
- [ ] NotificationMonitorService criado e funcional
- [ ] Integração com NotificationListenerService existente
- [ ] Notificações de debug exibem metadados corretamente
- [ ] Limitação de quantidade implementada
- [ ] UI com badges e avisos apropriados
- [ ] Botão para limpar notificações de debug
- [ ] Testes de integração (mock de notificações)
- [ ] Documentação de uso para debug
- [ ] Merge realizado para `develop`

---

## ⚙️ Fase 16: Transações de Receita e Depósito Automático de Salário

**Objetivo:** Implementar suporte a transações de receita (positivas) e criar sistema de depósito automático do salário na conta configurada.

**Status:** 0 / 7 tarefas concluídas

**Nota:** Esta fase prepara a base para funcionalidades futuras de pagamento de faturas e gestão de invoices de cartão de crédito.

---

### [ ] F16-T1: Atualizar Testes e Documentação

**Branch:** `chore/update-tests-reserve-refactor`

**Descrição:**
Atualizar todos os testes e documentação para refletir as mudanças no sistema de reserva e ciclo de faturamento.

**Implementação Esperada:**

1. **Repository Tests:**
   - Atualizar testes do `AppSettingsRepository` (remover `updateReserveBalance()`)
   - Atualizar testes do `AccountRepository` (adicionar `excludeFromReserve`)
   - Adicionar testes para cálculo de reserva a partir de contas

2. **Use Case Tests:**
   - Atualizar `GetDashboardDataUseCaseTest` para nova lógica de reserva
   - Adicionar testes para filtragem de ciclo de faturamento
   - Testar cenários:
     - Reserva com múltiplas contas
     - Reserva com contas excluídas
     - Ciclo de crédito em diferentes meses

3. **Widget Tests:**
   - Atualizar testes da `SettingsScreen` (sem input de reserva)
   - Atualizar testes de account form (novo toggle de exclusão)

4. **Integration Tests:**
   - Criar teste end-to-end do novo fluxo de reserva
   - Criar teste de filtragem de ciclo de crédito

5. **Documentation:**
   - Atualizar `CLAUDE.md`:
     - Remover referências a `reserveBalance`
     - Documentar `excludeFromReserve`
     - Documentar lógica de ciclo de faturamento
   - Atualizar comentários no código

**Definition of Done:**
- [ ] Todos os testes de repository atualizados
- [ ] Todos os testes de use case atualizados
- [ ] Todos os testes de widget atualizados
- [ ] Integration tests criados
- [ ] CLAUDE.md atualizado
- [ ] Todos os testes passando
- [ ] Merge realizado para `develop`

---

### [ ] F16-T2: Implementar Sistema de Tipo de Transação

**Branch:** `feature/transaction-income-type`

**Descrição:**
Adicionar suporte a transações de receita (positivas) além de despesas (negativas), incluindo campos preparatórios para pagamento futuro de faturas.

**Implementação Esperada:**

1. **Database Migration (v9→v10):**
   - Adicionar coluna `isIncome` (boolean, default: false) na tabela `Transactions`
   - Adicionar coluna `paymentDate` (nullable DateTime) na tabela `Transactions`
   - Adicionar coluna `paymentAccountId` (nullable int, foreign key) na tabela `Transactions`
   - `isIncome = true`: transação de receita (salário, presente, reembolso)
   - `isIncome = false`: transação de despesa (padrão, compatível com dados existentes)
   - Campos de payment: preparação para funcionalidade futura de pagar faturas

2. **Atualizar Transaction Model:**
   ```dart
   @DataClassName('TransactionModel')
   class Transactions extends Table {
     // ... campos existentes
     BoolColumn get isIncome => boolean().withDefault(const Constant(false))();
     DateTimeColumn get paymentDate => dateTime().nullable()();
     IntColumn get paymentAccountId => integer().nullable().references(Accounts, #id)();
   }
   ```

3. **Repository Updates:**
   - Métodos de CRUD já suportarão automaticamente o novo campo
   - Adicionar filtros por tipo (opcional):
     - `getIncomeTransactions()`
     - `getExpenseTransactions()`

4. **Dashboard Logic Updates:**
   - Atualizar cálculo de `totalSpent` para contas de débito:
   ```dart
   // Para contas de débito, considerar receitas e despesas:
   final expenses = transactions.where((t) => !t.isIncome).fold(0.0, (sum, t) => sum + t.value);
   final income = transactions.where((t) => t.isIncome).fold(0.0, (sum, t) => sum + t.value);
   final netSpent = expenses - income; // Despesas menos receitas adicionais
   ```
   - Para contas de crédito, manter apenas despesas (`isIncome = false`)

5. **UI Updates (Preparatório):**
   - Mostrar transações de receita com estilo diferente na lista:
     - Cor verde para receitas
     - Ícone de seta para cima
     - Prefix "+" no valor
   - Transações de despesa mantêm estilo atual (vermelho/padrão)

**Definition of Done:**
- [ ] Migration v9→v10 implementada
- [ ] Campos `isIncome`, `paymentDate`, `paymentAccountId` adicionados
- [ ] Transaction model atualizado
- [ ] Dashboard calcula corretamente receitas vs despesas
- [ ] UI diferencia visualmente receitas de despesas
- [ ] Dados existentes permanecem como `isIncome=false` (despesas)
- [ ] Testes atualizados
- [ ] Code generation executado
- [ ] Merge realizado para `develop`

---

### [ ] F16-T3: Criar Tabela Invoice para Gestão Futura de Faturas

**Branch:** `chore/invoice-table-foundation`

**Descrição:**
Criar tabela Invoice para suportar gestão futura de faturas de cartão de crédito, incluindo rastreamento de períodos de cobrança, valores totais e status de pagamento.

**Implementação Esperada:**

1. **Database Table Definition:**
   ```dart
   @DataClassName('InvoiceModel')
   class Invoices extends Table {
     IntColumn get id => integer().autoIncrement()();
     IntColumn get accountId => integer().references(Accounts, #id)();
     DateTimeColumn get billingCycleStart => dateTime()();
     DateTimeColumn get billingCycleEnd => dateTime()();
     DateTimeColumn get closingDate => dateTime()();
     DateTimeColumn get dueDate => dateTime()();
     RealColumn get totalAmount => real()();
     BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
     DateTimeColumn get paidDate => dateTime().nullable()();
     IntColumn get paidFromAccountId => integer().nullable().references(Accounts, #id)();
   }
   ```

2. **Domain Repository Interface:**
   ```dart
   abstract class IInvoiceRepository {
     Future<InvoiceModel> create(InvoiceModel invoice);
     Future<InvoiceModel?> getById(int id);
     Future<List<InvoiceModel>> getByAccountId(int accountId);
     Future<List<InvoiceModel>> getUnpaidByAccountId(int accountId);
     Future<InvoiceModel> update(InvoiceModel invoice);
     Future<void> delete(int id);
     Stream<List<InvoiceModel>> watchByAccountId(int accountId);
   }
   ```

3. **Data Repository Implementation:**
   - Criar `InvoiceRepositoryImpl` em `lib/data/repositories/`
   - Implementar CRUD completo usando Drift queries
   - Adicionar provider no `repository_providers.dart`

4. **Register in Database:**
   - Adicionar `Invoices` à lista de tabelas em `@DriftDatabase`
   - Executar code generation

5. **Nota Importante:**
   - **Nenhuma UI será implementada nesta task**
   - Esta é apenas a fundação para funcionalidade futura (Fase 16+)
   - Quando implementado, permitirá:
     - Gerar invoices automaticamente por ciclo de faturamento
     - Marcar invoices como pagas
     - Rastrear de qual conta foi pago
     - Visualizar histórico de faturas

**Definition of Done:**
- [ ] Tabela `Invoices` criada com todos os campos
- [ ] Repository interface definida
- [ ] Repository implementation completa
- [ ] Provider registrado
- [ ] Tabela adicionada ao `@DriftDatabase`
- [ ] Code generation executado com sucesso
- [ ] Testes de repository implementados
- [ ] Documentação inline sobre uso futuro
- [ ] Merge realizado para `develop`

---

### [ ] F16-T4: Adicionar Configuração de Conta de Salário

**Branch:** `feature/salary-account-config`

**Descrição:**
Permitir que o usuário configure para qual conta o salário deve ser depositado automaticamente.

**Implementação Esperada:**

1. **Database Migration (v10→v11):**
   - Adicionar coluna `salaryAccountId` (nullable int, foreign key) na tabela `AppSettings`
   - Default: null (não configurado)

2. **Settings UI:**
   - Adicionar seção "Conta de Depósito do Salário" nas configurações
   - Dropdown mostrando apenas contas com `isDebit=true`
   - Formato do item: "[Nome da Conta] - Saldo: R$ X.XXX,XX"
   - Opção "Nenhuma" (null) para desabilitar depósito automático

3. **Validation:**
   - Apenas contas com `isDebit=true` podem ser selecionadas
   - Se conta selecionada for excluída, limpar `salaryAccountId`
   - Mostrar warning se salário estiver configurado mas conta não

4. **Repository Updates:**
   - Adicionar método `updateSalaryAccountId(int? accountId)` no `AppSettingsRepository`
   - Validação: verificar se conta existe e tem `isDebit=true`

5. **UI Feedback:**
   - Texto explicativo: "O salário será depositado automaticamente às 6h do dia configurado"
   - Se não houver contas de débito, mostrar mensagem: "Crie uma conta de débito primeiro"

**Definition of Done:**
- [ ] Coluna `salaryAccountId` adicionada a `AppSettings`
- [ ] Dropdown implementado na Settings screen
- [ ] Apenas contas de débito aparecem no dropdown
- [ ] Validação implementada
- [ ] Repository method criado
- [ ] UI feedback e textos explicativos
- [ ] Testes de integração
- [ ] Code generation executado
- [ ] Merge realizado para `develop`

---

### [ ] F16-T5: Atualizar UI de Transação para Receita/Despesa

**Branch:** `feature/transaction-ui-income-expense`

**Descrição:**
Atualizar o bottom sheet de transação e a lista de transações para suportar criação e visualização de transações de receita.

**Implementação Esperada:**

1. **Bottom Sheet Updates:**
   - Adicionar SegmentedButton no topo para selecionar "Despesa" ou "Receita"
   - Posições:
     - Despesa (left, default)
     - Receita (right)
   - Estado inicial: "Despesa" (`isIncome = false`)

2. **Visual Feedback no Form:**
   - Quando "Receita" selecionado:
     - Mudar cor do valor para verde
     - Ícone de seta para cima
     - Label: "Valor da Receita"
   - Quando "Despesa" selecionado:
     - Manter cor padrão (vermelho/neutro)
     - Label: "Valor da Despesa"

3. **Transaction List Updates:**
   - Transações de receita (`isIncome = true`):
     - Cor verde no valor: `Text(value, style: TextStyle(color: Colors.green))`
     - Prefix "+": `+R$ 1.500,00`
     - Ícone: `Icon(Icons.arrow_upward, color: Colors.green)`
   - Transações de despesa (`isIncome = false`):
     - Cor padrão/vermelho: `Text(value, style: TextStyle(color: Colors.red))`
     - Prefix "-": `-R$ 150,00`
     - Ícone: `Icon(Icons.arrow_downward, color: Colors.red)`

4. **Dashboard Updates:**
   - Mostrar resumo separado de receitas e despesas (opcional):
     ```
     Receitas: +R$ 5.000,00
     Despesas: -R$ 3.200,00
     Líquido: R$ 1.800,00
     ```

5. **Contas de Crédito:**
   - Para contas de crédito, ocultar opção "Receita" (apenas despesas)
   - Ou mostrar com tooltip: "Cartões de crédito suportam apenas despesas"

**Definition of Done:**
- [ ] SegmentedButton implementado no bottom sheet
- [ ] Visual feedback de receita vs despesa no form
- [ ] Lista de transações diferencia visualmente os tipos
- [ ] Dashboard mostra resumo de receitas/despesas (opcional)
- [ ] Validação para contas de crédito
- [ ] Testes de widget atualizados
- [ ] Merge realizado para `develop`

---

### [ ] F16-T6: Implementar Depósito Automático de Salário

**Branch:** `feature/automatic-salary-deposit`

**Descrição:**
Implementar sistema de background job para depositar automaticamente o salário na conta configurada às 6h da manhã do dia especificado.

**Implementação Esperada:**

1. **Adicionar Dependência:**
   - Adicionar `workmanager: ^0.5.2` ao `pubspec.yaml`
   - Ou `flutter_local_notifications` + scheduler alternativo
   - Configurar permissões no Android/iOS

2. **Background Task Setup:**
   ```dart
   // lib/data/services/salary_deposit_service.dart
   class SalaryDepositService {
     static const taskName = 'salaryDepositTask';

     static Future<void> initialize() async {
       await Workmanager().initialize(callbackDispatcher);
       await Workmanager().registerPeriodicTask(
         taskName,
         taskName,
         frequency: Duration(hours: 24),
         initialDelay: _calculateInitialDelay(),
       );
     }

     static Duration _calculateInitialDelay() {
       final now = DateTime.now();
       final next6AM = DateTime(now.year, now.month, now.day, 6, 0);
       if (now.isAfter(next6AM)) {
         return next6AM.add(Duration(days: 1)).difference(now);
       }
       return next6AM.difference(now);
     }
   }

   @pragma('vm:entry-point')
   void callbackDispatcher() {
     Workmanager().executeTask((task, inputData) async {
       await _processSalaryDeposit();
       return true;
     });
   }
   ```

3. **Deposit Logic:**
   ```dart
   Future<void> _processSalaryDeposit() async {
     // Inicializar database
     await LocalDatabase.initialize();
     final db = LocalDatabase.instance;

     // Buscar configurações
     final settings = await appSettingsRepo.get();
     if (settings.salaryAccountId == null || settings.monthlySalary == 0) {
       return; // Não configurado
     }

     // Verificar se hoje é o dia do salário
     final today = DateTime.now();
     final isPaymentDay = _isSalaryPaymentDay(today, settings);
     if (!isPaymentDay) return;

     // Verificar se já depositou este mês
     final alreadyDeposited = await _checkIfAlreadyDeposited(settings.salaryAccountId!, today);
     if (alreadyDeposited) return;

     // Criar transação de receita
     final transaction = TransactionsCompanion.insert(
       value: settings.monthlySalary,
       description: 'Salário - ${_formatMonthYear(today)}',
       date: today,
       accountId: settings.salaryAccountId!,
       categoryId: _getSalaryCategoryId(), // Categoria "Salário"
       isIncome: Value(true),
     );

     await transactionRepo.create(transaction);

     // Atualizar saldo da conta
     final account = await accountRepo.getById(settings.salaryAccountId!);
     await accountRepo.update(account.copyWith(
       balance: account.balance + settings.monthlySalary,
     ));
   }

   bool _isSalaryPaymentDay(DateTime date, AppSettingsModel settings) {
     if (settings.salaryPaymentMode == 'calendar') {
       final targetDay = settings.salaryPaymentValue;
       final lastDayOfMonth = DateTime(date.year, date.month + 1, 0).day;

       // Se dia configurado > dias no mês, usar último dia
       final effectiveDay = targetDay > lastDayOfMonth ? lastDayOfMonth : targetDay;
       return date.day == effectiveDay;
     } else if (settings.salaryPaymentMode == 'workday') {
       final workdayNumber = settings.salaryPaymentValue;
       final effectiveDate = _calculateWorkday(date.year, date.month, workdayNumber);
       return date.year == effectiveDate.year &&
              date.month == effectiveDate.month &&
              date.day == effectiveDate.day;
     }
     return false;
   }

   Future<bool> _checkIfAlreadyDeposited(int accountId, DateTime date) async {
     final transactions = await transactionRepo.getByAccountAndMonth(accountId, date);
     return transactions.any((t) =>
       t.isIncome &&
       t.description.startsWith('Salário') &&
       t.date.month == date.month &&
       t.date.year == date.year
     );
   }
   ```

4. **Initialization:**
   - Inicializar serviço no `main.dart`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await LocalDatabase.initialize();
     await SalaryDepositService.initialize();
     runApp(MyApp());
   }
   ```

5. **Edge Cases:**
   - Dia 31 em meses com 30 dias → usar dia 30
   - Dia 30/31 em fevereiro → usar dia 28 (ou 29 em ano bissexto)
   - App fechado → background job ainda executa
   - Erro na execução → retry na próxima execução diária

6. **Testing:**
   - Criar comando de teste manual: botão em Settings para "Simular Depósito"
   - Logs para debugging

**Definition of Done:**
- [ ] Dependência `workmanager` adicionada
- [ ] Background task configurado para rodar diariamente às 6h
- [ ] Lógica de depósito implementada com todas as validações
- [ ] Prevenção de duplicatas funcionando
- [ ] Edge cases tratados (dias inválidos em meses)
- [ ] Inicialização no `main.dart`
- [ ] Comando de teste manual criado
- [ ] Testes de integração
- [ ] Documentação do serviço
- [ ] Merge realizado para `develop`

---

### [ ] F16-T7: Testes e Casos Extremos

**Branch:** `chore/income-salary-tests`

**Descrição:**
Implementar suite completa de testes para transações de receita, depósito automático de salário e todos os casos extremos.

**Implementação Esperada:**

1. **Unit Tests - Salary Deposit Service:**
   ```dart
   // test/data/services/salary_deposit_service_test.dart
   group('SalaryDepositService', () {
     test('identifica corretamente dia de pagamento - modo calendário', () {
       // Testar dias 1-28
       // Testar dia 31 em mês com 30 dias
       // Testar dia 30/31 em fevereiro
     });

     test('identifica corretamente dia de pagamento - modo dia útil', () {
       // Testar com feriados
       // Testar último dia útil
     });

     test('previne duplicação de depósito no mesmo mês', () {
       // Criar transação de salário
       // Tentar depositar novamente
       // Verificar que não cria duplicata
     });

     test('pula depósito se salário não configurado', () {
       // Settings com salaryAccountId = null
       // Verificar que nada acontece
     });
   });
   ```

2. **Integration Tests - Transaction Types:**
   ```dart
   // test/integration/income_transaction_test.dart
   testWidgets('cria transação de receita corretamente', (tester) async {
     // Abrir bottom sheet
     // Selecionar "Receita"
     // Inserir valor
     // Salvar
     // Verificar que isIncome = true
     // Verificar que aparece verde na lista
   });

   testWidgets('transações de receita reduzem despesa líquida', (tester) async {
     // Criar despesa de R$ 1000
     // Criar receita de R$ 500
     // Verificar que totalSpent = R$ 500 (líquido)
   });
   ```

3. **Edge Case Tests:**
   ```dart
   group('Edge Cases - Salary Deposit', () {
     test('depósito no dia 31 em abril (30 dias) usa dia 30', () {
       final settings = AppSettingsModel(
         salaryPaymentMode: 'calendar',
         salaryPaymentValue: 31,
         // ...
       );
       final april30 = DateTime(2025, 4, 30);
       expect(_isSalaryPaymentDay(april30, settings), true);
     });

     test('depósito no dia 31 em fevereiro não-bissexto usa dia 28', () {
       final settings = AppSettingsModel(
         salaryPaymentMode: 'calendar',
         salaryPaymentValue: 31,
         // ...
       );
       final feb28 = DateTime(2025, 2, 28);
       expect(_isSalaryPaymentDay(feb28, settings), true);
     });

     test('depósito no dia 31 em fevereiro bissexto usa dia 29', () {
       final settings = AppSettingsModel(
         salaryPaymentMode: 'calendar',
         salaryPaymentValue: 31,
         // ...
       );
       final feb29 = DateTime(2024, 2, 29); // 2024 é bissexto
       expect(_isSalaryPaymentDay(feb29, settings), true);
     });
   });
   ```

4. **Repository Tests:**
   - Atualizar testes de `TransactionRepository` para `isIncome`
   - Testar filtros por tipo
   - Testar campos `paymentDate` e `paymentAccountId` (nullable)

5. **Use Case Tests:**
   - Atualizar `GetDashboardDataUseCaseTest`
   - Testar cálculo líquido (receitas - despesas)
   - Testar com mix de receitas e despesas

6. **Widget Tests:**
   - Testar SegmentedButton no bottom sheet
   - Testar visual de receitas vs despesas na lista
   - Testar dropdown de conta de salário nas configurações

**Definition of Done:**
- [ ] Unit tests para SalaryDepositService (100% coverage)
- [ ] Integration tests para income transactions
- [ ] Edge case tests para todos os cenários de data
- [ ] Repository tests atualizados
- [ ] Use case tests atualizados
- [ ] Widget tests completos
- [ ] Todos os testes passando
- [ ] Coverage report gerado
- [ ] Merge realizado para `develop`

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

Este plano mapeia todas as **69 tarefas** necessárias para completar o MVP do Previsor Financeiro. Ao seguir este roadmap, você terá um aplicativo funcional, testado e preparado para uso pessoal, com uma arquitetura sólida que permitirá expansões futuras.

A **Fase 5** representa a primeira iteração de melhorias baseada em uso real, demonstrando a importância de testar o aplicativo e iterar sobre o design inicial.

A **Fase 6** adiciona refinamentos críticos de UX: onboarding para novos usuários, gestão completa de transações, e padronização de inputs numéricos para o mercado brasileiro.

A **Fase 7** introduz automação inteligente e identidade visual: ícone personalizado do app e captura automática de transações a partir de notificações bancárias, com arquitetura extensível para suportar múltiplos bancos.

A **Fase 8** foca em correções críticas e refinamentos de UX: sistema de input numérico tipo Nubank, bottom sheet com abas para melhor experiência com teclado, swipe-to-delete aprimorado, toggle entre dashboard e histórico, correção de permissões de notificação, e file picker para backups.

A **Fase 9** traz correções de UX e padronização visual: correção do bug de exibição de valores nas configurações e padronização do app bar em todas as telas principais para garantir consistência visual e facilitar o acesso às configurações.

A **Fase 10** garante a estabilidade e saúde do código: atualização de dependências, migração de APIs deprecated, implementação de logging adequado, e remoção de código morto.

**Bom desenvolvimento! 🚀**

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

**Total de Tarefas:** 91
**Concluídas:** 53 / 91 (58%)

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
- **Fase 15 - Melhorias em Ciclo de Faturamento e UX:** 4 / 4 (100%)
- **Fase 16 - Melhorias no Histórico de Transações:** 7 / 7 (100%)
- **Fase 17 - Gerenciador de Faturas e Transações Parceladas:** 3 / 3 (100%)
- **Fase 18 - Correções Críticas de Despesas Recorrentes:** 0 / 3 (0%)
- **Fase 19 - Correções Críticas de UX/UI:** 0 / 5 (0%)
- **Fase 20 - Correções no Sistema de Backup/Restore:** 0 / 4 (0%)

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

---

## 🔧 Fase 18: Correções Críticas de Despesas Recorrentes

**Objetivo:** Corrigir problemas críticos no formulário de despesas recorrentes relacionados a exibição de valores, seleção de data, e criação automática de transações.

**Status:** 0 / 3 tarefas concluídas

---

### [ ] F18-T1: Correção - Exibição e Edição de Valores em Despesas Recorrentes

**Branch:** `fix/recurring-value-display`

**Descrição:**
Corrigir dois problemas relacionados à exibição de valores no formulário de despesas recorrentes:
1. Valores salvos são exibidos multiplicados por 100 na lista
2. Ao editar uma despesa, o valor aparece como 0 no bottom sheet

**Root Cause:**
O `_valueController` está sendo inicializado com o valor bruto (double) em vez de um controller vazio, conflitando com a lógica interna do `NubankStyleCurrencyField` que espera armazenar valores em centavos.

**Implementação Esperada:**

1. **Remover inicialização do `_valueController` (linha 344):**
   ```dart
   // ANTES (INCORRETO):
   _valueController = TextEditingController(
     text: widget.expense?.value.toString() ?? '',
   );

   // DEPOIS (CORRETO):
   _valueController = TextEditingController(); // Empty controller
   ```

2. **Adicionar helper method para parsing de centavos:**
   ```dart
   /// Parse cents value (stored as digits in controller) to double
   double _parseCentsToDouble(String centsText) {
     if (centsText.isEmpty) return 0.0;
     try {
       final cents = int.parse(centsText);
       return cents / 100.0;
     } catch (e) {
       return 0.0;
     }
   }
   ```

3. **Atualizar `_handleSubmit` para usar o parser (linha 401):**
   ```dart
   // ANTES:
   final value = double.parse(_valueController.text);

   // DEPOIS:
   final value = _parseCentsToDouble(_valueController.text);
   ```

**Definition of Done:**
- [ ] `_valueController` inicializado como vazio (sem texto pré-preenchido)
- [ ] Helper method `_parseCentsToDouble()` implementado
- [ ] `_handleSubmit` atualizado para usar o parser
- [ ] Testar criação: valor salvo corretamente e exibido sem multiplicação
- [ ] Testar edição: valor carregado corretamente no campo (não mostra 0)
- [ ] Testar edição: valor atualizado salvo corretamente
- [ ] Pattern de `account_form_bottom_sheet.dart` seguido (linhas 192-194, 862-870)
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F18-T2: Refatorar para Multi-Page Bottom Sheet com InlineCalendar

**Branch:** `feature/recurring-inline-calendar`

**Descrição:**
Substituir o campo de texto para "Dia de Cobrança" por um `InlineCalendar` em uma segunda página do bottom sheet, seguindo o mesmo pattern usado no formulário de contas para seleção do dia de pagamento do cartão.

**Implementação Esperada:**

1. **Adicionar state variables:**
   ```dart
   late PageController _pageController;
   int _currentPageIndex = 0;
   int _chargeDay; // Substituir _chargeDayController
   ```

2. **Inicializar PageController e chargeDay:**
   ```dart
   @override
   void initState() {
     super.initState();
     _pageController = PageController();
     _chargeDay = widget.expense?.chargeDay ?? 1;
     // ... outros controllers
   }
   ```

3. **Substituir Form por PageView:**
   ```dart
   Expanded(
     child: PageView(
       controller: _pageController,
       onPageChanged: (index) {
         setState(() {
           _currentPageIndex = index;
         });
       },
       children: [
         _buildPage1(scrollController, isEditing),
         _buildPage2(),
       ],
     ),
   )
   ```

4. **Criar `_buildPage1()` com navegação:**
   - Manter: Description, Value, Account, Category
   - Remover: Charge Day field (mover para página 2)
   - Botões: `[Cancel] [Calendar Icon] [Próximo →]`

5. **Criar `_buildPage2()` com InlineCalendar:**
   ```dart
   Widget _buildPage2() {
     return SingleChildScrollView(
       padding: const EdgeInsets.all(AppSpacing.lg),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text('Dia de Cobrança', style: AppTypography.headlineMedium),
           const SizedBox(height: AppSpacing.sm),
           Text(
             'Selecione o dia do mês em que a despesa é cobrada',
             style: AppTypography.bodyMedium.copyWith(
               color: AppColors.textSecondary,
             ),
           ),
           const SizedBox(height: AppSpacing.md),
           InlineCalendar(
             selectedDay: _chargeDay,
             onDaySelected: (day) {
               setState(() {
                 _chargeDay = day;
               });
             },
             compactMode: true,
           ),
           const SizedBox(height: AppSpacing.lg),
           Row(
             children: [
               Expanded(
                 flex: 1,
                 child: IconButton(
                   icon: Icon(Icons.close),
                   onPressed: () => Navigator.pop(context),
                 ),
               ),
               SizedBox(width: AppSpacing.sm),
               Expanded(
                 flex: 1,
                 child: IconButton(
                   icon: Icon(Icons.arrow_back),
                   onPressed: _goToPreviousPage,
                 ),
               ),
               SizedBox(width: AppSpacing.sm),
               Expanded(
                 flex: 2,
                 child: PrimaryButton(
                   label: 'Salvar',
                   onPressed: _handleSubmit,
                 ),
               ),
             ],
           ),
         ],
       ),
     );
   }
   ```

6. **Adicionar navigation methods:**
   ```dart
   void _goToNextPage() {
     FocusScope.of(context).unfocus();
     _pageController.animateToPage(
       1,
       duration: const Duration(milliseconds: 300),
       curve: Curves.easeInOut,
     );
   }

   void _goToPreviousPage() {
     _pageController.animateToPage(
       0,
       duration: const Duration(milliseconds: 300),
       curve: Curves.easeInOut,
     );
   }
   ```

7. **Atualizar validation em `_handleSubmit`:**
   - Validar form na página 1
   - Se falhar validação e estiver na página 2, navegar para página 1
   - Substituir `int.parse(_chargeDayController.text)` por `_chargeDay`

8. **Dispose PageController:**
   ```dart
   @override
   void dispose() {
     _pageController.dispose();
     // ... outros disposes
   }
   ```

**Definition of Done:**
- [ ] `PageController` e `_currentPageIndex` adicionados
- [ ] `_chargeDayController` removido, `_chargeDay` int adicionado
- [ ] Form substituído por PageView com 2 páginas
- [ ] Page 1 construída com campos básicos + navegação
- [ ] Page 2 construída com InlineCalendar
- [ ] Navigation methods implementados
- [ ] Import de `InlineCalendar` adicionado
- [ ] Validação funciona corretamente entre páginas
- [ ] PageController disposed adequadamente
- [ ] Testar criação: navegação entre páginas funciona
- [ ] Testar edição: dia carregado corretamente no calendar
- [ ] Testar validação: erros na página 1 navegam corretamente
- [ ] Pattern de `account_form_bottom_sheet.dart` seguido (linhas 35-44, 177, 528-650)
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F18-T3: Auto-Criação de Transações Baseada em Billing Period

**Branch:** `feature/recurring-auto-transaction`

**Descrição:**
Implementar lógica para criar automaticamente uma transação quando uma despesa recorrente é criada/editada e o dia de cobrança já passou no ciclo de faturamento atual. Para contas de crédito, usar lógica de billing cycle. Para contas de débito, usar lógica de dia do mês.

**Implementação Esperada:**

1. **Adicionar import:**
   ```dart
   import '../../../core/utils/billing_cycle_utils.dart';
   ```

2. **Criar método `_createImmediateTransactionIfNeeded()`:**
   ```dart
   /// Creates an immediate transaction if the charge day has passed in the current billing period
   Future<void> _createImmediateTransactionIfNeeded(
     int chargeDay,
     String description,
     double value,
     int accountId,
     int categoryId,
   ) async {
     final now = DateTime.now();
     final accountRepository = ref.read(accountRepositoryProvider);
     final transactionRepository = ref.read(transactionRepositoryProvider);

     // Get account to determine billing logic
     final account = await accountRepository.getById(accountId);
     if (account == null) return;

     DateTime? transactionDate;
     String transactionType = 'credit';

     if (account.isCredit && account.creditPaymentDay != null) {
       // CREDIT ACCOUNT: Use billing cycle logic
       final currentCycle = calculateCurrentBillingCycleFromPaymentDay(
         account.creditPaymentDay!,
         now,
       );

       // Calculate charge date for current month (handle months with different day counts)
       final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
       final effectiveChargeDay = chargeDay > daysInMonth ? daysInMonth : chargeDay;

       final chargeDate = DateTime(now.year, now.month, effectiveChargeDay);

       // Check if charge date is in current cycle AND has already passed
       if (currentCycle.contains(chargeDate) && chargeDate.isBefore(now)) {
         transactionDate = chargeDate;
       }

       // Determine transaction type for credit
       if (account.isDebit && !account.isCredit) {
         transactionType = 'debit';
       }
     } else if (account.isDebit) {
       // DEBIT ACCOUNT: Use simple calendar day logic
       if (chargeDay <= now.day) {
         final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
         final effectiveChargeDay = chargeDay > daysInMonth ? daysInMonth : chargeDay;
         transactionDate = DateTime(now.year, now.month, effectiveChargeDay);
         transactionType = 'debit';
       }
     }

     // Create transaction if date was determined
     if (transactionDate != null) {
       try {
         await transactionRepository.create(
           TransactionModelCompanion.insert(
             value: value,
             description: '[Recorrente] $description',
             date: transactionDate,
             accountId: accountId,
             categoryId: categoryId,
             notes: const drift.Value('[Processada automaticamente]'),
           ).copyWith(transactionType: drift.Value(transactionType)),
         );
       } catch (e) {
         debugPrint('Error creating immediate transaction: $e');
         // Don't block the flow - log error only
       }
     }
   }
   ```

3. **Chamar método em `_handleSubmit`:**
   - Após criação bem-sucedida (depois da linha 474)
   - Após edição bem-sucedida (depois da linha 434)

   ```dart
   // After successful create/update:
   await _createImmediateTransactionIfNeeded(
     chargeDay,
     description,
     value,
     accountId,
     categoryId,
   );
   ```

**Billing Cycle Logic (Credit Accounts):**
- Uses `calculateCurrentBillingCycleFromPaymentDay()` from `billing_cycle_utils.dart`
- Calculates billing cycle based on `creditPaymentDay` (closing = payment - 7 days)
- Checks if charge day falls within current cycle using `currentCycle.contains(chargeDate)`
- Only creates transaction if charge date is in cycle AND has passed

**Calendar Day Logic (Debit Accounts):**
- Simple check: `chargeDay <= now.day`
- Creates transaction for current month if day has passed

**Edge Cases Handled:**
- Months with different day counts (28, 29, 30, 31)
- Credit payment day between 1-7 (closing in previous month)
- Year transitions
- Dual-type accounts (checks both `isCredit` and `isDebit`)
- Transaction type determined by account type

**Definition of Done:**
- [ ] Import de `billing_cycle_utils.dart` adicionado
- [ ] Método `_createImmediateTransactionIfNeeded()` implementado
- [ ] Lógica de billing cycle para contas de crédito implementada
- [ ] Lógica de calendar day para contas de débito implementada
- [ ] Método chamado após criar despesa recorrente
- [ ] Método chamado após editar despesa recorrente
- [ ] Edge cases de dias do mês tratados (28-31)
- [ ] Transaction type determinado corretamente
- [ ] Erro não bloqueia salvamento (apenas log)
- [ ] Testar com conta crédito: charge day no ciclo atual e já passou → cria transação
- [ ] Testar com conta crédito: charge day no ciclo atual mas não passou → não cria
- [ ] Testar com conta crédito: charge day fora do ciclo atual → não cria
- [ ] Testar com conta débito: charge day <= hoje → cria transação
- [ ] Testar com conta débito: charge day > hoje → não cria
- [ ] Testar transação criada com descrição "[Recorrente] X"
- [ ] Testar transação criada com notes "[Processada automaticamente]"
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

## 🔧 Fase 19: Correções Críticas de UX/UI (Anteriormente Fase 18)

**Objetivo:** Corrigir problemas críticos de experiência do usuário identificados durante uso real da aplicação.

**Status:** 0 / 5 tarefas concluídas

---

### [ ] F19-T1: Correção - Descrição de Transação Retorna à Tela Anterior

**Branch:** `fix/transaction-description-save`

**Descrição:**
Na criação de transações, ao salvar no campo de descrição (pressionar "salvar" no teclado), a aplicação volta para a primeira tela sem salvar a transação. Corrigir o comportamento para que salvar na descrição não cause navegação automática.

**Definition of Done:**
- [ ] Identificar o listener/callback que está causando a navegação prematura
- [ ] Remover ou ajustar o comportamento de navegação no TextField de descrição
- [ ] Garantir que apenas o botão "Salvar" da transação cause a navegação
- [ ] Testar fluxo completo de criação de transação com descrição
- [ ] Verificar comportamento em modo edição também
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F19-T2: Correção - Botão Salvar na Primeira Tela de Edição de Contas

**Branch:** `fix/account-edit-save-button`

**Descrição:**
Na edição de contas, quando há crédito habilitado, a primeira tela deve ter um botão "Salvar" em vez de "Avançar". O fluxo atual força o usuário a passar para a segunda tela mesmo quando só quer editar informações da primeira tela.

**Definition of Done:**
- [ ] Detectar se conta tem crédito habilitado (`isCredit == true`)
- [ ] Se apenas débito: manter botão "Salvar" (comportamento atual)
- [ ] Se crédito habilitado: trocar "Avançar" por "Salvar" na primeira tela
- [ ] Botão "Salvar" deve persistir mudanças e fechar o bottom sheet
- [ ] Manter opção de ir para segunda tela (adicionar botão secundário "Configurar Crédito" ou similar)
- [ ] Testar fluxo de edição com conta débito-only
- [ ] Testar fluxo de edição com conta crédito
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F19-T3: Correção - Auto-refresh do Dashboard em Mudanças de Configurações

**Branch:** `fix/dashboard-auto-refresh`

**Descrição:**
O dashboard não atualiza automaticamente quando há mudanças nas configurações ou nos saldos das contas. Usuário precisa navegar para a lista de transações e voltar para ver os valores atualizados. Implementar invalidação automática dos providers do dashboard.

**Definition of Done:**
- [ ] Identificar todos os providers que afetam o dashboard (accounts, settings, transactions)
- [ ] Implementar `ref.invalidate()` ou `ref.refresh()` nos providers dependentes
- [ ] Garantir que mudanças em `AppSettings` invalidam dashboard
- [ ] Garantir que mudanças em `Accounts` (saldo, limite) invalidam dashboard
- [ ] Garantir que mudanças em `Transactions` invalidam dashboard automaticamente (já deve funcionar via streams)
- [ ] Testar cenário: mudar `paymentDay` → dashboard atualiza
- [ ] Testar cenário: editar saldo de conta → dashboard atualiza
- [ ] Testar cenário: criar/editar transação → dashboard atualiza
- [ ] Verificar performance (evitar rebuilds desnecessários)
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F19-T4: Correção - Error Toasts Aparecendo Atrás do Bottom Sheet

**Branch:** `fix/toast-z-index`

**Descrição:**
Error toasts aparecem atrás dos bottom sheets, impossibilitando identificar o problema. Implementar solução para garantir que toasts sempre apareçam acima de todos os outros widgets, incluindo bottom sheets.

**Definition of Done:**
- [ ] Investigar implementação atual do sistema de toasts (fluttertoast, custom overlay, etc.)
- [ ] Implementar solução com maior z-index/elevation
- [ ] Opções possíveis:
  - Usar `Overlay` com prioridade alta
  - Usar `OverlayEntry` para toasts
  - Ajustar `showDialog` ou `showModalBottomSheet` com WillPopScope
- [ ] Garantir que toasts aparecem acima de bottom sheets
- [ ] Garantir que toasts aparecem acima de dialogs
- [ ] Testar com expense bottom sheet aberto
- [ ] Testar com account bottom sheet aberto
- [ ] Testar com todos os tipos de toast (error, success, info)
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F19-T5: Correção - Habilitar/Desabilitar Débito/Crédito Baseado no Tipo de Conta

**Branch:** `fix/expense-payment-type-toggle`

**Descrição:**
No bottom sheet de criação de despesas, os campos de débito/crédito devem ser habilitados/desabilitados automaticamente de acordo com o tipo da conta selecionada. Se a conta for apenas débito, desabilitar opção de crédito. Se for apenas crédito, desabilitar opção de débito.

**Definition of Done:**
- [ ] Monitorar mudanças no campo de seleção de conta
- [ ] Ao selecionar conta, verificar `account.isDebit` e `account.isCredit`
- [ ] Se `isDebit == true && isCredit == false`: desabilitar toggle de crédito, forçar débito
- [ ] Se `isCredit == true && isDebit == false`: desabilitar toggle de débito, forçar crédito
- [ ] Se `isDebit == true && isCredit == true`: habilitar ambos os toggles
- [ ] Atualizar UI para mostrar estado desabilitado visualmente (cinza, opacity reduzida)
- [ ] Garantir que valor default é correto ao trocar de conta
- [ ] Testar com conta débito-only
- [ ] Testar com conta crédito-only
- [ ] Testar com conta dual-type
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

## 📦 Fase 20: Correções no Sistema de Backup/Restore

**Objetivo:** Corrigir problemas críticos no sistema de backup e restore de dados, garantindo persistência completa de todas as informações.

**Status:** 0 / 4 tarefas concluídas

---

### [ ] F20-T1: Adicionar Botão "Importar Backup" no Tour Inicial

**Branch:** `feature/import-backup-onboarding`

**Descrição:**
Adicionar botão de "Importar Backup" no tour de início do aplicativo, permitindo que usuários restaurem seus dados antes de completar o onboarding.

**Definition of Done:**
- [ ] Adicionar botão "Importar Backup" na tela inicial do tour
- [ ] Posicionar adequadamente (acima ou abaixo do botão "Começar")
- [ ] Implementar fluxo de importação:
  - Abrir file picker
  - Validar arquivo JSON
  - Restaurar dados
  - Navegar para tela apropriada (dashboard ou completar tour)
- [ ] Adicionar loading state durante importação
- [ ] Adicionar tratamento de erros (arquivo inválido, formato incorreto)
- [ ] Testar cenário: importar backup válido antes do tour
- [ ] Testar cenário: importar backup inválido (mostrar erro)
- [ ] Testar cenário: cancelar file picker
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F20-T2: Correção - Persistir Data de Pagamento no Backup

**Branch:** `fix/backup-payment-day`

**Descrição:**
O sistema de backup não está salvando a data de pagamento dos cartões de crédito (`creditPaymentDay`). Adicionar este campo ao JSON de backup e restore.

**Definition of Done:**
- [ ] Identificar estrutura atual do JSON de backup para `Accounts`
- [ ] Adicionar campo `creditPaymentDay` ao JSON de export
- [ ] Adicionar leitura do campo `creditPaymentDay` no JSON de import
- [ ] Garantir compatibilidade com backups antigos (campo nullable)
- [ ] Testar export: verificar que `creditPaymentDay` está no JSON
- [ ] Testar import: verificar que valor é restaurado corretamente
- [ ] Testar import de backup antigo sem o campo (deve funcionar)
- [ ] Adicionar migration/validação se necessário
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F20-T3: Correção - Persistir Data de Fechamento no Backup

**Branch:** `fix/backup-closing-day`

**Descrição:**
O sistema de backup não está salvando a data de fechamento dos cartões de crédito (campo calculado baseado em `creditPaymentDay`). Garantir que o ciclo de faturamento completo é restaurado corretamente.

**Observação:** Este problema pode estar relacionado ao F20-T2, já que a data de fechamento é calculada como `creditPaymentDay - 7`. Se `creditPaymentDay` for restaurado corretamente, o fechamento será calculado automaticamente.

**Definition of Done:**
- [ ] Verificar se correção do F20-T2 resolve o problema
- [ ] Se necessário, adicionar campo explícito de `creditClosingDay` ao backup
- [ ] Testar export: verificar que ciclo de faturamento está completo
- [ ] Testar import: verificar que `creditPaymentDay` e fechamento são restaurados
- [ ] Testar cálculo automático de fechamento após restore
- [ ] Validar que faturas são geradas com períodos corretos após restore
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F20-T4: Correção - Persistir Tipo de Pagamento (Débito/Crédito) no Backup

**Branch:** `fix/backup-payment-type`

**Descrição:**
O sistema de backup não está salvando o tipo de pagamento das transações (se foi débito ou crédito, campo `isCredit`). Adicionar este campo ao JSON de backup e restore.

**Definition of Done:**
- [ ] Identificar estrutura atual do JSON de backup para `Transactions`
- [ ] Adicionar campo `isCredit` ao JSON de export
- [ ] Adicionar leitura do campo `isCredit` no JSON de import
- [ ] Garantir compatibilidade com backups antigos (campo nullable, default baseado em tipo de conta)
- [ ] Testar export: verificar que `isCredit` está no JSON
- [ ] Testar import: verificar que valor é restaurado corretamente
- [ ] Testar import de backup antigo sem o campo (inferir baseado em tipo de conta)
- [ ] Validar que dashboard calcula valores corretamente após restore
- [ ] Validar que faturas agrupam transações corretamente após restore
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

## 🎊 Conclusão

Este plano mapeia todas as **91 tarefas** necessárias para completar o MVP do Previsor Financeiro. Ao seguir este roadmap, você terá um aplicativo funcional, testado e preparado para uso pessoal, com uma arquitetura sólida que permitirá expansões futuras.

A **Fase 5** representa a primeira iteração de melhorias baseada em uso real, demonstrando a importância de testar o aplicativo e iterar sobre o design inicial.

A **Fase 6** adiciona refinamentos críticos de UX: onboarding para novos usuários, gestão completa de transações, e padronização de inputs numéricos para o mercado brasileiro.

A **Fase 7** introduz automação inteligente e identidade visual: ícone personalizado do app e captura automática de transações a partir de notificações bancárias, com arquitetura extensível para suportar múltiplos bancos.

A **Fase 8** foca em correções críticas e refinamentos de UX: sistema de input numérico tipo Nubank, bottom sheet com abas para melhor experiência com teclado, swipe-to-delete aprimorado, toggle entre dashboard e histórico, correção de permissões de notificação, e file picker para backups.

A **Fase 9** traz correções de UX e padronização visual: correção do bug de exibição de valores nas configurações e padronização do app bar em todas as telas principais para garantir consistência visual e facilitar o acesso às configurações.

A **Fase 10** garante a estabilidade e saúde do código: atualização de dependências, migração de APIs deprecated, implementação de logging adequado, e remoção de código morto.

A **Fase 18** corrige problemas críticos no formulário de despesas recorrentes: exibição de valores (bug do multiplicador *100), refatoração para usar InlineCalendar em uma segunda página do bottom sheet, e implementação de auto-criação de transações baseada em billing periods para contas de crédito e calendar days para contas de débito.

A **Fase 19** aborda correções críticas de UX/UI identificadas durante uso real: comportamento de salvamento de descrição, botões de navegação em edição de contas, auto-refresh do dashboard, z-index de toasts, e controle de tipo de pagamento baseado em tipo de conta.

A **Fase 20** corrige problemas no sistema de backup/restore: adicionar opção de importação no onboarding, e garantir persistência completa de dados críticos (data de pagamento, data de fechamento, e tipo de pagamento).

**Bom desenvolvimento! 🚀**

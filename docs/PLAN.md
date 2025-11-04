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

**Total de Tarefas:** 79
**Concluídas:** 53 / 79 (67%)

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
- **Fase 17 - Gerenciador de Faturas e Transações Parceladas:** 0 / 3 (0%)
- **Fase 18 - Transações de Receita e Depósito Automático:** 0 / 7 (0%)

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

---

## 💳 Fase 17: Gerenciador de Faturas e Transações Parceladas

**Objetivo:** Implementar gerenciador de faturas de cartão de crédito com histórico de pagamentos e suporte a transações parceladas automáticas.

**Status:** 0 / 3 tarefas concluídas

---

### [x] F17-T1: Gerenciador de Faturas com Navegação Temporal

**Branch:** `feature/invoice-manager`

**Descrição:**
Implementar sistema simplificado de gerenciamento de faturas com navegação temporal no dashboard. O sistema permite navegar entre períodos de fatura (passado/futuro) através de swipe, marca ciclos como pagos, e calcula valores dinamicamente através de queries. Períodos de fatura são unificados entre todos os cartões de crédito, usando a data de início mais antiga e data de fim mais recente.

**Implementação Esperada:**

1. **Database - Tabela Simplificada de Invoices:**
   ```dart
   @DataClassName('InvoiceModel')
   class Invoices extends Table {
     IntColumn get id => integer().autoIncrement()();

     // Período da fatura (calculado baseado em TODOS os cartões)
     // startDate = EARLIEST start entre todos os cartões
     // endDate = LATEST end entre todos os cartões
     DateTimeColumn get startDate => dateTime()();
     DateTimeColumn get endDate => dateTime()();

     // Status de pagamento
     BoolColumn get isPaid => boolean().withDefault(const Constant(false))();

     @override
     List<String> get customConstraints => [
       'UNIQUE(startDate, endDate)',
     ];
   }
   ```
   - **Remover completamente** a tabela `InvoiceItems` (não é mais necessária)
   - Todos os valores (total, breakdown por conta) serão calculados dinamicamente via queries
   - Migration para remover `InvoiceItems` e atualizar `Invoices`

2. **Repository (Interface + Implementation):**

   **Interface** (`lib/domain/repositories/i_invoice_repository.dart`):
   ```dart
   abstract class IInvoiceRepository {
     // Cria um novo registro de fatura apenas com período e flag isPaid
     Future<int> create({
       required DateTime startDate,
       required DateTime endDate,
       bool isPaid = false,
     });

     // Retorna a fatura para um período específico
     Future<InvoiceModel?> getByPeriod({
       required DateTime startDate,
       required DateTime endDate,
     });

     // Retorna TODAS as faturas que têm transações (ordenadas por data)
     Future<List<InvoiceModel>> getAllWithTransactions();

     // Retorna a primeira fatura não paga (ou a primeira fatura se todas pagas)
     Future<InvoiceModel?> getFirstUnpaidOrFirst();

     // Marca/desmarca como paga
     Future<bool> markAsPaid(int invoiceId);
     Future<bool> unmarkPaid(int invoiceId);

     // Streams reativos
     Stream<InvoiceModel?> watchByPeriod({
       required DateTime startDate,
       required DateTime endDate,
     });
     Stream<List<InvoiceModel>> watchAllWithTransactions();

     // Deleta uma fatura
     Future<bool> delete(int id);
   }
   ```

   **Implementation** (`lib/data/repositories/invoice_repository_impl.dart`):
   - Implementar todos os métodos da interface
   - `getAllWithTransactions()` deve:
     1. Buscar todas as faturas
     2. Para cada fatura, verificar se existem transações de crédito no período
     3. Retornar apenas faturas com transações
   - `getFirstUnpaidOrFirst()` deve retornar a primeira fatura com `isPaid = false`, ou a primeira fatura se todas pagas

   **Provider** em `repository_providers.dart`:
   ```dart
   @riverpod
   IInvoiceRepository invoiceRepository(InvoiceRepositoryRef ref) {
     return InvoiceRepositoryImpl(LocalDatabase.instance);
   }
   ```

3. **Lógica de Cálculo de Períodos Unificados:**

   Criar utility em `lib/core/utils/invoice_period_utils.dart`:
   ```dart
   /// Calcula o período de fatura unificado para uma data de referência
   /// Considera TODOS os cartões de crédito e usa:
   /// - startDate = EARLIEST billing cycle start entre todos os cartões
   /// - endDate = LATEST billing cycle end entre todos os cartões
   InvoicePeriod calculateUnifiedInvoicePeriod(
     DateTime referenceDate,
     List<AccountModel> creditAccounts,
   ) {
     // Para cada cartão:
     // 1. Calcular o billing cycle start/end baseado em creditPaymentDay
     // 2. Encontrar o EARLIEST start
     // 3. Encontrar o LATEST end
     // 4. Retornar InvoicePeriod(start, end)
   }

   /// Retorna todos os períodos de fatura disponíveis (que têm transações)
   Future<List<InvoicePeriod>> getAllAvailableInvoicePeriods(
     List<AccountModel> creditAccounts,
     List<TransactionModel> creditTransactions,
   ) {
     // 1. Agrupar transações por mês
     // 2. Para cada mês com transações, calcular o período unificado
     // 3. Retornar lista ordenada de períodos
   }
   ```

4. **Queries Dinâmicas para Valores:**

   Criar provider para calcular valores dinamicamente:
   ```dart
   @riverpod
   Future<InvoiceCalculatedData> invoiceCalculatedData(
     InvoiceCalculatedDataRef ref,
     InvoiceModel invoice,
   ) async {
     final transactionRepo = ref.watch(transactionRepositoryProvider);
     final accountRepo = ref.watch(accountRepositoryProvider);

     // 1. Buscar todas as contas de crédito
     final accounts = await accountRepo.getAll();
     final creditAccounts = accounts.where((a) => a.isCredit).toList();

     // 2. Buscar todas as transações no período da fatura
     final allTransactions = await transactionRepo.getAll();
     final periodTransactions = allTransactions.where((t) {
       final account = accounts.firstWhere((a) => a.id == t.accountId);
       return account.isCredit &&
              t.date.isAfter(invoice.startDate.subtract(Duration(days: 1))) &&
              t.date.isBefore(invoice.endDate.add(Duration(days: 1)));
     }).toList();

     // 3. Calcular total e breakdown por conta
     final breakdown = <int, double>{}; // accountId -> amount
     for (final transaction in periodTransactions) {
       breakdown[transaction.accountId] =
         (breakdown[transaction.accountId] ?? 0.0) + transaction.value;
     }

     final total = breakdown.values.fold<double>(0.0, (sum, v) => sum + v);

     return InvoiceCalculatedData(
       total: total,
       breakdown: breakdown,
       transactionCount: periodTransactions.length,
     );
   }
   ```

5. **UI - Dashboard com Navegação Temporal:**

   Atualizar `InvoiceManagerCard` em `lib/presentation/widgets/dashboard/invoice_manager_card.dart`:

   **Header com Navegação:**
   ```dart
   // Substituir "Fatura do Ciclo" por:
   Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
       IconButton(
         icon: Icon(Icons.chevron_left),
         onPressed: () => _navigateToPreviousPeriod(ref),
       ),
       Column(
         children: [
           Text(
             'Fatura',
             style: AppTypography.bodySmall,
           ),
           Text(
             'Mês/Ano', // ex: "Jan/2024"
             style: AppTypography.titleLarge,
           ),
         ],
       ),
       IconButton(
         icon: Icon(Icons.chevron_right),
         onPressed: () => _navigateToNextPeriod(ref),
       ),
     ],
   )
   ```

   **Swipe Gesture:**
   ```dart
   GestureDetector(
     onHorizontalDragEnd: (details) {
       if (details.primaryVelocity! > 0) {
         // Swipe right - período anterior
         _navigateToPreviousPeriod(ref);
       } else if (details.primaryVelocity! < 0) {
         // Swipe left - próximo período
         _navigateToNextPeriod(ref);
       }
     },
     child: // ... conteúdo da fatura
   )
   ```

   **Provider de Período Atual:**
   ```dart
   // StateProvider para controlar qual período está sendo visualizado
   final currentInvoicePeriodProvider = StateProvider<InvoicePeriod?>((ref) {
     // Default: primeiro período não pago (ou primeiro se todos pagos)
     return null; // Será inicializado no build
   });
   ```

   **Lógica de Navegação:**
   ```dart
   void _navigateToPreviousPeriod(WidgetRef ref) {
     final allPeriods = ref.read(allAvailablePeriodsProvider);
     final currentPeriod = ref.read(currentInvoicePeriodProvider);

     // Encontrar período anterior na lista
     final currentIndex = allPeriods.indexOf(currentPeriod);
     if (currentIndex > 0) {
       ref.read(currentInvoicePeriodProvider.notifier).state =
         allPeriods[currentIndex - 1];
     }
   }

   void _navigateToNextPeriod(WidgetRef ref) {
     // Similar, mas incrementa índice
   }
   ```

   **Auto-criação de Faturas:**
   - Ao navegar para um período que NÃO tem fatura no database:
     1. Verificar se o período tem transações de crédito
     2. Se sim, criar automaticamente `InvoiceModel` com `isPaid = false`
     3. Se não, não mostrar nada (ou mensagem "Sem transações neste período")

6. **UI - Histórico de Faturas:**

   Atualizar `InvoiceHistoryScreen` em `lib/presentation/screens/invoice_history_screen.dart`:
   ```dart
   // Lista de faturas (apenas períodos com transações)
   final invoicesAsync = ref.watch(invoiceRepositoryProvider).watchAllWithTransactions();

   ListView.builder(
     itemCount: invoices.length,
     itemBuilder: (context, index) {
       final invoice = invoices[index];
       final calculatedData = ref.watch(invoiceCalculatedDataProvider(invoice));

       return InvoiceHistoryCard(
         invoice: invoice,
         total: calculatedData.total,
         breakdown: calculatedData.breakdown,
         onTap: () {
           // Navegar para dashboard com este período selecionado
           ref.read(currentInvoicePeriodProvider.notifier).state =
             InvoicePeriod(invoice.startDate, invoice.endDate);
           Navigator.pop(context);
         },
       );
     },
   )
   ```

7. **Comportamento Padrão ao Abrir Dashboard:**
   ```dart
   // Ao inicializar o dashboard:
   // 1. Buscar todas as faturas disponíveis (com transações)
   // 2. Filtrar faturas não pagas
   // 3. Se existir fatura não paga, selecionar a PRIMEIRA
   // 4. Se todas pagas, selecionar a PRIMEIRA da lista
   // 5. Se nenhuma fatura existe, usar período atual calculado

   @riverpod
   Future<InvoicePeriod> defaultInvoicePeriod(DefaultInvoicePeriodRef ref) async {
     final invoiceRepo = ref.watch(invoiceRepositoryProvider);
     final firstUnpaid = await invoiceRepo.getFirstUnpaidOrFirst();

     if (firstUnpaid != null) {
       return InvoicePeriod(firstUnpaid.startDate, firstUnpaid.endDate);
     }

     // Fallback: calcular período atual
     final accountRepo = ref.watch(accountRepositoryProvider);
     final accounts = await accountRepo.getAll();
     final creditAccounts = accounts.where((a) => a.isCredit).toList();

     return calculateUnifiedInvoicePeriod(DateTime.now(), creditAccounts);
   }
   ```

**Definition of Done:**
- [x] Tabela `InvoiceItems` removida do database (migration criada)
- [x] Tabela `Invoices` atualizada com schema simplificado (startDate, endDate, isPaid)
- [x] Migration executada com sucesso
- [x] Repository interface e implementation completos com novos métodos
- [x] Provider `invoiceRepository` registrado
- [x] Utility `invoice_period_utils.dart` implementado
- [x] Lógica de cálculo de período unificado entre cartões funcionando
- [x] Provider `invoiceCalculatedData` implementado
- [x] Queries dinâmicas calculam total e breakdown corretamente
- [x] UI do dashboard atualizada com header de navegação (mês/ano)
- [x] Navegação com setas (esquerda/direita) funcionando
- [x] Swipe horizontal funcionando para navegar períodos
- [x] Dashboard abre no primeiro período não pago por padrão
- [x] Auto-criação de faturas ao navegar para períodos com transações
- [x] Apenas períodos com transações são exibíveis
- [x] Tela de histórico lista apenas faturas com transações
- [x] Ao clicar em fatura no histórico, dashboard navega para aquele período
- [x] Breakdown por conta calculado dinamicamente e exibido
- [x] Funcionalidade de marcar/desmarcar "pago" funcionando
- [x] Considera apenas transações de contas de crédito
- [x] Testes unitários do repository
- [x] Testes de integração da lógica de períodos unificados
- [x] Testes de widget das UIs atualizadas
- [x] Code generation executado
- [x] Merge realizado para `develop`

---

### [x] F17-T2: Dashboard Baseado em Faturas com Navegação Temporal

**Branch:** `feature/dashboard-invoice-integration`

**Descrição:**
Transformar o dashboard principal em uma visualização baseada em faturas com navegação temporal. O dashboard deve exibir valores calculados a partir da fatura atual (apenas transações de crédito), permitir navegação entre períodos através de swipe, remover a seção de fatura como card separado, e integrar a seção de faturas em uma página de detalhes dedicada.

**Implementação Esperada:**

1. **Remover Seção de Fatura do Dashboard**
   - Remover o widget `InvoiceManagerCard` da tela do dashboard
   - A seção de fatura não será mais um card separado - os valores da fatura serão a base do dashboard inteiro
   - Todos os cálculos e exibições agora baseados na fatura atual

2. **Dashboard Baseado em Valores de Fatura (Apenas Crédito)**

   Provider de Dados do Dashboard:
   ```dart
   @riverpod
   Future<DashboardData> dashboardData(
     DashboardDataRef ref,
     InvoicePeriod currentPeriod,
   ) async {
     final transactionRepo = ref.watch(transactionRepositoryProvider);
     final accountRepo = ref.watch(accountRepositoryProvider);

     // 1. Buscar todas as contas de crédito
     final accounts = await accountRepo.getAll();
     final creditAccounts = accounts.where((a) => a.isCredit).toList();

     // 2. Buscar transações do período da fatura (APENAS CRÉDITO)
     final allTransactions = await transactionRepo.getAll();
     final invoiceTransactions = allTransactions.where((t) {
       final account = accounts.firstWhere((a) => a.id == t.accountId);
       return account.isCredit &&
              t.date.isAfter(currentPeriod.startDate.subtract(Duration(days: 1))) &&
              t.date.isBefore(currentPeriod.endDate.add(Duration(days: 1)));
     }).toList();

     // 3. Calcular valores
     final totalSpent = invoiceTransactions.fold(0.0, (sum, t) => sum + t.value);
     final totalCreditLimit = creditAccounts.fold(0.0, (sum, a) => sum + (a.creditLimit ?? 0));
     final availableBudget = totalCreditLimit - totalSpent;

     // 4. Breakdown por conta
     final breakdown = <int, double>{};
     for (final transaction in invoiceTransactions) {
       breakdown[transaction.accountId] =
         (breakdown[transaction.accountId] ?? 0.0) + transaction.value;
     }

     return DashboardData(
       totalSpent: totalSpent,
       availableBudget: availableBudget,
       totalLimit: totalCreditLimit,
       breakdown: breakdown,
       transactions: invoiceTransactions,
     );
   }
   ```

3. **Header do Dashboard com Navegação Temporal**

   Substituir "Início" por Formato MÊS ANO (ex: "NOV 2025"):
   ```dart
   AppBar(
     title: Text(
       _formatPeriodTitle(currentPeriod), // "NOV 2025"
       style: AppTypography.titleLarge,
     ),
     centerTitle: true,
   )

   String _formatPeriodTitle(InvoicePeriod period) {
     final monthNames = [
       'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
       'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'
     ];

     final month = monthNames[period.startDate.month - 1];
     final year = period.startDate.year;

     return '$month $year';
   }
   ```

4. **PageView para Navegação por Swipe**

   Implementação do PageView:
   ```dart
   class DashboardScreen extends ConsumerStatefulWidget {
     @override
     ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
   }

   class _DashboardScreenState extends ConsumerState<DashboardScreen> {
     late PageController _pageController;

     @override
     void initState() {
       super.initState();

       // Inicializar no índice da fatura atual (primeira não paga)
       final initialIndex = _getInitialPageIndex();
       _pageController = PageController(initialPage: initialIndex);
     }

     @override
     Widget build(BuildContext context) {
       final periodsAsync = ref.watch(allAvailablePeriodsProvider);

       return periodsAsync.when(
         data: (periods) => PageView.builder(
           controller: _pageController,
           itemCount: periods.length,
           onPageChanged: (index) {
             // Atualizar período atual no provider
             ref.read(currentInvoicePeriodProvider.notifier).state =
               periods[index];
           },
           itemBuilder: (context, index) {
             final period = periods[index];
             return _buildDashboardContent(period);
           },
         ),
         loading: () => LoadingIndicator(),
         error: (err, stack) => ErrorWidget(err),
       );
     }

     Widget _buildDashboardContent(InvoicePeriod period) {
       return SingleChildScrollView(
         child: Column(
           children: [
             // Card de orçamento disponível
             _buildBudgetCard(period),

             // Breakdown por conta
             _buildAccountBreakdown(period),

             // Histórico de transações do período
             _buildTransactionHistory(period),

             // Botões de ação (abaixo do histórico)
             _buildActionButtons(period),
           ],
         ),
       );
     }
   }
   ```

   Comportamento de Navegação:
   - Swipe para a direita → período ANTERIOR (mês passado)
   - Swipe para a esquerda → período FUTURO (próximo mês)
   - PageView carrega períodos conforme disponíveis

5. **Botões de Ação Abaixo do Histórico**

   ```dart
   Widget _buildActionButtons(InvoicePeriod period) {
     final invoice = ref.watch(invoiceByPeriodProvider(period));

     return Padding(
       padding: AppSpacing.paddingMd,
       child: Row(
         children: [
           // Botão de pagamento (funciona como toggle)
           if (invoice != null)
             Expanded(
               child: PrimaryButton(
                 label: invoice.isPaid ? 'Desmarcar Pagamento' : 'Pagar Fatura',
                 onPressed: () => _toggleInvoicePayment(invoice),
               ),
             ),

           if (invoice != null)
             SizedBox(width: AppSpacing.md),

           // Botão "Ver Detalhes"
           Expanded(
             child: SecondaryButton(
               label: 'Ver Detalhes',
               onPressed: () => Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (_) => InvoiceDetailsScreen(period: period),
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }

   Future<void> _toggleInvoicePayment(InvoiceModel invoice) async {
     final confirmed = await showDialog<bool>(
       context: context,
       builder: (context) => AlertDialog(
         title: Text(invoice.isPaid ? 'Desmarcar Pagamento' : 'Confirmar Pagamento'),
         content: Text(
           invoice.isPaid
             ? 'Desmarcar esta fatura como paga?'
             : 'Marcar esta fatura como paga?'
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context, false),
             child: Text('Cancelar'),
           ),
           TextButton(
             onPressed: () => Navigator.pop(context, true),
             child: Text('Confirmar'),
           ),
         ],
       ),
     );

     if (confirmed == true) {
       if (invoice.isPaid) {
         await ref.read(invoiceRepositoryProvider).unmarkPaid(invoice.id);
       } else {
         await ref.read(invoiceRepositoryProvider).markAsPaid(invoice.id);
       }
     }
   }
   ```

6. **Página de Detalhes da Fatura**

   Criar `InvoiceDetailsScreen`:
   ```dart
   class InvoiceDetailsScreen extends ConsumerWidget {
     final InvoicePeriod period;

     const InvoiceDetailsScreen({required this.period});

     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final invoiceAsync = ref.watch(invoiceByPeriodProvider(period));
       final dataAsync = ref.watch(dashboardDataProvider(period));

       return Scaffold(
         appBar: AppBar(
           title: Text('Detalhes da Fatura'),
         ),
         body: SingleChildScrollView(
           child: Column(
             children: [
               // 1. Resumo da fatura
               _buildInvoiceSummary(dataAsync),

               // 2. Breakdown por conta
               _buildAccountBreakdown(dataAsync),

               // 3. Lista de transações do período
               _buildTransactionList(dataAsync),

               // 4. Histórico de faturas
               _buildInvoiceHistory(),
             ],
           ),
         ),
       );
     }

     Widget _buildInvoiceHistory() {
       final invoicesAsync = ref.watch(allInvoicesWithTransactionsProvider);

       return invoicesAsync.when(
         data: (invoices) => Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Padding(
               padding: AppSpacing.paddingMd,
               child: Text(
                 'Histórico de Faturas',
                 style: AppTypography.titleMedium,
               ),
             ),
             ListView.builder(
               shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
               itemCount: invoices.length,
               itemBuilder: (context, index) {
                 final invoice = invoices[index];
                 return InvoiceHistoryTile(
                   invoice: invoice,
                   onTap: () {
                     // Navegar para dashboard com este período
                     ref.read(currentInvoicePeriodProvider.notifier).state =
                       InvoicePeriod(invoice.startDate, invoice.endDate);
                     Navigator.popUntil(context, (route) => route.isFirst);
                   },
                 );
               },
             ),
           ],
         ),
         loading: () => LoadingIndicator(),
         error: (err, stack) => ErrorWidget(err),
       );
     }
   }
   ```

7. **Validações e Edge Cases**

   - Período sem transações: Mostrar mensagem "Nenhuma transação neste período"
   - Primeira fatura não paga: Dashboard abre automaticamente nesta fatura
   - Todas faturas pagas: Dashboard abre na fatura mais recente
   - Navegação infinita: Carregar períodos dinamicamente conforme necessário
   - Performance: Usar `AutoDisposeProvider` para liberar memória

8. **UI/UX Improvements**

   - Indicador de posição: Mostrar dots ou texto de posição abaixo do título
   - Animação de transição: Smooth scroll entre páginas
   - Pull-to-refresh: Atualizar dados da fatura atual
   - Skeleton loading: Mostrar placeholders enquanto carrega dados

**Definition of Done:**
- [x] Seção `InvoiceManagerCard` removida do dashboard
- [x] Dashboard recalculado baseado em valores de fatura (apenas crédito)
- [x] Transações de débito completamente excluídas do cálculo de orçamento
- [x] Header do dashboard mostra "MÊS ANO" em vez de "Início"
- [x] PageView implementado com swipe horizontal funcionando
- [x] Navegação entre períodos (anterior/futuro) funciona corretamente
- [x] Dashboard abre na primeira fatura não paga por padrão
- [x] Botão de pagamento funciona como toggle (Pagar ↔ Desmarcar Pagamento)
- [x] Label do botão muda dinamicamente baseado no status da fatura
- [x] Dialog de confirmação adapta mensagem ao status atual
- [x] Botão "Ver Detalhes" implementado e navegação funciona
- [x] `InvoiceDetailsScreen` criada com todo conteúdo da antiga seção de faturas
- [x] Histórico de faturas integrado na página de detalhes
- [x] Navegação de detalhes → dashboard funciona corretamente
- [x] Breakdown por conta calculado dinamicamente e exibido
- [x] Período sem transações tratado adequadamente
- [x] Performance otimizada com AutoDispose
- [x] Testes unitários dos providers de dados
- [x] Testes de widget do PageView e navegação
- [x] Testes de integração do fluxo completo
- [x] Code generation executado
- [x] Merge realizado para `develop`

---

### [x] F17-T3: Transações Parceladas com Criação Automática

**Branch:** `feature/installment-transactions`

**Descrição:**
Implementar sistema de transações parceladas que cria automaticamente as parcelas futuras nos próximos ciclos de faturamento.

**Implementação Esperada:**

1. **Database Updates:**
   - Adicionar campos na tabela `Transactions`:
   ```dart
   IntColumn get installmentNumber => integer().nullable()(); // Número da parcela atual
   IntColumn get installmentTotal => integer().nullable()(); // Total de parcelas
   TextColumn get installmentGroupId => text().nullable()(); // UUID para agrupar parcelas
   ```

2. **Transaction Form Updates:**
   - Adicionar checkbox "Parcelar transação" (apenas para crédito)
   - Quando habilitado, mostrar campos:
     - "Parcela atual" (número de 1 a N)
     - "Total de parcelas" (número de 2 a 99)
   - Validações:
     - Parcela atual <= Total de parcelas
     - Disponível apenas para contas de crédito (`account.isCredit == true`)
     - Se débito selecionado, desabilitar checkbox

3. **Lógica de Criação Automática:**
   ```dart
   Future<void> createInstallmentTransactions({
     required TransactionModel baseTransaction,
     required int currentInstallment,
     required int totalInstallments,
   }) async {
     final groupId = Uuid().v4();

     // Criar transação atual com título atualizado
     final currentTransaction = baseTransaction.copyWith(
       description: '${baseTransaction.description} $currentInstallment/$totalInstallments',
       installmentNumber: currentInstallment,
       installmentTotal: totalInstallments,
       installmentGroupId: groupId,
     );
     await create(currentTransaction);

     // Criar parcelas futuras
     for (int i = currentInstallment + 1; i <= totalInstallments; i++) {
       final nextCycleDate = _calculateNextCycleFirstDay(
         baseTransaction.date,
         i - currentInstallment
       );

       final futureTransaction = baseTransaction.copyWith(
         description: '${baseTransaction.description} $i/$totalInstallments',
         date: nextCycleDate,
         installmentNumber: i,
         installmentTotal: totalInstallments,
         installmentGroupId: groupId,
       );

       await create(futureTransaction);
     }
   }

   DateTime _calculateNextCycleFirstDay(DateTime current, int cyclesAhead) {
     // Obter creditPaymentDay da conta
     // Calcular primeiro dia do próximo ciclo
     // Ciclo = de (paymentDay + 1) até próximo paymentDay
     return DateTime(
       current.year,
       current.month + cyclesAhead,
       account.creditPaymentDay + 1,
     );
   }
   ```

4. **Exemplo de Uso:**
   - Usuário cria "Wine-Clube" com valor R$ 75,75
   - Parcela atual: 8
   - Total de parcelas: 12
   - Conta: Nubank (crédito)
   - Resultado:
     - **Ciclo atual:** Wine-Clube 8/12 - R$ 75,75
     - **Próximo ciclo:** Wine-Clube 9/12 - R$ 75,75 (dia 1 do ciclo)
     - **Ciclo +2:** Wine-Clube 10/12 - R$ 75,75
     - **Ciclo +3:** Wine-Clube 11/12 - R$ 75,75
     - **Ciclo +4:** Wine-Clube 12/12 - R$ 75,75

5. **UI Updates:**
   - Transaction list mostra parcelas com ícone especial
   - Tooltip ao editar: "Esta transação faz parte de um parcelamento"
   - Opção de editar/deletar: perguntar se quer afetar todas as parcelas ou apenas esta

6. **Edge Cases:**
   - Validar que conta é crédito antes de criar parcelas
   - Se conta mudar para débito, não permitir parcelamento
   - Se usuário editar parcela, não afetar as outras (por padrão)

**Definition of Done:**
- [x] Campos de parcelamento adicionados à tabela `Transactions`
- [x] UI do formulário atualizada com campos de parcela
- [x] Validação de conta de crédito funcionando
- [x] Lógica de criação automática implementada
- [x] Cálculo correto do primeiro dia do próximo ciclo
- [x] Formato do título com parcela funcionando (X/Y)
- [x] Exemplo do Wine-Clube funciona corretamente
- [x] Ícone/indicador visual de parcelas na lista
- [x] Opções de edição/exclusão tratadas
- [x] Testes unitários da lógica de criação
- [x] Testes de integração do fluxo completo
- [x] Testes de edge cases (débito, validações)
- [x] Code generation executado
- [x] Merge realizado para `develop`

---

## 🎊 Conclusão

Este plano mapeia todas as **79 tarefas** necessárias para completar o MVP do Previsor Financeiro. Ao seguir este roadmap, você terá um aplicativo funcional, testado e preparado para uso pessoal, com uma arquitetura sólida que permitirá expansões futuras.

A **Fase 5** representa a primeira iteração de melhorias baseada em uso real, demonstrando a importância de testar o aplicativo e iterar sobre o design inicial.

A **Fase 6** adiciona refinamentos críticos de UX: onboarding para novos usuários, gestão completa de transações, e padronização de inputs numéricos para o mercado brasileiro.

A **Fase 7** introduz automação inteligente e identidade visual: ícone personalizado do app e captura automática de transações a partir de notificações bancárias, com arquitetura extensível para suportar múltiplos bancos.

A **Fase 8** foca em correções críticas e refinamentos de UX: sistema de input numérico tipo Nubank, bottom sheet com abas para melhor experiência com teclado, swipe-to-delete aprimorado, toggle entre dashboard e histórico, correção de permissões de notificação, e file picker para backups.

A **Fase 9** traz correções de UX e padronização visual: correção do bug de exibição de valores nas configurações e padronização do app bar em todas as telas principais para garantir consistência visual e facilitar o acesso às configurações.

A **Fase 10** garante a estabilidade e saúde do código: atualização de dependências, migração de APIs deprecated, implementação de logging adequado, e remoção de código morto.

**Bom desenvolvimento! 🚀**

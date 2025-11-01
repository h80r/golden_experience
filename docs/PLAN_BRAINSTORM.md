## ⚙️ Fase 18: Transações de Receita e Depósito Automático de Salário

**Objetivo:** Implementar suporte a transações de receita (positivas) e criar sistema de depósito automático do salário na conta configurada.

**Status:** 0 / 7 tarefas concluídas

**Nota:** Esta fase prepara a base para funcionalidades futuras de pagamento de faturas e gestão de invoices de cartão de crédito.

---

### [ ] F18-T1: Atualizar Testes e Documentação

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

### [ ] F18-T2: Implementar Sistema de Tipo de Transação

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

### [ ] F18-T3: Criar Tabela Invoice para Gestão Futura de Faturas

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

### [ ] F18-T4: Adicionar Configuração de Conta de Salário

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

### [ ] F18-T5: Atualizar UI de Transação para Receita/Despesa

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

### [ ] F18-T6: Implementar Depósito Automático de Salário

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

### [ ] F18-T7: Testes e Casos Extremos

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

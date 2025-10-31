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

**Total de Tarefas:** 76
**Concluídas:** 53 / 76 (70%)

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
- **Fase 17 - Transações de Receita e Depósito Automático:** 0 / 7 (0%)

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

---

## 🔍 Fase 16: Melhorias no Histórico de Transações

**Objetivo:** Aprimorar a tela de histórico de transações com filtragem por ciclo de faturamento (alinhado ao dashboard), filtros débito/crédito, card de soma total flutuante e tags visuais.

**Status:** 7 / 7 tarefas concluídas ✅ FASE COMPLETA

---

### [x] F16-T1: Filtrar Transações por Ciclo de Faturamento

**Branch:** `feature/transaction-history-billing-cycle-filter`

**Descrição:**
Alterar a lógica de exibição do histórico de transações para mostrar, por padrão, as transações do ciclo de faturamento atual (como calculado na página principal), em vez de simplesmente filtrar por mês.

**Implementação Esperada:**

1. **Lógica de Filtro:**
   - Para contas de **crédito**: usar o período entre closing date e payment day do ciclo atual
   - Para contas de **débito**: usar mês atual (comportamento existente)
   - O filtro deve respeitar a mesma lógica usada no dashboard para calcular "quanto ainda posso gastar"

2. **UI Updates:**
   - Adicionar chip/badge mostrando o período atual: "Ciclo: 15/out - 14/nov"
   - Botão para alternar entre: "Ciclo Atual" / "Mês Atual" / "Todos"
   - Manter funcionalidade de navegação entre períodos (setas < >)

3. **Repository/Use Case:**
   - Criar método `getTransactionsByBillingCycle(accountId, startDate, endDate)`
   - Reutilizar lógica de cálculo de ciclo do dashboard

**Definition of Done:**
- [x] Histórico exibe transações do ciclo de faturamento por padrão
- [x] Filtro de período (Ciclo/Mês/Todos) implementado
- [x] UI mostra claramente qual período está sendo exibido
- [x] Lógica alinhada com cálculos do dashboard
- [x] Testes de integração para diferentes tipos de conta
- [x] Merge realizado para `develop`

---

### [x] F16-T2: Adicionar Filtro Débito/Crédito no Histórico

**Branch:** `feature/transaction-history-account-type-filter`

**Descrição:**
Implementar filtro para mostrar apenas transações de contas de débito ou crédito no histórico.

**Implementação Esperada:**

1. **Filter UI:**
   - Adicionar SegmentedButton ou FilterChips abaixo do período:
     - "Todas" (padrão)
     - "Débito"
     - "Crédito"
   - Manter estado do filtro durante a sessão

2. **Repository Method:**
   ```dart
   Future<List<TransactionModel>> getTransactionsByAccountType({
     required DateTime startDate,
     required DateTime endDate,
     String? accountType, // 'debit', 'credit', null for all
   });
   ```

3. **Query Logic:**
   - Join com tabela Accounts
   - Filtrar por `account.isDebit` ou `account.isCredit` conforme seleção
   - Considerar contas dual-type (tanto débito quanto crédito)

4. **UX Details:**
   - Mostrar contagem: "12 transações (Débito)"
   - Animação suave ao trocar filtros

**Definition of Done:**
- [x] Filtro débito/crédito implementado na UI
- [x] Repository method criado
- [x] Query filtra corretamente por tipo de conta
- [x] Contagem de transações atualiza dinamicamente
- [x] Testes unitários para query
- [x] Testes de widget para filtro
- [x] Merge realizado para `develop`

---

### [x] F16-T3: Card de Soma Total Flutuante com Transição para FAB

**Branch:** `feature/transaction-history-floating-sum-card`

**Descrição:**
Criar um card pequeno flutuante no rodapé do histórico mostrando a soma total das transações filtradas. Ao tocar, o card se transforma no FAB para adicionar nova transação.

**Implementação Esperada:**

1. **Floating Sum Card:**
   ```dart
   // Posição: bottom-center, acima do FAB
   Container(
     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
     decoration: BoxDecoration(
       color: AppColors.surface,
       borderRadius: BorderRadius.circular(24),
       boxShadow: [AppShadows.medium],
     ),
     child: Row(
       mainAxisSize: MainAxisSize.min,
       children: [
         Text('Total: ', style: AppTypography.bodySmall),
         Text('R$ 1.234,56', style: AppTypography.titleMedium.copyWith(
           color: isNegative ? Colors.red : Colors.green,
         )),
         SizedBox(width: 8),
         Icon(Icons.expand_less, size: 16),
       ],
     ),
   )
   ```

2. **Animation Logic:**
   - Estado inicial: SumCard visível, FAB oculto
   - Ao tocar no SumCard:
     - SumCard escala e move para posição do FAB
     - Transforma em FAB circular com ícone "+"
     - AnimatedContainer com duration: 300ms
   - Ao fechar bottom sheet: animação reversa

3. **Cálculo da Soma:**
   - Somar valores de todas as transações visíveis (após filtros)
   - Para receitas: valor positivo
   - Para despesas: valor negativo
   - Cor verde se líquido positivo, vermelho se negativo

4. **Stack Layout:**
   ```dart
   Stack(
     children: [
       TransactionList(),
       Positioned(
         bottom: 16,
         left: 0,
         right: 0,
         child: AnimatedSwitcher(
           duration: Duration(milliseconds: 300),
           child: _showingSumCard ? SumCard() : AddTransactionFAB(),
         ),
       ),
     ],
   )
   ```

**Definition of Done:**
- [x] Sum card flutuante implementado
- [x] Cálculo de soma total funcional
- [x] Animação de transição para FAB suave
- [x] Cores dinâmicas (verde/vermelho) conforme saldo
- [x] Funcionalidade de adicionar transação mantida
- [ ] Testes de widget
- [x] Merge realizado para `develop`

---

### [x] F16-T4: Adicionar Tags Visuais de Débito/Crédito nas Transações

**Branch:** `feature/transaction-debit-credit-tags`

**Descrição:**
Adicionar tags visuais (badges) em cada transação do histórico indicando se é débito ou crédito.

**Implementação Esperada:**

1. **Tag Design:**
   ```dart
   // Débito
   Container(
     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
     decoration: BoxDecoration(
       color: AppColors.debitTag.withOpacity(0.1),
       borderRadius: BorderRadius.circular(8),
     ),
     child: Text(
       'Débito',
       style: AppTypography.labelSmall.copyWith(
         color: AppColors.debitTag,
         fontWeight: FontWeight.w600,
       ),
     ),
   )

   // Crédito
   Container(
     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
     decoration: BoxDecoration(
       color: AppColors.creditTag.withOpacity(0.1),
       borderRadius: BorderRadius.circular(8),
     ),
     child: Text(
       'Crédito',
       style: AppTypography.labelSmall.copyWith(
         color: AppColors.creditTag,
         fontWeight: FontWeight.w600,
       ),
     ),
   )
   ```

2. **Transaction List Item Layout:**
   ```dart
   // Estrutura do item:
   ListTile(
     leading: CategoryIcon(),
     title: Row(
       children: [
         Text(description),
         SizedBox(width: 8),
         DebitCreditTag(account: transaction.account),
       ],
     ),
     subtitle: Text(date),
     trailing: Text(value),
   )
   ```

3. **Color Palette Update:**
   - Adicionar cores ao `app_colors.dart`:
   ```dart
   static const debitTag = Color(0xFF2196F3); // Blue
   static const creditTag = Color(0xFFFF9800); // Orange
   ```

4. **Positioning:**
   - Tag ao lado da descrição da transação
   - Tamanho pequeno e discreto
   - Não interferir na leitura do valor principal

**Definition of Done:**
- [x] Tags visuais implementadas
- [x] Cores adicionadas ao design system
- [x] Layout do item de transação atualizado
- [x] Tags aparecem em todas as transações
- [x] Estilo consistente com design do app
- [ ] Testes de widget
- [x] Merge realizado para `develop`

---

### [x] F16-T5: Corrigir Tipo de Transação ao Editar

**Branch:** `fix/transaction-edit-type-mismatch`

**Descrição:**
Corrigir bug onde o modal de edição de transação não respeita o tipo de conta da transação, sempre defaultando para crédito mesmo quando a transação é de débito.

**Definition of Done:**
- [x] Modal de edição carrega o tipo correto da transação (débito/crédito)
- [x] Tipo de transação é preservado durante a edição
- [x] Testes de widget para verificar o comportamento
- [x] Merge realizado para `develop`

---

### [x] F16-T6: Melhorar UI dos Filtros do Histórico

**Branch:** `feature/transaction-filters-ui-improvements`

**Descrição:**
Melhorar a interface do filtro de transações: converter o período em dropdown e usar um seletor visual similar ao seletor débito/crédito do expense sheet para o tipo de transação.

**Definition of Done:**
- [x] Filtro de período convertido para dropdown
- [x] Filtro de tipo de transação usando seletor visual (similar ao expense sheet)
- [x] UI consistente com padrões do app
- [ ] Testes de widget atualizados
- [x] Merge realizado para `develop`

---

### [x] F16-T7: Corrigir Persistência de Configuração de Dia de Pagamento

**Branch:** `fix/salary-payday-workday-persistence`

**Descrição:**
Corrigir bug onde configurar o dia de pagamento do salário como o último dia útil do mês não persiste corretamente. Ao recarregar a página de configurações, o valor exibido volta para o 1º dia útil.

**Implementação Esperada:**

1. **Investigar Causa Raiz:**
   - Verificar lógica de salvamento em `app_settings_repository.dart`
   - Verificar se o valor correto está sendo persistido no banco de dados
   - Verificar lógica de carregamento no widget de configurações
   - Identificar se o problema está no save, load, ou UI state

2. **Correção:**
   - Se o problema for no save: corrigir método de update do repository
   - Se o problema for no load: corrigir método de fetch/watch do repository
   - Se o problema for no UI: corrigir estado inicial do dropdown/selector

3. **Validação:**
   - Testar cenários:
     - Salvar 1º dia útil e recarregar
     - Salvar último dia útil e recarregar
     - Salvar 5º dia útil e recarregar
   - Verificar persistência após fechar e reabrir o app

**Definition of Done:**
- [x] Causa raiz identificada
- [x] Bug corrigido na camada apropriada
- [x] Todos os valores de dia útil persistem corretamente
- [x] Testes de integração adicionados para prevenir regressão
- [x] Merge realizado para `develop`

---

## ⚙️ Fase 17: Transações de Receita e Depósito Automático de Salário

**Objetivo:** Implementar suporte a transações de receita (positivas) e criar sistema de depósito automático do salário na conta configurada.

**Status:** 0 / 7 tarefas concluídas

**Nota:** Esta fase prepara a base para funcionalidades futuras de pagamento de faturas e gestão de invoices de cartão de crédito.

---

### [ ] F17-T1: Atualizar Testes e Documentação

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

### [ ] F17-T2: Implementar Sistema de Tipo de Transação

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

### [ ] F17-T3: Criar Tabela Invoice para Gestão Futura de Faturas

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

### [ ] F17-T4: Adicionar Configuração de Conta de Salário

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

### [ ] F17-T5: Atualizar UI de Transação para Receita/Despesa

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

### [ ] F17-T6: Implementar Depósito Automático de Salário

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

### [ ] F17-T7: Testes e Casos Extremos

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

Este plano mapeia todas as **73 tarefas** necessárias para completar o MVP do Previsor Financeiro. Ao seguir este roadmap, você terá um aplicativo funcional, testado e preparado para uso pessoal, com uma arquitetura sólida que permitirá expansões futuras.

A **Fase 5** representa a primeira iteração de melhorias baseada em uso real, demonstrando a importância de testar o aplicativo e iterar sobre o design inicial.

A **Fase 6** adiciona refinamentos críticos de UX: onboarding para novos usuários, gestão completa de transações, e padronização de inputs numéricos para o mercado brasileiro.

A **Fase 7** introduz automação inteligente e identidade visual: ícone personalizado do app e captura automática de transações a partir de notificações bancárias, com arquitetura extensível para suportar múltiplos bancos.

A **Fase 8** foca em correções críticas e refinamentos de UX: sistema de input numérico tipo Nubank, bottom sheet com abas para melhor experiência com teclado, swipe-to-delete aprimorado, toggle entre dashboard e histórico, correção de permissões de notificação, e file picker para backups.

A **Fase 9** traz correções de UX e padronização visual: correção do bug de exibição de valores nas configurações e padronização do app bar em todas as telas principais para garantir consistência visual e facilitar o acesso às configurações.

A **Fase 10** garante a estabilidade e saúde do código: atualização de dependências, migração de APIs deprecated, implementação de logging adequado, e remoção de código morto.

**Bom desenvolvimento! 🚀**

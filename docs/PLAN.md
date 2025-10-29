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

**Total de Tarefas:** 66
**Concluídas:** 40 / 66 (61%)

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
- **Fase 14 - Refatoração do Sistema de Reserva:** 0 / 4 (0%)
- **Fase 15 - Transações de Receita e Depósito Automático:** 0 / 6 (0%)

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

---

## ⚙️ Fase 13: Gestão Avançada de Contas e Configurações

**Objetivo:** Aprimorar a gestão de contas, categorias e configurações financeiras com recursos avançados de personalização.

**Status:** 6 / 6 tarefas concluídas

---

### [x] F13-T1: Correção - Fix New Account Bottom Sheet Behavior

**Branch:** `fix/account-bottom-sheet-keyboard`

**Descrição:**
Corrigir o comportamento do bottom sheet de nova conta para expandir e contrair adequadamente com e sem teclado, exatamente como o bottom sheet de transações.

**Problema Atual:**
- Bottom sheet de conta não se ajusta corretamente quando o teclado aparece
- Campos podem ficar ocultos atrás do teclado
- Comportamento inconsistente com o bottom sheet de transações

**Implementação Esperada:**
- Usar `MediaQuery.of(context).viewInsets.bottom` para detectar teclado
- Aplicar padding inferior dinâmico
- Bottom sheet deve expandir quando teclado aparece
- Bottom sheet deve contrair quando teclado desaparece
- Scroll automático para campo em foco

**Referência:**
Verificar implementação do `ExpenseDetailsBottomSheet` e aplicar a mesma lógica.

**Definition of Done:**
- [x] Bottom sheet ajusta altura corretamente com teclado
- [x] Todos os campos acessíveis quando teclado está visível
- [x] Scroll automático para campo em foco
- [x] Comportamento consistente com bottom sheet de transações
- [x] Testes de widget para verificar comportamento
- [x] Merge realizado para `develop`

---

### [x] F13-T2: Melhoria - Collapsible Account Tiles with Click to Expand

**Branch:** `feature/collapsible-account-tiles`

**Descrição:**
Reduzir o tamanho dos tiles de contas e implementar funcionalidade de click-to-expand para mostrar detalhes.

**Problema Atual:**
- Tiles de contas ocupam muito espaço vertical
- Todas as informações sempre visíveis desperdiçam espaço
- Dificulta visualização quando há muitas contas

**Implementação Esperada:**
1. **Versão Colapsada (Padrão):**
   - Nome da conta
   - Tipo (débito/crédito)
   - Saldo atual
   - Ícone de expansão

2. **Versão Expandida (Ao Clicar):**
   - Todas as informações da versão colapsada
   - Limite de crédito (se aplicável)
   - Saldo da fatura (se aplicável)
   - Data de vencimento (se aplicável)
   - Botões de ação (editar, excluir)

3. **Animação:**
   - Transição suave entre estados
   - Rotação do ícone de expansão
   - Expansion tile animado

**Exemplo de Implementação:**
```dart
ExpansionTile(
  title: Text(account.name),
  subtitle: Text('${account.type} - ${CurrencyFormatter.format(account.balance)}'),
  children: [
    // Detalhes expandidos
    if (account.isCredit) ...[
      ListTile(
        title: Text('Limite de Crédito'),
        trailing: Text(CurrencyFormatter.format(account.creditLimit)),
      ),
      // ... outros detalhes
    ],
    ButtonBar(
      children: [
        IconButton(icon: Icon(Icons.edit), onPressed: () => _editAccount(account)),
        IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteAccount(account)),
      ],
    ),
  ],
)
```

**Definition of Done:**
- [x] Account tiles colapsados por padrão
- [x] Click expande/colapsa tile com animação
- [x] Informações essenciais visíveis em modo colapsado
- [x] Detalhes completos visíveis em modo expandido
- [x] Ícone de expansão rotaciona adequadamente
- [x] Testes de widget implementados
- [x] Merge realizado para `develop`

---

### [x] F13-T3: Feature - Default Account Selection

**Branch:** `feature/default-account-selection`

**Descrição:**
Implementar seleção de conta padrão na página de contas que já venha pré-selecionada no dropdown de criação/edição de transações.

**Implementação Esperada:**
1. **Adicionar Campo no Banco:**
   - Adicionar coluna `isDefault` (booleano) na tabela `Accounts`
   - Apenas uma conta pode ser default por vez

2. **UI na Página de Contas:**
   - Adicionar ícone de "estrela" ou "favorito" nos tiles de conta
   - Permitir marcar/desmarcar como conta padrão
   - Destacar visualmente a conta padrão (ex: ícone dourado)

3. **Integração com Bottom Sheet de Transações:**
   - Ao abrir bottom sheet, pré-selecionar a conta marcada como default
   - Se não houver conta default, manter comportamento atual

4. **Regras de Negócio:**
   - Ao marcar uma conta como default, desmarcar a anterior automaticamente
   - Não permitir excluir conta marcada como default sem antes marcar outra
   - Se conta default for excluída, limpar flag de default

**Database Migration:**
```dart
// Adicionar ao schema do Drift
class Accounts extends Table {
  // ... campos existentes
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}
```

**Definition of Done:**
- [x] Coluna `isDefault` adicionada à tabela Accounts
- [x] UI para marcar/desmarcar conta padrão implementada
- [x] Apenas uma conta pode ser default por vez
- [x] Bottom sheet de transações pré-seleciona conta padrão
- [x] Regras de negócio para exclusão implementadas
- [x] Testes de integração para seleção de conta padrão
- [x] Migration documentada
- [x] Merge realizado para `develop`

---

### [x] F13-T4: Feature - Category Management in Settings

**Branch:** `feature/category-management`

**Descrição:**
Adicionar seção nas configurações para criação/remoção de categorias e seleção de categoria padrão.

**Implementação Esperada:**
1. **UI na Settings Screen:**
   - Nova seção "Gerenciar Categorias"
   - Lista de categorias existentes
   - Botão para adicionar nova categoria
   - Ícone de estrela para marcar categoria padrão
   - Botão de excluir categoria

2. **Adicionar Campo no Banco:**
   - Adicionar coluna `isDefault` na tabela `Categories`
   - Apenas uma categoria pode ser default por vez

3. **Dialog de Nova Categoria:**
   - Campo de texto para nome da categoria
   - Seletor de cor/ícone (opcional para MVP)
   - Botão salvar/cancelar

4. **Regras de Negócio:**
   - Não permitir excluir categorias que tenham transações vinculadas
   - Ao marcar categoria como default, desmarcar a anterior
   - Bottom sheet de transações pré-seleciona categoria default

5. **Categorias Iniciais:**
   - Criar categorias padrão no primeiro uso:
     - Alimentação
     - Transporte
     - Lazer
     - Saúde
     - Educação
     - Moradia
     - Outros

**Definition of Done:**
- [x] Seção de gerenciamento de categorias na settings
- [x] CRUD completo de categorias implementado
- [x] Seleção de categoria padrão funcional
- [x] Validação de exclusão (categorias com transações)
- [x] Categorias iniciais criadas no onboarding
- [x] Bottom sheet de transações pré-seleciona categoria padrão
- [x] Testes de integração
- [x] Merge realizado para `develop`

---

### [x] F13-T5: Feature - Salary Payment Date Configuration

**Branch:** `feature/salary-payment-date`

**Descrição:**
Criar seção nas configurações para definir a data mensal em que o salário é recebido com suporte a dois modos: data específica (calendário) e dia útil específico com cálculo de feriados.

**Implementação Esperada:**
1. **Adicionar Campos no Banco:**
   - Adicionar coluna `salaryPaymentMode` (texto: 'calendar' ou 'workday') na tabela `AppSettings`
   - Adicionar coluna `salaryPaymentValue` (inteiro) na tabela `AppSettings`
   - Valores padrão: modo 'calendar', valor 1

2. **UI na Settings Screen:**
   - SegmentedToggle para seleção entre "Dia Específico" e "Dia Útil"
   - Modo Dia Específico: Calendário inline personalizado mostrando mês atual com seleção de dias (1-31)
   - Modo Dia Útil: Dropdown com opções comuns (1º, 5º, 10º, 15º, 20º, último dia útil) + opção "Outro..." para entrada customizada (1-23)
   - Datas de trabalho mostram o day/month correspondente (ex: "1º dia útil (03/11)")

3. **Lógica de Feriados:**
   - Implementar calendário brasileiro de feriados nacionais
   - Incluir feriados específicos de São Paulo
   - Suportar cálculo do nº dia útil excluindo finais de semana e feriados
   - Seleção inteligente de mês: se data calculada já passou, usa próximo mês

4. **Uso Futuro:**
   - Base para funcionalidade de projeção de saldo
   - Alertas de proximidade do dia do salário
   - Resetar "quanto posso gastar" baseado nesta data

**Definition of Done:**
- [x] Colunas `salaryPaymentMode` e `salaryPaymentValue` adicionadas ao banco
- [x] Migration v5→v6 implementada
- [x] Widget calendário inline personalizado criado
- [x] SegmentedToggle para modo de seleção
- [x] Dropdown de dias úteis com cálculo de datas
- [x] Calendário brasileiro de feriados implementado
- [x] Lógica de seleção inteligente de mês
- [x] UI completa integrada ao Settings Screen
- [x] Persistência de dados funcionando
- [x] Merge realizado para `develop`

---

### [x] F13-T6: Feature - Credit Payment Date per Account

**Branch:** `feature/credit-payment-date`

**Descrição:**
Criar seção nas configurações para definir a data de fechamento da fatura de crédito para cada conta de crédito e também calcular a data de pagamento.

**Implementação Esperada:**
1. **Adicionar Campo no Banco:**
   - Adicionar coluna `creditClosingDay` (int 1-31) na tabela `Accounts`
   - Aplicável apenas para contas de crédito

2. **UI na Account Creation/Editing:**
   - Mostrar campo "Dia do Fechamento" apenas se `isCredit == true`
   - Usar o mesmo widget de seleção de dia do salário:
     - Calendário inline personalizado
   - Validação de dias

3. **Uso Futuro:**
   - Alertas de proximidade de vencimento
   - Cálculo automático de fatura do mês
   - Projeção de gastos considerando vencimentos

**Definition of Done:**
- [x] Coluna `creditClosingDay` adicionada à tabela Accounts
- [x] Campo visível apenas para contas de crédito
- [x] UI para edição do dia de fechamento (InlineCalendar widget)
- [x] Validação implementada (nullable field, 1-31 values)
- [x] Valor persistido corretamente (both create and update)
- [x] Documentação de uso futuro (comments in code)
- [x] Merge realizado para `develop`

---

## ⚙️ Fase 14: Refatoração do Sistema de Reserva e Ciclo de Faturamento

**Objetivo:** Refatorar o cálculo da reserva para usar saldos das contas de débito e implementar filtragem de transações de crédito por ciclo de faturamento.

**Status:** 0 / 4 tarefas concluídas

---

### [ ] F14-T1: Refatorar Cálculo de Reserva para Usar Saldos de Contas

**Branch:** `refactor/reserve-from-account-balances`

**Descrição:**
Remover o campo de reserva inicial das configurações e calcular a reserva automaticamente como a soma dos saldos de todas as contas de débito não excluídas.

**Problema Atual:**
- Reserva é um valor manual que precisa ser atualizado pelo usuário
- Não reflete automaticamente os saldos reais das contas
- Dados duplicados e sujeitos a inconsistência

**Implementação Esperada:**

1. **Database Migration (v7→v8):**
   - Remover coluna `reserveBalance` da tabela `AppSettings`
   - Manter `maxReserveUsagePercentage` (ainda necessário)

2. **Atualizar Dashboard Calculation Logic:**
   - No `GetDashboardDataUseCase`, calcular reserva dinamicamente:
   ```dart
   // Buscar todas as contas com isDebit=true e excludeFromReserve=false
   final debitAccounts = await accountRepository.getAll();
   final reserveBalance = debitAccounts
       .where((account) => account.isDebit && !account.excludeFromReserve)
       .fold(0.0, (sum, account) => sum + account.balance);
   ```

3. **Remover de Settings UI:**
   - Remover input de "Reserva Inicial" da tela de configurações
   - Mostrar apenas a reserva calculada (read-only, informativo)
   - Adicionar texto explicativo: "Calculado automaticamente como a soma dos saldos das contas de débito"

4. **Atualizar Onboarding:**
   - Remover step de configuração da reserva inicial (se existir)
   - Focar apenas em salário e porcentagem de uso máximo

5. **Repository Updates:**
   - Remover método `updateReserveBalance()` do `AppSettingsRepository`
   - Atualizar testes relacionados

**Definition of Done:**
- [ ] Migration v7→v8 implementada e testada
- [ ] Campo `reserveBalance` removido do código
- [ ] Dashboard calcula reserva a partir de saldos de contas
- [ ] Settings UI atualizada (sem input manual de reserva)
- [ ] Onboarding atualizado (se necessário)
- [ ] Todos os testes atualizados e passando
- [ ] Code generation executado com sucesso
- [ ] Merge realizado para `develop`

---

### [ ] F14-T2: Adicionar Exclusão de Conta da Reserva

**Branch:** `feature/account-reserve-exclusion`

**Descrição:**
Adicionar opção por conta para excluir seu saldo do cálculo da reserva (como um valor intocável).

**Implementação Esperada:**

1. **Database Migration (v8→v9):**
   - Adicionar coluna `excludeFromReserve` (boolean, default: false) na tabela `Accounts`

2. **UI em Account Creation/Editing:**
   - Adicionar toggle "Excluir da Reserva" no formulário de conta
   - Mostrar apenas para contas com `isDebit=true`
   - Tooltip/helper text: "Contas excluídas não entram no cálculo da reserva disponível"

3. **Visual Indicator:**
   - Na lista de contas, mostrar ícone ou badge para contas excluídas da reserva
   - Exemplo: ícone de cadeado ou badge "Intocável"

4. **Dashboard Integration:**
   - Já implementado na F14-T1 (filtro `!account.excludeFromReserve`)

5. **Validation:**
   - Não há restrições: usuário pode excluir qualquer conta
   - Alertar se todas as contas forem excluídas (reserva = 0)

**Definition of Done:**
- [ ] Coluna `excludeFromReserve` adicionada à tabela Accounts
- [ ] Toggle implementado no formulário de conta
- [ ] Visual indicator implementado na lista de contas
- [ ] Dashboard respeita a exclusão no cálculo
- [ ] Validação e alertas implementados
- [ ] Testes de integração para exclusão
- [ ] Code generation executado
- [ ] Merge realizado para `develop`

---

### [ ] F14-T3: Implementar Filtragem de Transações por Ciclo de Faturamento de Crédito

**Branch:** `feature/credit-billing-cycle-filtering`

**Descrição:**
Filtrar transações de crédito para incluir apenas aquelas dentro do ciclo de faturamento atual (entre o dia de fechamento anterior e o próximo).

**Implementação Esperada:**

1. **Lógica de Cálculo do Ciclo:**
   ```dart
   // Para uma conta de crédito com creditClosingDay = 15
   // Se hoje é 10/11/2025:
   // - Ciclo atual: 15/10/2025 a 14/11/2025
   // - Próximo fechamento: 15/11/2025

   DateTime calculateCurrentCycleStart(int closingDay, DateTime today) {
     final currentMonth = DateTime(today.year, today.month, closingDay);
     if (today.day >= closingDay) {
       return currentMonth; // Estamos após o fechamento deste mês
     } else {
       return DateTime(today.year, today.month - 1, closingDay); // Ciclo começou no mês anterior
     }
   }

   DateTime calculateCurrentCycleEnd(int closingDay, DateTime today) {
     final cycleStart = calculateCurrentCycleStart(closingDay, today);
     return DateTime(cycleStart.year, cycleStart.month + 1, closingDay).subtract(Duration(days: 1));
   }
   ```

2. **Atualizar Dashboard Calculation:**
   - Ao calcular `totalSpent` para contas de crédito, filtrar transações:
   ```dart
   if (account.isCredit && account.creditClosingDay != null) {
     final cycleStart = calculateCurrentCycleStart(account.creditClosingDay!, DateTime.now());
     final cycleEnd = calculateCurrentCycleEnd(account.creditClosingDay!, DateTime.now());

     transactions = transactions.where((t) =>
       t.date.isAfter(cycleStart.subtract(Duration(days: 1))) &&
       t.date.isBefore(cycleEnd.add(Duration(days: 1)))
     ).toList();
   }
   ```

3. **Edge Cases:**
   - Conta sem `creditClosingDay`: incluir todas as transações (comportamento atual)
   - Transições de mês (ex: ciclo de 25/10 a 24/11)
   - Fevereiro e dias 29, 30, 31 (usar último dia válido do mês)

4. **Atualizar Recurring Expenses:**
   - Se despesas recorrentes usam contas de crédito, aplicar mesma lógica

5. **UI Feedback:**
   - Mostrar período do ciclo atual na tela de detalhes da conta
   - Exemplo: "Ciclo atual: 15/10 a 14/11"

**Definition of Done:**
- [ ] Funções de cálculo de ciclo implementadas e testadas
- [ ] Dashboard filtra transações de crédito por ciclo
- [ ] Edge cases tratados (meses com dias inválidos)
- [ ] Recurring expenses atualizado (se aplicável)
- [ ] UI mostra período do ciclo (opcional)
- [ ] Testes unitários para cálculo de ciclo
- [ ] Testes de integração para filtragem
- [ ] Merge realizado para `develop`

---

### [ ] F14-T4: Atualizar Testes e Documentação

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

## ⚙️ Fase 15: Transações de Receita e Depósito Automático de Salário

**Objetivo:** Implementar suporte a transações de receita (positivas) e criar sistema de depósito automático do salário na conta configurada.

**Status:** 0 / 6 tarefas concluídas

**Nota:** Esta fase prepara a base para funcionalidades futuras de pagamento de faturas e gestão de invoices de cartão de crédito.

---

### [ ] F15-T1: Implementar Sistema de Tipo de Transação

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

### [ ] F15-T2: Criar Tabela Invoice para Gestão Futura de Faturas

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

### [ ] F15-T3: Adicionar Configuração de Conta de Salário

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

### [ ] F15-T4: Atualizar UI de Transação para Receita/Despesa

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

### [ ] F15-T5: Implementar Depósito Automático de Salário

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

### [ ] F15-T6: Testes e Casos Extremos

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

Este plano mapeia todas as **39 tarefas** necessárias para completar o MVP do Previsor Financeiro. Ao seguir este roadmap, você terá um aplicativo funcional, testado e preparado para uso pessoal, com uma arquitetura sólida que permitirá expansões futuras.

A **Fase 5** representa a primeira iteração de melhorias baseada em uso real, demonstrando a importância de testar o aplicativo e iterar sobre o design inicial.

A **Fase 6** adiciona refinamentos críticos de UX: onboarding para novos usuários, gestão completa de transações, e padronização de inputs numéricos para o mercado brasileiro.

A **Fase 7** introduz automação inteligente e identidade visual: ícone personalizado do app e captura automática de transações a partir de notificações bancárias, com arquitetura extensível para suportar múltiplos bancos.

A **Fase 8** foca em correções críticas e refinamentos de UX: sistema de input numérico tipo Nubank, bottom sheet com abas para melhor experiência com teclado, swipe-to-delete aprimorado, toggle entre dashboard e histórico, correção de permissões de notificação, e file picker para backups.

A **Fase 9** traz correções de UX e padronização visual: correção do bug de exibição de valores nas configurações e padronização do app bar em todas as telas principais para garantir consistência visual e facilitar o acesso às configurações.

A **Fase 10** garante a estabilidade e saúde do código: atualização de dependências, migração de APIs deprecated, implementação de logging adequado, e remoção de código morto.

**Bom desenvolvimento! 🚀**

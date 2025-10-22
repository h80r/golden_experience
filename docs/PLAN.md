# 📋 Plano de Implementação - Previsor Financeiro v1.0

> **Projeto:** Previsor Financeiro (MVP)
> **Framework:** Flutter 3.x com Dart 3.x
> **Última Atualização:** 20 de outubro de 2025

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

**Total de Tarefas:** 21
**Concluídas:** 9 / 21 (43%)

### Por Fase
- **Fase 1 - Fundação:** 4 / 4 (100%)
- **Fase 2 - Registro de Gastos:** 4 / 4 (100%)
- **Fase 3 - Dashboard Reativo:** 2 / 4 (50%)
- **Fase 4 - Funcionalidades de Suporte:** 0 / 5 (0%)

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

---

## 🏗️ Fase 1: Fundação e Lógica Core

**Objetivo:** Estabelecer a base técnica do projeto com arquitetura limpa, configuração do banco de dados e estrutura de navegação.

**Status:** 4 / 4 tarefas concluídas

---

### [x] F1-T1: Configuração do Projeto e Arquitetura

**Branch:** `chore/project-setup`

**Descrição:**
Inicializar o projeto Flutter, configurar Riverpod, Isar e estabelecer a estrutura de pastas seguindo Clean Architecture.

**Requisitos:**
- Projeto Flutter criado e configurado
- Estrutura de pastas `presentation/`, `domain/`, `data/` definida
- Dependências principais adicionadas ao `pubspec.yaml`:
  - `isar` e `isar_flutter_libs`
  - `riverpod` e `flutter_riverpod`
  - `path_provider`
  - Dependências de desenvolvimento: `build_runner`, `isar_generator`

**Definition of Done:**
- [x] Projeto Flutter inicializado
- [x] Estrutura de pastas Clean Architecture criada
- [x] Dependências instaladas e configuradas
- [x] Código commitado na branch
- [x] Merge realizado para `develop`

---

### [x] F1-T2: Modelagem e Configuração do Banco de Dados

**Branch:** `chore/database-models`
   
**Descrição:**
Implementar todas as entidades do domínio como coleções do Isar com suas respectivas anotações e configurações.

**Entidades a Modelar:**
1. **Transaction**
   - id (int, auto-increment)
   - value (double)
   - description (String)
   - date (DateTime)
   - notes (String?)
   - accountId (int)
   - categoryId (int)

2. **Account**
   - id (int, auto-increment)
   - name (String)
   - type (Enum: debit/credit)
   - initialBalance (double)
   - creditLimit (double)

3. **RecurringExpense**
   - id (int, auto-increment)
   - value (double)
   - description (String)
   - chargeDay (int)
   - accountId (int)
   - categoryId (int)

4. **Category**
   - id (int, auto-increment)
   - name (String)

5. **AppSettings**
   - id (int, fixo = 1)
   - monthlySalary (double)
   - reserveBalance (double)
   - maxReserveUsagePercentage (double)
   - lastRecurringCheck (DateTime)

**Definition of Done:**
- [x] Todas as 5 entidades modeladas com anotações Isar
- [x] Schema do Isar gerado com sucesso (`build_runner`)
- [x] Instância do Isar pode ser aberta e fechada
- [x] Testes unitários para os modelos criados
- [ ] Merge realizado para `develop`

---

### [x] F1-T3: Implementação dos Repositórios

**Branch:** `feature/repositories`

**Descrição:**
Criar as interfaces dos repositórios na camada de domínio e suas implementações concretas usando Isar na camada de dados.

**Repositórios a Implementar:**
1. **ITransactionRepository** / **TransactionRepositoryImpl**
   - Métodos CRUD completos
   - Query por período (mês atual)
   - Stream de transações

2. **IAccountRepository** / **AccountRepositoryImpl**
   - Métodos CRUD completos
   - Atualização de saldo/limite

3. **IRecurringExpenseRepository** / **RecurringExpenseRepositoryImpl**
   - Métodos CRUD completos
   - Query por dia de cobrança

4. **ICategoryRepository** / **CategoryRepositoryImpl**
   - Métodos CRUD completos
   - Seed de categorias padrão

5. **IAppSettingsRepository** / **AppSettingsRepositoryImpl**
   - Get/Update settings
   - Inicialização com valores padrão

**Definition of Done:**
- [x] Interfaces criadas na camada `domain/repositories/`
- [x] Implementações criadas na camada `data/repositories/`
- [x] Providers do Riverpod configurados
- [x] Testes unitários para todos os repositórios
- [ ] Merge realizado para `develop`

---

### [x] F1-T4: Navegação e Shell do Aplicativo

**Branch:** `feature/navigation-shell`

**Descrição:**
Construir a estrutura de navegação principal do app com Tab Bar inferior e as telas iniciais (vazias).

**Estrutura de Navegação:**
```
MaterialApp
└── MainScreen (Scaffold com BottomNavigationBar)
    ├── Tab 1: DashboardScreen (Início)
    ├── Tab 2: RecurringExpensesScreen (Recorrências)
    └── Tab 3: AccountsScreen (Contas)
```

**Definition of Done:**
- [x] `MainScreen` com `BottomNavigationBar` implementado
- [x] 3 telas criadas (Dashboard, Recorrências, Contas)
- [x] Navegação entre abas funcional
- [x] App inicia na aba "Início"
- [x] Testes de widget para navegação básica
- [ ] Merge realizado para `develop`

---

## 💰 Fase 2: O Fluxo Crítico - Registro de Gasto

**Objetivo:** Implementar o fluxo core do produto - o registro rápido de gastos com interface de calculadora e bottom sheet de detalhes.

**Status:** 2 / 4 tarefas concluídas

---

### [x] F2-T1: UI da Calculadora e Bottom Sheet

**Branch:** `feature/calculator-ui`

**Descrição:**
Construir os widgets para a calculadora (overlay) e para o bottom sheet de detalhes do gasto, seguindo o design conceitual.

**Componentes a Criar:**
1. **CalculatorOverlay** (fullscreen)
   - Grid de botões numéricos (0-9)
   - Botões de operação (vírgula, backspace)
   - Display do valor
   - Botão de confirmação

2. **ExpenseDetailsBottomSheet**
   - Header com handle e valor
   - Campo de Descrição (TextField)
   - Campo de Notas (TextField, opcional)
   - Seletor de Conta (Dropdown)
   - Seletor de Tipo (Débito/Crédito)
   - Seletor de Categoria (Dropdown)
   - Seletor de Data (DatePicker)
   - Botões de ação (Cancelar, Salvar)

3. **Componentes Reutilizáveis**
   - `PrimaryButton`
   - `SecondaryButton`
   - `CustomTextField`
   - `CustomDropdown`

**Definition of Done:**
- [x] Widgets criados seguindo o design
- [x] Componentes reutilizáveis implementados
- [x] Interações de UI funcionam isoladamente
- [x] Testes de widget para componentes
- [x] Aplicação do design system (cores, tipografia, espaçamento)
- [x] Merge realizado para `develop`

---

### [x] F2-T2: Lógica de Estado para o Registro

**Branch:** `feature/expense-state`

**Descrição:**
Criar o StateNotifier com Riverpod para gerenciar o estado completo do fluxo de registro de gastos.

**Estado a Gerenciar:**
```dart
class ExpenseFormState {
  final double value;
  final String description;
  final String? notes;
  final int accountId;
  final String transactionType; // 'debit' | 'credit'
  final int categoryId;
  final DateTime date;
  final bool isValid;
  final String? errorMessage;
}
```

**Funcionalidades:**
- Validação de campos obrigatórios
- Atualização reativa do estado
- Reset do formulário

**Definition of Done:**
- [x] `ExpenseFormNotifier` implementado
- [x] Provider configurado
- [x] Validações implementadas
- [x] Testes unitários para o notifier
- [x] Estados de erro tratados
- [x] Merge realizado para `develop`

---

### [x] F2-T3: Use Case - Adicionar Transação

**Branch:** `feature/add-transaction-usecase`

**Descrição:**
Criar o Use Case na camada de domínio responsável por orquestrar a lógica de salvar uma nova transação e atualizar o saldo/limite da conta.

**Responsabilidades:**
1. Receber dados da transação
2. Validar regras de negócio
3. Salvar transação no repositório
4. Atualizar saldo da conta (débito) ou limite (crédito)
5. Retornar sucesso/erro

**Definition of Done:**
- [x] `AddTransactionUseCase` implementado em `domain/usecases/`
- [x] Lógica de atualização de saldo/limite correta
- [x] Tratamento de erros implementado
- [x] Testes unitários cobrindo todos os cenários
- [x] Provider do use case configurado
- [x] Merge realizado para `develop`

---

### [x] F2-T4: Integração Fim-a-Fim do Fluxo

**Branch:** `feature/expense-flow-integration`

**Descrição:**
Conectar todos os componentes criados nas tarefas anteriores para formar o fluxo completo de registro de gastos.

**Integração:**
```
FAB (+) → CalculatorOverlay → ExpenseDetailsBottomSheet → ExpenseFormNotifier → AddTransactionUseCase → Repository → Database
```

**Definition of Done:**
- [x] FAB no Dashboard abre a calculadora
- [x] Calculadora confirma valor e abre bottom sheet
- [x] Bottom sheet salva e chama o use case
- [x] Transação é persistida no Isar
- [x] Saldo/limite da conta é atualizado
- [x] Fluxo fecha e retorna ao Dashboard
- [x] Teste de integração E2E para o fluxo completo
- [x] Merge realizado para `develop`

---

## 📈 Fase 3: O Coração do Produto - Dashboard Reativo

**Objetivo:** Implementar o Dashboard com todos os cálculos financeiros e reatividade em tempo real.

**Status:** 1 / 4 tarefas concluídas

---

### [x] F3-T1: Use Case - Dados do Dashboard

**Branch:** `feature/dashboard-usecase`

**Descrição:**
Criar o Use Case que busca todos os dados necessários e realiza os cálculos financeiros definidos no PRD.

**Cálculos a Implementar:**
1. **Gasto Total:** Soma de todas as transações do mês atual
2. **Salário - Gasto:** Diferença simples
3. **Gasto Restante:** `(Salário + (Reserva * % Máximo)) - Gasto Total`
4. **Reserva Final:** `Reserva Inicial - (Gasto Total - Salário)` (se gasto > salário)
5. **% da Reserva Gasto:** Percentual da reserva utilizado

**Modelo de Retorno:**
```dart
class DashboardData {
  final double monthlySalary;
  final double totalSpent;
  final double remainingBudget;
  final double partialResult; // Salário - Gasto
  final double finalReserve;
  final double reserveUsagePercentage;
}
```

**Definition of Done:**
- [x] `GetDashboardDataUseCase` implementado
- [x] Todos os cálculos corretos conforme PRD
- [x] Testes unitários cobrindo múltiplos cenários
- [x] Casos extremos tratados (reserva negativa, etc.)
- [x] Provider configurado
- [x] Merge realizado para `develop`

---

### [x] F3-T2: Lógica de Processamento de Recorrências

**Branch:** `feature/recurring-processor`

**Descrição:**
Implementar a lógica que processa despesas recorrentes na inicialização do app, criando transações automaticamente.

**Algoritmo:**
1. Buscar `lastRecurringCheck` do `AppSettings`
2. Comparar com a data atual
3. Para cada dia entre `lastRecurringCheck` e hoje:
   - Buscar todas as recorrências com `chargeDay` = dia atual
   - Criar transação automática para cada recorrência
4. Atualizar `lastRecurringCheck` para hoje

**Casos Especiais:**
- Meses com menos de 31 dias (cobranças no dia 31)
- Primeira inicialização do app
- Múltiplos dias sem abrir o app

**Definition of Done:**
- [x] `ProcessRecurringExpensesUseCase` implementado
- [x] Lógica de múltiplos dias funcional
- [x] Meses com diferentes durações tratados
- [x] Testes unitários com casos extremos
- [x] Execução na inicialização configurada
- [x] Merge realizado para `develop`

---

### [x] F3-T3: UI do Dashboard

**Branch:** `feature/dashboard-ui`

**Descrição:**
Construir a interface completa do Dashboard seguindo o design conceitual, preparada para receber dados reativos.

**Componentes:**
1. **Header**
   - Título "Início"
   - Botão de configurações

2. **Card Principal** (destaque)
   - Label "Você ainda pode gastar este mês"
   - Valor do Gasto Restante (grande, destaque)
   - Barra de progresso da reserva
   - Texto auxiliar sobre uso da reserva

3. **Card Secundário** (detalhes)
   - Salário mensal
   - Gasto total
   - Resultado parcial (Salário - Gasto)
   - Reserva final prevista

4. **FAB** (Floating Action Button)
   - Botão "+" para adicionar gasto

**Definition of Done:**
- [x] Layout fiel ao design conceitual
- [x] Responsividade para diferentes tamanhos de tela
- [x] Design system aplicado (cores, tipografia)
- [x] Componentes criados e organizados
- [x] Testes de widget para os componentes
- [ ] Merge realizado para `develop`

---

### [x] F3-T4: Integração Reativa do Dashboard

**Branch:** `feature/dashboard-reactive`

**Descrição:**
Conectar o Dashboard ao `GetDashboardDataUseCase` usando StreamProvider (Riverpod) para reatividade automática.

**Fluxo Reativo:**
```
Isar Streams (Transactions, Accounts, Settings)
    ↓
StreamProvider (watching changes)
    ↓
GetDashboardDataUseCase (recalcula)
    ↓
Dashboard UI (atualiza automaticamente)
```

**Definition of Done:**
- [x] `StreamProvider` configurado para o dashboard
- [x] Dashboard consome o provider reativamente
- [x] Adicionar novo gasto atualiza Dashboard instantaneamente
- [x] Todas as mudanças refletidas em tempo real
- [x] Estados de loading e erro tratados
- [x] Teste de integração para reatividade
- [ ] Merge realizado para `develop`

---

## ⚙️ Fase 4: Funcionalidades de Suporte e Polimento

**Objetivo:** Completar as funcionalidades secundárias (CRUD de contas/recorrências, configurações) e preparar o app para produção.

**Status:** 0 / 5 tarefas concluídas

---

### [ ] F4-T1: CRUD de Contas

**Branch:** `feature/accounts-crud`

**Descrição:**
Implementar a tela de Contas com funcionalidades completas de criar, visualizar, editar e remover contas.

**Funcionalidades:**
- Listar todas as contas cadastradas
- Adicionar nova conta (débito ou crédito)
- Editar conta existente
- Remover conta (com validação: não permitir se houver transações)
- Exibir saldo atual (débito) ou limite disponível (crédito)

**Definition of Done:**
- [ ] Tela de listagem de contas implementada
- [ ] Formulário de criação/edição implementado
- [ ] Validações de campos implementadas
- [ ] Lógica de remoção com verificação
- [ ] Testes de widget para a tela
- [ ] Merge realizado para `develop`

---

### [ ] F4-T2: CRUD de Recorrências

**Branch:** `feature/recurring-crud`

**Descrição:**
Implementar a tela de Recorrências permitindo gerenciar despesas fixas mensais.

**Funcionalidades:**
- Listar todas as recorrências cadastradas
- Adicionar nova recorrência (valor, dia de cobrança, conta, categoria)
- Editar recorrência existente
- Remover recorrência
- Indicador visual do próximo dia de cobrança

**Definition of Done:**
- [ ] Tela de listagem implementada
- [ ] Formulário de criação/edição implementado
- [ ] Validações (dia de cobrança entre 1-31)
- [ ] Lógica de remoção implementada
- [ ] Testes de widget para a tela
- [ ] Merge realizado para `develop`

---

### [ ] F4-T3: Tela de Configurações

**Branch:** `feature/settings`

**Descrição:**
Implementar a tela onde o usuário define os valores base para os cálculos do app.

**Configurações:**
1. **Salário Mensal Fixo** (double)
2. **Saldo Inicial da Reserva** (double)
3. **Percentual Máximo de Gasto da Reserva** (0-100%)

**Definition of Done:**
- [ ] Tela de configurações acessível pelo ícone no Dashboard
- [ ] Formulário com os 3 campos implementado
- [ ] Validações de valores implementadas
- [ ] Dados salvos em `AppSettings`
- [ ] Mudanças refletem imediatamente no Dashboard
- [ ] Testes de widget para a tela
- [ ] Merge realizado para `develop`

---

### [ ] F4-T4: Backup e Restauração

**Branch:** `feature/backup-restore`

**Descrição:**
Implementar funcionalidade de exportar todos os dados para JSON e importar de volta, mitigando o risco de perda de dados.

**Funcionalidades:**
1. **Exportar**
   - Gerar arquivo JSON com todas as coleções do Isar
   - Salvar no diretório de documentos do dispositivo
   - Feedback visual de sucesso

2. **Importar**
   - Selecionar arquivo JSON
   - Validar formato
   - Confirmar sobrescrita de dados
   - Importar dados para o Isar
   - Feedback visual de sucesso/erro

**Definition of Done:**
- [ ] Botão "Exportar Backup" nas configurações
- [ ] Botão "Importar Backup" nas configurações
- [ ] Exportação gera JSON válido
- [ ] Importação valida e restaura dados
- [ ] Diálogos de confirmação implementados
- [ ] Tratamento de erros robusto
- [ ] Testes para lógica de import/export
- [ ] Merge realizado para `develop`

---

### [ ] F4-T5: Configuração de CI/CD

**Branch:** `chore/ci-cd`

**Descrição:**
Criar workflow no GitHub Actions para automatizar testes, análise de código e builds.

**Pipeline:**
1. **On Pull Request / Push to develop:**
   - Rodar `flutter analyze`
   - Rodar `flutter test`
   - Gerar relatório de cobertura

2. **On Merge to main:**
   - Build de release (Android APK/Bundle)
   - Gerar changelog automático
   - (Futuro) Deploy para Firebase App Distribution

**Definition of Done:**
- [ ] Arquivo `.github/workflows/ci.yml` criado
- [ ] Workflow roda automaticamente
- [ ] Builds de sucesso/falha visíveis no GitHub
- [ ] Documentação no README sobre o CI/CD
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

Este plano mapeia todas as **21 tarefas** necessárias para completar o MVP do Previsor Financeiro. Ao seguir este roadmap, você terá um aplicativo funcional, testado e preparado para uso pessoal, com uma arquitetura sólida que permitirá expansões futuras.

**Bom desenvolvimento! 🚀**

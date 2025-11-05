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
- [x] Merge realizado para `develop`

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
- [x] Merge realizado para `develop`

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
- [x] Merge realizado para `develop`

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
- [x] Merge realizado para `develop`

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
- [x] Merge realizado para `develop`

---

## ⚙️ Fase 4: Funcionalidades de Suporte e Polimento

**Objetivo:** Completar as funcionalidades secundárias (CRUD de contas/recorrências, configurações) e preparar o app para produção.

**Status:** 0 / 5 tarefas concluídas

---

### [x] F4-T1: CRUD de Contas

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
- [x] Tela de listagem de contas implementada
- [x] Formulário de criação/edição implementado
- [x] Validações de campos implementadas
- [x] Lógica de remoção com verificação
- [x] Testes de widget para a tela
- [x] Merge realizado para `develop`

---

### [x] F4-T2: CRUD de Recorrências

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
- [x] Tela de listagem implementada
- [x] Formulário de criação/edição implementado
- [x] Validações (dia de cobrança entre 1-31)
- [x] Lógica de remoção implementada
- [x] Testes de widget para a tela
- [x] Merge realizado para `develop`

---

### [x] F4-T3: Tela de Configurações

**Branch:** `feature/settings`

**Descrição:**
Implementar a tela onde o usuário define os valores base para os cálculos do app.

**Configurações:**
1. **Salário Mensal Fixo** (double)
2. **Saldo Inicial da Reserva** (double)
3. **Percentual Máximo de Gasto da Reserva** (0-100%)

**Definition of Done:**
- [x] Tela de configurações acessível pelo ícone no Dashboard
- [x] Formulário com os 3 campos implementado
- [x] Validações de valores implementadas
- [x] Dados salvos em `AppSettings`
- [x] Mudanças refletem imediatamente no Dashboard
- [x] Testes de widget para a tela (12 testes implementados e passando)
- [x] Merge realizado para `develop`

---

### [x] F4-T4: Backup e Restauração

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
- [x] Botão "Exportar Backup" nas configurações
- [x] Botão "Importar Backup" nas configurações
- [x] Exportação gera JSON válido
- [x] Importação valida e restaura dados
- [x] Diálogos de confirmação implementados
- [x] Tratamento de erros robusto
- [x] Testes para lógica de import/export
- [x] Merge realizado para `develop`

---

## 🔧 Fase 5: Primeira Iteração - Correções e Melhorias

**Objetivo:** Corrigir bugs identificados no uso inicial e implementar melhorias de UX baseadas em feedback real.

**Status:** 1 / 5 tarefas concluídas

---

### [x] F5-T1: Correção - Persistência de Configurações

**Branch:** `fix/settings-persistence`

**Descrição:**
Investigar e corrigir o problema que impede o salvamento das configurações do aplicativo. Os dados inseridos na tela de configurações não estão sendo persistidos no banco de dados.

**Investigação Necessária:**
1. Verificar se o método `save()` do repositório está sendo chamado
2. Verificar se os dados estão sendo passados corretamente do formulário
3. Checar se há erros silenciosos no processo de salvamento
4. Validar se o Isar está escrevendo os dados corretamente
5. Confirmar se o singleton de `AppSettings` (id = 1) está sendo atualizado

**Correções Esperadas:**
- Garantir que o botão "Salvar" nas configurações persiste os dados
- Adicionar feedback visual de sucesso/erro ao salvar
- Verificar se mudanças refletem imediatamente no Dashboard

**Definition of Done:**
- [x] Causa raiz do problema identificada
- [x] Salvamento de configurações funcionando corretamente
- [x] Dados persistem após fechar e reabrir o app
- [x] Mudanças refletem instantaneamente no Dashboard
- [x] Feedback visual de sucesso implementado
- [x] Testes de integração para persistência adicionados
- [x] Merge realizado para `develop`

---

### [x] F5-T2: Correção - Bug no Modal de Detalhes da Transação

**Branch:** `fix/transaction-modal-reload`

**Descrição:**
Corrigir o bug que causa recarregamento completo do `ExpenseDetailsBottomSheet` quando o usuário clica para inserir detalhes nos campos de texto, impedindo o cadastro da transação.

**Problema Atual:**
- Ao tocar em um campo de texto (descrição, notas, etc.), o modal inteiro recarrega
- O teclado aparece e desaparece
- O foco é perdido
- O usuário não consegue completar o cadastro

**Possíveis Causas:**
1. Rebuild desnecessário causado por setState() na widget pai
2. Problema com o gerenciamento de estado do ExpenseFormNotifier
3. Conflito entre FocusNode e rebuilds
4. Bottom sheet sendo recriado a cada interação

**Correções a Implementar:**
- Isolar o estado do bottom sheet para evitar rebuilds externos
- Usar `const` constructors onde possível
- Implementar shouldRebuild corretamente nos providers
- Garantir que apenas os widgets afetados sejam reconstruídos

**Definition of Done:**
- [x] Bug identificado e causa raiz documentada
- [x] Bottom sheet não recarrega ao interagir com campos
- [x] Foco nos campos de texto mantido corretamente
- [x] Fluxo completo de criação de transação funcional
- [x] Teclado aparece e desaparece normalmente
- [x] Teste de integração E2E passando
- [x] Merge realizado para `develop`

---

### [x] F5-T3: Refatoração - Substituir Calculadora por Input Field

**Branch:** `refactor/simple-value-input`

**Descrição:**
Remover a interface de calculadora overlay e substituir por um campo de input numérico simples diretamente no bottom sheet de detalhes. A experiência com a calculadora em popup se mostrou ruim e pouco prática.

**Mudanças Arquiteturais:**
```
ANTES:
FAB (+) → CalculatorOverlay → ExpenseDetailsBottomSheet → Salvar

DEPOIS:
FAB (+) → ExpenseDetailsBottomSheet (com campo de valor) → Salvar
```

**Componentes a Remover:**
- `calculator/calculator_overlay.dart`
- Lógica de estado da calculadora
- Navegação intermediária para a calculadora

**Componentes a Criar/Modificar:**
- Adicionar campo de input numérico no topo do `ExpenseDetailsBottomSheet`
- Implementar formatação automática de moeda (R$ X.XXX,XX)
- Adicionar validação de valor obrigatório
- Ajustar layout do bottom sheet para acomodar o novo campo

**Formatação de Moeda:**
- Usar `intl` package para formatação brasileira
- Permitir input com vírgula decimal
- Formatar automaticamente com separadores de milhar

**Definition of Done:**
- [x] CalculatorOverlay removido do código
- [x] Campo de valor numérico implementado no bottom sheet
- [x] Formatação de moeda funcionando corretamente
- [x] Validação de valor obrigatório implementada
- [x] FAB abre diretamente o bottom sheet
- [x] Fluxo de criação de transação mais rápido e intuitivo
- [x] Testes de widget atualizados
- [x] Merge realizado para `develop`

---

### [x] F5-T4: Ajuste - Tipo de Conta (Débito E Crédito)

**Branch:** `feature/account-dual-type`

**Descrição:**
Modificar o modelo de `Account` para permitir que uma conta seja simultaneamente débito E crédito, em vez de forçar a escolha de apenas um tipo. Isso reflete melhor a realidade das contas bancárias modernas.

**Modelo Atual (INCORRETO):**
```dart
enum AccountType { debit, credit }

class Account {
  AccountType type; // Apenas um tipo permitido
}
```

**Modelo Novo (CORRETO):**
```dart
class Account {
  bool isDebit;    // Pode ser true
  bool isCredit;   // Pode ser true simultaneamente
  double balance;       // Para operações de débito
  double creditLimit;   // Para operações de crédito
  double creditUsed;    // Quanto do limite foi usado
}
```

**Mudanças Necessárias:**

1. **Modelo de Dados (Isar):**
   - Remover campo `type` (enum)
   - Adicionar campos `isDebit` e `isCredit` (bool)
   - Adicionar campo `creditUsed` (double)
   - Atualizar schema do Isar

2. **Formulário de Conta:**
   - Substituir radio buttons por checkboxes
   - Permitir seleção de "Débito", "Crédito" ou ambos
   - Mostrar campo `balance` se isDebit = true
   - Mostrar campo `creditLimit` se isCredit = true

3. **Lógica de Transações:**
   - Ao criar transação em conta débito: atualizar `balance`
   - Ao criar transação em conta crédito: atualizar `creditUsed`
   - Se conta é ambos: permitir escolher qual usar na transação

4. **UI de Listagem:**
   - Exibir badges indicando tipo(s) da conta
   - Mostrar saldo e/ou limite disponível conforme tipo

**Migração de Dados:**
- Criar script de migração para contas existentes
- Contas "debit" → `isDebit = true, isCredit = false`
- Contas "credit" → `isDebit = false, isCredit = true`

**Definition of Done:**
- [x] Modelo Account atualizado com campos booleanos (isDebit, isCrebit, balance, creditUsed)
- [x] Schema do Drift regenerado (v2)
- [x] Formulário de conta com seleção múltipla implementado (CheckboxListTile)
- [x] Lógica de transações atualizada (suporta debit + credit simultaneamente)
- [x] UI de listagem mostrando tipos corretamente (badges duplos, detalhes específicos)
- [x] Migração de dados existentes implementada (v1→v2 com SQL transformation)
- [x] Testes atualizados (232+ passando, falhas de UI widget não relacionadas)
- [x] Merge realizado para `develop` (aguardando revisão)

---

### [x] F5-T5: Melhoria - Slider para Percentual Máximo da Reserva

**Branch:** `feature/reserve-percentage-slider`

**Descrição:**
Substituir o campo de texto para "Percentual Máximo de Gasto da Reserva" por um componente Slider, proporcionando uma experiência mais intuitiva e visual para ajustar esse valor.

**Problema Atual:**
- TextField numérico não é intuitivo para percentuais
- Usuário pode inserir valores inválidos (> 100%, negativos)
- Falta feedback visual da escolha

**Solução: Slider Widget**

**Especificações do Slider:**
- **Range:** 0% a 100%
- **Divisões:** 100 (incrementos de 1%)
- **Labels:** Mostrar percentual atual acima/ao lado do slider
- **Valor inicial:** Carregar do AppSettings atual
- **Cores:** Usar AppColors do design system
  - Track ativo: primaryColor
  - Track inativo: cinza claro
  - Thumb: primaryColor com sombra

**Layout Sugerido:**
```
┌─────────────────────────────────────┐
│ Percentual Máximo da Reserva        │
│                                     │
│            45%                      │  ← Valor atual em destaque
│  ●─────────────────○               │  ← Slider
│  0%               100%              │  ← Labels min/max
│                                     │
│ Quanto da sua reserva você pode     │  ← Texto auxiliar
│ usar no mês, se necessário.         │
└─────────────────────────────────────┘
```

**Componente a Criar:**
```dart
class ReservePercentageSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  // Widget com Slider + Label + Texto auxiliar
}
```

**Definition of Done:**
- [x] TextField do percentual removido
- [x] Slider widget implementado
- [x] Design system aplicado (cores, tipografia)
- [x] Valor exibido claramente acima do slider
- [x] Texto auxiliar explicativo adicionado
- [x] Salvamento do valor funcionando
- [x] Testes de widget para o slider
- [x] Merge realizado para `develop`

---

## 🎨 Fase 6: Segunda Iteração - UX e Refinamentos

**Objetivo:** Melhorar a experiência do usuário com onboarding guiado, gestão completa de transações e padronização de inputs numéricos.

**Status:** 0 / 3 tarefas concluídas

---

### [x] F6-T1: Welcome Tour / Onboarding Inicial

**Branch:** `feature/welcome-tour`

**Descrição:**
Implementar um tour de boas-vindas que guia o usuário na primeira inicialização do app, coletando todas as configurações essenciais para começar a usar o aplicativo imediatamente.

**Fluxo do Onboarding:**
1. **Tela de Boas-Vindas**
   - Apresentação do app
   - Explicação do propósito
   - Botão "Começar"

2. **Configurações Iniciais (Multi-Step)**
   - **Passo 1:** Salário mensal fixo
   - **Passo 2:** Saldo inicial da reserva
   - **Passo 3:** Percentual máximo de uso da reserva (slider)

3. **Criação de Conta Padrão**
   - Sugerir criação de primeira conta
   - Permitir escolher nome, tipo (débito/crédito), e saldo/limite

4. **Categorias Padrão**
   - Mostrar categorias pré-configuradas
   - Permitir adicionar mais categorias personalizadas

5. **Conclusão**
   - Resumo das configurações
   - Mensagem motivacional
   - Redirecionar para o Dashboard

**Tecnologias Sugeridas:**
- Package `introduction_screen` (^4.0.0) para slides
- Persistir flag `hasCompletedOnboarding` no `AppSettings`

**Definition of Done:**
- [x] Package de onboarding adicionado (ou implementação customizada)
- [x] Fluxo de 5 telas implementado
- [x] Dados coletados salvos no banco (AppSettings, Account, Categories)
- [x] Flag `hasCompletedOnboarding` controla exibição do tour
- [x] Tour só aparece na primeira inicialização
- [x] Design system aplicado em todas as telas
- [x] Botão "Pular" permite acesso ao app sem completar
- [x] Testes de widget para o fluxo de onboarding
- [x] Merge realizado para `develop`

---

### [x] F6-T2: Listagem de Transações com CRUD

**Branch:** `feature/transactions-list`

**Descrição:**
Criar uma nova tela dedicada à visualização e gestão completa de todas as transações registradas, permitindo edição e exclusão de forma intuitiva.

**Funcionalidades da Tela:**
1. **Lista de Transações**
   - Exibir todas as transações ordenadas por data (mais recente primeiro)
   - Card compacto mostrando:
     - Valor (com cor verde/vermelho conforme entrada/saída)
     - Descrição
     - Data
     - Conta
     - Categoria (badge)
   - Scroll infinito ou paginação

2. **Filtros**
   - Por período (Hoje, Esta semana, Este mês, Personalizado)
   - Por conta (dropdown multi-select)
   - Por categoria (dropdown multi-select)
   - Botão "Limpar Filtros"

3. **Ações por Transação**
   - Swipe para a direita: Editar (ícone de lápis)
   - Swipe para a esquerda: Deletar (ícone de lixeira)
   - Ou menu de ações (três pontos verticais)

4. **Edição de Transação**
   - Reutilizar `ExpenseDetailsBottomSheet`
   - Pré-preencher campos com dados existentes
   - Salvar atualiza a transação no banco
   - Atualizar saldo/limite da conta

5. **Exclusão de Transação**
   - Dialog de confirmação
   - Reverter impacto no saldo/limite da conta
   - Deletar do banco
   - Feedback visual (Snackbar)

6. **Navegação**
   - Nova aba na `BottomNavigationBar` (ícone de lista)
   - Ou acessível via menu no Dashboard

**Widgets a Criar:**
- `TransactionsListScreen`
- `TransactionCard`
- `TransactionFiltersSheet`

**Definition of Done:**
- [x] Tela de listagem implementada
- [x] Filtros de período, conta e categoria funcionais
- [x] Swipe actions para editar/deletar implementados
- [x] Bottom sheet reutilizado para edição
- [x] Dialog de confirmação de exclusão implementado
- [x] Lógica de reversão de saldo/limite ao deletar
- [x] Navegação adicionada (nova aba ou menu)
- [x] Empty state quando não há transações
- [x] Testes de widget para a tela e componentes
- [x] Merge realizado para `develop`

---

### [x] F6-T3: Padronização de Input Numérico com Vírgula

**Branch:** `refactor/numeric-input-standard`

**Descrição:**
Criar um widget reutilizável para entrada de valores monetários que aceite vírgula como separador decimal e aplicá-lo consistentemente em todo o aplicativo, substituindo campos numéricos existentes.

**Problema Atual:**
- Inputs numéricos usam ponto (.) como separador decimal (padrão inglês)
- Usuários brasileiros esperam usar vírgula (,)
- Formatação inconsistente entre diferentes telas
- Validação de valores duplicada em vários lugares

**Solução: Widget `CurrencyTextField`**

**Especificações do Widget:**
```dart
class CurrencyTextField extends StatelessWidget {
  final String label;
  final double? initialValue;
  final ValueChanged<double> onChanged;
  final String? errorText;
  final bool required;

  // Recursos:
  // - TextInputFormatter customizado para aceitar vírgula
  // - Conversão automática vírgula → ponto internamente
  // - Formatação visual com separador de milhar (R$ 1.234,56)
  // - Validação de valores negativos/inválidos
  // - Cursor posicionado corretamente após formatação
}
```

**Características:**
- **Input:** Aceita vírgula como separador decimal
- **Formatação:** Adiciona separadores de milhar automaticamente (exemplo: 1234.5 → R$ 1.234,50)
- **Validação:** Apenas números e vírgula permitidos
- **Acessibilidade:** Teclado numérico com vírgula
- **Reatividade:** Atualiza estado em tempo real

**Locais de Aplicação:**
1. **ExpenseDetailsBottomSheet**
   - Campo de valor da transação

2. **SettingsScreen**
   - Campo de salário mensal
   - Campo de saldo da reserva

3. **AccountForm**
   - Campo de saldo inicial (débito)
   - Campo de limite de crédito

4. **RecurringExpenseForm**
   - Campo de valor da recorrência

**Packages Necessários:**
- `intl` (já usado): Para formatação brasileira
- `flutter_masked_text2` (opcional): Para máscaras avançadas
- Ou implementação customizada com `TextInputFormatter`

**Definition of Done:**
- [x] Widget `CurrencyTextField` criado em `lib/presentation/widgets/inputs/`
- [x] TextInputFormatter customizado para vírgula implementado
- [x] Formatação com separador de milhar funcional
- [x] Validação de valores implementada
- [x] Aplicado em ExpenseDetailsBottomSheet
- [x] Aplicado em SettingsScreen
- [x] Aplicado em AccountForm
- [x] Aplicado em RecurringExpenseForm
- [x] Testes de widget para CurrencyTextField
- [x] Testes de validação e formatação
- [x] Documentação do widget (comentários)
- [x] Merge realizado para `develop`

---

## 🔄 Fase 7: Terceira Iteração - Automação e Identidade Visual

**Objetivo:** Modernizar a identidade visual do app com ícone personalizado e implementar captura inteligente de transações via notificações bancárias com arquitetura extensível para múltiplos bancos.

**Status:** 1 / 2 tarefas concluídas

---

### [x] F7-T1: Substituição do Ícone do Aplicativo

**Branch:** `chore/app-icon-update`

**Descrição:**
Substituir o ícone padrão do Flutter pelo novo ícone personalizado (`icon.png`) em todas as plataformas suportadas, seguindo as melhores práticas de design de ícones mobile.

**Implementação:**

1. **Preparação do Ícone:**
   - Mover `docs/icon.png` para `assets/images/icon.png`
   - Validar que a imagem possui dimensões adequadas (recomendado 1024x1024px)
   - Verificar que o design funciona bem em diferentes fundos

2. **Configuração com flutter_launcher_icons:**
   - Adicionar dependência dev:
     ```yaml
     dev_dependencies:
       flutter_launcher_icons: ^0.14.4
     ```
   - Criar configuração no `pubspec.yaml`:
     ```yaml
     flutter_launcher_icons:
       android: true
       ios: true
       image_path: "assets/images/icon.png"
       adaptive_icon_background: "#F5C842"  # Cor dourada do design
       adaptive_icon_foreground: "assets/images/icon.png"
     ```

3. **Geração dos Ícones:**
   - Executar: `dart run flutter_launcher_icons`
   - Verificar geração em `android/app/src/main/res/` (mipmap-*)
   - Verificar geração em `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

4. **Teste Visual:**
   - Instalar app em dispositivo físico/emulador
   - Verificar ícone na home screen
   - Verificar ícone na lista de apps
   - Verificar ícone nas notificações

**Definition of Done:**
- [x] Ícone movido para `assets/images/icon.png`
- [x] Package `flutter_launcher_icons` configurado no `pubspec.yaml`
- [x] Ícones gerados para Android (mipmap densities + adaptive icon)
- [x] Ícones gerados para iOS (AppIcon.appiconset)
- [x] App instalado exibe novo ícone em todos os contextos
- [x] Arquivos gerados commitados no repositório
- [x] Merge realizado para `develop`

---

### [x] F7-T2: Captura Inteligente de Transações via Notificações

**Branch:** `feature/notification-transaction-capture`

**Descrição:**
Implementar um sistema extensível que detecta notificações de compras aprovadas de bancos parceiros, extrai automaticamente os dados da transação (valor, data, descrição) e oferece ao usuário um botão para criar a transação rapidamente no app. A arquitetura permite adicionar novos bancos facilmente no futuro.

**Fluxo do Usuário:**
1. Usuário recebe notificação do banco: "Compra aprovada! Compra no cartão final 1167, de R$ 208,05, em 22/10/25, às 07:58, em aliexpress, aprovada."
2. App detecta a notificação e extrai os dados usando o parser apropriado
3. App cria uma notificação própria: "💰 Nova compra detectada: R$ 208,05 em aliexpress"
4. Usuário toca no botão "Adicionar Transação"
5. `ExpenseDetailsBottomSheet` abre pré-preenchido com os dados extraídos
6. Usuário revisa, seleciona conta/categoria e confirma

**Arquitetura Extensível:**

**1. Interface do Parser (Domain Layer)**
```dart
// lib/domain/parsers/i_notification_parser.dart
abstract class INotificationParser {
  /// Package name do app do banco (ex: 'com.santander.app')
  String get packageName;

  /// Nome do banco para exibição
  String get bankName;

  /// Tenta fazer parse da notificação
  /// Retorna null se não for uma notificação de transação válida
  TransactionData? parse(NotificationEvent event);

  /// Valida se a notificação é elegível para parse
  bool canParse(NotificationEvent event);
}
```

**2. Implementação Santander (Data Layer)**
```dart
// lib/data/parsers/santander_notification_parser.dart
class SantanderNotificationParser implements INotificationParser {
  @override
  String get packageName => 'com.santander.app';

  @override
  String get bankName => 'Santander';

  // Regex patterns específicos do Santander
  static final _valueRegex = RegExp(r'R\$\s*([\d.,]+)');
  static final _dateRegex = RegExp(r'em (\d{2}/\d{2}/\d{2}), às (\d{2}:\d{2})');
  static final _merchantRegex = RegExp(r'em ([^,]+), aprovada');

  @override
  bool canParse(NotificationEvent event) {
    final text = event.text ?? '';
    return text.contains('Compra aprovada') &&
           text.contains('cartão final');
  }

  @override
  TransactionData? parse(NotificationEvent event) {
    // Implementação com extração via regex
    // Retorna TransactionData com value, description, date, sourceBank
  }
}
```

**3. Registry de Parsers (Data Layer)**
```dart
// lib/data/parsers/notification_parser_registry.dart
class NotificationParserRegistry {
  // Singleton pattern
  static final NotificationParserRegistry _instance =
      NotificationParserRegistry._internal();

  factory NotificationParserRegistry() => _instance;

  final Map<String, INotificationParser> _parsers = {};

  void _registerDefaultParsers() {
    register(SantanderNotificationParser());
    // Futuro: register(NubankNotificationParser());
    // Futuro: register(ItauNotificationParser());
  }

  void register(INotificationParser parser) {
    _parsers[parser.packageName] = parser;
  }

  INotificationParser? getParser(String packageName) {
    return _parsers[packageName];
  }

  List<String> get supportedBanks =>
      _parsers.values.map((p) => p.bankName).toList();
}
```

**4. Service Orquestrador (Presentation/Services)**
```dart
// lib/presentation/services/notification_service.dart
class NotificationService {
  final _registry = NotificationParserRegistry();

  static Future<void> initialize() async {
    NotificationsListener.initialize();

    NotificationsListener.receivePort.listen((event) {
      _handleNotification(event);
    });

    final hasPermission = await NotificationsListener.hasPermission;
    if (hasPermission == true) {
      await NotificationsListener.startService();
    }
  }

  static void _handleNotification(NotificationEvent event) {
    final packageName = event.packageName ?? '';

    // Buscar parser registrado para este packageName
    final parser = _registry.getParser(packageName);
    if (parser == null) return; // Banco não suportado

    // Tentar fazer parse
    final transactionData = parser.parse(event);
    if (transactionData != null) {
      TransactionNotificationService.show(transactionData);
    }
  }
}
```

**5. Notificação de Ação**
```dart
// lib/presentation/services/transaction_notification_service.dart
class TransactionNotificationService {
  static Future<void> show(TransactionData data) async {
    const androidDetails = AndroidNotificationDetails(
      'transaction_channel',
      'Transações Detectadas',
      importance: Importance.high,
      actions: [
        AndroidNotificationAction(
          'add_transaction',
          'Adicionar Transação',
          showsUserInterface: true,
        ),
      ],
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      '💰 Nova compra detectada',
      'R\$ ${data.value.toStringAsFixed(2)} em ${data.description}',
      NotificationDetails(android: androidDetails),
      payload: jsonEncode(data.toJson()),
    );
  }
}
```

**6. Handler de Navegação**
```dart
// No main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar handler de notificação
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) {
      if (response.actionId == 'add_transaction') {
        final data = TransactionData.fromJson(
          jsonDecode(response.payload!)
        );
        // Navegar para ExpenseDetailsBottomSheet com dados pré-preenchidos
        // usando navigatorKey global
      }
    },
  );

  await NotificationService.initialize();
  runApp(MyApp());
}
```

**7. UI de Configuração**
```dart
// Nas configurações, adicionar seção de notificações
class NotificationSettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registry = NotificationParserRegistry();
    final supportedBanks = registry.supportedBanks;

    return Column(
      children: [
        SwitchListTile(
          title: Text('Captura automática de transações'),
          subtitle: Text('Detectar compras de notificações bancárias'),
          value: settings.autoCapture,
          onChanged: (value) { /* Ativar/desativar feature */ },
        ),

        if (settings.autoCapture)
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Permissão de notificações'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => NotificationsListener.openPermissionSettings(),
          ),

        ExpansionTile(
          title: Text('Bancos suportados (${supportedBanks.length})'),
          children: supportedBanks.map((bank) =>
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(bank),
            )
          ).toList(),
        ),
      ],
    );
  }
}
```

**Packages Necessários:**
```yaml
dependencies:
  flutter_notification_listener: ^2.1.0
  flutter_local_notifications: ^17.0.0
```

**Modelo de Dados:**
```dart
// Adicionar campo sourceBank ao TransactionData
class TransactionData {
  final double value;
  final String description;
  final DateTime date;
  final String? sourceBank; // Novo campo

  // ...
}
```

**Como Adicionar Novos Bancos no Futuro:**

**Passo 1:** Criar novo parser implementando `INotificationParser`
```dart
// lib/data/parsers/nubank_notification_parser.dart
class NubankNotificationParser implements INotificationParser {
  @override
  String get packageName => 'com.nu.production';

  @override
  String get bankName => 'Nubank';

  @override
  bool canParse(NotificationEvent event) {
    // Lógica específica do Nubank
  }

  @override
  TransactionData? parse(NotificationEvent event) {
    // Regex e lógica específica do Nubank
  }
}
```

**Passo 2:** Registrar no Registry
```dart
// Em notification_parser_registry.dart
void _registerDefaultParsers() {
  register(SantanderNotificationParser());
  register(NubankNotificationParser()); // <- Adicionar esta linha
}
```

**Pronto!** Novo banco integrado sem modificar código existente.

**Casos Extremos a Tratar:**
- Notificação de compra cancelada (não criar transação)
- Formatos de data variados
- Valores com/sem centavos
- Caracteres especiais em nomes de estabelecimentos
- Múltiplas notificações em sequência
- Permissão negada pelo usuário
- Service do listener parado

**Limitações Conhecidas:**
- **Android-only:** iOS não permite acesso a notificações de outros apps por restrições da plataforma
- **Específico por banco:** Cada banco requer um parser dedicado devido a formatos diferentes de notificação
- **Dependente de formato:** Se o banco mudar o formato da notificação, o parser precisa ser atualizado

**Definition of Done:**
- [x] Package `flutter_notification_listener` adicionado ao `pubspec.yaml`
- [x] Interface `INotificationParser` criada em `lib/domain/parsers/`
- [x] `SantanderNotificationParser` implementado em `lib/data/parsers/`
- [x] `NotificationParserRegistry` implementado com padrão Singleton
- [x] `NotificationService` inicializado no `main.dart`
- [x] Parser de Santander com regex funcional para valor, data e merchant
- [x] Extração de dados testada com múltiplos formatos de notificação
- [x] `TransactionNotificationService` criando notificações locais com action button
- [x] Handler de ação "Adicionar Transação" implementado (em TransactionNotificationService)
- [~] Navegação para `ExpenseDetailsBottomSheet` com pré-preenchimento (infraestrutura pronta, integração futura)
- [x] Campo `sourceBank` adicionado ao modelo `TransactionData`
- [x] UI de configurações com toggle e lista de bancos suportados
- [x] Botão para abrir configurações de permissão do sistema
- [x] Testes unitários isolados para `SantanderNotificationParser`
- [x] Testes unitários para o `NotificationParserRegistry`
- [x] Testes cobrindo casos extremos (valores, datas, caracteres especiais)
- [x] Tratamento de permissões negadas com feedback ao usuário
- [~] Documentação de como adicionar novos bancos em código (comentários presentes, CONTRIBUTING.md futuro)
- [x] Exemplo de stub/template para novos parsers comentado no código (MockNotificationParser nos testes)
- [~] Merge realizado para `develop` (pronto para merge, aguardando)

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
- [x] Merge realizado para `develop`

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
- [x] Merge realizado para `develop`

---

## 🐛 Fase 10: Correções Críticas de UI/UX

**Objetivo:** Corrigir bugs críticos de interface e comportamento que afetam a experiência do usuário no uso diário do aplicativo.

**Status:** 2 / 6 tarefas concluídas

---

### [x] F10-T1: Correção - Reserve Slider Snap to Saved Percentage

**Branch:** `fix/reserve-slider-snap`

**Descrição:**
O slider de porcentagem da reserva na página de configurações inicia no 0 quando a página carrega e "encaixa" (snap) no valor correto logo depois, o que é uma experiência de UI ruim. Além disso, é uma experiência ruim ter que apertar o botão de salvar para que o valor seja aplicado.

**Definition of Done:**
- [x] Slider não pula ao carregar a página de configurações, já inicia no valor salvo
- [x] Alterações no slider são aplicadas imediatamente sem necessidade de botão salvar
- [x] Validar que todas as alterações da página de configuração são salvas automaticamente
- [x] Merge realizado para `develop`

---

### [x] F10-T2: Correção - Automatic Capture Switch Persistence

**Branch:** `fix/automatic-capture-switch`

**Descrição:**
O switch de captura automática de transações na página de configurações não persiste a seleção do usuário.

**Problema Atual:**
- Usuário ativa/desativa o switch de captura automática
- Ao sair e retornar à página de configurações, o switch volta ao estado anterior
- A configuração não está sendo salva no banco de dados ou não está sendo carregada corretamente

**Investigação Necessária:**
- Verificar se o método `updateSettings()` está sendo chamado ao trocar o switch
- Confirmar que o valor está sendo persistido na tabela `AppSettings`
- Verificar se o provider está recarregando o valor correto ao retornar à tela

**Definition of Done:**
- [x] Switch persiste o estado corretamente entre navegações
- [x] Valor é salvo no banco de dados imediatamente ao alterar
- [x] Provider recarrega o valor correto ao retornar à tela
- [x] Testes de integração para verificar persistência
- [x] Merge realizado para `develop`

---

### [x] F10-T3: Correção - Credit Limit Visualization Bug

**Branch:** `fix/credit-limit-display`

**Descrição:**
A visualização do limite de crédito está completamente quebrada quando valores decimais são inseridos (ex: tentativa de inserir 9,17 e 14000,00).

**Problema Atual:**
- Inserção de valores com vírgula decimal não funciona corretamente
- Display do limite de crédito mostra valores incorretos ou formatação quebrada
- Possível problema de parsing entre string formatada e valor numérico

**Investigação Necessária:**
- Verificar o widget de input usado para limite de crédito
- Confirmar se está usando `NubankStyleCurrencyField` corretamente
- Verificar conversão entre display formatado e valor armazenado no banco
- Checar se há validação adequada para valores decimais

**Definition of Done:**
- [x] Valores decimais são aceitos e exibidos corretamente
- [x] Formatação de moeda consistente (R$ 14.000,00)
- [x] Conversão correta entre UI e banco de dados
- [x] Validação de entrada implementada
- [x] Testes para diferentes formatos de entrada
- [x] Merge realizado para `develop`

---

### [x] F10-T4: Correção - Duplicate R$ in Transfer Creation/Editing

**Branch:** `fix/duplicate-currency-symbol`

**Descrição:**
Remove o símbolo R$ duplicado que aparece na tela de criação/edição de transferências.

**Problema Atual:**
- Símbolo R$ aparece duplicado no campo de valor
- Pode estar sendo exibido tanto pelo label quanto pelo input field
- Prejudica a legibilidade e experiência do usuário

**Implementação Esperada:**
- Remover uma das ocorrências do símbolo R$
- Manter apenas o símbolo do ícone
- Garantir consistência com outros campos de moeda no app

**Definition of Done:**
- [x] Símbolo R$ aparece apenas uma vez no campo de valor
- [x] Consistência visual com outros campos de moeda
- [x] Testes de widget atualizados
- [x] Merge realizado para `develop`

---

### [x] F10-T5: Correção - Value Field Disappearing on Save Button Click

**Branch:** `fix/value-field-disappearing`

**Descrição:**
No momento em que o usuário clica no botão de salvar na aba de notas, o valor inserido desaparece do campo.

**Problema Atual:**
- Ao clicar em "Salvar" na aba de notas, o valor some
- Pode estar relacionado a rebuild do widget ou perda de estado
- Comportamento inconsistente entre as abas

**Investigação Necessária:**
- Verificar se há rebuild não intencional do widget
- Confirmar se o estado do valor está sendo mantido entre as abas
- Verificar se o `TextEditingController` está sendo descartado prematuramente
- Checar se há algum `setState` que limpa o campo

**Definition of Done:**
- [x] Valor permanece visível ao clicar em salvar
- [x] Estado do campo é mantido entre mudanças de aba
- [x] Não há rebuilds desnecessários que limpam o campo
- [x] Testes de widget para verificar persistência do valor
- [x] Merge realizado para `develop`

---

### [x] F10-T6: Correção - Transaction Save Validation for Missing Value

**Branch:** `fix/transaction-value-validation`

**Descrição:**
O botão de salvar na criação/edição de transações não valida a ausência de valor antes de tentar salvar.

**Problema Atual:**
- Usuário pode clicar em "Salvar" sem preencher o valor da transação
- Não há feedback visual de erro
- Pode causar crash ou salvar transação com valor zero/nulo

**Implementação Esperada:**
- Adicionar validação obrigatória para o campo de valor
- Exibir mensagem de erro quando tentar salvar sem valor
- Desabilitar botão de salvar ou destacar campo em vermelho quando inválido
- Validação deve ocorrer tanto na aba de detalhes quanto na aba de notas

**Definition of Done:**
- [x] Validação de valor obrigatório implementada
- [x] Mensagem de erro clara para o usuário
- [x] Feedback visual adequado (campo em destaque/botão desabilitado)
- [x] Validação funciona em ambas as abas (detalhes e notas)
- [x] Testes de validação implementados
- [x] Merge realizado para `develop`

---

## 🎨 Fase 11: Padronização e Melhorias de UX

**Objetivo:** Padronizar a formatação de valores monetários e melhorar a experiência do usuário em inputs e seleções.

**Status:** 4 / 5 tarefas concluídas

---

### [x] F11-T1: Padronização - Monetary Value Formatting Across App

**Branch:** `feature/consistent-monetary-formatting`

**Descrição:**
Padronizar a formatação de todos os valores monetários no aplicativo para usar o formato brasileiro consistente: R$ 99.990,99

**Problema Atual:**
- Dashboard exibe: R$ 99990,99
- Inputs exibem: R$ 99.990,99
- Falta de consistência visual entre diferentes telas
- Dificulta leitura de valores grandes

**Implementação Esperada:**
1. **Criar Utility para Formatação:**
   - Criar classe `CurrencyFormatter` em `lib/utils/`
   - Método para formatar valores com separador de milhares e decimais
   - Método para parsing de string formatada para double

2. **Atualizar Dashboard:**
   - Aplicar formatação consistente em todos os cards de valor
   - Saldo disponível, total de gastos, previsão, etc.

3. **Verificar Outros Locais:**
   - Tela de histórico de transações
   - Lista de despesas recorrentes
   - Detalhes de contas
   - Qualquer outro local que exiba valores monetários

**Exemplo de Implementação:**
```dart
class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static String format(double value) {
    return _formatter.format(value);
  }

  static double? parse(String formattedValue) {
    try {
      final cleanValue = formattedValue
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();
      return double.parse(cleanValue);
    } catch (e) {
      return null;
    }
  }
}
```

**Definition of Done:**
- [x] Dashboard usa formatação consistente (R$ 99.990,99)
- [x] Todas as telas do app exibem valores com o mesmo formato
- [x] Merge realizado para `develop`

---

### [x] F11-T2: Melhoria - Allow Future Date Selection in Transactions

**Branch:** `feature/future-date-transactions`

**Descrição:**
Permitir que o usuário selecione datas futuras ao criar/editar transações.

**Problema Atual:**
- Date picker limita seleção apenas para datas passadas e presente
- Usuários não podem registrar transações agendadas/futuras
- Limita casos de uso como planejamento de gastos futuros

**Implementação Esperada:**
- Remover restrição de data máxima no date picker
- Permitir seleção de qualquer data futura

**Definition of Done:**
- [x] Date picker aceita datas futuras
- [x] Merge realizado para `develop`

---

### [x] F11-T3: Melhoria - Auto-Capitalize Text Inputs

**Branch:** `feature/auto-capitalize-inputs`

**Descrição:**
Forçar a primeira letra em maiúscula em todos os campos de entrada de texto do aplicativo (descrição, notas, etc.).

**Problema Atual:**
- Usuário digita descrições começando com letra minúscula
- Falta de padronização na apresentação dos dados
- Aparência menos profissional

**Implementação Esperada:**
- Aplicar `TextCapitalization.sentences` em todos os `TextField`/`TextFormField`
- Atualizar widgets customizados (`CustomTextField`, `NubankStyleTextField`, etc.)
- Garantir que a capitalização funciona em todos os formulários:
  - Descrição de transações
  - Notas de transações
  - Nome de contas
  - Nome de categorias
  - Descrição de despesas recorrentes

**Exemplo:**
```dart
TextField(
  textCapitalization: TextCapitalization.sentences,
  // ... outros parâmetros
)
```

**Definition of Done:**
- [x] Todos os campos de texto usam `TextCapitalization.sentences`
- [x] Widgets customizados atualizados para suportar capitalização
- [x] Verificação manual em todos os formulários do app
- [ ] Testes de widget atualizados
- [x] Merge realizado para `develop`

---

### [x] F11-T4: Melhoria - Improve Dropdown UI Consistency

**Branch:** `feature/consistent-dropdown-ui`

**Descrição:**
Melhorar a interface do dropdown em todo o aplicativo para ter consistência com o design system.

**Problema Atual:**
- Dropdowns no bottom sheet de transações e resto do app não seguem design consistente
- Falta de alinhamento visual com os outros inputs do tipo Nubank
- Experiência de usuário inconsistente

**Implementação Realizada:**
- Atualizado `CustomDropdown` widget existente para melhorar consistência visual
- Adicionado `dropdownColor: AppColors.surfaceVariant` para menu dropdown combinar com tema dark
- Adicionado `menuMaxHeight: 300` para limitar altura do menu
- Customizado ícone do dropdown com cores que mudam baseado no estado de foco
- Dropdown menu agora combina perfeitamente com o design system do app

**Definition of Done:**
- [x] Dropdown menu styled com cores do dark theme
- [x] Design consistente com outros inputs do app
- [x] Menu dropdown usa cores apropriadas (surfaceVariant)
- [x] Ícone customizado com estados de foco
- [x] Merge realizado para `develop`

---

## 🏗️ Fase 12: Estabilidade e Code Health

**Objetivo:** Corrigir todos os warnings e infos do `flutter analyze`, atualizar pacotes desatualizados, e migrar código obsoleto, garantindo um código **limpo**, **moderno** e **sem alertas**.

**Status:** 1 / 4 tarefas concluídas

---

### [x] F12-T1: Implementação de Logging e Limpeza de Produção (7 Issues)

**Descrição:** Remover todas as chamadas de `print()` em código de produção e substituí-las por uma solução de logging adequada para facilitar a depuração.

**Issues/Grupo Corrigido:**
- **7** instâncias de `avoid_print` (lib/data/services/notification_service.dart, lib/data/services/transaction_notification_service.dart).

**Subtarefas:**
1.  Adicionar um pacote de logging (ex: `logger`) como `dev_dependency` e criar um wrapper de `LoggerService` ou usar o pacote diretamente.
2.  Substituir todas as 7 chamadas de **`print(...)`** nos dois arquivos de serviço de notificação por chamadas ao logger (ex: `_log.info('...')`).
3.  Configurar o logger para ser silencioso em builds de produção/release, aderindo à regra de lint.

**Definition of Done:**
- [ ] Pacote de logging adicionado ao projeto
- [ ] Todas as chamadas `print()` substituídas
- [ ] Logger configurado para produção
- [ ] `flutter analyze` não retorna `avoid_print`
- [ ] Merge realizado para `develop`

---

### [x] F12-T2: Remoção de Código Morto e Alertas de Compilação (10 Issues)

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

**Definition of Done:**
- [ ] Todos os campos e variáveis não utilizados removidos
- [ ] Elementos mortos removidos
- [ ] Anotações `@override` incorretas corrigidas
- [ ] `flutter analyze` não retorna warnings de código não utilizado
- [ ] Testes continuam passando
- [ ] Merge realizado para `develop`

---

### [x] F12-T3: Migração de APIs Deprecated e Contextos Assíncronos (11 Issues)

**Branch:** `chore/deprecated-api-migration`

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

**Definition of Done:**
- [x] Todas as APIs deprecated substituídas
- [x] Contextos assíncronos corrigidos com `if (mounted)`
- [x] `flutter analyze` não retorna `deprecated_member_use`
- [x] `flutter analyze` não retorna `use_build_context_synchronously`
- [x] Testes executam sem warnings
- [ ] Merge realizado para `develop`

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

**Status:** 3 / 3 tarefas concluídas

---

### [x] F14-T1: Refatorar Cálculo de Reserva para Usar Saldos de Contas

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

### [x] F14-T2: Adicionar Exclusão de Conta da Reserva

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

### [x] F14-T3: Implementar Filtragem de Transações por Ciclo de Faturamento de Crédito

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
- [x] Funções de cálculo de ciclo implementadas e testadas
- [x] Dashboard filtra transações de crédito por ciclo
- [x] Edge cases tratados (meses com dias inválidos)
- [x] Recurring expenses atualizado (se aplicável)
- [x] UI mostra período do ciclo (opcional)
- [x] Testes unitários para cálculo de ciclo
- [x] Testes de integração para filtragem
- [x] Merge realizado para `develop`

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

### [x] F15-T2: Melhorias de Layout no Formulário de Conta

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
- [x] Checkboxes de débito/crédito na mesma linha
- [x] Inputs de saldo/limite na mesma linha
- [x] Lógica de enable/disable funcionando corretamente
- [x] Visual feedback para campos desabilitados
- [x] Layout responsivo (vertical em telas pequenas)
- [x] Testes de widget atualizados
- [x] Aparência consistente com design system
- [x] Merge realizado para `develop`

---

### [x] F15-T3: Remover Página de Calendário Condicional para Contas Não-Crédito

**Branch:** `feature/conditional-calendar-page`

**Descrição:**
Tornar a segunda página do formulário de conta (com calendário de pagamento) visível apenas quando o checkbox de crédito está marcado, eliminando navegação desnecessária para contas de débito.

**Problema Atual:**
- Formulário tem 2 páginas (PageView com 2 children)
- Usuário pode fazer um swipe para a página do calendário mesmo se não for relevante

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
- [x] Segunda página (calendário) só aparece se `_isCredit == true`
- [x] Botão de navegação adapta-se ao número de páginas
- [x] Desmarcar crédito volta para página 1 se necessário
- [x] Validação impede salvar crédito sem dia de pagamento
- [x] Indicador de página condicional implementado
- [x] UX suave com animações apropriadas
- [x] Testes de widget para fluxos de 1 e 2 páginas
- [x] Merge realizado para `develop`

---

### [x] F15-T4: Feature Experimental - Monitor de Notificações para Debug

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

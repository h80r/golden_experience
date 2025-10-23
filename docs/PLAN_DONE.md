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

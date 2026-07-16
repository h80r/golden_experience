# Tasks

## 1. UI da Calculadora e Bottom Sheet
**Branch:** `feature/calculator-ui`
- [x] 1.1 Widgets criados seguindo o design
- [x] 1.2 Componentes reutilizáveis implementados
- [x] 1.3 Interações de UI funcionam isoladamente
- [x] 1.4 Testes de widget para componentes
- [x] 1.5 Aplicação do design system (cores, tipografia, espaçamento)
- [x] 1.6 Merge realizado para `develop`

## 2. Lógica de Estado para o Registro
**Branch:** `feature/expense-state`
- [x] 2.1 `ExpenseFormNotifier` implementado
- [x] 2.2 Provider configurado
- [x] 2.3 Validações implementadas
- [x] 2.4 Testes unitários para o notifier
- [x] 2.5 Estados de erro tratados
- [x] 2.6 Merge realizado para `develop`

## 3. Use Case - Adicionar Transação
**Branch:** `feature/add-transaction-usecase`
- [x] 3.1 `AddTransactionUseCase` implementado em `domain/usecases/`
- [x] 3.2 Lógica de atualização de saldo/limite correta
- [x] 3.3 Tratamento de erros implementado
- [x] 3.4 Testes unitários cobrindo todos os cenários
- [x] 3.5 Provider do use case configurado
- [x] 3.6 Merge realizado para `develop`

## 4. Integração Fim-a-Fim do Fluxo
**Branch:** `feature/expense-flow-integration`
- [x] 4.1 FAB no Dashboard abre a calculadora
- [x] 4.2 Calculadora confirma valor e abre bottom sheet
- [x] 4.3 Bottom sheet salva e chama o use case
- [x] 4.4 Transação é persistida no banco
- [x] 4.5 Saldo/limite da conta é atualizado
- [x] 4.6 Fluxo fecha e retorna ao Dashboard
- [x] 4.7 Teste de integração E2E para o fluxo completo
- [x] 4.8 Merge realizado para `develop`

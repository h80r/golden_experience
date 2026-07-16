# Tasks

## 1. Welcome Tour / Onboarding Inicial
**Branch:** `feature/welcome-tour`
- [x] 1.1 Package de onboarding adicionado (ou implementação customizada)
- [x] 1.2 Fluxo de 5 telas implementado
- [x] 1.3 Dados coletados salvos no banco (AppSettings, Account, Categories)
- [x] 1.4 Flag `hasCompletedOnboarding` controla exibição do tour
- [x] 1.5 Tour só aparece na primeira inicialização
- [x] 1.6 Design system aplicado em todas as telas
- [x] 1.7 Botão "Pular" permite acesso ao app sem completar
- [x] 1.8 Testes de widget para o fluxo de onboarding
- [x] 1.9 Merge realizado para `develop`

## 2. Listagem de Transações com CRUD
**Branch:** `feature/transactions-list`
- [x] 2.1 Tela de listagem implementada
- [x] 2.2 Filtros de período, conta e categoria funcionais
- [x] 2.3 Swipe actions para editar/deletar implementados
- [x] 2.4 Bottom sheet reutilizado para edição
- [x] 2.5 Dialog de confirmação de exclusão implementado
- [x] 2.6 Lógica de reversão de saldo/limite ao deletar
- [x] 2.7 Navegação adicionada (nova aba ou menu)
- [x] 2.8 Empty state quando não há transações
- [x] 2.9 Testes de widget para a tela e componentes
- [x] 2.10 Merge realizado para `develop`

## 3. Padronização de Input Numérico com Vírgula
**Branch:** `refactor/numeric-input-standard`
- [x] 3.1 Widget `CurrencyTextField` criado em `lib/presentation/widgets/inputs/`
- [x] 3.2 TextInputFormatter customizado para vírgula implementado
- [x] 3.3 Formatação com separador de milhar funcional
- [x] 3.4 Validação de valores implementada
- [x] 3.5 Aplicado em ExpenseDetailsBottomSheet
- [x] 3.6 Aplicado em SettingsScreen
- [x] 3.7 Aplicado em AccountForm
- [x] 3.8 Aplicado em RecurringExpenseForm
- [x] 3.9 Testes de widget para CurrencyTextField
- [x] 3.10 Testes de validação e formatação
- [x] 3.11 Documentação do widget (comentários)
- [x] 3.12 Merge realizado para `develop`

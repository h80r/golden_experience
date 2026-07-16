# Tasks

## 1. Correção - Fix New Account Bottom Sheet Behavior
**Branch:** `fix/account-bottom-sheet-keyboard`
- [x] 1.1 Bottom sheet ajusta altura corretamente com teclado
- [x] 1.2 Todos os campos acessíveis quando teclado está visível
- [x] 1.3 Scroll automático para campo em foco
- [x] 1.4 Comportamento consistente com bottom sheet de transações
- [x] 1.5 Testes de widget para verificar comportamento
- [x] 1.6 Merge realizado para `develop`

## 2. Melhoria - Collapsible Account Tiles with Click to Expand
**Branch:** `feature/collapsible-account-tiles`
- [x] 2.1 Account tiles colapsados por padrão
- [x] 2.2 Click expande/colapsa tile com animação
- [x] 2.3 Informações essenciais visíveis em modo colapsado
- [x] 2.4 Detalhes completos visíveis em modo expandido
- [x] 2.5 Ícone de expansão rotaciona adequadamente
- [x] 2.6 Testes de widget implementados
- [x] 2.7 Merge realizado para `develop`

## 3. Feature - Default Account Selection
**Branch:** `feature/default-account-selection`
- [x] 3.1 Coluna `isDefault` adicionada à tabela Accounts
- [x] 3.2 UI para marcar/desmarcar conta padrão implementada
- [x] 3.3 Apenas uma conta pode ser default por vez
- [x] 3.4 Bottom sheet de transações pré-seleciona conta padrão
- [x] 3.5 Regras de negócio para exclusão implementadas
- [x] 3.6 Testes de integração para seleção de conta padrão
- [x] 3.7 Migration documentada
- [x] 3.8 Merge realizado para `develop`

## 4. Feature - Category Management in Settings
**Branch:** `feature/category-management`
- [x] 4.1 Seção de gerenciamento de categorias na settings
- [x] 4.2 CRUD completo de categorias implementado
- [x] 4.3 Seleção de categoria padrão funcional
- [x] 4.4 Validação de exclusão (categorias com transações)
- [x] 4.5 Categorias iniciais criadas no onboarding
- [x] 4.6 Bottom sheet de transações pré-seleciona categoria padrão
- [x] 4.7 Testes de integração
- [x] 4.8 Merge realizado para `develop`

## 5. Feature - Salary Payment Date Configuration
**Branch:** `feature/salary-payment-date`
- [x] 5.1 Colunas `salaryPaymentMode` e `salaryPaymentValue` adicionadas ao banco
- [x] 5.2 Migration v5→v6 implementada
- [x] 5.3 Widget calendário inline personalizado criado
- [x] 5.4 SegmentedToggle para modo de seleção
- [x] 5.5 Dropdown de dias úteis com cálculo de datas
- [x] 5.6 Calendário brasileiro de feriados implementado
- [x] 5.7 Lógica de seleção inteligente de mês
- [x] 5.8 UI completa integrada ao Settings Screen
- [x] 5.9 Persistência de dados funcionando
- [x] 5.10 Merge realizado para `develop`

## 6. Feature - Credit Payment Date per Account
**Branch:** `feature/credit-payment-date`
- [x] 6.1 Coluna `creditClosingDay` adicionada à tabela Accounts
- [x] 6.2 Campo visível apenas para contas de crédito
- [x] 6.3 UI para edição do dia de fechamento (InlineCalendar widget)
- [x] 6.4 Validação implementada (nullable field, 1-31 values)
- [x] 6.5 Valor persistido corretamente (both create and update)
- [x] 6.6 Documentação de uso futuro (comments in code)
- [x] 6.7 Merge realizado para `develop`

**Nota de reconciliação (2026-07-16):** o campo `creditClosingDay` (item 6.1) foi posteriormente renomeado para `creditPaymentDay` na migração de schema v9→v10 (Fase 15, F15-T1), com o dia de fechamento passando a ser sempre derivado (`paymentDay - 7`) em vez de armazenado. Ver spec `billing-cycles-and-invoices`.

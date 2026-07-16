# Tasks

## 1. Correção - Exibição de Valores nas Configurações
**Branch:** `fix/settings-values-display`
- [x] 1.1 Causa raiz do bug identificada e documentada
- [x] 1.2 Valores de salário e reserva carregam corretamente ao abrir a tela
- [x] 1.3 Campos de input exibem os valores formatados corretamente (ex: R$ 5.000,00)
- [x] 1.4 Alterações nos valores são persistidas e recarregam corretamente
- [x] 1.5 Testes de widget atualizados para cobrir o carregamento de valores
- [x] 1.6 Merge realizado para `develop`

## 2. Melhoria - Padronização do App Bar nas Telas Principais
**Branch:** `enhancement/standardize-app-bar`
- [x] 2.1 Widget `StandardAppBar` criado em `lib/presentation/widgets/common/`
- [x] 2.2 App bar padronizado aplicado na `DashboardScreen`
- [x] 2.3 App bar padronizado aplicado na `RecurringExpensesScreen`
- [x] 2.4 App bar padronizado aplicado na `AccountsScreen`
- [x] 2.5 Botão de configurações funcional em todas as telas
- [x] 2.6 Navegação para `SettingsScreen` funcionando corretamente
- [x] 2.7 Design consistente com as especificações do design system
- [x] 2.8 Ações adicionais (botões de adicionar) preservadas onde necessário
- [x] 2.9 Testes de widget para o `StandardAppBar`
- [x] 2.10 Testes de widget atualizados para as telas modificadas
- [x] 2.11 Merge realizado para `develop`

**Nota de reconciliação (2026-07-16):** o item 1 (F9-T1) estava marcado `[ ]` no título do documento legado (typo), mas todos os subitens já estavam `[x]`; confirmado implementado via `settings_screen.dart:160` (`initialValue: formState.monthlySalary`).

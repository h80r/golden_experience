# Tasks

## 1. Refatorar Cálculo de Reserva para Usar Saldos de Contas
**Branch:** `refactor/reserve-from-account-balances`
- [x] 1.1 Migration v7→v8 implementada e testada
- [x] 1.2 Campo `reserveBalance` removido do código
- [x] 1.3 Dashboard calcula reserva a partir de saldos de contas
- [x] 1.4 Settings UI atualizada (sem input manual de reserva)
- [x] 1.5 Onboarding atualizado (se necessário)
- [x] 1.6 Todos os testes atualizados e passando
- [x] 1.7 Code generation executado com sucesso
- [x] 1.8 Merge realizado para `develop`

## 2. Adicionar Exclusão de Conta da Reserva
**Branch:** `feature/account-reserve-exclusion`
- [x] 2.1 Coluna `excludeFromReserve` adicionada à tabela Accounts
- [x] 2.2 Toggle implementado no formulário de conta
- [x] 2.3 Visual indicator implementado na lista de contas
- [x] 2.4 Dashboard respeita a exclusão no cálculo
- [x] 2.5 Validação e alertas implementados
- [x] 2.6 Testes de integração para exclusão
- [x] 2.7 Code generation executado
- [x] 2.8 Merge realizado para `develop`

## 3. Implementar Filtragem de Transações por Ciclo de Faturamento de Crédito
**Branch:** `feature/credit-billing-cycle-filtering`
- [x] 3.1 Funções de cálculo de ciclo implementadas e testadas
- [x] 3.2 Dashboard filtra transações de crédito por ciclo
- [x] 3.3 Edge cases tratados (meses com dias inválidos)
- [x] 3.4 Recurring expenses atualizado (se aplicável)
- [x] 3.5 UI mostra período do ciclo (opcional)
- [x] 3.6 Testes unitários para cálculo de ciclo
- [x] 3.7 Testes de integração para filtragem
- [x] 3.8 Merge realizado para `develop`

**Nota de reconciliação (2026-07-16):** os itens 1.x e 2.x estavam desmarcados `[ ]` no Definition of Done do documento legado apesar do header da tarefa e da fase estarem `[x]`. Verificado no código atual: `AppSettings` não possui `reserveBalance` (confirmado em `app_settings_table.dart`), `excludeFromReserve` existe em `accounts_table.dart`, e `GetDashboardDataUseCase` soma saldos de contas de débito não excluídas — a funcionalidade está de fato implementada; marcado como concluído aqui.

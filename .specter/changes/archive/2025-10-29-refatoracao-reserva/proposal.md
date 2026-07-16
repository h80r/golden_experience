# Proposal: Refatoração do Sistema de Reserva e Ciclo de Faturamento

## Intent
Refatorar o cálculo da reserva para usar saldos das contas de débito e implementar filtragem de transações de crédito por ciclo de faturamento.

## Scope
- Remover o campo manual `reserveBalance` de `AppSettings`; reserva passa a ser calculada dinamicamente como soma dos saldos de contas de débito
- Adicionar `excludeFromReserve` por conta (contas "intocáveis" não entram no cálculo da reserva)
- Filtrar transações de contas de crédito pelo ciclo de faturamento (entre fechamentos), em vez de mês calendário

## Approach
Migration v7→v8 remove `reserveBalance`; migration v8→v9 adiciona `excludeFromReserve`. `GetDashboardDataUseCase` passa a somar saldos de contas de débito não excluídas, e filtra transações de crédito por ciclo de faturamento calculado a partir do dia de fechamento.

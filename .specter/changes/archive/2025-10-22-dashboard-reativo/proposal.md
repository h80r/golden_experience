# Proposal: O Coração do Produto - Dashboard Reativo

## Intent
Implementar o Dashboard com todos os cálculos financeiros e reatividade em tempo real.

## Scope
- Use case que busca dados e realiza os cálculos financeiros (gasto total, salário-gasto, gasto restante, reserva final, % da reserva gasto)
- Lógica de processamento de recorrências na inicialização do app
- UI completa do Dashboard (header, card principal, card secundário, FAB)
- Integração reativa via StreamProvider (Riverpod) conectada ao banco

## Approach
Streams do banco de dados alimentam StreamProviders que recalculam os dados do dashboard automaticamente a cada mudança em transações, contas ou configurações.

# Proposal: Melhorias no Histórico de Transações

## Intent
Aprimorar a tela de histórico de transações com filtragem por ciclo de faturamento (alinhado ao dashboard), filtros débito/crédito, card de soma total flutuante e tags visuais.

## Scope
- Histórico exibe por padrão o ciclo de faturamento atual (não mês calendário) para contas de crédito
- Filtro débito/crédito no histórico
- Card de soma total flutuante que se transforma no FAB de adicionar transação
- Tags visuais (badges) de débito/crédito em cada transação da lista
- Correção: tipo de transação não era preservado ao editar
- Melhoria de UI dos filtros (dropdown de período, seletor visual de tipo)
- Correção de persistência do dia de pagamento de salário quando configurado como "último dia útil"

## Approach
Reutilização da lógica de cálculo de ciclo de faturamento já usada no dashboard. Novo `AnimatedSwitcher`/`Stack` para a transição sum-card↔FAB. Cores dedicadas no design system para as tags débito/crédito.

# Proposal: Gerenciador de Faturas e Transações Parceladas

## Intent
Implementar gerenciador de faturas de cartão de crédito com histórico de pagamentos e suporte a transações parceladas automáticas.

## Scope
- Gerenciador de faturas simplificado: tabela `Invoices` armazena apenas período (start/end) + flag `isPaid`; todos os valores calculados dinamicamente via query
- Período de fatura unificado entre todos os cartões de crédito (earliest start / latest end)
- Navegação temporal no dashboard (swipe/setas entre faturas), abrindo por padrão na primeira fatura não paga
- `InvoiceDetailsScreen` com breakdown por conta e `InvoiceHistoryScreen` com faturas passadas
- Dashboard passa a ser inteiramente baseado em faturas de crédito (transações de débito excluídas do orçamento de fatura)
- Transações parceladas: criação automática das parcelas futuras, uma por ciclo de faturamento seguinte, agrupadas por UUID

## Approach
Migration remove `InvoiceItems` (schema anterior) e simplifica `Invoices` para período+status. `calculateUnifiedInvoicePeriod` (billing_cycle_utils) unifica ciclos de múltiplos cartões. Parcelamento usa `installmentGroupId` (UUID) para agrupar transações relacionadas, com data de cada parcela futura calculada como o primeiro dia do N-ésimo ciclo seguinte.

# Correção - Persistir Data de Fechamento no Backup

**Captured:** 2026-07-16
**Source:** migrated from PLAN.md Phase 20 (F20-T3)

## Idea
O sistema de backup não está salvando a data de fechamento dos cartões de crédito (campo calculado baseado em `creditPaymentDay`). Garantir que o ciclo de faturamento completo é restaurado corretamente.

## Notes
- Observação original: este problema está diretamente ligado ao item irmão (persistir `creditPaymentDay`), já que a data de fechamento é sempre calculada como `paymentDay - 7` — não é armazenada como coluna própria desde a migração de schema v9→v10.
- **Provavelmente resolvido automaticamente** ao implementar a correção de `creditPaymentDay` (ver `backup-persist-credit-payment-day`), já que o fechamento nunca é persistido separadamente no schema atual — não existe coluna `creditClosingDay` na tabela `Accounts` hoje.
- Se ao investigar a tarefa irmã confirmar que o problema já está resolvido, esta entrada pode ser descartada sem implementação própria.
- Branch sugerida (se ainda necessária): `fix/backup-closing-day`

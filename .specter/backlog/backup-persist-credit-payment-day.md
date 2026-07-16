# Correção - Persistir Data de Pagamento no Backup

**Captured:** 2026-07-16
**Source:** migrated from PLAN.md Phase 20 (F20-T2)

## Idea
O sistema de backup não está salvando a data de pagamento dos cartões de crédito (`creditPaymentDay`). Adicionar este campo ao JSON de backup e restore.

## Notes
- Identificar estrutura atual do JSON de backup para `Accounts`
- Adicionar campo `creditPaymentDay` ao JSON de export
- Adicionar leitura do campo `creditPaymentDay` no JSON de import
- Garantir compatibilidade com backups antigos (campo nullable)
- Testar export/import e compatibilidade com backup antigo sem o campo
- Branch sugerida: `fix/backup-payment-day`
- **Verificado em 2026-07-16:** o gap ainda existe no código atual — `backup_repository_impl.dart` exporta/importa apenas `transactions`, `accounts` (campos base), `categories`, `recurringExpenses`, `appSettings`; `creditPaymentDay` não está entre os campos tratados.

# Correção - Persistir Tipo de Pagamento (Débito/Crédito) no Backup

**Captured:** 2026-07-16
**Source:** migrated from PLAN.md Phase 20 (F20-T4)

## Idea
O sistema de backup não está salvando o tipo de pagamento das transações (se foi débito ou crédito, campo `transactionType`). Adicionar este campo ao JSON de backup e restore.

## Notes
- Identificar estrutura atual do JSON de backup para `Transactions`
- Adicionar campo `transactionType` ao JSON de export
- Adicionar leitura do campo `transactionType` no JSON de import
- Garantir compatibilidade com backups antigos (campo nullable, default baseado em tipo de conta)
- Testar export/import e inferência para backup antigo sem o campo
- Validar que dashboard calcula valores corretamente após restore
- Validar que faturas agrupam transações corretamente após restore
- Branch sugerida: `fix/backup-payment-type`
- **Verificado em 2026-07-16 — escopo maior que o originalmente descrito:** `backup_repository_impl.dart` não exporta/importa `transactionType` nem os campos de parcelamento (`installmentNumber`, `installmentTotal`, `installmentGroupId`), e a tabela `invoices` inteira também está ausente do backup. Um restore hoje perde metadados de parcelamento e reseta `transactionType` para o default ('credit'). Vale reavaliar o escopo desta tarefa para cobrir todos os campos ausentes, não apenas `transactionType`.

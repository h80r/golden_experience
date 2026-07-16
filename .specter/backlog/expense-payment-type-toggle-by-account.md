# Correção - Habilitar/Desabilitar Débito/Crédito Baseado no Tipo de Conta

**Captured:** 2026-07-16
**Source:** migrated from PLAN.md Phase 19 (F19-T5)

## Idea
No bottom sheet de criação de despesas, os campos de débito/crédito devem ser habilitados/desabilitados automaticamente de acordo com o tipo da conta selecionada. Se a conta for apenas débito, desabilitar opção de crédito. Se for apenas crédito, desabilitar opção de débito.

## Notes
- Monitorar mudanças no campo de seleção de conta
- Ao selecionar conta, verificar `account.isDebit` e `account.isCredit`
- Se `isDebit == true && isCredit == false`: desabilitar toggle de crédito, forçar débito
- Se `isCredit == true && isDebit == false`: desabilitar toggle de débito, forçar crédito
- Se `isDebit == true && isCredit == true`: habilitar ambos os toggles
- Atualizar UI para mostrar estado desabilitado visualmente (cinza, opacity reduzida)
- Garantir que valor default é correto ao trocar de conta
- Testar com conta débito-only, crédito-only e dual-type
- Branch sugerida: `fix/expense-payment-type-toggle`

# Correção - Auto-refresh do Dashboard em Mudanças de Configurações

**Captured:** 2026-07-16
**Source:** migrated from PLAN.md Phase 19 (F19-T3)

## Idea
O dashboard não atualiza automaticamente quando há mudanças nas configurações ou nos saldos das contas. Usuário precisa navegar para a lista de transações e voltar para ver os valores atualizados. Implementar invalidação automática dos providers do dashboard.

## Notes
- Identificar todos os providers que afetam o dashboard (accounts, settings, transactions)
- Implementar `ref.invalidate()` ou `ref.refresh()` nos providers dependentes
- Garantir que mudanças em `AppSettings` invalidam dashboard
- Garantir que mudanças em `Accounts` (saldo, limite) invalidam dashboard
- Garantir que mudanças em `Transactions` invalidam dashboard automaticamente (já deve funcionar via streams)
- Testar cenário: mudar `paymentDay` → dashboard atualiza
- Testar cenário: editar saldo de conta → dashboard atualiza
- Testar cenário: criar/editar transação → dashboard atualiza
- Verificar performance (evitar rebuilds desnecessários)
- Branch sugerida: `fix/dashboard-auto-refresh`

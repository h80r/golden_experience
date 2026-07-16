# Correção - Descrição de Transação Retorna à Tela Anterior

**Captured:** 2026-07-16
**Source:** migrated from PLAN.md Phase 19 (F19-T1)

## Idea
Na criação de transações, ao salvar no campo de descrição (pressionar "salvar" no teclado), a aplicação volta para a primeira tela sem salvar a transação. Corrigir o comportamento para que salvar na descrição não cause navegação automática.

## Notes
- Identificar o listener/callback que está causando a navegação prematura
- Remover ou ajustar o comportamento de navegação no TextField de descrição
- Garantir que apenas o botão "Salvar" da transação cause a navegação
- Testar fluxo completo de criação de transação com descrição
- Verificar comportamento em modo edição também
- Branch sugerida: `fix/transaction-description-save`

# Correção - Botão Salvar na Primeira Tela de Edição de Contas

**Captured:** 2026-07-16
**Source:** migrated from PLAN.md Phase 19 (F19-T2)

## Idea
Na edição de contas, quando há crédito habilitado, a primeira tela deve ter um botão "Salvar" em vez de "Avançar". O fluxo atual força o usuário a passar para a segunda tela mesmo quando só quer editar informações da primeira tela.

## Notes
- Detectar se conta tem crédito habilitado (`isCredit == true`)
- Se apenas débito: manter botão "Salvar" (comportamento atual)
- Se crédito habilitado: trocar "Avançar" por "Salvar" na primeira tela
- Botão "Salvar" deve persistir mudanças e fechar o bottom sheet
- Manter opção de ir para segunda tela (adicionar botão secundário "Configurar Crédito" ou similar)
- Testar fluxo de edição com conta débito-only e com conta crédito
- Branch sugerida: `fix/account-edit-save-button`

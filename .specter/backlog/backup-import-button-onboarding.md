# Adicionar Botão "Importar Backup" no Tour Inicial

**Captured:** 2026-07-16
**Source:** migrated from PLAN.md Phase 20 (F20-T1)

## Idea
Adicionar botão de "Importar Backup" no tour de início do aplicativo, permitindo que usuários restaurem seus dados antes de completar o onboarding.

## Notes
- Adicionar botão "Importar Backup" na tela inicial do tour (posicionado acima ou abaixo do botão "Começar")
- Implementar fluxo: abrir file picker → validar arquivo JSON → restaurar dados → navegar para tela apropriada (dashboard ou completar tour)
- Adicionar loading state durante importação
- Adicionar tratamento de erros (arquivo inválido, formato incorreto)
- Testar cenário: importar backup válido antes do tour
- Testar cenário: importar backup inválido (mostrar erro)
- Testar cenário: cancelar file picker
- Branch sugerida: `feature/import-backup-onboarding`

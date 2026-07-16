# Correção - Error Toasts Aparecendo Atrás do Bottom Sheet

**Captured:** 2026-07-16
**Source:** migrated from PLAN.md Phase 19 (F19-T4)

## Idea
Error toasts aparecem atrás dos bottom sheets, impossibilitando identificar o problema. Implementar solução para garantir que toasts sempre apareçam acima de todos os outros widgets, incluindo bottom sheets.

## Notes
- Investigar implementação atual do sistema de toasts (o app usa `ScaffoldMessenger.showSnackBar` diretamente, sem um sistema de toast/overlay dedicado — ver spec de referência para confirmar antes de planejar)
- Implementar solução com maior z-index/elevation (`Overlay`/`OverlayEntry` com prioridade alta, ou ajuste de `showModalBottomSheet`)
- Garantir que toasts aparecem acima de bottom sheets e de dialogs
- Testar com expense bottom sheet aberto e com account bottom sheet aberto
- Testar com todos os tipos de toast (error, success, info)
- Branch sugerida: `fix/toast-z-index`

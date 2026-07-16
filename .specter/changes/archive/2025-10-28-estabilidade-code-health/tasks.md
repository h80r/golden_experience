# Tasks

## 1. Implementação de Logging e Limpeza de Produção (7 Issues)
- [x] 1.1 Pacote de logging adicionado ao projeto
- [x] 1.2 Todas as chamadas `print()` substituídas
- [x] 1.3 Logger configurado para produção
- [x] 1.4 `flutter analyze` não retorna `avoid_print`
- [x] 1.5 Merge realizado para `develop`

## 2. Remoção de Código Morto e Alertas de Compilação (10 Issues)
- [x] 2.1 Todos os campos e variáveis não utilizados removidos
- [x] 2.2 Elementos mortos removidos
- [x] 2.3 Anotações `@override` incorretas corrigidas
- [x] 2.4 `flutter analyze` não retorna warnings de código não utilizado
- [x] 2.5 Testes continuam passando
- [x] 2.6 Merge realizado para `develop`

## 3. Migração de APIs Deprecated e Contextos Assíncronos (11 Issues)
**Branch:** `chore/deprecated-api-migration`
- [x] 3.1 Todas as APIs deprecated substituídas
- [x] 3.2 Contextos assíncronos corrigidos com `if (mounted)`
- [x] 3.3 `flutter analyze` não retorna `deprecated_member_use`
- [x] 3.4 `flutter analyze` não retorna `use_build_context_synchronously`
- [x] 3.5 Testes executam sem warnings
- [ ] 3.6 Merge realizado para `develop`

**Nota de reconciliação (2026-07-16):** o item 3.6 permanece não marcado no documento legado, apesar da fase estar concluída (código confirma migração via commits subsequentes, ex. `chore/deprecated-api-migration` no histórico git). Preservado como está por fidelidade à fonte.

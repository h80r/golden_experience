# Proposal: Estabilidade e Code Health

## Intent
Corrigir todos os warnings e infos do `flutter analyze`, atualizar pacotes desatualizados, e migrar código obsoleto, garantindo um código limpo, moderno e sem alertas.

## Scope
- Substituir `print()` por logging adequado em produção (7 issues)
- Remover código morto e variáveis/campos não utilizados (10 issues)
- Migrar APIs deprecated (`withOpacity`, `setMockMethodCallHandler`, etc.) e corrigir uso de `BuildContext` em contextos assíncronos (11 issues)

## Approach
Passagem sistemática pelos alertas do `flutter analyze`, agrupados por categoria (logging, dead code, deprecated APIs), corrigidos em três frentes de trabalho sequenciais.

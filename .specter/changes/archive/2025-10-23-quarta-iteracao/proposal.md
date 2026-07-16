# Proposal: Quarta Iteração - Correções Críticas e Refinamentos de UX

## Intent
Corrigir bugs críticos no sistema de input numérico, melhorar a experiência de uso do bottom sheet de transações e refinar interações da lista de transações.

## Scope
- Sistema de input numérico tipo Nubank (dígitos da direita para esquerda), substituindo o `CurrencyTextField` anterior em pontos críticos
- Bottom sheet de transação dividido em duas páginas (PageView) para não esconder campos atrás do teclado
- Swipe-to-delete com Undo no toast (padrão Gmail), removendo swipe-to-edit
- Toggle Dashboard/Histórico na aba "Início" com suporte ao botão voltar do Android
- Correção de visibilidade do app nas permissões de notificação do Android
- File picker para escolher o destino do backup exportado

## Approach
Novo widget `NubankStyleCurrencyField` para resolver bugs de formatação do `CurrencyTextField`. `PageView` de 2 páginas no bottom sheet de transação. `Dismissible` com `SnackBar` de duração indefinida para undo. Provider Riverpod para alternância de view na aba Início com `WillPopScope`.

# Proposal: Primeira Iteração - Correções e Melhorias

## Intent
Corrigir bugs identificados no uso inicial e implementar melhorias de UX baseadas em feedback real.

## Scope
- Correção de persistência de configurações (dados não salvavam no banco)
- Correção de bug de recarregamento do modal de detalhes da transação
- Refatoração: substituir calculadora overlay por campo de input numérico direto
- Ajuste do modelo de conta para suportar débito E crédito simultaneamente (`isDebit`/`isCredit`)
- Melhoria: slider para percentual máximo da reserva (substituindo campo de texto)

## Approach
Correções pontuais de bugs reportados em uso real, seguidas de uma mudança arquitetural importante (contas dual-type) e uma melhoria de UX (slider).

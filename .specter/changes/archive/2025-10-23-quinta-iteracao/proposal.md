# Proposal: Quinta Iteração - Correções de UX e Padronização Visual

## Intent
Corrigir bugs na tela de configurações e padronizar a interface do aplicativo com um app bar consistente em todas as telas principais.

## Scope
- Correção da exibição de valores salvos (salário mensal, saldo da reserva) na tela de Configurações
- Componente `StandardAppBar` reutilizável com botão de configurações, aplicado em Dashboard, Recorrências e Contas

## Approach
Diagnóstico de carregamento de estado (provider/initialValue) para o bug de exibição. Widget de app bar compartilhado seguindo o design system, com navegação padronizada para `SettingsScreen`.

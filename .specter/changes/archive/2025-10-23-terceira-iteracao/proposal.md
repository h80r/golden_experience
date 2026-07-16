# Proposal: Terceira Iteração - Automação e Identidade Visual

## Intent
Modernizar a identidade visual do app com ícone personalizado e implementar captura inteligente de transações via notificações bancárias com arquitetura extensível para múltiplos bancos.

## Scope
- Substituição do ícone padrão do Flutter pelo ícone personalizado em todas as plataformas
- Sistema extensível de captura de transações via notificações bancárias (parser registry pattern)
- Implementação inicial do parser do Santander (regex para valor, data, merchant)
- Notificação local com botão de ação "Adicionar Transação"

## Approach
`flutter_launcher_icons` para geração de ícones. Arquitetura de parsers (`INotificationParser` interface + `NotificationParserRegistry` singleton) permitindo adicionar novos bancos sem modificar código existente. Android-only devido a restrições de plataforma do iOS.

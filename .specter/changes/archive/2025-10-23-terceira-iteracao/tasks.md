# Tasks

## 1. Substituição do Ícone do Aplicativo
**Branch:** `chore/app-icon-update`
- [x] 1.1 Ícone movido para `assets/images/icon.png`
- [x] 1.2 Package `flutter_launcher_icons` configurado no `pubspec.yaml`
- [x] 1.3 Ícones gerados para Android (mipmap densities + adaptive icon)
- [x] 1.4 Ícones gerados para iOS (AppIcon.appiconset)
- [x] 1.5 App instalado exibe novo ícone em todos os contextos
- [x] 1.6 Arquivos gerados commitados no repositório
- [x] 1.7 Merge realizado para `develop`

## 2. Captura Inteligente de Transações via Notificações
**Branch:** `feature/notification-transaction-capture`
- [x] 2.1 Package `flutter_notification_listener` adicionado ao `pubspec.yaml`
- [x] 2.2 Interface `INotificationParser` criada em `lib/domain/parsers/`
- [x] 2.3 `SantanderNotificationParser` implementado em `lib/data/parsers/`
- [x] 2.4 `NotificationParserRegistry` implementado com padrão Singleton
- [x] 2.5 `NotificationService` inicializado no `main.dart`
- [x] 2.6 Parser de Santander com regex funcional para valor, data e merchant
- [x] 2.7 Extração de dados testada com múltiplos formatos de notificação
- [x] 2.8 `TransactionNotificationService` criando notificações locais com action button
- [x] 2.9 Handler de ação "Adicionar Transação" implementado (em TransactionNotificationService)
- [x] 2.10 Campo `sourceBank` adicionado ao modelo `TransactionData`
- [x] 2.11 UI de configurações com toggle e lista de bancos suportados
- [x] 2.12 Botão para abrir configurações de permissão do sistema
- [x] 2.13 Testes unitários isolados para `SantanderNotificationParser`
- [x] 2.14 Testes unitários para o `NotificationParserRegistry`
- [x] 2.15 Testes cobrindo casos extremos (valores, datas, caracteres especiais)
- [x] 2.16 Tratamento de permissões negadas com feedback ao usuário
- [x] 2.17 Merge realizado para `develop`

**Nota de reconciliação (2026-07-16):** a navegação de "Adicionar Transação" a partir do payload da notificação tocada permanece com handler incompleto/stubbed no código atual (`transaction_notification_service.dart`) — ver spec `notification-capture` para o comportamento real verificado.

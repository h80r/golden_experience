# Tasks

## 1. Implementar Sistema de Data de Fechamento e Pagamento Separados
**Branch:** `refactor/closing-vs-payment-dates`
- [x] 1.1 Migration v9→v10 implementada (rename + preserva dados)
- [x] 1.2 Campo `creditPaymentDay` adicionado ao model
- [x] 1.3 Campo `creditClosingDay` calculado automaticamente
- [x] 1.4 Funções de cálculo de fechamento e período ideal criadas
- [x] 1.5 `calculateCurrentBillingCycle()` atualizado para usar lógica correta
- [x] 1.6 UI do formulário atualizada (payment day selector)
- [x] 1.7 Accounts screen exibe fechamento, pagamento e período ideal
- [x] 1.8 Edge cases tratados (dias inválidos, mudança de mês)
- [x] 1.9 Testes unitários para todas as funções de cálculo
- [x] 1.10 Testes de integração para billing cycle com nova lógica
- [x] 1.11 Todos os testes passando (atualizar mocks para usar paymentDay)
- [x] 1.12 Documentação atualizada (CLAUDE.md)
- [x] 1.13 Merge realizado para `develop`

## 2. Melhorias de Layout no Formulário de Conta
**Branch:** `feature/account-form-layout-improvements`
- [x] 2.1 Checkboxes de débito/crédito na mesma linha
- [x] 2.2 Inputs de saldo/limite na mesma linha
- [x] 2.3 Lógica de enable/disable funcionando corretamente
- [x] 2.4 Visual feedback para campos desabilitados
- [x] 2.5 Layout responsivo (vertical em telas pequenas)
- [x] 2.6 Testes de widget atualizados
- [x] 2.7 Aparência consistente com design system
- [x] 2.8 Merge realizado para `develop`

## 3. Remover Página de Calendário Condicional para Contas Não-Crédito
**Branch:** `feature/conditional-calendar-page`
- [x] 3.1 Segunda página (calendário) só aparece se `_isCredit == true`
- [x] 3.2 Botão de navegação adapta-se ao número de páginas
- [x] 3.3 Desmarcar crédito volta para página 1 se necessário
- [x] 3.4 Validação impede salvar crédito sem dia de pagamento
- [x] 3.5 Indicador de página condicional implementado
- [x] 3.6 UX suave com animações apropriadas
- [x] 3.7 Testes de widget para fluxos de 1 e 2 páginas
- [x] 3.8 Merge realizado para `develop`

## 4. Feature Experimental - Monitor de Notificações para Debug
**Branch:** `feature/notification-debug-monitor`
- [ ] 4.1 Campo `notificationDebugMode` adicionado a AppSettings
- [ ] 4.2 Toggle implementado em Settings (seção Developer Options)
- [ ] 4.3 NotificationMonitorService criado e funcional
- [ ] 4.4 Integração com NotificationListenerService existente
- [ ] 4.5 Notificações de debug exibem metadados corretamente
- [ ] 4.6 Limitação de quantidade implementada
- [ ] 4.7 UI com badges e avisos apropriados
- [ ] 4.8 Botão para limpar notificações de debug
- [ ] 4.9 Testes de integração (mock de notificações)
- [ ] 4.10 Documentação de uso para debug
- [ ] 4.11 Merge realizado para `develop`

**Nota de reconciliação (2026-07-16):** o grupo 4 (F15-T4) está marcado `[x]` no header do documento legado mas todo o Definition of Done permanece `[ ]`. Verificado no código atual: nenhum arquivo/símbolo `notificationDebugMode`, `NotificationMonitorService`, ou similar existe em `lib/`. O commit `feature/notification-debug-monitor` (2025-10-30) evidentemente implementou algo diferente/menor do que o especificado aqui (provavelmente apenas melhorias no parsing de notificações, conforme a mensagem do commit "Improve notification parsing"). Preservado como não concluído por fidelidade ao código real — esta feature específica (debug monitor) não existe hoje.

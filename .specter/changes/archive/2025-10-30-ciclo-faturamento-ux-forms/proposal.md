# Proposal: Melhorias em Ciclo de Faturamento e UX de Formulários

## Intent
Refinar o sistema de ciclo de faturamento de crédito para separar conceitos de fechamento vs pagamento, melhorar a experiência do formulário de contas, e adicionar ferramentas de debug para notificações.

## Scope
- Separar "data de fechamento" (calculada) de "data de pagamento" (armazenada) para cartões de crédito, com "período ideal de compra" de 7 dias
- Reorganizar layout do formulário de conta (checkboxes e inputs lado a lado)
- Segunda página do formulário (calendário de pagamento) visível apenas quando crédito está marcado
- Ferramenta experimental de debug para monitorar notificações recebidas

## Approach
Migration v9→v10 renomeia `creditClosingDay` para `creditPaymentDay`; fechamento passa a ser sempre calculado como `paymentDay - 7`. Formulário de conta com `PageView` condicional (1 ou 2 páginas conforme tipo). Debug tool exibe metadados de notificações capturadas via notificação local do sistema.

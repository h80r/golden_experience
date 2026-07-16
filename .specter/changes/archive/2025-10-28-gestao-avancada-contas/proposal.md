# Proposal: Gestão Avançada de Contas e Configurações

## Intent
Aprimorar a gestão de contas, categorias e configurações financeiras com recursos avançados de personalização.

## Scope
- Correção do comportamento do bottom sheet de nova conta com teclado (paridade com o de transações)
- Account tiles colapsáveis com click-to-expand
- Seleção de conta padrão (pré-seleção no bottom sheet de transações)
- Gerenciamento de categorias nas configurações (CRUD, categoria padrão, seed inicial)
- Configuração de data de pagamento de salário (dia específico ou dia útil, com calendário de feriados brasileiros)
- Data de fechamento de fatura por conta de crédito

## Approach
Reuso do padrão de bottom sheet responsivo ao teclado já validado em transações. Novo widget de calendário inline reutilizado tanto para dia de salário quanto para fechamento de crédito. Lógica de feriados brasileiros (nacional + São Paulo) para cálculo de dia útil.

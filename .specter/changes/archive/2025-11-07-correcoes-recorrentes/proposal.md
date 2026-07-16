# Proposal: Correções Críticas de Despesas Recorrentes

## Intent
Corrigir problemas críticos no formulário de despesas recorrentes relacionados a exibição de valores, seleção de data, e criação automática de transações.

## Scope
- Correção do bug de exibição de valores (multiplicação por 100 na listagem, valor zerado ao editar) no `NubankStyleCurrencyField` do formulário de recorrências
- Refatoração do bottom sheet para multi-page com `InlineCalendar` para seleção do dia de cobrança (substituindo campo de texto)
- Auto-criação de transação imediata quando uma despesa recorrente é criada/editada e o dia de cobrança já passou no ciclo atual (billing cycle para crédito, dia do mês para débito)

## Approach
Correção de inicialização do controller de valor (mesmo padrão já usado em `account_form_bottom_sheet.dart`). `PageView` de 2 páginas seguindo o padrão já estabelecido em outros formulários. Nova lógica que reutiliza `calculateCurrentBillingCycleFromPaymentDay` para determinar se a cobrança já ocorreu no ciclo vigente.

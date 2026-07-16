# Transações de Receita e Depósito Automático de Salário

**Captured:** 2026-07-16
**Source:** migrated from PLAN_BRAINSTORM.md (unintegrated draft — 7-task "Fase 18" that never merged into docs/PLAN.md's numbering and conflicts with the real, completed Phase 18 in PLAN_DONE.md)

## Idea
Implementar suporte a transações de receita (positivas) além de despesas, e um sistema de depósito automático do salário na conta configurada. Prepara a base para funcionalidades futuras de pagamento de faturas e gestão de invoices de cartão de crédito (nota: uma tabela de invoices simplificada já existe hoje, ver spec `billing-cycles-and-invoices` — o desenho de invoice completo com `accountId`/`totalAmount`/`paidFromAccountId` descrito aqui é mais amplo que o implementado e precisaria de reconciliação antes de qualquer trabalho).

## Notes
Ideias originais (nunca implementadas — verificado: não existe `isIncome` em nenhuma tabela do schema atual v14):

- **Tipo de transação (receita/despesa):** adicionar `isIncome` (bool), `paymentDate` e `paymentAccountId` (nullable, preparatórios) à tabela `Transactions`; dashboard passaria a calcular despesas líquidas de receitas para contas de débito; UI com cor verde/seta para cima para receitas.
- **Tabela Invoice mais rica:** desenho alternativo de tabela de faturas com `accountId`, `billingCycleStart/End`, `closingDate`, `dueDate`, `totalAmount`, `isPaid`, `paidDate`, `paidFromAccountId` — mais detalhado que a tabela `Invoices` simplificada já implementada (que armazena apenas período unificado + flag `isPaid`, calculando valores dinamicamente). Precisaria decidir se estende o design atual ou o substitui.
- **Configuração de conta de salário:** campo `salaryAccountId` em `AppSettings`, dropdown de contas de débito nas configurações.
- **UI de transação receita/despesa:** `SegmentedButton` no bottom sheet, cores/ícones diferenciados na lista e no dashboard.
- **Depósito automático de salário:** background job (`workmanager` ou similar) rodando diariamente às 6h, verificando se é o dia de pagamento configurado (reaproveitando a lógica de `salaryPaymentMode`/`salaryPaymentValue` já existente), criando transação de receita e evitando duplicatas no mês.
- **Testes e edge cases:** cobertura completa para cálculo de dia de pagamento (incluindo dia 31 em meses curtos, fevereiro bissexto/não-bissexto), prevenção de depósito duplicado, testes de widget e integração.

Antes de promover: reconciliar contra o estado real do sistema de faturas (`billing-cycles-and-invoices`) e decidir se o conceito de "receita" cabe no modelo atual de `transactionType` (debit/credit) ou exige um eixo novo.

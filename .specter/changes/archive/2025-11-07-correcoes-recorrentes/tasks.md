# Tasks

## 1. Correção - Exibição e Edição de Valores em Despesas Recorrentes
**Branch:** `fix/recurring-value-display`
- [x] 1.1 `_valueController` inicializado como vazio (sem texto pré-preenchido)
- [x] 1.2 Helper method `_parseCentsToDouble()` implementado
- [x] 1.3 `_handleSubmit` atualizado para usar o parser
- [x] 1.4 Testar criação: valor salvo corretamente e exibido sem multiplicação
- [x] 1.5 Testar edição: valor carregado corretamente no campo (não mostra 0)
- [x] 1.6 Testar edição: valor atualizado salvo corretamente
- [x] 1.7 Pattern de `account_form_bottom_sheet.dart` seguido
- [x] 1.8 Code generation executado (se necessário)
- [x] 1.9 Merge realizado para `develop`

## 2. Refatorar para Multi-Page Bottom Sheet com InlineCalendar
**Branch:** `feature/recurring-inline-calendar`
- [x] 2.1 `PageController` e `_currentPageIndex` adicionados
- [x] 2.2 `_chargeDayController` removido, `_chargeDay` int adicionado
- [x] 2.3 Form substituído por PageView com 2 páginas
- [x] 2.4 Page 1 construída com campos básicos + navegação
- [x] 2.5 Page 2 construída com InlineCalendar
- [x] 2.6 Navigation methods implementados
- [x] 2.7 Import de `InlineCalendar` adicionado
- [x] 2.8 Validação funciona corretamente entre páginas
- [x] 2.9 PageController disposed adequadamente
- [x] 2.10 Testar criação: navegação entre páginas funciona
- [x] 2.11 Testar edição: dia carregado corretamente no calendar
- [x] 2.12 Testar validação: erros na página 1 navegam corretamente
- [x] 2.13 Pattern de `account_form_bottom_sheet.dart` seguido
- [x] 2.14 Code generation executado (se necessário)
- [x] 2.15 Merge realizado para `develop`

## 3. Auto-Criação de Transações Baseada em Billing Period
**Branch:** `feature/recurring-auto-transaction`
- [x] 3.1 Import de `billing_cycle_utils.dart` adicionado
- [x] 3.2 Método `_createImmediateTransactionIfNeeded()` implementado
- [x] 3.3 Lógica de billing cycle para contas de crédito implementada
- [x] 3.4 Lógica de calendar day para contas de débito implementada
- [x] 3.5 Método chamado após criar despesa recorrente
- [x] 3.6 Método chamado após editar despesa recorrente
- [x] 3.7 Edge cases de dias do mês tratados (28-31)
- [x] 3.8 Transaction type determinado corretamente
- [x] 3.9 Erro não bloqueia salvamento (apenas log)
- [x] 3.10 Testar com conta crédito: charge day no ciclo atual e já passou → cria transação
- [x] 3.11 Testar com conta crédito: charge day no ciclo atual mas não passou → não cria
- [x] 3.12 Testar com conta crédito: charge day fora do ciclo atual → não cria
- [x] 3.13 Testar com conta débito: charge day <= hoje → cria transação
- [x] 3.14 Testar com conta débito: charge day > hoje → não cria
- [x] 3.15 Testar transação criada com descrição "[Recorrente] X"
- [x] 3.16 Testar transação criada com notes "[Processada automaticamente]"
- [x] 3.17 Code generation executado (se necessário)
- [x] 3.18 Merge realizado para `develop`

**Nota de reconciliação (2026-07-16):** item 3.18 permanece `[ ]` no documento legado, mas `docs/STATUS.md` confirma `current_task_id: F18-T3`, `current_task_status: COMPLETED`, e o commit `2025-11-07 📝 docs: Move Phase 18 recurring expenses fixes to completed tasks` moveu esta fase inteira para PLAN_DONE.md — tratado como concluído.

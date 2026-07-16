# Tasks

## 1. Filtrar Transações por Ciclo de Faturamento
**Branch:** `feature/transaction-history-billing-cycle-filter`
- [x] 1.1 Histórico exibe transações do ciclo de faturamento por padrão
- [x] 1.2 Filtro de período (Ciclo/Mês/Todos) implementado
- [x] 1.3 UI mostra claramente qual período está sendo exibido
- [x] 1.4 Lógica alinhada com cálculos do dashboard
- [x] 1.5 Testes de integração para diferentes tipos de conta
- [x] 1.6 Merge realizado para `develop`

## 2. Adicionar Filtro Débito/Crédito no Histórico
**Branch:** `feature/transaction-history-account-type-filter`
- [x] 2.1 Filtro débito/crédito implementado na UI
- [x] 2.2 Repository method criado
- [x] 2.3 Query filtra corretamente por tipo de conta
- [x] 2.4 Contagem de transações atualiza dinamicamente
- [x] 2.5 Testes unitários para query
- [x] 2.6 Testes de widget para filtro
- [x] 2.7 Merge realizado para `develop`

## 3. Card de Soma Total Flutuante com Transição para FAB
**Branch:** `feature/transaction-history-floating-sum-card`
- [x] 3.1 Sum card flutuante implementado
- [x] 3.2 Cálculo de soma total funcional
- [x] 3.3 Animação de transição para FAB suave
- [x] 3.4 Cores dinâmicas (verde/vermelho) conforme saldo
- [x] 3.5 Funcionalidade de adicionar transação mantida
- [ ] 3.6 Testes de widget
- [x] 3.7 Merge realizado para `develop`

## 4. Adicionar Tags Visuais de Débito/Crédito nas Transações
**Branch:** `feature/transaction-debit-credit-tags`
- [x] 4.1 Tags visuais implementadas
- [x] 4.2 Cores adicionadas ao design system
- [x] 4.3 Layout do item de transação atualizado
- [x] 4.4 Tags aparecem em todas as transações
- [x] 4.5 Estilo consistente com design do app
- [ ] 4.6 Testes de widget
- [x] 4.7 Merge realizado para `develop`

## 5. Corrigir Tipo de Transação ao Editar
**Branch:** `fix/transaction-edit-type-mismatch`
- [x] 5.1 Modal de edição carrega o tipo correto da transação (débito/crédito)
- [x] 5.2 Tipo de transação é preservado durante a edição
- [x] 5.3 Testes de widget para verificar o comportamento
- [x] 5.4 Merge realizado para `develop`

## 6. Melhorar UI dos Filtros do Histórico
**Branch:** `feature/transaction-filters-ui-improvements`
- [x] 6.1 Filtro de período convertido para dropdown
- [x] 6.2 Filtro de tipo de transação usando seletor visual (similar ao expense sheet)
- [x] 6.3 UI consistente com padrões do app
- [ ] 6.4 Testes de widget atualizados
- [x] 6.5 Merge realizado para `develop`

## 7. Corrigir Persistência de Configuração de Dia de Pagamento
**Branch:** `fix/salary-payday-workday-persistence`
- [x] 7.1 Causa raiz identificada
- [x] 7.2 Bug corrigido na camada apropriada
- [x] 7.3 Todos os valores de dia útil persistem corretamente
- [x] 7.4 Testes de integração adicionados para prevenir regressão
- [x] 7.5 Merge realizado para `develop`

**Nota de reconciliação (2026-07-16):** itens 3.6, 4.6 e 6.4 (testes de widget) permanecem não marcados no documento legado apesar da fase estar rotulada "7/7 FASE COMPLETA" — preservados como estão, não verificados individualmente contra a suíte de testes atual.

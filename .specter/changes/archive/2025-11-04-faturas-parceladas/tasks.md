# Tasks

## 1. Gerenciador de Faturas com Navegação Temporal
**Branch:** `feature/invoice-manager`
- [x] 1.1 Tabela `InvoiceItems` removida do database (migration criada)
- [x] 1.2 Tabela `Invoices` atualizada com schema simplificado (startDate, endDate, isPaid)
- [x] 1.3 Migration executada com sucesso
- [x] 1.4 Repository interface e implementation completos com novos métodos
- [x] 1.5 Provider `invoiceRepository` registrado
- [x] 1.6 Utility de cálculo de período unificado implementado
- [x] 1.7 Lógica de cálculo de período unificado entre cartões funcionando
- [x] 1.8 Provider `invoiceCalculatedData` implementado
- [x] 1.9 Queries dinâmicas calculam total e breakdown corretamente
- [x] 1.10 UI do dashboard atualizada com header de navegação (mês/ano)
- [x] 1.11 Navegação com setas (esquerda/direita) funcionando
- [x] 1.12 Swipe horizontal funcionando para navegar períodos
- [x] 1.13 Dashboard abre no primeiro período não pago por padrão
- [x] 1.14 Auto-criação de faturas ao navegar para períodos com transações
- [x] 1.15 Apenas períodos com transações são exibíveis
- [x] 1.16 Tela de histórico lista apenas faturas com transações
- [x] 1.17 Ao clicar em fatura no histórico, dashboard navega para aquele período
- [x] 1.18 Breakdown por conta calculado dinamicamente e exibido
- [x] 1.19 Funcionalidade de marcar/desmarcar "pago" funcionando
- [x] 1.20 Considera apenas transações de contas de crédito
- [x] 1.21 Testes unitários do repository
- [x] 1.22 Testes de integração da lógica de períodos unificados
- [x] 1.23 Testes de widget das UIs atualizadas
- [x] 1.24 Code generation executado
- [x] 1.25 Merge realizado para `develop`

## 2. Dashboard Baseado em Faturas com Navegação Temporal
**Branch:** `feature/dashboard-invoice-integration`
- [x] 2.1 Seção `InvoiceManagerCard` removida do dashboard
- [x] 2.2 Dashboard recalculado baseado em valores de fatura (apenas crédito)
- [x] 2.3 Transações de débito completamente excluídas do cálculo de orçamento
- [x] 2.4 Header do dashboard mostra "MÊS ANO" em vez de "Início"
- [x] 2.5 PageView implementado com swipe horizontal funcionando
- [x] 2.6 Navegação entre períodos (anterior/futuro) funciona corretamente
- [x] 2.7 Dashboard abre na primeira fatura não paga por padrão
- [x] 2.8 Botão de pagamento funciona como toggle (Pagar ↔ Desmarcar Pagamento)
- [x] 2.9 Label do botão muda dinamicamente baseado no status da fatura
- [x] 2.10 Dialog de confirmação adapta mensagem ao status atual
- [x] 2.11 Botão "Ver Detalhes" implementado e navegação funciona
- [x] 2.12 `InvoiceDetailsScreen` criada com todo conteúdo da antiga seção de faturas
- [x] 2.13 Histórico de faturas integrado na página de detalhes
- [x] 2.14 Navegação de detalhes → dashboard funciona corretamente
- [x] 2.15 Breakdown por conta calculado dinamicamente e exibido
- [x] 2.16 Período sem transações tratado adequadamente
- [x] 2.17 Performance otimizada com AutoDispose
- [x] 2.18 Testes unitários dos providers de dados
- [x] 2.19 Testes de widget do PageView e navegação
- [x] 2.20 Testes de integração do fluxo completo
- [x] 2.21 Code generation executado
- [x] 2.22 Merge realizado para `develop`

## 3. Transações Parceladas com Criação Automática
**Branch:** `feature/installment-transactions`
- [x] 3.1 Campos de parcelamento adicionados à tabela `Transactions`
- [x] 3.2 UI do formulário atualizada com campos de parcela
- [x] 3.3 Validação de conta de crédito funcionando
- [x] 3.4 Lógica de criação automática implementada
- [x] 3.5 Cálculo correto do primeiro dia do próximo ciclo
- [x] 3.6 Formato do título com parcela funcionando (X/Y)
- [x] 3.7 Ícone/indicador visual de parcelas na lista
- [x] 3.8 Opções de edição/exclusão tratadas
- [x] 3.9 Testes unitários da lógica de criação
- [x] 3.10 Testes de integração do fluxo completo
- [x] 3.11 Testes de edge cases (débito, validações)
- [x] 3.12 Code generation executado
- [x] 3.13 Merge realizado para `develop`

**Nota de reconciliação (2026-07-16):** commits subsequentes (`bugfix/installment-duplication`, `bugfix/installment-early-payment-day`, ambos 2025-11-04) corrigiram bugs de duplicação e cálculo de ciclo de faturamento em cenários de pagamento antecipado — não fazem parte desta fase, ver histórico git para detalhes.

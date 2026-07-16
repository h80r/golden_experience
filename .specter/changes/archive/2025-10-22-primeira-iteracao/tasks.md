# Tasks

## 1. Correção - Persistência de Configurações
**Branch:** `fix/settings-persistence`
- [x] 1.1 Causa raiz do problema identificada
- [x] 1.2 Salvamento de configurações funcionando corretamente
- [x] 1.3 Dados persistem após fechar e reabrir o app
- [x] 1.4 Mudanças refletem instantaneamente no Dashboard
- [x] 1.5 Feedback visual de sucesso implementado
- [x] 1.6 Testes de integração para persistência adicionados
- [x] 1.7 Merge realizado para `develop`

## 2. Correção - Bug no Modal de Detalhes da Transação
**Branch:** `fix/transaction-modal-reload`
- [x] 2.1 Bug identificado e causa raiz documentada
- [x] 2.2 Bottom sheet não recarrega ao interagir com campos
- [x] 2.3 Foco nos campos de texto mantido corretamente
- [x] 2.4 Fluxo completo de criação de transação funcional
- [x] 2.5 Teclado aparece e desaparece normalmente
- [x] 2.6 Teste de integração E2E passando
- [x] 2.7 Merge realizado para `develop`

## 3. Refatoração - Substituir Calculadora por Input Field
**Branch:** `refactor/simple-value-input`
- [x] 3.1 CalculatorOverlay removido do código
- [x] 3.2 Campo de valor numérico implementado no bottom sheet
- [x] 3.3 Formatação de moeda funcionando corretamente
- [x] 3.4 Validação de valor obrigatório implementada
- [x] 3.5 FAB abre diretamente o bottom sheet
- [x] 3.6 Fluxo de criação de transação mais rápido e intuitivo
- [x] 3.7 Testes de widget atualizados
- [x] 3.8 Merge realizado para `develop`

## 4. Ajuste - Tipo de Conta (Débito E Crédito)
**Branch:** `feature/account-dual-type`
- [x] 4.1 Modelo Account atualizado com campos booleanos (isDebit, isCredit, balance, creditUsed)
- [x] 4.2 Schema do Drift regenerado (v2)
- [x] 4.3 Formulário de conta com seleção múltipla implementado (CheckboxListTile)
- [x] 4.4 Lógica de transações atualizada (suporta debit + credit simultaneamente)
- [x] 4.5 UI de listagem mostrando tipos corretamente (badges duplos, detalhes específicos)
- [x] 4.6 Migração de dados existentes implementada (v1→v2 com SQL transformation)
- [x] 4.7 Testes atualizados
- [x] 4.8 Merge realizado para `develop`

## 5. Melhoria - Slider para Percentual Máximo da Reserva
**Branch:** `feature/reserve-percentage-slider`
- [x] 5.1 TextField do percentual removido
- [x] 5.2 Slider widget implementado
- [x] 5.3 Design system aplicado (cores, tipografia)
- [x] 5.4 Valor exibido claramente acima do slider
- [x] 5.5 Texto auxiliar explicativo adicionado
- [x] 5.6 Salvamento do valor funcionando
- [x] 5.7 Testes de widget para o slider
- [x] 5.8 Merge realizado para `develop`

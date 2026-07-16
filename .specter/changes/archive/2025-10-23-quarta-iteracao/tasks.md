# Tasks

## 1. Correção - Sistema de Input Numérico tipo Nubank
**Branch:** `fix/nubank-style-input`
- [x] 1.1 Widget `NubankStyleCurrencyField` criado em `lib/presentation/widgets/inputs/`
- [x] 1.2 TextInputFormatter customizado implementado
- [x] 1.3 Bugs de formatação corrigidos (reserva, limite, conta)
- [x] 1.4 Comportamento de construção da direita pra esquerda funcional
- [x] 1.5 Aplicado em todas as 4 telas mencionadas
- [x] 1.6 Testes de widget para o novo campo
- [x] 1.7 Testes de formatação e conversão de valores
- [x] 1.8 Merge realizado para `develop`

## 2. Melhoria - Bottom Sheet com Sistema de Abas
**Branch:** `feature/transaction-details-tabs`
- [x] 2.1 PageView implementado no `ExpenseDetailsBottomSheet`
- [x] 2.2 Página 1 com campos: Valor, Descrição, Conta, Débito/Crédito
- [x] 2.3 Página 2 com campos: Notas, Categoria, Data
- [x] 2.4 Navegação Próximo/Anterior implementada
- [x] 2.5 Validação de campos obrigatórios da Página 1 antes de "Próximo"
- [x] 2.6 Botão "Salvar" visível apenas na Página 2
- [x] 2.7 Estado compartilhado via `ExpenseFormNotifier` entre páginas
- [x] 2.8 Merge realizado para `develop`

## 3. Melhoria - Swipe-to-Delete com Undo no Toast
**Branch:** `enhancement/slidable-delete`
- [x] 3.1 Swipe-to-edit removido completamente
- [x] 3.2 Mantida implementação com `Dismissible` (não flutter_slidable)
- [x] 3.3 Toast com botão "Desfazer" implementado
- [x] 3.4 Toast não fecha por timeout (duration indefinido)
- [x] 3.5 `GestureDetector` implementado para detectar toque em qualquer lugar da tela
- [x] 3.6 Exclusão não executada imediatamente ao swipe
- [x] 3.7 Clicar "Desfazer" restaura o card na lista e fecha o toast
- [x] 3.8 Clicar em qualquer lugar da tela fecha o toast e executa a exclusão
- [x] 3.9 Toque no card abre `ExpenseDetailsBottomSheet` para edição
- [x] 3.10 Lógica de reversão de saldo/limite mantida
- [x] 3.11 Testes de widget atualizados
- [x] 3.12 Merge realizado para `develop`

## 4. Feature - Alternar Dashboard/Histórico na Aba Início
**Branch:** `feature/toggle-dashboard-history`
- [x] 4.1 Provider `DashboardViewState` criado
- [x] 4.2 Lógica de toggle implementada no `MainScreen`
- [x] 4.3 Tocar na aba "Início" alterna entre Dashboard e Histórico
- [x] 4.4 Botão voltar do Android retorna para Dashboard antes de sair
- [x] 4.5 `WillPopScope` configurado corretamente
- [x] 4.6 Transição suave entre as telas
- [x] 4.7 Testes de widget para a navegação
- [x] 4.8 Merge realizado para `develop`

## 5. Correção - Golden Experience em Permissões de Notificação
**Branch:** `fix/notification-permission-visibility`
- [x] 5.1 Causa raiz identificada e documentada
- [x] 5.2 `AndroidManifest.xml` corrigido com declarações necessárias
- [x] 5.3 Permissões adicionadas corretamente
- [x] 5.4 App aparece em Configurações > Acesso às notificações
- [x] 5.5 Usuário consegue conceder permissão manualmente
- [x] 5.6 Service inicia e funciona após permissão concedida
- [x] 5.7 Testes manuais em dispositivo físico/emulador
- [x] 5.8 Merge realizado para `develop`

## 6. Melhoria - File Picker para Exportação de Backup
**Branch:** `feature/backup-file-picker`
- [x] 6.1 Package `file_picker` adicionado ao `pubspec.yaml`
- [x] 6.2 Método de exportação modificado para usar file picker
- [x] 6.3 Dialog de seleção de pasta funcional
- [x] 6.4 Arquivo salvo no local escolhido pelo usuário
- [x] 6.5 Feedback visual com caminho completo do arquivo
- [x] 6.6 Tratamento de erro caso salvamento falhe
- [x] 6.7 Testes manuais em dispositivo Android
- [x] 6.8 Merge realizado para `develop`

**Nota de reconciliação (2026-07-16):** o item 6 (F8-T6) estava marcado `[ ]` no título do documento legado (typo), mas todos os subitens já estavam `[x]`; confirmado implementado via `file_picker: ^8.1.0` em `pubspec.yaml` e `backup_repository_impl.dart`.

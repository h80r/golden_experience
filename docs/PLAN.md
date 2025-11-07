# 📋 Plano de Implementação - Previsor Financeiro v1.0

> **Projeto:** Previsor Financeiro (MVP)
> **Framework:** Flutter 3.x com Dart 3.x
> **Última Atualização:** 23 de outubro de 2025

---

## 🎯 Visão Geral do Projeto

### Objetivo
Desenvolver um aplicativo mobile de controle financeiro pessoal que elimina o atrito do uso de planilhas, oferecendo uma resposta instantânea à pergunta: **"Quanto ainda posso gastar este mês?"**

### Pilares Técnicos
1. **Reatividade Instantânea:** UI reflete mudanças em tempo real sem refresh manual
2. **Performance Nativa:** Experiência fluida a 60 FPS
3. **Arquitetura Escalável:** Clean Architecture preparada para crescimento futuro

### Stack Tecnológica
| Componente | Tecnologia | Versão |
|------------|------------|--------|
| Framework | Flutter | 3.35.6 |
| Linguagem | Dart | 3.9.2 |
| Banco de Dados | Isar Database | 3.1.0+1 |
| Gestão de Estado | Riverpod | 3.0.3 |
| Testes | flutter_test, integration_test | Latest |
| CI/CD | GitHub Actions | - |

---

## 🌿 Estratégia de Branching

### Git Flow Adaptado (Solo Development)

```
main (develop)
  ├── feature/nome-da-feature
  ├── chore/nome-da-tarefa
  ├── refactor/nome-do-refactor
  └── fix/nome-do-bugfix
```

### Convenções de Nomenclatura

| Tipo | Prefixo | Uso | Exemplo |
|------|---------|-----|---------|
| Nova funcionalidade | `feature/` | Implementação de novas features | `feature/calculator-ui` |
| Configuração/Setup | `chore/` | Tarefas de setup, dependências, configs | `chore/project-setup` |
| Refatoração | `refactor/` | Melhorias de código sem mudar funcionalidade | `refactor/clean-architecture` |
| Correção de bugs | `fix/` | Correção de erros e bugs | `fix/recurring-logic` |

### Fluxo de Trabalho
1. Criar branch a partir de `develop`
2. Implementar a tarefa
3. Testar conforme Definition of Done
4. Fazer merge para `develop`
5. Marcar checkbox como `[x]` neste documento

---

## 📊 Progresso Geral

**Total de Tarefas:** 91
**Concluídas:** 53 / 91 (58%)

### Por Fase
- **Fase 1 - Fundação:** 4 / 4 (100%)
- **Fase 2 - Registro de Gastos:** 4 / 4 (100%)
- **Fase 3 - Dashboard Reativo:** 4 / 4 (100%)
- **Fase 4 - Funcionalidades de Suporte:** 4 / 5 (80%)
- **Fase 5 - Primeira Iteração:** 5 / 5 (100%)
- **Fase 6 - Segunda Iteração:** 3 / 3 (100%)
- **Fase 7 - Terceira Iteração:** 2 / 2 (100%)
- **Fase 8 - Quarta Iteração:** 5 / 6 (83%)
- **Fase 9 - Quinta Iteração:** 2 / 2 (100%)
- **Fase 10 - Correções Críticas de UI/UX:** 6 / 6 (100%)
- **Fase 11 - Padronização e Melhorias de UX:** 4 / 4 (100%)
- **Fase 12 - Estabilidade e Code Health:** 3 / 3 (100%)
- **Fase 13 - Gestão Avançada de Contas:** 6 / 6 (100%)
- **Fase 14 - Refatoração do Sistema de Reserva:** 3 / 3 (100%)
- **Fase 15 - Melhorias em Ciclo de Faturamento e UX:** 4 / 4 (100%)
- **Fase 16 - Melhorias no Histórico de Transações:** 7 / 7 (100%)
- **Fase 17 - Gerenciador de Faturas e Transações Parceladas:** 3 / 3 (100%)
- **Fase 18 - Correções Críticas de Despesas Recorrentes:** 0 / 3 (0%)
- **Fase 19 - Correções Críticas de UX/UI:** 0 / 5 (0%)
- **Fase 20 - Correções no Sistema de Backup/Restore:** 0 / 4 (0%)

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

---

## 🔧 Fase 19: Correções Críticas de UX/UI (Anteriormente Fase 18)

**Objetivo:** Corrigir problemas críticos de experiência do usuário identificados durante uso real da aplicação.

**Status:** 0 / 5 tarefas concluídas

---

### [ ] F19-T1: Correção - Descrição de Transação Retorna à Tela Anterior

**Branch:** `fix/transaction-description-save`

**Descrição:**
Na criação de transações, ao salvar no campo de descrição (pressionar "salvar" no teclado), a aplicação volta para a primeira tela sem salvar a transação. Corrigir o comportamento para que salvar na descrição não cause navegação automática.

**Definition of Done:**
- [ ] Identificar o listener/callback que está causando a navegação prematura
- [ ] Remover ou ajustar o comportamento de navegação no TextField de descrição
- [ ] Garantir que apenas o botão "Salvar" da transação cause a navegação
- [ ] Testar fluxo completo de criação de transação com descrição
- [ ] Verificar comportamento em modo edição também
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F19-T2: Correção - Botão Salvar na Primeira Tela de Edição de Contas

**Branch:** `fix/account-edit-save-button`

**Descrição:**
Na edição de contas, quando há crédito habilitado, a primeira tela deve ter um botão "Salvar" em vez de "Avançar". O fluxo atual força o usuário a passar para a segunda tela mesmo quando só quer editar informações da primeira tela.

**Definition of Done:**
- [ ] Detectar se conta tem crédito habilitado (`isCredit == true`)
- [ ] Se apenas débito: manter botão "Salvar" (comportamento atual)
- [ ] Se crédito habilitado: trocar "Avançar" por "Salvar" na primeira tela
- [ ] Botão "Salvar" deve persistir mudanças e fechar o bottom sheet
- [ ] Manter opção de ir para segunda tela (adicionar botão secundário "Configurar Crédito" ou similar)
- [ ] Testar fluxo de edição com conta débito-only
- [ ] Testar fluxo de edição com conta crédito
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F19-T3: Correção - Auto-refresh do Dashboard em Mudanças de Configurações

**Branch:** `fix/dashboard-auto-refresh`

**Descrição:**
O dashboard não atualiza automaticamente quando há mudanças nas configurações ou nos saldos das contas. Usuário precisa navegar para a lista de transações e voltar para ver os valores atualizados. Implementar invalidação automática dos providers do dashboard.

**Definition of Done:**
- [ ] Identificar todos os providers que afetam o dashboard (accounts, settings, transactions)
- [ ] Implementar `ref.invalidate()` ou `ref.refresh()` nos providers dependentes
- [ ] Garantir que mudanças em `AppSettings` invalidam dashboard
- [ ] Garantir que mudanças em `Accounts` (saldo, limite) invalidam dashboard
- [ ] Garantir que mudanças em `Transactions` invalidam dashboard automaticamente (já deve funcionar via streams)
- [ ] Testar cenário: mudar `paymentDay` → dashboard atualiza
- [ ] Testar cenário: editar saldo de conta → dashboard atualiza
- [ ] Testar cenário: criar/editar transação → dashboard atualiza
- [ ] Verificar performance (evitar rebuilds desnecessários)
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F19-T4: Correção - Error Toasts Aparecendo Atrás do Bottom Sheet

**Branch:** `fix/toast-z-index`

**Descrição:**
Error toasts aparecem atrás dos bottom sheets, impossibilitando identificar o problema. Implementar solução para garantir que toasts sempre apareçam acima de todos os outros widgets, incluindo bottom sheets.

**Definition of Done:**
- [ ] Investigar implementação atual do sistema de toasts (fluttertoast, custom overlay, etc.)
- [ ] Implementar solução com maior z-index/elevation
- [ ] Opções possíveis:
  - Usar `Overlay` com prioridade alta
  - Usar `OverlayEntry` para toasts
  - Ajustar `showDialog` ou `showModalBottomSheet` com WillPopScope
- [ ] Garantir que toasts aparecem acima de bottom sheets
- [ ] Garantir que toasts aparecem acima de dialogs
- [ ] Testar com expense bottom sheet aberto
- [ ] Testar com account bottom sheet aberto
- [ ] Testar com todos os tipos de toast (error, success, info)
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F19-T5: Correção - Habilitar/Desabilitar Débito/Crédito Baseado no Tipo de Conta

**Branch:** `fix/expense-payment-type-toggle`

**Descrição:**
No bottom sheet de criação de despesas, os campos de débito/crédito devem ser habilitados/desabilitados automaticamente de acordo com o tipo da conta selecionada. Se a conta for apenas débito, desabilitar opção de crédito. Se for apenas crédito, desabilitar opção de débito.

**Definition of Done:**
- [ ] Monitorar mudanças no campo de seleção de conta
- [ ] Ao selecionar conta, verificar `account.isDebit` e `account.isCredit`
- [ ] Se `isDebit == true && isCredit == false`: desabilitar toggle de crédito, forçar débito
- [ ] Se `isCredit == true && isDebit == false`: desabilitar toggle de débito, forçar crédito
- [ ] Se `isDebit == true && isCredit == true`: habilitar ambos os toggles
- [ ] Atualizar UI para mostrar estado desabilitado visualmente (cinza, opacity reduzida)
- [ ] Garantir que valor default é correto ao trocar de conta
- [ ] Testar com conta débito-only
- [ ] Testar com conta crédito-only
- [ ] Testar com conta dual-type
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

## 📦 Fase 20: Correções no Sistema de Backup/Restore

**Objetivo:** Corrigir problemas críticos no sistema de backup e restore de dados, garantindo persistência completa de todas as informações.

**Status:** 0 / 4 tarefas concluídas

---

### [ ] F20-T1: Adicionar Botão "Importar Backup" no Tour Inicial

**Branch:** `feature/import-backup-onboarding`

**Descrição:**
Adicionar botão de "Importar Backup" no tour de início do aplicativo, permitindo que usuários restaurem seus dados antes de completar o onboarding.

**Definition of Done:**
- [ ] Adicionar botão "Importar Backup" na tela inicial do tour
- [ ] Posicionar adequadamente (acima ou abaixo do botão "Começar")
- [ ] Implementar fluxo de importação:
  - Abrir file picker
  - Validar arquivo JSON
  - Restaurar dados
  - Navegar para tela apropriada (dashboard ou completar tour)
- [ ] Adicionar loading state durante importação
- [ ] Adicionar tratamento de erros (arquivo inválido, formato incorreto)
- [ ] Testar cenário: importar backup válido antes do tour
- [ ] Testar cenário: importar backup inválido (mostrar erro)
- [ ] Testar cenário: cancelar file picker
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F20-T2: Correção - Persistir Data de Pagamento no Backup

**Branch:** `fix/backup-payment-day`

**Descrição:**
O sistema de backup não está salvando a data de pagamento dos cartões de crédito (`creditPaymentDay`). Adicionar este campo ao JSON de backup e restore.

**Definition of Done:**
- [ ] Identificar estrutura atual do JSON de backup para `Accounts`
- [ ] Adicionar campo `creditPaymentDay` ao JSON de export
- [ ] Adicionar leitura do campo `creditPaymentDay` no JSON de import
- [ ] Garantir compatibilidade com backups antigos (campo nullable)
- [ ] Testar export: verificar que `creditPaymentDay` está no JSON
- [ ] Testar import: verificar que valor é restaurado corretamente
- [ ] Testar import de backup antigo sem o campo (deve funcionar)
- [ ] Adicionar migration/validação se necessário
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F20-T3: Correção - Persistir Data de Fechamento no Backup

**Branch:** `fix/backup-closing-day`

**Descrição:**
O sistema de backup não está salvando a data de fechamento dos cartões de crédito (campo calculado baseado em `creditPaymentDay`). Garantir que o ciclo de faturamento completo é restaurado corretamente.

**Observação:** Este problema pode estar relacionado ao F20-T2, já que a data de fechamento é calculada como `creditPaymentDay - 7`. Se `creditPaymentDay` for restaurado corretamente, o fechamento será calculado automaticamente.

**Definition of Done:**
- [ ] Verificar se correção do F20-T2 resolve o problema
- [ ] Se necessário, adicionar campo explícito de `creditClosingDay` ao backup
- [ ] Testar export: verificar que ciclo de faturamento está completo
- [ ] Testar import: verificar que `creditPaymentDay` e fechamento são restaurados
- [ ] Testar cálculo automático de fechamento após restore
- [ ] Validar que faturas são geradas com períodos corretos após restore
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

### [ ] F20-T4: Correção - Persistir Tipo de Pagamento (Débito/Crédito) no Backup

**Branch:** `fix/backup-payment-type`

**Descrição:**
O sistema de backup não está salvando o tipo de pagamento das transações (se foi débito ou crédito, campo `isCredit`). Adicionar este campo ao JSON de backup e restore.

**Definition of Done:**
- [ ] Identificar estrutura atual do JSON de backup para `Transactions`
- [ ] Adicionar campo `isCredit` ao JSON de export
- [ ] Adicionar leitura do campo `isCredit` no JSON de import
- [ ] Garantir compatibilidade com backups antigos (campo nullable, default baseado em tipo de conta)
- [ ] Testar export: verificar que `isCredit` está no JSON
- [ ] Testar import: verificar que valor é restaurado corretamente
- [ ] Testar import de backup antigo sem o campo (inferir baseado em tipo de conta)
- [ ] Validar que dashboard calcula valores corretamente após restore
- [ ] Validar que faturas agrupam transações corretamente após restore
- [ ] Code generation executado (se necessário)
- [ ] Merge realizado para `develop`

---

## 🎊 Conclusão

Este plano mapeia todas as **91 tarefas** necessárias para completar o MVP do Previsor Financeiro. Ao seguir este roadmap, você terá um aplicativo funcional, testado e preparado para uso pessoal, com uma arquitetura sólida que permitirá expansões futuras.

A **Fase 5** representa a primeira iteração de melhorias baseada em uso real, demonstrando a importância de testar o aplicativo e iterar sobre o design inicial.

A **Fase 6** adiciona refinamentos críticos de UX: onboarding para novos usuários, gestão completa de transações, e padronização de inputs numéricos para o mercado brasileiro.

A **Fase 7** introduz automação inteligente e identidade visual: ícone personalizado do app e captura automática de transações a partir de notificações bancárias, com arquitetura extensível para suportar múltiplos bancos.

A **Fase 8** foca em correções críticas e refinamentos de UX: sistema de input numérico tipo Nubank, bottom sheet com abas para melhor experiência com teclado, swipe-to-delete aprimorado, toggle entre dashboard e histórico, correção de permissões de notificação, e file picker para backups.

A **Fase 9** traz correções de UX e padronização visual: correção do bug de exibição de valores nas configurações e padronização do app bar em todas as telas principais para garantir consistência visual e facilitar o acesso às configurações.

A **Fase 10** garante a estabilidade e saúde do código: atualização de dependências, migração de APIs deprecated, implementação de logging adequado, e remoção de código morto.

A **Fase 18** corrige problemas críticos no formulário de despesas recorrentes: exibição de valores (bug do multiplicador *100), refatoração para usar InlineCalendar em uma segunda página do bottom sheet, e implementação de auto-criação de transações baseada em billing periods para contas de crédito e calendar days para contas de débito.

A **Fase 19** aborda correções críticas de UX/UI identificadas durante uso real: comportamento de salvamento de descrição, botões de navegação em edição de contas, auto-refresh do dashboard, z-index de toasts, e controle de tipo de pagamento baseado em tipo de conta.

A **Fase 20** corrige problemas no sistema de backup/restore: adicionar opção de importação no onboarding, e garantir persistência completa de dados críticos (data de pagamento, data de fechamento, e tipo de pagamento).

**Bom desenvolvimento! 🚀**

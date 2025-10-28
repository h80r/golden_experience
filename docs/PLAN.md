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

**Total de Tarefas:** 56
**Concluídas:** 37 / 56 (66%)

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
- **Fase 13 - Gestão Avançada de Contas:** 0 / 6 (0%)

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

---

## 🐛 Fase 10: Correções Críticas de UI/UX

**Objetivo:** Corrigir bugs críticos de interface e comportamento que afetam a experiência do usuário no uso diário do aplicativo.

**Status:** 2 / 6 tarefas concluídas

---

### [x] F10-T1: Correção - Reserve Slider Snap to Saved Percentage

**Branch:** `fix/reserve-slider-snap`

**Descrição:**
O slider de porcentagem da reserva na página de configurações inicia no 0 quando a página carrega e "encaixa" (snap) no valor correto logo depois, o que é uma experiência de UI ruim. Além disso, é uma experiência ruim ter que apertar o botão de salvar para que o valor seja aplicado.

**Definition of Done:**
- [x] Slider não pula ao carregar a página de configurações, já inicia no valor salvo
- [x] Alterações no slider são aplicadas imediatamente sem necessidade de botão salvar
- [x] Validar que todas as alterações da página de configuração são salvas automaticamente
- [x] Merge realizado para `develop`

---

### [x] F10-T2: Correção - Automatic Capture Switch Persistence

**Branch:** `fix/automatic-capture-switch`

**Descrição:**
O switch de captura automática de transações na página de configurações não persiste a seleção do usuário.

**Problema Atual:**
- Usuário ativa/desativa o switch de captura automática
- Ao sair e retornar à página de configurações, o switch volta ao estado anterior
- A configuração não está sendo salva no banco de dados ou não está sendo carregada corretamente

**Investigação Necessária:**
- Verificar se o método `updateSettings()` está sendo chamado ao trocar o switch
- Confirmar que o valor está sendo persistido na tabela `AppSettings`
- Verificar se o provider está recarregando o valor correto ao retornar à tela

**Definition of Done:**
- [x] Switch persiste o estado corretamente entre navegações
- [x] Valor é salvo no banco de dados imediatamente ao alterar
- [x] Provider recarrega o valor correto ao retornar à tela
- [x] Testes de integração para verificar persistência
- [x] Merge realizado para `develop`

---

### [x] F10-T3: Correção - Credit Limit Visualization Bug

**Branch:** `fix/credit-limit-display`

**Descrição:**
A visualização do limite de crédito está completamente quebrada quando valores decimais são inseridos (ex: tentativa de inserir 9,17 e 14000,00).

**Problema Atual:**
- Inserção de valores com vírgula decimal não funciona corretamente
- Display do limite de crédito mostra valores incorretos ou formatação quebrada
- Possível problema de parsing entre string formatada e valor numérico

**Investigação Necessária:**
- Verificar o widget de input usado para limite de crédito
- Confirmar se está usando `NubankStyleCurrencyField` corretamente
- Verificar conversão entre display formatado e valor armazenado no banco
- Checar se há validação adequada para valores decimais

**Definition of Done:**
- [x] Valores decimais são aceitos e exibidos corretamente
- [x] Formatação de moeda consistente (R$ 14.000,00)
- [x] Conversão correta entre UI e banco de dados
- [x] Validação de entrada implementada
- [x] Testes para diferentes formatos de entrada
- [x] Merge realizado para `develop`

---

### [x] F10-T4: Correção - Duplicate R$ in Transfer Creation/Editing

**Branch:** `fix/duplicate-currency-symbol`

**Descrição:**
Remove o símbolo R$ duplicado que aparece na tela de criação/edição de transferências.

**Problema Atual:**
- Símbolo R$ aparece duplicado no campo de valor
- Pode estar sendo exibido tanto pelo label quanto pelo input field
- Prejudica a legibilidade e experiência do usuário

**Implementação Esperada:**
- Remover uma das ocorrências do símbolo R$
- Manter apenas o símbolo do ícone
- Garantir consistência com outros campos de moeda no app

**Definition of Done:**
- [x] Símbolo R$ aparece apenas uma vez no campo de valor
- [x] Consistência visual com outros campos de moeda
- [x] Testes de widget atualizados
- [x] Merge realizado para `develop`

---

### [x] F10-T5: Correção - Value Field Disappearing on Save Button Click

**Branch:** `fix/value-field-disappearing`

**Descrição:**
No momento em que o usuário clica no botão de salvar na aba de notas, o valor inserido desaparece do campo.

**Problema Atual:**
- Ao clicar em "Salvar" na aba de notas, o valor some
- Pode estar relacionado a rebuild do widget ou perda de estado
- Comportamento inconsistente entre as abas

**Investigação Necessária:**
- Verificar se há rebuild não intencional do widget
- Confirmar se o estado do valor está sendo mantido entre as abas
- Verificar se o `TextEditingController` está sendo descartado prematuramente
- Checar se há algum `setState` que limpa o campo

**Definition of Done:**
- [x] Valor permanece visível ao clicar em salvar
- [x] Estado do campo é mantido entre mudanças de aba
- [x] Não há rebuilds desnecessários que limpam o campo
- [x] Testes de widget para verificar persistência do valor
- [x] Merge realizado para `develop`

---

### [x] F10-T6: Correção - Transaction Save Validation for Missing Value

**Branch:** `fix/transaction-value-validation`

**Descrição:**
O botão de salvar na criação/edição de transações não valida a ausência de valor antes de tentar salvar.

**Problema Atual:**
- Usuário pode clicar em "Salvar" sem preencher o valor da transação
- Não há feedback visual de erro
- Pode causar crash ou salvar transação com valor zero/nulo

**Implementação Esperada:**
- Adicionar validação obrigatória para o campo de valor
- Exibir mensagem de erro quando tentar salvar sem valor
- Desabilitar botão de salvar ou destacar campo em vermelho quando inválido
- Validação deve ocorrer tanto na aba de detalhes quanto na aba de notas

**Definition of Done:**
- [x] Validação de valor obrigatório implementada
- [x] Mensagem de erro clara para o usuário
- [x] Feedback visual adequado (campo em destaque/botão desabilitado)
- [x] Validação funciona em ambas as abas (detalhes e notas)
- [x] Testes de validação implementados
- [x] Merge realizado para `develop`

---

## 🎨 Fase 11: Padronização e Melhorias de UX

**Objetivo:** Padronizar a formatação de valores monetários e melhorar a experiência do usuário em inputs e seleções.

**Status:** 4 / 5 tarefas concluídas

---

### [x] F11-T1: Padronização - Monetary Value Formatting Across App

**Branch:** `feature/consistent-monetary-formatting`

**Descrição:**
Padronizar a formatação de todos os valores monetários no aplicativo para usar o formato brasileiro consistente: R$ 99.990,99

**Problema Atual:**
- Dashboard exibe: R$ 99990,99
- Inputs exibem: R$ 99.990,99
- Falta de consistência visual entre diferentes telas
- Dificulta leitura de valores grandes

**Implementação Esperada:**
1. **Criar Utility para Formatação:**
   - Criar classe `CurrencyFormatter` em `lib/utils/`
   - Método para formatar valores com separador de milhares e decimais
   - Método para parsing de string formatada para double

2. **Atualizar Dashboard:**
   - Aplicar formatação consistente em todos os cards de valor
   - Saldo disponível, total de gastos, previsão, etc.

3. **Verificar Outros Locais:**
   - Tela de histórico de transações
   - Lista de despesas recorrentes
   - Detalhes de contas
   - Qualquer outro local que exiba valores monetários

**Exemplo de Implementação:**
```dart
class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static String format(double value) {
    return _formatter.format(value);
  }

  static double? parse(String formattedValue) {
    try {
      final cleanValue = formattedValue
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();
      return double.parse(cleanValue);
    } catch (e) {
      return null;
    }
  }
}
```

**Definition of Done:**
- [x] Dashboard usa formatação consistente (R$ 99.990,99)
- [x] Todas as telas do app exibem valores com o mesmo formato
- [x] Merge realizado para `develop`

---

### [x] F11-T2: Melhoria - Allow Future Date Selection in Transactions

**Branch:** `feature/future-date-transactions`

**Descrição:**
Permitir que o usuário selecione datas futuras ao criar/editar transações.

**Problema Atual:**
- Date picker limita seleção apenas para datas passadas e presente
- Usuários não podem registrar transações agendadas/futuras
- Limita casos de uso como planejamento de gastos futuros

**Implementação Esperada:**
- Remover restrição de data máxima no date picker
- Permitir seleção de qualquer data futura

**Definition of Done:**
- [x] Date picker aceita datas futuras
- [x] Merge realizado para `develop`

---

### [x] F11-T3: Melhoria - Auto-Capitalize Text Inputs

**Branch:** `feature/auto-capitalize-inputs`

**Descrição:**
Forçar a primeira letra em maiúscula em todos os campos de entrada de texto do aplicativo (descrição, notas, etc.).

**Problema Atual:**
- Usuário digita descrições começando com letra minúscula
- Falta de padronização na apresentação dos dados
- Aparência menos profissional

**Implementação Esperada:**
- Aplicar `TextCapitalization.sentences` em todos os `TextField`/`TextFormField`
- Atualizar widgets customizados (`CustomTextField`, `NubankStyleTextField`, etc.)
- Garantir que a capitalização funciona em todos os formulários:
  - Descrição de transações
  - Notas de transações
  - Nome de contas
  - Nome de categorias
  - Descrição de despesas recorrentes

**Exemplo:**
```dart
TextField(
  textCapitalization: TextCapitalization.sentences,
  // ... outros parâmetros
)
```

**Definition of Done:**
- [x] Todos os campos de texto usam `TextCapitalization.sentences`
- [x] Widgets customizados atualizados para suportar capitalização
- [x] Verificação manual em todos os formulários do app
- [ ] Testes de widget atualizados
- [x] Merge realizado para `develop`

---

### [x] F11-T4: Melhoria - Improve Dropdown UI Consistency

**Branch:** `feature/consistent-dropdown-ui`

**Descrição:**
Melhorar a interface do dropdown em todo o aplicativo para ter consistência com o design system.

**Problema Atual:**
- Dropdowns no bottom sheet de transações e resto do app não seguem design consistente
- Falta de alinhamento visual com os outros inputs do tipo Nubank
- Experiência de usuário inconsistente

**Implementação Realizada:**
- Atualizado `CustomDropdown` widget existente para melhorar consistência visual
- Adicionado `dropdownColor: AppColors.surfaceVariant` para menu dropdown combinar com tema dark
- Adicionado `menuMaxHeight: 300` para limitar altura do menu
- Customizado ícone do dropdown com cores que mudam baseado no estado de foco
- Dropdown menu agora combina perfeitamente com o design system do app

**Definition of Done:**
- [x] Dropdown menu styled com cores do dark theme
- [x] Design consistente com outros inputs do app
- [x] Menu dropdown usa cores apropriadas (surfaceVariant)
- [x] Ícone customizado com estados de foco
- [x] Merge realizado para `develop`

---

## 🏗️ Fase 12: Estabilidade e Code Health

**Objetivo:** Corrigir todos os warnings e infos do `flutter analyze`, atualizar pacotes desatualizados, e migrar código obsoleto, garantindo um código **limpo**, **moderno** e **sem alertas**.

**Status:** 1 / 4 tarefas concluídas

---

### [x] F12-T1: Implementação de Logging e Limpeza de Produção (7 Issues)

**Descrição:** Remover todas as chamadas de `print()` em código de produção e substituí-las por uma solução de logging adequada para facilitar a depuração.

**Issues/Grupo Corrigido:**
- **7** instâncias de `avoid_print` (lib/data/services/notification_service.dart, lib/data/services/transaction_notification_service.dart).

**Subtarefas:**
1.  Adicionar um pacote de logging (ex: `logger`) como `dev_dependency` e criar um wrapper de `LoggerService` ou usar o pacote diretamente.
2.  Substituir todas as 7 chamadas de **`print(...)`** nos dois arquivos de serviço de notificação por chamadas ao logger (ex: `_log.info('...')`).
3.  Configurar o logger para ser silencioso em builds de produção/release, aderindo à regra de lint.

**Definition of Done:**
- [ ] Pacote de logging adicionado ao projeto
- [ ] Todas as chamadas `print()` substituídas
- [ ] Logger configurado para produção
- [ ] `flutter analyze` não retorna `avoid_print`
- [ ] Merge realizado para `develop`

---

### [x] F12-T2: Remoção de Código Morto e Alertas de Compilação (10 Issues)

**Descrição:** Identificar e remover variáveis, campos, métodos e elementos de código não utilizados, e corrigir problemas de sobrescrita.

**Issues/Grupo Corrigido:**
- **5** instâncias de `unused_field` (lib/presentation/screens/onboarding_screen.dart).
- **3** instâncias de `unused_local_variable` (test/data/parsers/notification_parser_registry_test.dart, test/domain/usecases/get_dashboard_data_usecase_test.dart, test/domain/usecases/process_recurring_expenses_usecase_test.dart).
- **2** instâncias de `unused_element` (lib/data/datasources/local_database.g.dart, lib/presentation/widgets/expense/expense_details_bottom_sheet.dart).
- **1** instância de `override_on_non_overriding_member` (test/domain/usecases/process_recurring_expenses_usecase_test.dart).
- **1** instância de `unused_local_variable` (test/presentation/screens/accounts_screen_test.dart).

**Subtarefas:**
1.  Remover os 5 campos não utilizados (`_accountName`, `_accountIsDebit`, etc.) do `onboarding_screen.dart`.
2.  Remover ou utilizar as 4 variáveis locais não utilizadas nos arquivos de teste (`instance1Id`, `now`, `scaffold`, `tomorrow`, `callCount`, `originalCreate`).
3.  Remover as declarações não referenciadas `_$LocalDatabase.connect` e `_handleValueChange`.
4.  Remover a anotação `@override` do método que não sobrescreve em `process_recurring_expenses_usecase_test.dart`.

**Definition of Done:**
- [ ] Todos os campos e variáveis não utilizados removidos
- [ ] Elementos mortos removidos
- [ ] Anotações `@override` incorretas corrigidas
- [ ] `flutter analyze` não retorna warnings de código não utilizado
- [ ] Testes continuam passando
- [ ] Merge realizado para `develop`

---

### [x] F12-T3: Migração de APIs Deprecated e Contextos Assíncronos (11 Issues)

**Branch:** `chore/deprecated-api-migration`

**Descrição:** Substituir APIs obsoletas do Flutter/Dart e resolver problemas de uso do `BuildContext` em contextos assíncronos.

**Issues/Grupo Corrigido:**
- **4** instâncias de `deprecated_member_use` (Flutter Core: `withOpacity`, `window`, `viewInsets`).
- **5** instâncias de `deprecated_member_use` (Testes: `setMockMethodCallHandler`).
- **2** instâncias de `use_build_context_synchronously` (lib/presentation/screens/accounts_screen.dart, lib/presentation/screens/transactions_list_screen.dart).

**Subtarefas:**
1.  Substituir todas as 3 ocorrências de `.withOpacity()` por métodos alternativos como `.withValues()` ou reescrever a lógica de cores.
2.  Corrigir o uso de `window.viewInsets` e `window` no teste de dashboard usando `tester.view` ou `tester.platformDispatcher`.
3.  Atualizar todas as 5 chamadas de `setMockMethodCallHandler` nos testes de repositório para a nova API: `TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler`.
4.  Adicionar verificações de **`if (mounted)`** antes de qualquer uso de `BuildContext` (ex: `Navigator.of(context)`) nas funções assíncronas de `accounts_screen.dart` e `transactions_list_screen.dart`.

**Definition of Done:**
- [x] Todas as APIs deprecated substituídas
- [x] Contextos assíncronos corrigidos com `if (mounted)`
- [x] `flutter analyze` não retorna `deprecated_member_use`
- [x] `flutter analyze` não retorna `use_build_context_synchronously`
- [x] Testes executam sem warnings
- [ ] Merge realizado para `develop`

---

## ⚙️ Fase 13: Gestão Avançada de Contas e Configurações

**Objetivo:** Aprimorar a gestão de contas, categorias e configurações financeiras com recursos avançados de personalização.

**Status:** 0 / 6 tarefas concluídas

---

### [ ] F13-T1: Correção - Fix New Account Bottom Sheet Behavior

**Branch:** `fix/account-bottom-sheet-keyboard`

**Descrição:**
Corrigir o comportamento do bottom sheet de nova conta para expandir e contrair adequadamente com e sem teclado, exatamente como o bottom sheet de transações.

**Problema Atual:**
- Bottom sheet de conta não se ajusta corretamente quando o teclado aparece
- Campos podem ficar ocultos atrás do teclado
- Comportamento inconsistente com o bottom sheet de transações

**Implementação Esperada:**
- Usar `MediaQuery.of(context).viewInsets.bottom` para detectar teclado
- Aplicar padding inferior dinâmico
- Bottom sheet deve expandir quando teclado aparece
- Bottom sheet deve contrair quando teclado desaparece
- Scroll automático para campo em foco

**Referência:**
Verificar implementação do `ExpenseDetailsBottomSheet` e aplicar a mesma lógica.

**Definition of Done:**
- [ ] Bottom sheet ajusta altura corretamente com teclado
- [ ] Todos os campos acessíveis quando teclado está visível
- [ ] Scroll automático para campo em foco
- [ ] Comportamento consistente com bottom sheet de transações
- [ ] Testes de widget para verificar comportamento
- [ ] Merge realizado para `develop`

---

### [ ] F13-T2: Melhoria - Collapsible Account Tiles with Click to Expand

**Branch:** `feature/collapsible-account-tiles`

**Descrição:**
Reduzir o tamanho dos tiles de contas e implementar funcionalidade de click-to-expand para mostrar detalhes.

**Problema Atual:**
- Tiles de contas ocupam muito espaço vertical
- Todas as informações sempre visíveis desperdiçam espaço
- Dificulta visualização quando há muitas contas

**Implementação Esperada:**
1. **Versão Colapsada (Padrão):**
   - Nome da conta
   - Tipo (débito/crédito)
   - Saldo atual
   - Ícone de expansão

2. **Versão Expandida (Ao Clicar):**
   - Todas as informações da versão colapsada
   - Limite de crédito (se aplicável)
   - Saldo da fatura (se aplicável)
   - Data de vencimento (se aplicável)
   - Botões de ação (editar, excluir)

3. **Animação:**
   - Transição suave entre estados
   - Rotação do ícone de expansão
   - Expansion tile animado

**Exemplo de Implementação:**
```dart
ExpansionTile(
  title: Text(account.name),
  subtitle: Text('${account.type} - ${CurrencyFormatter.format(account.balance)}'),
  children: [
    // Detalhes expandidos
    if (account.isCredit) ...[
      ListTile(
        title: Text('Limite de Crédito'),
        trailing: Text(CurrencyFormatter.format(account.creditLimit)),
      ),
      // ... outros detalhes
    ],
    ButtonBar(
      children: [
        IconButton(icon: Icon(Icons.edit), onPressed: () => _editAccount(account)),
        IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteAccount(account)),
      ],
    ),
  ],
)
```

**Definition of Done:**
- [ ] Account tiles colapsados por padrão
- [ ] Click expande/colapsa tile com animação
- [ ] Informações essenciais visíveis em modo colapsado
- [ ] Detalhes completos visíveis em modo expandido
- [ ] Ícone de expansão rotaciona adequadamente
- [ ] Testes de widget implementados
- [ ] Merge realizado para `develop`

---

### [ ] F13-T3: Feature - Default Account Selection

**Branch:** `feature/default-account-selection`

**Descrição:**
Implementar seleção de conta padrão na página de contas que já venha pré-selecionada no dropdown de criação/edição de transações.

**Implementação Esperada:**
1. **Adicionar Campo no Banco:**
   - Adicionar coluna `isDefault` (booleano) na tabela `Accounts`
   - Apenas uma conta pode ser default por vez

2. **UI na Página de Contas:**
   - Adicionar ícone de "estrela" ou "favorito" nos tiles de conta
   - Permitir marcar/desmarcar como conta padrão
   - Destacar visualmente a conta padrão (ex: ícone dourado)

3. **Integração com Bottom Sheet de Transações:**
   - Ao abrir bottom sheet, pré-selecionar a conta marcada como default
   - Se não houver conta default, manter comportamento atual

4. **Regras de Negócio:**
   - Ao marcar uma conta como default, desmarcar a anterior automaticamente
   - Não permitir excluir conta marcada como default sem antes marcar outra
   - Se conta default for excluída, limpar flag de default

**Database Migration:**
```dart
// Adicionar ao schema do Drift
class Accounts extends Table {
  // ... campos existentes
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}
```

**Definition of Done:**
- [ ] Coluna `isDefault` adicionada à tabela Accounts
- [ ] UI para marcar/desmarcar conta padrão implementada
- [ ] Apenas uma conta pode ser default por vez
- [ ] Bottom sheet de transações pré-seleciona conta padrão
- [ ] Regras de negócio para exclusão implementadas
- [ ] Testes de integração para seleção de conta padrão
- [ ] Migration documentada
- [ ] Merge realizado para `develop`

---

### [ ] F13-T4: Feature - Category Management in Settings

**Branch:** `feature/category-management`

**Descrição:**
Adicionar seção nas configurações para criação/remoção de categorias e seleção de categoria padrão.

**Implementação Esperada:**
1. **UI na Settings Screen:**
   - Nova seção "Gerenciar Categorias"
   - Lista de categorias existentes
   - Botão para adicionar nova categoria
   - Ícone de estrela para marcar categoria padrão
   - Botão de excluir categoria

2. **Adicionar Campo no Banco:**
   - Adicionar coluna `isDefault` na tabela `Categories`
   - Apenas uma categoria pode ser default por vez

3. **Dialog de Nova Categoria:**
   - Campo de texto para nome da categoria
   - Seletor de cor/ícone (opcional para MVP)
   - Botão salvar/cancelar

4. **Regras de Negócio:**
   - Não permitir excluir categorias que tenham transações vinculadas
   - Ao marcar categoria como default, desmarcar a anterior
   - Bottom sheet de transações pré-seleciona categoria default

5. **Categorias Iniciais:**
   - Criar categorias padrão no primeiro uso:
     - Alimentação
     - Transporte
     - Lazer
     - Saúde
     - Educação
     - Moradia
     - Outros

**Definition of Done:**
- [ ] Seção de gerenciamento de categorias na settings
- [ ] CRUD completo de categorias implementado
- [ ] Seleção de categoria padrão funcional
- [ ] Validação de exclusão (categorias com transações)
- [ ] Categorias iniciais criadas no onboarding
- [ ] Bottom sheet de transações pré-seleciona categoria padrão
- [ ] Testes de integração
- [ ] Merge realizado para `develop`

---

### [ ] F13-T5: Feature - Salary Payment Date Configuration

**Branch:** `feature/salary-payment-date`

**Descrição:**
Criar seção nas configurações para definir a data mensal em que o salário é recebido.

**Implementação Esperada:**
1. **Adicionar Campo no Banco:**
   - Adicionar coluna `salaryPaymentDay` (int 1-31) na tabela `AppSettings`
   - Valor padrão: dia 1 do mês

2. **UI na Settings Screen:**
   - Campo "Dia do Recebimento do Salário"
   - Dropdown ou number picker com dias 1-31
   - Validação para meses com menos de 31 dias

3. **Uso Futuro:**
   - Base para funcionalidade de projeção de saldo
   - Alertas de proximidade do dia do salário
   - Resetar "quanto posso gastar" baseado nesta data

**Definition of Done:**
- [ ] Coluna `salaryPaymentDay` adicionada ao banco
- [ ] UI para seleção do dia implementada
- [ ] Validação de dias implementada
- [ ] Valor persistido corretamente
- [ ] Documentação de uso futuro
- [ ] Merge realizado para `develop`

---

### [ ] F13-T6: Feature - Credit Payment Date per Account

**Branch:** `feature/credit-payment-date`

**Descrição:**
Criar seção nas configurações para definir a data de pagamento da fatura de crédito para cada conta de crédito.

**Implementação Esperada:**
1. **Adicionar Campo no Banco:**
   - Adicionar coluna `creditPaymentDay` (int 1-31) na tabela `Accounts`
   - Aplicável apenas para contas de crédito

2. **UI na Account Creation/Editing:**
   - Mostrar campo "Dia do Vencimento" apenas se `isCredit == true`
   - Dropdown ou number picker com dias 1-31
   - Validação de dias

3. **UI na Settings Screen (Alternativa):**
   - Seção "Datas de Vencimento"
   - Lista de contas de crédito com seus respectivos dias
   - Click para editar dia de vencimento

4. **Uso Futuro:**
   - Alertas de proximidade de vencimento
   - Cálculo automático de fatura do mês
   - Projeção de gastos considerando vencimentos

**Definition of Done:**
- [ ] Coluna `creditPaymentDay` adicionada à tabela Accounts
- [ ] Campo visível apenas para contas de crédito
- [ ] UI para edição do dia de vencimento
- [ ] Validação implementada
- [ ] Valor persistido corretamente
- [ ] Documentação de uso futuro
- [ ] Merge realizado para `develop`

---

## 📝 Notas Importantes

### Boas Práticas Durante o Desenvolvimento

3. **Testes Primeiro:** Escrever testes antes ou junto com a implementação
4. **Code Review Solo:** Revisar o próprio código antes do merge
5. **Documentação:** Comentar código complexo e manter este PLAN.md atualizado

### Atualização deste Documento

Sempre que concluir uma tarefa:
1. Mudar o checkbox de `[ ]` para `[x]`
2. Atualizar os contadores de progresso
3. Pedir ao usuário que faça commit da mudança

### Ordem Sugerida

As fases devem ser seguidas sequencialmente, mas dentro de cada fase há alguma flexibilidade. Tarefas marcadas como **críticas** devem ser priorizadas.

---

## 🎊 Conclusão

Este plano mapeia todas as **39 tarefas** necessárias para completar o MVP do Previsor Financeiro. Ao seguir este roadmap, você terá um aplicativo funcional, testado e preparado para uso pessoal, com uma arquitetura sólida que permitirá expansões futuras.

A **Fase 5** representa a primeira iteração de melhorias baseada em uso real, demonstrando a importância de testar o aplicativo e iterar sobre o design inicial.

A **Fase 6** adiciona refinamentos críticos de UX: onboarding para novos usuários, gestão completa de transações, e padronização de inputs numéricos para o mercado brasileiro.

A **Fase 7** introduz automação inteligente e identidade visual: ícone personalizado do app e captura automática de transações a partir de notificações bancárias, com arquitetura extensível para suportar múltiplos bancos.

A **Fase 8** foca em correções críticas e refinamentos de UX: sistema de input numérico tipo Nubank, bottom sheet com abas para melhor experiência com teclado, swipe-to-delete aprimorado, toggle entre dashboard e histórico, correção de permissões de notificação, e file picker para backups.

A **Fase 9** traz correções de UX e padronização visual: correção do bug de exibição de valores nas configurações e padronização do app bar em todas as telas principais para garantir consistência visual e facilitar o acesso às configurações.

A **Fase 10** garante a estabilidade e saúde do código: atualização de dependências, migração de APIs deprecated, implementação de logging adequado, e remoção de código morto.

**Bom desenvolvimento! 🚀**

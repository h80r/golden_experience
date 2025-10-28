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
**Concluídas:** 40 / 56 (71%)

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

### Legenda de Status
- `[ ]` Not Started (Não iniciada)
- `[~]` In Progress (Em andamento)
- `[x]` Completed (Concluída)

---

## ⚙️ Fase 13: Gestão Avançada de Contas e Configurações

**Objetivo:** Aprimorar a gestão de contas, categorias e configurações financeiras com recursos avançados de personalização.

**Status:** 6 / 6 tarefas concluídas

---

### [x] F13-T1: Correção - Fix New Account Bottom Sheet Behavior

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
- [x] Bottom sheet ajusta altura corretamente com teclado
- [x] Todos os campos acessíveis quando teclado está visível
- [x] Scroll automático para campo em foco
- [x] Comportamento consistente com bottom sheet de transações
- [x] Testes de widget para verificar comportamento
- [x] Merge realizado para `develop`

---

### [x] F13-T2: Melhoria - Collapsible Account Tiles with Click to Expand

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
- [x] Account tiles colapsados por padrão
- [x] Click expande/colapsa tile com animação
- [x] Informações essenciais visíveis em modo colapsado
- [x] Detalhes completos visíveis em modo expandido
- [x] Ícone de expansão rotaciona adequadamente
- [x] Testes de widget implementados
- [x] Merge realizado para `develop`

---

### [x] F13-T3: Feature - Default Account Selection

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
- [x] Coluna `isDefault` adicionada à tabela Accounts
- [x] UI para marcar/desmarcar conta padrão implementada
- [x] Apenas uma conta pode ser default por vez
- [x] Bottom sheet de transações pré-seleciona conta padrão
- [x] Regras de negócio para exclusão implementadas
- [x] Testes de integração para seleção de conta padrão
- [x] Migration documentada
- [x] Merge realizado para `develop`

---

### [x] F13-T4: Feature - Category Management in Settings

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
- [x] Seção de gerenciamento de categorias na settings
- [x] CRUD completo de categorias implementado
- [x] Seleção de categoria padrão funcional
- [x] Validação de exclusão (categorias com transações)
- [x] Categorias iniciais criadas no onboarding
- [x] Bottom sheet de transações pré-seleciona categoria padrão
- [x] Testes de integração
- [x] Merge realizado para `develop`

---

### [x] F13-T5: Feature - Salary Payment Date Configuration

**Branch:** `feature/salary-payment-date`

**Descrição:**
Criar seção nas configurações para definir a data mensal em que o salário é recebido com suporte a dois modos: data específica (calendário) e dia útil específico com cálculo de feriados.

**Implementação Esperada:**
1. **Adicionar Campos no Banco:**
   - Adicionar coluna `salaryPaymentMode` (texto: 'calendar' ou 'workday') na tabela `AppSettings`
   - Adicionar coluna `salaryPaymentValue` (inteiro) na tabela `AppSettings`
   - Valores padrão: modo 'calendar', valor 1

2. **UI na Settings Screen:**
   - SegmentedToggle para seleção entre "Dia Específico" e "Dia Útil"
   - Modo Dia Específico: Calendário inline personalizado mostrando mês atual com seleção de dias (1-31)
   - Modo Dia Útil: Dropdown com opções comuns (1º, 5º, 10º, 15º, 20º, último dia útil) + opção "Outro..." para entrada customizada (1-23)
   - Datas de trabalho mostram o day/month correspondente (ex: "1º dia útil (03/11)")

3. **Lógica de Feriados:**
   - Implementar calendário brasileiro de feriados nacionais
   - Incluir feriados específicos de São Paulo
   - Suportar cálculo do nº dia útil excluindo finais de semana e feriados
   - Seleção inteligente de mês: se data calculada já passou, usa próximo mês

4. **Uso Futuro:**
   - Base para funcionalidade de projeção de saldo
   - Alertas de proximidade do dia do salário
   - Resetar "quanto posso gastar" baseado nesta data

**Definition of Done:**
- [x] Colunas `salaryPaymentMode` e `salaryPaymentValue` adicionadas ao banco
- [x] Migration v5→v6 implementada
- [x] Widget calendário inline personalizado criado
- [x] SegmentedToggle para modo de seleção
- [x] Dropdown de dias úteis com cálculo de datas
- [x] Calendário brasileiro de feriados implementado
- [x] Lógica de seleção inteligente de mês
- [x] UI completa integrada ao Settings Screen
- [x] Persistência de dados funcionando
- [x] Merge realizado para `develop`

---

### [x] F13-T6: Feature - Credit Payment Date per Account

**Branch:** `feature/credit-payment-date`

**Descrição:**
Criar seção nas configurações para definir a data de fechamento da fatura de crédito para cada conta de crédito e também calcular a data de pagamento.

**Implementação Esperada:**
1. **Adicionar Campo no Banco:**
   - Adicionar coluna `creditClosingDay` (int 1-31) na tabela `Accounts`
   - Aplicável apenas para contas de crédito

2. **UI na Account Creation/Editing:**
   - Mostrar campo "Dia do Fechamento" apenas se `isCredit == true`
   - Usar o mesmo widget de seleção de dia do salário:
     - Calendário inline personalizado
   - Validação de dias

3. **Uso Futuro:**
   - Alertas de proximidade de vencimento
   - Cálculo automático de fatura do mês
   - Projeção de gastos considerando vencimentos

**Definition of Done:**
- [x] Coluna `creditClosingDay` adicionada à tabela Accounts
- [x] Campo visível apenas para contas de crédito
- [x] UI para edição do dia de fechamento (InlineCalendar widget)
- [x] Validação implementada (nullable field, 1-31 values)
- [x] Valor persistido corretamente (both create and update)
- [x] Documentação de uso futuro (comments in code)
- [x] Merge realizado para `develop`

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

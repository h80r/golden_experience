**📄 Documento de Especificação Técnica e Plano de Execução v1.0**

* **Produto:** Previsor Financeiro (MVP)  
* **Autor:** Seu Tech Lead  
* **Data:** 18 de outubro de 2025  
* **Status:** Aprovado. Pronto para Desenvolvimento.

### **1\. Visão Geral e Contexto Técnico**

Este documento traduz os requisitos do PRD e do Design Conceitual em uma especificação técnica e um plano de ação para a equipe de engenharia.

* **Objetivo do Produto:** Oferecer um aplicativo mobile (Flutter) *local-first* que elimina o atrito do controle financeiro, focando na resposta em tempo real à pergunta: "Quanto ainda posso gastar este mês?".  
* **Pilares Técnicos:**  
  1. **Reatividade Instantânea:** A UI, especialmente o Dashboard, deve refletir qualquer mudança de dados (novos gastos, etc.) em tempo real e sem a necessidade de refresh manual.  
  2. **Performance Nativa:** A experiência do usuário, principalmente no fluxo de registro de gastos, deve ser fluida e rápida, operando a 60 FPS.  
  3. **Arquitetura Escalável:** Embora o MVP seja *local-first*, a arquitetura deve ser limpa e modular (Clean Architecture) para facilitar a manutenção e a futura introdução de um backend para sincronização na nuvem.

### **2\. Análise de Viabilidade e Mitigação de Riscos**

A proposta é **100% viável tecnicamente**. Os riscos principais e suas respectivas mitigações estão delineados abaixo:

| Risco | Descrição | Estratégia de Mitigação |
| :---- | :---- | :---- |
| **Perda de Dados** | Como um app *local-first*, a desinstalação ou troca de aparelho resultará em perda total dos dados do usuário. | Implementar uma funcionalidade de **Backup/Restauração manual** (exportar/importar arquivo JSON), deixando claro para o usuário a responsabilidade sobre seus dados no MVP. |
| **Lógica de Recorrências** | Um job em background para processar recorrências pode ser ineficiente, consumir bateria ou falhar. | A lógica de criação de despesas recorrentes será executada **apenas na inicialização do aplicativo**, comparando a data atual com a da última verificação para processar os dias pendentes. |
| **Gestão de Estado** | A reatividade exigida pode levar a um código complexo e propenso a bugs se o gerenciamento de estado for inadequado. | Adoção do **Riverpod** como padrão para gerenciamento de estado e injeção de dependência, garantindo um fluxo de dados unidirecional e reativo. |

### **3\. Arquitetura Proposta: Clean Architecture**

A estrutura do projeto será dividida em três camadas principais para garantir a separação de responsabilidades.

1. **Presentation Layer (Flutter):**  
   * **Responsabilidade:** UI (Widgets), roteamento e captura de input do usuário.  
   * **Tecnologias:** Flutter, Riverpod (para conectar com a camada de domínio).  
2. **Domain Layer (Dart Puro):**  
   * **Responsabilidade:** Lógica de negócio, entidades e regras. Totalmente independente de frameworks.  
   * **Componentes:**  
     * **Models/Entities:** Transaction, Account, RecurringExpense, etc.  
     * **Use Cases:** Orquestradores da lógica (ex: AddTransactionUseCase).  
     * **Repository Interfaces:** Contratos que definem como os dados são acessados.  
3. **Data Layer (Dart \+ Packages):**  
   * **Responsabilidade:** Implementação concreta da persistência e acesso a dados.  
   * **Tecnologias:**  
     * **Banco de Dados:** **Isar Database** (pela performance, tipagem forte e queries reativas).  
     * **Repository Implementations:** Classes que implementam as interfaces do domínio usando o Isar.

### **4\. Stack Tecnológica**

| Categoria | Ferramenta/Tecnologia | Justificativa |
| :---- | :---- | :---- |
| **Framework** | Flutter 3.x | Requisito de produto, multiplataforma e ecossistema maduro. |
| **Linguagem** | Dart 3.x | Linguagem padrão do Flutter, com sound null safety. |
| **Banco de Dados Local** | **Isar Database** | Rápido, orientado a objetos, com queries reativas que simplificam a reatividade da UI. |
| **Gestão de Estado** | **Riverpod 2.x** | Solução robusta, compilada e segura que simplifica a injeção de dependência e o padrão *Observer*. |
| **Testes** | flutter\_test, integration\_test | Ferramentas nativas e recomendadas para testes unitários, de widget e de integração. |
| **Observabilidade** | Firebase Crashlytics | Essencial para monitorar crashes em produção e garantir a estabilidade do app. |
| **CI/CD** | GitHub Actions | Automação de builds, testes e deploys para as lojas (Firebase App Distribution para betas). |

### **5\. Modelagem de Dados (Entidades do Isar)**

* Transaction:  
  * id (int, auto-increment), value (double), description (String), date (DateTime), notes (String?), accountId (int), categoryId (int)  
* Account:  
  * id (int, auto-increment), name (String), type (Enum: debit/credit), initialBalance (double), creditLimit (double)  
* RecurringExpense:  
  * id (int, auto-increment), value (double), description (String), chargeDay (int), accountId (int), categoryId (int)  
* Category:  
  * id (int, auto-increment), name (String)  
* AppSettings:  
  * id (int, fixo \= 1), monthlySalary (double), reserveBalance (double), maxReserveUsagePercentage (double), lastRecurringCheck (DateTime)

---

### **6\. Plano de Execução Detalhado: Tarefas Atomizadas**

#### **Fase 1: Fundação e Lógica Core (Sprints 1-2)**

| ID | Título | Descrição | Requisitos/Critérios de Aceitação | Definition of Done (DoD) |
| :---- | :---- | :---- | :---- | :---- |
| **F1-T1** | Configuração do Projeto e Arquitetura | Inicializar o projeto Flutter, configurar Riverpod, Isar e a estrutura de pastas da Clean Architecture. | \- Projeto criado. \- Estrutura de pastas presentation, domain, data definida. \- Dependências (isar, riverpod, etc.) adicionadas. | \- Código no repositório. \- PR aprovado. \- Merged na develop. |
| **F1-T2** | Modelagem e Configuração do DB | Implementar as classes de modelo (Transaction, Account, etc.) como coleções do Isar. | \- Todas as entidades do item 5 modeladas com anotações do Isar. \- Uma instância do Isar pode ser aberta com sucesso. | \- Código implementado. \- Testes unitários para os modelos. \- PR aprovado. |
| **F1-T3** | Implementação dos Repositórios | Criar as interfaces dos repositórios na camada de domínio e suas implementações com Isar na camada de dados. | \- Interfaces IAccountRepository, ITransactionRepository, etc., definidas. \- Implementações com métodos CRUD (Create, Read, Update, Delete). | \- Código implementado. \- Testes unitários para os repositórios (usando mock do Isar). \- PR aprovado. |
| **F1-T4** | Navegação e Shell do App | Construir a estrutura de navegação principal (Tab Bar com 3 abas) e as telas vazias. | \- App abre na tela "Início". \- É possível navegar entre as telas "Início", "Recorrências" e "Contas". | \- Código implementado. \- Testes de widget para a navegação básica. \- PR aprovado. |

#### **Fase 2: O Fluxo Crítico \- Registro de Gasto (Sprints 3-4)**

| ID | Título | Descrição | Requisitos/Critérios de Aceitação | Definition of Done (DoD) |
| :---- | :---- | :---- | :---- | :---- |
| **F2-T1** | UI da Calculadora e Bottom Sheet | Construir os widgets para a calculadora e para o bottom sheet de detalhes, conforme o design. | \- Widgets visualmente idênticos ao protótipo. \- Componentes reutilizáveis (botões, campos de texto) criados. \- Interações puramente de UI funcionam. | \- Código implementado. \- Testes de widget para os componentes isolados. \- PR aprovado. |
| **F2-T2** | Lógica de Estado para o Registro | Criar o StateNotifierProvider (Riverpod) para gerenciar o estado do fluxo de registro (valor, descrição, conta, etc.). | \- O estado é atualizado conforme o usuário interage com a UI. \- Validações básicas (ex: descrição não pode ser vazia) são implementadas. | \- Código implementado. \- Testes unitários para o Notifier. \- PR aprovado. |
| **F2-T3** | Use Case: Adicionar Transação | Criar o AddTransactionUseCase na camada de domínio para orquestrar a lógica de salvar uma nova transação. | \- O Use Case recebe os dados da transação. \- Chama o repositório para salvar a transação. \- Abate o saldo/limite da conta correspondente. | \- Código implementado. \- Testes unitários para o Use Case. \- PR aprovado. |
| **F2-T4** | Integração Fim-a-Fim do Fluxo | Conectar a UI (botão "Salvar Gasto") ao StateNotifier, que por sua vez chama o AddTransactionUseCase. | \- Ao clicar em salvar, uma nova transação é persistida no Isar. \- O saldo da conta selecionada é atualizado. \- O fluxo é fechado e o usuário retorna ao Dashboard. | \- Funcionalidade testada manualmente. \- Teste de integração para o fluxo completo. \- PR aprovado. |

#### **Fase 3: O Coração do Produto \- Dashboard Reativo (Sprints 5-6)**

| ID | Título | Descrição | Requisitos/Critérios de Aceitação | Definition of Done (DoD) |
| :---- | :---- | :---- | :---- | :---- |
| **F3-T1** | Use Case: Dados do Dashboard | Criar o GetDashboardDataUseCase que busca todas as informações necessárias e realiza os cálculos definidos no PRD. | \- O Use Case retorna um modelo com "Gasto Restante", "Gasto Total", "Reserva Final", etc. \- Os cálculos estão corretos conforme as regras do PRD. | \- Código implementado. \- Testes unitários para todos os cenários de cálculo. \- PR aprovado. |
| **F3-T2** | Lógica de Processamento de Recorrências | Implementar a lógica que roda na inicialização do app para criar transações a partir das despesas recorrentes cadastradas. | \- Transações são criadas para os dias de cobrança que passaram desde a última abertura. \- A lógica lida corretamente com meses de diferentes durações. | \- Código implementado. \- Testes unitários para a lógica de recorrências. \- PR aprovado. |
| **F3-T3** | UI do Dashboard | Construir os widgets do Dashboard (cards, valores, barra de progresso) conforme o design. | \- A tela é visualmente idêntica ao protótipo. \- Os componentes são responsivos a diferentes tamanhos de tela. | \- Código implementado. \- Testes de widget para os componentes do Dashboard. \- PR aprovado. |
| **F3-T4** | Integração Reativa do Dashboard | Usar um StreamProvider (Riverpod) que consome o GetDashboardDataUseCase e atualiza a UI automaticamente quando qualquer dado relevante (transações, contas) muda no Isar. | \- Salvar um novo gasto no fluxo da Fase 2 atualiza o Dashboard instantaneamente. \- A UI do Dashboard sempre exibe os dados mais recentes sem refresh manual. | \- Funcionalidade testada manualmente. \- Teste de integração para a reatividade. \- PR aprovado. |

#### **Fase 4: Funcionalidades de Suporte e Polimento (Sprints 7-8)**

| ID | Título | Descrição | Requisitos/Critérios de Aceitação | Definition of Done (DoD) |
| :---- | :---- | :---- | :---- | :---- |
| **F4-T1** | CRUD de Contas | Implementar a tela de "Contas" permitindo adicionar, editar e remover contas. | \- Usuário pode criar contas de débito e crédito. \- As informações são salvas corretamente no DB. | \- Código implementado. \- Testes de widget para a tela. \- PR aprovado. |
| **F4-T2** | CRUD de Recorrências | Implementar a tela de "Recorrências" permitindo adicionar, editar e remover despesas recorrentes. | \- Usuário pode cadastrar uma nova recorrência com valor, dia, conta, etc. | \- Código implementado. \- Testes de widget para a tela. \- PR aprovado. |
| **F4-T3** | Tela de Configurações | Implementar a tela onde o usuário define Salário, Reserva e % de uso da reserva. | \- Os valores são salvos no AppSettings. \- As mudanças refletem imediatamente nos cálculos do Dashboard. | \- Código implementado. \- Testes de widget para a tela. \- PR aprovado. |
| **F4-T4** | Backup e Restauração | Implementar a funcionalidade de exportar o banco de dados para um arquivo JSON e importar de volta. | \- Botão "Exportar" gera um arquivo JSON legível. \- Botão "Importar" substitui os dados atuais pelos do arquivo. \- Alertas de confirmação são exibidos. | \- Funcionalidade testada manualmente. \- PR aprovado. |
| **F4-T5** | Configuração de CI/CD | Criar um workflow no GitHub Actions para rodar testes, analisar o código (lint) e fazer build do app em cada PR. | \- O workflow é acionado automaticamente. \- PRs com falhas nos testes ou lint são bloqueados. \- Um build de release é gerado ao fazer merge na main. | \- Pipeline configurado e funcional. \- Documentação no README. \- PR aprovado. |

### **7\. Recomendações Finais e Próximos Passos**

1. **Kick-off Técnico:** Agendar uma reunião com todo o time de engenharia para apresentar este documento, tirar dúvidas e refinar as estimativas para as tarefas da Fase 1\.  
2. **Configuração do Ambiente:** O primeiro passo prático é a tarefa **F1-T1**. Devemos garantir que o ambiente de desenvolvimento de todos esteja padronizado.  
3. **Comunicação:** Manter os rituais de Daily, Planning e Review para garantir o alinhamento contínuo com o PM e stakeholders.

Este plano fornece a clareza necessária para iniciarmos o desenvolvimento do Previsor Financeiro com velocidade, qualidade e uma base técnica sólida. Vamos construir um produto incrível.
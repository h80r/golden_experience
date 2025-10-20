**Product Requirements Document (PRD): Previsor Financeiro v1.0 (MVP)**

* **Produto:** Aplicativo de Controle Financeiro Pessoal  
* **Versão:** 1.0 (MVP \- Mínimo Produto Viável)  
* **Autor:** Seu Co-PM  
* **Data:** 18 de outubro de 2025

### **1\. Visão Geral (Executive Summary)**

O "Previsor Financeiro" é um aplicativo mobile (Flutter) de uso pessoal, projetado para oferecer tranquilidade e controle sobre as finanças mensais. Diferente de apps de controle tradicionais que focam em análise de dados passados, nosso MVP se concentra em responder à pergunta diária: **"Com base no meu cenário atual, quanto ainda posso gastar este mês sem comprometer minhas economias?"**. O produto substitui a necessidade de uma planilha manual, focando em um registro de gastos ultrarrápido e na automação de despesas recorrentes para oferecer uma previsão de saldo sempre atualizada e confiável.

### **2\. O Problema a Ser Resolvido**

O usuário-alvo atualmente utiliza uma planilha complexa para prever seu saldo de fechamento de mês. O processo, embora funcional, apresenta atritos significativos:

1. **Atrito de Registro:** A necessidade de "parar para organizar as finanças" e preencher a planilha manualmente é tediosa e suscetível a esquecimentos, levando a dados defasados.  
2. **Falta de Imediatismo:** A decisão de fazer uma nova compra exige uma consulta prévia à planilha, o que nem sempre é prático.  
3. **Gestão de Recorrências:** Despesas fixas e assinaturas precisam ser lembradas e lançadas manualmente todo mês.

O objetivo do app é eliminar esses atritos, fornecendo um "co-piloto" financeiro que oferece controle em tempo real com o mínimo de esforço.

### **3\. Objetivos e Métricas de Sucesso**

* **Objetivo Principal:** Garantir que, ao final de cada mês, o saldo (Salário \- Gasto) seja sempre maior ou igual a zero, utilizando no máximo o percentual da reserva pré-definido pelo usuário.  
* **Métricas de Sucesso (KPIs):**  
  * **KPI de Resultado 1:** Saldo Final do Mês (Meta: \>= R$ 0).  
  * **KPI de Resultado 2:** % da Reserva Gasto (Meta: \<= Limite definido pelo usuário).  
  * **KPI de Engajamento:** % de Gastos do Mês Capturados no App (Meta: \> 95%).

### **4\. Escopo do MVP (O que está DENTRO e o que está FORA)**

#### **Funcionalidades DENTRO do escopo do MVP:**

* Dashboard principal com a lógica de previsão de gastos.  
* Registro manual de despesas (débito e crédito) com interface de calculadora.  
* Captura de Categoria, Descrição e Notas para cada gasto.  
* Gestão de múltiplas contas (saldo para débito, limite para crédito).  
* Cadastro e lançamento automático de despesas recorrentes (assinaturas).

#### **Funcionalidades FORA do escopo do MVP (planejadas para o futuro):**

* Tela de análise detalhada com filtros e gráficos.  
* Automação de registro de gastos via leitura de notificações de apps bancários.  
* Metas de economia e objetivos financeiros.  
* Sincronização na nuvem e multi-dispositivo.

### **5\. Requisitos Funcionais Detalhados (Épicos)**

#### **Épico 1: Dashboard de Controle**

* **Objetivo:** Apresentar a saúde financeira do mês de forma clara e instantânea.  
* **História de Usuário:** "Como usuário, eu quero ver um resumo do meu poder de compra e dos meus gastos na tela inicial, para que eu possa tomar decisões financeiras rápidas e seguras."  
* **Critérios de Aceitação:**  
  * Deve exibir o Salário definido nas configurações.  
  * Deve exibir o Gasto Restante, calculado como: (Salário \+ (Reserva \* % Máximo)) \- Gasto Total.  
  * Deve exibir o Gasto Total (soma de todas as despesas manuais e recorrentes do mês).  
  * Deve exibir o resultado de Salário \- Gasto.  
  * Deve exibir a Reserva Final, calculada como Reserva Inicial \- (Gasto Total \- Salário) (se o gasto for maior que o salário).  
  * Deve haver um indicador visual (ex: barra de progresso) para o % da Reserva Gasto.

#### **Épico 2: Registro Rápido de Gastos**

* **Objetivo:** Permitir o registro de uma nova despesa com o mínimo de atrito e tempo.  
* **História de Usuário:** "Como usuário, eu quero registrar um gasto em poucos segundos logo após a compra, para que meus dados estejam sempre atualizados."  
* **Critérios de Aceitação:**  
  * O fluxo deve começar com uma interface de calculadora para inserção do valor.  
  * Após a confirmação do valor, um painel (ex: *bottom sheet*) deve surgir para os detalhes, sem trocar de tela.  
  * O painel de detalhes deve conter os seguintes campos:  
    * Descrição (Texto, obrigatório, ex: "Almoço").  
    * Notas (Texto, opcional, para detalhes extras).  
    * Conta de Origem (Seleção de uma das contas cadastradas).  
    * Tipo de Transação (Seleção entre "Débito" e "Crédito").  
    * Categoria (Seleção de uma lista pré-definida e customizável).  
    * Data (Padrão: hoje, mas editável).  
  * Ao salvar, o Dashboard deve ser atualizado instantaneamente.

#### **Épico 3: Gestão de Contas**

* **Objetivo:** Configurar as fontes de dinheiro e crédito do usuário.  
* **História de Usuário:** "Como usuário, eu quero cadastrar todas as minhas contas e cartões de crédito, para que eu possa rastrear corretamente a origem de cada gasto."  
* **Critérios de Aceitação:**  
  * O usuário pode adicionar/editar/remover contas.  
  * Cada conta deve ter um Nome.  
  * Ao cadastrar, o usuário deve definir se a conta é de Débito ou Crédito.  
  * Contas de Débito devem ter um Saldo Inicial.  
  * Contas de Crédito devem ter um Limite de Crédito.  
  * Uma transação de Débito deve abater o saldo da conta correspondente.  
  * Uma transação de Crédito deve abater o limite disponível da conta correspondente.

#### **Épico 4: Gestão de Recorrências**

* **Objetivo:** Automatizar o lançamento de despesas fixas para aumentar a precisão da previsão.  
* **História de Usuário:** "Como usuário, eu quero cadastrar minhas assinaturas e contas fixas uma única vez, para que o app as lance como despesa automaticamente todo mês."  
* **Critérios de Aceitação:**  
  * O usuário pode adicionar/editar/remover despesas recorrentes.  
  * Cada recorrência deve ter: Descrição, Valor, Conta de Origem, Categoria e Dia da Cobrança.  
  * No dia da cobrança de cada mês, o sistema deve criar automaticamente uma nova transação com os dados da recorrência, impactando o Gasto Total e o saldo/limite da conta.

#### **Épico 5: Configurações Iniciais**

* **Objetivo:** Permitir que o usuário configure os valores base para os cálculos do app.  
* **Critérios de Aceitação:**  
  * Deve haver uma área de configurações para o usuário definir/atualizar:  
    * Seu Salário Mensal Fixo.  
    * O Saldo Inicial da sua conta de Reserva.  
    * O Percentual Máximo de Gasto da Reserva (%).

### **6\. Jornada do Usuário (Exemplo de Fluxo)**

1. **Setup:** Usuário instala o app e realiza as **Configurações Iniciais** (salário, reserva). Ele também cadastra suas contas em **Gestão de Contas** (ex: Nubank, Santander).  
2. **Recorrências:** Ele acessa **Gestão de Recorrências** e cadastra seu plano de celular e a assinatura da Crunchyroll.  
3. **Dia a Dia:** Ao fazer uma compra, ele abre o app, usa o **Registro Rápido**, insere o valor na calculadora, preenche os detalhes e salva.  
4. **Controle:** Instantaneamente, ele consulta o **Dashboard** e vê seu Gasto Restante atualizado, sentindo-se seguro para as próximas decisões.

### **7\. Considerações para o Time**

* **Para o Designer de UI/UX:**  
  * O ponto focal do design deve ser a **velocidade e a clareza**. O fluxo de registro de gastos é o mais crítico e deve ser otimizado para o mínimo de toques possível.  
  * O Dashboard deve ser legível à primeira vista, destacando a informação mais importante (Gasto Restante).  
  * Os mockups de baixa fidelidade servem como um guia conceitual para o fluxo. A identidade visual e a experiência polida ficam a seu critério.  
* **Para o Tech Lead:**  
  * A arquitetura deve garantir que os cálculos no Dashboard sejam reativos e atualizados em tempo real após qualquer transação.  
  * Para o MVP, o armazenamento de dados pode ser local (*local-first*). Não há necessidade de backend ou sincronização na nuvem nesta fase.  
  * A lógica para o lançamento automático das despesas recorrentes deve ser robusta, considerando meses com diferentes quantidades de dias (ex: cobrança no dia 31).
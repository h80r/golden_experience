## **📄 Documento de Design Conceitual: Previsor Financeiro v1.0**

* **Produto:** Previsor Financeiro (MVP)  
* **Destinatário:** Tech Lead & Time de Desenvolvimento  
* **Autor:** Seu UX/UI Designer  
* **Data:** 18 de outubro de 2025  
* **Status:** Design Conceitual Aprovado. Pronto para Handoff.

### **1\. Contexto e Objetivos**

Este documento detalha a solução de design para o MVP do "Previsor Financeiro", um aplicativo mobile focado em eliminar o atrito do controle financeiro manual.

* **Problema Principal:** Usuários que usam planilhas enfrentam lentidão no registro de gastos e falta de imediatismo para tomar decisões financeiras, gerando dados defasados e insegurança.  
* **Solução Proposta:** Um app que responde instantaneamente à pergunta **"Quanto ainda posso gastar este mês?"**, através de um registro de gastos ultrarrápido e da automação de despesas recorrentes.  
* **Público-alvo:** Indivíduos que já possuem um método de controle financeiro, mas buscam uma ferramenta mais eficiente, rápida e que ofereça tranquilidade em tempo real.  
* **Métricas de Sucesso:**  
  * Manter o Saldo Final do Mês $\\ge$ R$ 0\.  
  * Manter o % da Reserva Gasto dentro do limite definido pelo usuário.  
  * Capturar \> 95% dos gastos do mês no aplicativo.

### **2\. Experiência do Usuário (UX)**

#### **Arquitetura da Informação**

A navegação principal do MVP será composta por uma barra de abas (Tab Bar) inferior com três destinos essenciais:

1. **Início (Dashboard):** Tela principal com a visão geral e o "Gasto Restante".  
2. **Recorrências:** Lista para gerenciar despesas fixas mensais.  
3. **Contas:** Lista para gerenciar contas de débito e cartões de crédito.

O acesso às **Configurações** (Salário, Reserva, etc.) será feito por um ícone de engrenagem no cabeçalho do Dashboard.

#### **Fluxos Principais de Navegação**

1. **Onboarding e Configuração Inicial:**  
   * O usuário é guiado por um fluxo de 3 passos para configurar Salário, Reserva e % de uso da reserva.  
   * Em seguida, é incentivado a cadastrar sua primeira conta.  
   * O fluxo termina no Dashboard, já funcional.  
2. **Registro Rápido de Gasto (Core Loop):**  
   * **Passo 1:** Usuário toca no Botão de Ação Flutuante (+) no Dashboard.  
   * **Passo 2:** Um *overlay* de calculadora em tela cheia é apresentado para inserção do valor.  
   * **Passo 3:** Ao confirmar o valor, um painel inferior (*bottom sheet*) desliza para cima.  
   * **Passo 4:** Usuário preenche os detalhes (Descrição, Conta, Categoria).  
   * **Passo 5:** Ao salvar, o painel desaparece e o Dashboard é atualizado instantaneamente.

#### **Wireframes Textuais**

* **Dashboard:**  
  * **Header:** Título da tela, Ícone de Configurações.  
  * **Card Principal:** Label "Você ainda pode gastar este mês", Valor do Gasto Restante (destaque máximo), Barra de Progresso, Texto auxiliar sobre o uso da reserva.  
  * **Card Secundário:** Detalhamento com Salário, Gasto Total, Resultado Parcial e Reserva Final Prevista.  
  * **FAB (Floating Action Button):** Ícone de "+" para iniciar o registro de gasto.  
  * **Tab Bar:** Ícones para Início, Recorrências e Contas.  
* **Registro de Gasto (Bottom Sheet):**  
  * **Header do Painel:** Handle para arrastar, Valor do gasto (não editável).  
  * **Corpo:** Campo "Descrição", Seletor "Conta", Seletor "Categoria", Seletor "Data".  
  * **Rodapé:** Botão "Cancelar" (secundário) e Botão "Salvar Gasto" (primário).

### **3\. Interface do Usuário (UI) \- Guia Visual**

* **Tema Geral:** Dark Mode First. A interface é projetada para ser primariamente escura, transmitindo sofisticação, foco e conforto visual.  
* **Paleta de Cores:**  
  * Fundo Principal: Obsidian (\#0B1215)  
  * Fundo dos Cards: Midnight Blue (\#101720)  
  * Cor de Ação (CTAs): Amarelo Ouro (\#FFC700)  
  * Cor de Branding (Ícones, Links): Ciano Vibrante (\#22D3EE)  
  * Texto (Ênfase Alta): Unohana Flower (\#F7FCFE)  
  * Texto (Ênfase Média): Cinza-Claro (\#B0B0B0)  
  * Texto (Ênfase Baixa): Cinza-Médio (\#757575)  
* **Tipografia:**  
  * **Títulos e Cabeçalhos:** **Montserrat Alternates** (SemiBold)  
  * **Valores e Botões:** **Prompt** (Bold)  
  * **Corpo de Texto e Labels:** **Karma** (Regular)

### **4\. Design System \- Diretrizes para Desenvolvimento**

* **Grid e Espaçamento:** O sistema é baseado em uma **grade de 8pt**. Todos os espaçamentos (margens, paddings) e dimensões de componentes devem ser múltiplos de 8 (8px, 16px, 24px, 32px) para garantir consistência e ritmo visual.  
* **Componentes Principais e Estados:**  
  * **Botão Primário (Amarelo Ouro):**  
    * **Padrão:** Fundo \#FFC700, texto \#0B1215.  
    * **Pressionado:** Levemente escurecido (overlay de 10% de preto).  
    * **Desabilitado:** Fundo \#757575, texto \#B0B0B0.  
  * **Campos de Entrada:**  
    * **Padrão:** Borda \#757575, label \#B0B0B0.  
    * **Focado:** Borda \#22D3EE, label \#22D3EE.  
    * **Erro:** Borda \#E54B4B, com texto de ajuda na mesma cor.  
* **Cores de Feedback:**  
  * **Sucesso:** Verde Menta (\#00C49A) \- Para toasts/snackbars de confirmação.  
  * **Erro/Negativo:** Vermelho Tomate (\#E54B4B) \- Para mensagens de erro e valores negativos (ex: "Resultado Parcial").  
  * **Aviso:** Laranja Queimado (\#F79E02) \- Para alertas não-bloqueantes.

### **5\. Validação de UX e Próximos Passos**

O design proposto deve ser validado para garantir sua eficácia antes e durante o desenvolvimento.

* **Plano de Validação:**  
  1. **Protótipo Interativo:** Criar um protótipo clicável no Figma com os fluxos principais.  
  2. **Testes de Usabilidade:** Realizar testes moderados com 5 usuários do público-alvo para avaliar os fluxos e coletar feedback qualitativo.  
* **Hipóteses a Serem Testadas:**  
  1. **Velocidade:** O fluxo de registro de gasto é percebido como mais rápido e prático que o método atual do usuário (planilha).  
  2. **Clareza:** O Dashboard comunica de forma instantânea e clara o poder de compra restante do usuário.  
* **Próximos Passos Imediatos:**  
  1. **Handoff para Desenvolvimento:** Entrega deste documento e dos assets visuais (ícones, especificações de componentes) para o time de desenvolvimento.  
  2. **Sessão de Alinhamento:** Realizar uma reunião para apresentar o design, tirar dúvidas e garantir que a visão está clara para todos.  
  3. **Suporte Contínuo:** Manter comunicação aberta com o time de desenvolvimento para resolver quaisquer dúvidas de implementação e fazer ajustes finos conforme necessário.
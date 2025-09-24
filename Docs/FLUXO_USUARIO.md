# Fluxo de Navegação do Usuário no Aplicativo

Este documento descreve a jornada completa e o passo a passo que um usuário realiza ao utilizar o aplicativo "Lista de Compras", desde a autenticação até a análise de seus gastos.

---

### **1. Autenticação: A Porta de Entrada**

A primeira interação do usuário com o aplicativo é a tela de autenticação, que oferece dois caminhos:

- **1.1. Login (Para usuários existentes):**
  - O usuário insere seu e-mail e senha.
  - O sistema valida as credenciais com o Firebase Authentication.
  - Em caso de sucesso, o usuário é direcionado para a tela principal (`HomePage`).

- **1.2. Criação de Conta (Para novos usuários):**
  - O usuário alterna para a visão de cadastro.
  - Preenche os campos: nome, e-mail e senha.
  - O sistema cria um novo usuário no Firebase Authentication e salva as informações adicionais no Firestore.
  - Após o sucesso, o usuário é automaticamente logado e direcionado para a `HomePage`.

- **1.3. Recuperação de Senha:**
  - Caso esqueça a senha, o usuário pode solicitar a redefinição, que enviará um link de recuperação para o e-mail cadastrado.

---

### **2. Tela Principal (`HomePage`): Visualizando as Listas**

Após o login, o usuário chega à tela principal, que exibe todas as suas listas de compras com status "ativa".

- **2.1. Ordenação Inteligente:** As listas são organizadas de forma automática para máxima conveniência:
  - **Prioridade 1:** Listas com data de compra agendada (`purchaseDate`) aparecem primeiro, ordenadas da data mais próxima para a mais distante.
  - **Prioridade 2:** Listas sem data agendada são exibidas em seguida, ordenadas pela data em que foram criadas.

- **2.2. Criação de Nova Lista:**
  - O usuário clica no botão `+` (Floating Action Button).
  - Um diálogo (`CreateListDialog`) surge, solicitando o nome da lista, a categoria (ex: Mercado, Farmácia) e uma data de compra opcional.
  - Ao confirmar, a nova lista aparece na `HomePage`.

---

### **3. Detalhes da Lista (`ListDetailsPage`): Gerenciando os Itens**

Ao tocar em qualquer lista na `HomePage` (seja uma lista própria ou uma compartilhada), o usuário navega para a tela de detalhes, o coração do gerenciamento de compras.

- **3.1. Gerenciamento de Membros (Apenas para o Dono):**
  - Se o usuário for o **dono (`owner`)** da lista, ele verá um ícone de "Membros" na barra de título.
  - Ao clicar, ele acessa a `MembersPage`, onde pode:
    - Visualizar os membros atuais da lista e suas permissões.
    - Convidar um novo usuário digitando seu e-mail. O usuário convidado recebe a permissão de **editor** por padrão.

- **3.2. Visualização de Itens:** Todos os itens pertencentes àquela lista são exibidos, com suas quantidades e preços.

- **3.3. Adição de Itens (Dono e Editor):**
  - Se o usuário for `owner` ou `editor`, ele pode adicionar itens manualmente através do botão `+`.
  - **Adição por Sugestão:** No topo da tela, um carrossel exibe os produtos que o usuário mais comprou no passado. Com um único toque, o produto sugerido é adicionado à lista atual.

- **3.4. Gerenciamento de Itens:**
  - **Marcar como Comprado:** Qualquer membro da lista (`owner`, `editor`, etc.) pode marcar um item como comprado.
  - **Editar e Remover Item (Dono e Editor):** Apenas `owner` e `editor` veem os botões para editar ou remover um item da lista.

- **3.5. Ações da Lista (Apenas para o Dono):**
  - O menu de opções no canto superior direito só é visível para o `owner` da lista. Através dele, é possível:
    - **Editar a Lista:** Alterar nome, categoria ou a data da compra.
    - **Arquivar a Lista:** Mover a lista para o histórico com o status "arquivada".
    - **Finalizar Compra:** Calcular o preço total e mover a lista para o histórico como "finalizada".

---

### **4. Pós-Compra: Histórico e Análise**

Após as compras, o usuário pode gerenciar e analisar seus dados através do menu lateral.

- **4.1. Histórico de Compras (`HistoryPage`):**
  - Acessível pelo menu, esta tela exibe todas as listas "finalizadas" e "arquivadas".
  - É o registro permanente de todas as compras, mostrando o nome da lista, a data em que foi finalizada e o valor total gasto.

- **4.2. Análise de Gastos (`SpendingAnalysisPage`):**
  - Também no menu, esta tela oferece uma visão financeira das compras:
    - **Filtro por Período:** O usuário pode selecionar um intervalo de datas para a análise.
    - **Totalizador:** Exibe a soma de todos os gastos das listas finalizadas no período selecionado.
    - **Gráfico de Pizza:** Mostra a distribuição percentual dos gastos por categoria, oferecendo insights sobre onde o dinheiro está sendo gasto.

---

### **5. Funcionalidades Adicionais**

- **5.1. Catálogo de Produtos (`ProductCatalogPage`):**
  - Permite que o usuário crie e gerencie uma base global de produtos com nome e imagem, que pode ser usada para adicionar itens às listas.

- **5.2. Logout:**
  - A opção "Sair" no menu lateral encerra a sessão do usuário de forma segura.

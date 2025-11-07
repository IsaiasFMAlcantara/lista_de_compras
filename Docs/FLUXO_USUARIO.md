## Fluxo de Usuário no Aplicativo Lista de Compras

Este documento descreve a jornada principal e os fluxos secundários que um usuário percorre ao utilizar o aplicativo.

### 1. Fluxo de Entrada e Autenticação

1.  **Tela de Splash (`SplashPage`):** O usuário abre o app e vê uma tela inicial. O app verifica em segundo plano se ele já está logado.
2.  **Redirecionamento Automático:**
    *   **Se não estiver logado:** É levado para a **`LoginPage`**.
    *   **Se já estiver logado:** É levado diretamente para a **`HomePage`**.
3.  **Login / Cadastro (`LoginPage`):** Na tela de login, o usuário tem as seguintes opções:
    *   Entrar com seu e-mail e senha.
    *   Criar uma nova conta.
    *   Solicitar a redefinição de senha caso a tenha esquecido.

### 2. Fluxo Principal (Jornada da Lista de Compras)

1.  **Tela Principal (`HomePage`):** Após o login, o usuário vê suas listas de compras com o status "ativa". Se não houver nenhuma, uma mensagem amigável de "lista vazia" é exibida.
2.  **Criação de Lista:** O usuário clica em um botão de ação (FloatingActionButton) para abrir um diálogo de criação (`CreateListDialog`).
3.  **Dados da Lista:** No diálogo, ele preenche as informações da nova lista:
    *   Nome (obrigatório).
    *   Categoria (ex: Supermercado, Farmácia).
    *   Data da Compra (opcional, usado para agendar lembretes).
4.  **Detalhes da Lista (`ListDetailsPage`):** Ao criar a lista ou ao tocar em uma lista existente na `HomePage`, o usuário navega para a tela de detalhes. Esta é a tela central para o gerenciamento de itens:
    *   **Adicionar Itens:** O usuário clica em um botão para adicionar produtos. Ele pode escolher de um catálogo de produtos já existentes (`ProductCatalogPage`) ou cadastrar um item novo manualmente (nome, quantidade, preço).
    *   **Marcar Itens:** Conforme realiza a compra, ele pode marcar cada item como "comprado" através de uma checkbox, atualizando visualmente o estado do item.
    *   **Editar/Remover Itens:** O usuário pode editar as informações de um item (nome, quantidade, preço) ou removê-lo da lista.
5.  **Finalizar a Compra:** Quando a compra é concluída, o usuário clica em "Finalizar". Esta ação:
    *   Calcula o valor total gasto com base nos itens da lista.
    *   Muda o status da lista para "finalizada".
    *   Move a lista da `HomePage` para o `HistoryPage`.

### 3. Fluxos Secundários e Avançados

Estes fluxos são acessados geralmente a partir do menu lateral (`CustomDrawer`) ou de ações específicas dentro das telas.

*   **Compartilhamento de Lista (`MembersPage`):**
    1.  Na tela de detalhes (`ListDetailsPage`), o dono da lista pode acessar a funcionalidade de "Membros".
    2.  Nesta tela, ele pode convidar outros usuários para a lista através do e-mail.
    3.  O usuário convidado recebe o convite e, ao aceitar, passa a ver a lista compartilhada em sua `HomePage`, com permissão para editar (adicionar/remover itens).

*   **Histórico de Compras (`HistoryPage`):**
    1.  Acessando o "Histórico" no menu, o usuário pode visualizar todas as suas listas com status "finalizada" ou "arquivada".
    2.  Isso permite a consulta de compras passadas e seus custos.

*   **Análise de Gastos (`SpendingAnalysisPage`):**
    1.  Ao acessar a "Análise de Gastos" no menu, o usuário tem uma visão financeira de suas compras.
    2.  Ele pode filtrar os gastos por um período de tempo.
    3.  Um gráfico (ex: pizza) mostra a distribuição dos gastos por categoria, ajudando no controle financeiro.

*   **Catálogo de Produtos (`ProductCatalogPage`):**
    1.  O usuário pode, a qualquer momento, acessar o catálogo de produtos para gerenciar uma lista de itens que ele compra com frequência.
    2.  Isso facilita a adição de produtos comuns às listas, pois eles já estarão pré-cadastrados.

### Resumo do Fluxo Principal

**Logar > Ver listas na `HomePage` > Criar uma nova lista > Ser direcionado para a `ListDetailsPage` > Adicionar itens > Marcar itens como comprados > Finalizar a compra > Consultar a compra no `HistoryPage` e ver o impacto na `SpendingAnalysisPage`.**
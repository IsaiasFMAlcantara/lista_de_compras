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

1.  **Tela Principal (`HomePage` - Dashboard):** Após o login, o usuário é recebido por um dashboard com informações relevantes:
    *   **Saudação:** "Olá, [Nome do Usuário]".
    - **Ações Rápidas:** Botões para "Criar Nova Lista" e "Ver Histórico".
    - **Próximas Compras:** Uma visão rápida das listas ativas, ordenadas por data.
    - **Resumo do Mês:** Total de gastos no mês corrente e um gráfico de despesas por categoria.
    *   **Última Compra:** Detalhes da última compra finalizada.
2.  **Criação de Lista:** O usuário clica no botão "Nova Lista" para abrir um diálogo de criação.
3.  **Dados da Lista:** No diálogo, ele preenche as informações da nova lista:
    *   Nome (obrigatório).
    *   Categoria.
    *   Data da Compra (opcional).
4.  **Detalhes da Lista (`ListDetailsPage`):** Ao tocar em uma lista na seção "Próximas Compras", o usuário navega para a tela de detalhes. Esta é a tela central para o gerenciamento de itens:
    *   **Adicionar Itens:** O usuário clica em um botão para adicionar produtos de um catálogo global.
    *   **Marcar Itens:** Conforme realiza a compra, ele pode marcar cada item como "comprado".
    *   **Editar/Remover Itens:** O usuário pode editar a quantidade e o preço de um item ou removê-lo da lista.
5.  **Finalizar a Compra:** Quando a compra é concluída, o usuário clica em "Finalizar". Esta ação:
    *   Calcula o valor total gasto.
    *   Define a data da compra como o momento da finalização.
    *   Muda o status da lista para "finalizada".
    *   Move a lista para a tela de "Histórico".

### 3. Fluxos Secundários e Avançados

Estes fluxos são acessados a partir do menu lateral (`AppDrawer`) ou de ações específicas dentro das telas.

*   **Compartilhamento de Lista (`MembersPage`):**
    1.  Na tela de detalhes (`ListDetailsPage`), o dono da lista pode acessar a funcionalidade de "Membros".
    2.  Nesta tela, ele pode convidar outros usuários para a lista através do e-mail, definindo permissões.

*   **Histórico de Compras (`HistoryPage`):**
    1.  Acessando o "Histórico" no menu ou na ação rápida do dashboard, o usuário pode visualizar todas as suas listas finalizadas.
    2.  Nesta tela, ele também pode **clonar** uma lista antiga para uma nova compra.

*   **Análise de Gastos (`SpendingAnalysisPage`):**
    1.  Ao acessar a "Análise de Gastos" no menu, o usuário tem uma visão financeira detalhada.
    2.  Ele pode filtrar os gastos por um período de tempo.
    3.  Um gráfico de pizza mostra a distribuição dos gastos por categoria.

*   **Catálogo de Produtos (`ProductCatalogPage`):**
    1.  O usuário pode, a qualquer momento, acessar o catálogo de produtos para gerenciar uma lista de itens que ele compra com frequência.

### Resumo do Fluxo Principal

**Logar > Ver o dashboard na `HomePage` com resumos e ações rápidas > Criar ou selecionar uma lista > Gerenciar itens na `ListDetailsPage` > Finalizar a compra > Consultar a compra no `HistoryPage` e ver o impacto na `HomePage` e na `SpendingAnalysisPage`.**
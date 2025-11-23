# Apoio ao Desenvolvimento

## 1. Estrutura e Arquitetura do Projeto

A arquitetura que utilizamos é uma adaptação da **Arquitetura Limpa (Clean Architecture)**, com uma forte ênfase na **modularização por funcionalidade (feature)**.

O objetivo principal é separar o código em camadas com responsabilidades distintas. A regra mais importante é que as dependências apontam sempre para "dentro", ou seja, camadas externas conhecem as internas, mas as internas não sabem nada sobre as externas.

### 1.1. Camada de Apresentação (Presentation)

*   **Onde fica?** Principalmente na pasta `app/features/`.
*   **Qual o papel?** É a parte visual e interativa da aplicação que o usuário vê e com a qual interage.
*   **Como separamos?** O projeto é dividido em **módulos** baseados em funcionalidades. Cada subpasta dentro de `features` (como `auth`, `home`, `product`, `shopping_list`) é um módulo autônomo. Ele contém:
    *   **Views/Pages:** As telas que o usuário vê.
    *   **Controllers:** A lógica que controla o estado da tela, responde a interações do usuário e busca os dados necessários para exibir.

### 1.2. Camada de Domínio (Domain)

*   **Onde fica?** Esta camada é mais conceitual no nosso projeto. As regras de negócio e a orquestração ficam nos **Controllers** (dentro de `features`), e os contratos (as "regras" do que pode ser feito com os dados) são definidos pelas abstrações dos **Repositories**.
*   **Qual o papel?** Contem as regras de negócio puras e orquestrar o fluxo de dados para a UI. O `Controller` de uma feature pede os dados que precisa através da interface de um `Repository`, sem saber os detalhes de implementação.
*   **Ponto-chave:** O `Controller` não sabe se os dados vêm do Firebase, de uma API REST ou de um banco de dados local. Ele apenas "pede" e confia no contrato do `Repository`.

### 1.3. Camada de Dados (Data)

*   **Onde fica?** Na pasta `app/data/`.
*   **Qual o papel?** É a camada responsável por buscar, salvar e gerenciar os dados, seja de fontes remotas ou locais.
*   **Como separamos?**
    *   **`models`**: Define os objetos e estruturas de dados da aplicação (ex: um `Produto` com `id`, `nome`, `preco`).
    *   **`repositories`**: A implementação concreta dos contratos. É aqui que a lógica de decidir de onde buscar os dados (de um cache ou de uma fonte remota) reside. Ele usa os `providers` para fazer o trabalho sujo.
    *   **`providers`**: A parte mais externa da aplicação. É a implementação que fala diretamente com o mundo exterior (ex: faz as chamadas ao Firestore, se comunica com a API do Firebase Auth, etc.).

### 1.4. Resumo do Fluxo e Organização

1.  **Módulos por Feature**: A organização principal é por funcionalidade (`auth`, `home`, etc.), o que torna fácil encontrar tudo relacionado a uma parte específica do app.
2.  **Separação por Camadas**: Dentro dessa organização, aplicamos os princípios da Arquitetura Limpa.
3.  **Fluxo de Dependência**: O fluxo é sempre `Feature (Controller)` -> `Repository (Contrato)` -> `Repository (Implementação)` -> `Provider`. A interface do usuário depende da lógica de dados, mas a lógica de dados não tem nenhuma dependência da interface.

## 2. Modelagem de Dados

A modelagem segue um padrão NoSQL, otimizado para o Firestore, e é estruturada em coleções principais e sub-coleções.

### 2.1. Coleção `users`
Esta coleção armazena o perfil público de cada usuário. O ID de cada documento é o mesmo `UID` fornecido pelo Firebase Authentication.

*   **`id`** (string): ID do usuário (o mesmo do Auth).
*   **`name`** (string): Nome do usuário.
*   **`email`** (string): Email do usuário.
*   **`phone`** (string, opcional): Telefone do usuário.
*   **`photoUrl`** (string, opcional): URL da foto de perfil.

### 2.2. Coleção `categories`
Armazena as categorias que os usuários criam para organizar suas listas de compras.

*   **`name`** (string): Nome da categoria (ex: "Supermercado Mensal", "Churrasco").
*   **`createdBy`** (string): O `id` do usuário que criou a categoria.
*   **`createdAt`**, **`updatedAt`** (timestamp): Datas de criação e atualização.

### 2.3. Coleção `products`
Funciona como um catálogo de produtos pessoal para cada usuário.

*   **`name`** (string): Nome do produto (ex: "Arroz 5kg").
*   **`description`** (string): Descrição do produto.
*   **`imageUrl`** (string, opcional): URL da imagem do produto.
*   **`ownerId`** (string): O `id` do usuário que cadastrou o produto.
*   **`createdAt`**, **`updatedAt`** (timestamp): Datas de criação e atualização.

### 2.4. Coleção `shopping_lists` (ou `lists`)
A coleção central do aplicativo, contendo as listas de compras.

*   **`name`** (string): Nome da lista (ex: "Compras de Janeiro").
*   **`ownerId`** (string): O `id` do usuário dono da lista.
*   **`status`** (string): O estado atual da lista (ex: "ativa", "finalizada").
*   **`categoryId`** (string): O `id` da categoria à qual a lista pertence.
*   **`memberUIDs`** (array de strings): Uma lista com os `id`s de todos os usuários que são membros desta lista.
*   **`memberPermissions`** (map): Mapeia o `id` de um membro a sua permissão (ex: `{ "user_id_1": "editor" }`).
*   **`totalPrice`** (double): O valor total da lista, calculado.
*   **`createdAt`**, **`purchaseDate`** (timestamp): Datas de criação e da finalização da compra.

### 2.5. Sub-coleção: `items`
Esta é uma parte crucial da modelagem. Em vez de armazenar os produtos dentro de um array no documento da lista, cada lista de compras tem sua própria **sub-coleção** chamada `items`.

A estrutura fica assim: `shopping_lists/{id_da_lista}/items/{id_do_item}`.

Um documento em `items` representa um produto na lista e tem os seguintes campos:

*   **`productId`** (string): O `id` do produto original da coleção `products`.
*   **`productName`**, **`productImageUrl`** (string): Dados duplicados (desnormalizados) do produto para acesso rápido sem precisar de outra consulta.
*   **`quantity`** (double): Quantidade do item na lista.
*   **`unitPrice`** (double): Preço unitário no momento da adição.
*   **`totalItemPrice`** (double): Preço total do item (`quantity` * `unitPrice`).
*   **`isCompleted`** (boolean): Indica se o item já foi "pego" no carrinho (marcado).

Essa abordagem com sub-coleção é muito mais escalável do que usar um array, permitindo que as listas tenham um número virtualmente ilimitado de itens.

## 3. Funcionalidades Chave

### 3.1. Autenticação e Gestão de Perfil
*   **Cadastro de Conta:** Permite que novos usuários se cadastrem usando e-mail and senha.
*   **Login e Logout:** Acesso seguro à conta e capacidade de sair dela.
*   **Recuperação de Senha:** Funcionalidade de "esqueci minha senha" para redefini-la.
*   **Gerenciamento de Perfil:** O usuário pode visualizar e, potencialmente, editar suas informações como nome e foto.

### 3.2. Gestão de Listas de Compras
*   **Criação de Listas:** O usuário pode criar múltiplas listas de compras, atribuindo um nome e uma categoria a elas.
*   **Adição de Itens:** É possível adicionar produtos do catálogo pessoal à lista, especificando a quantidade e o preço.
*   **Interação com a Lista:** Dentro de uma lista ativa, o usuário pode marcar/desmarcar itens como "comprados", e o sistema calcula o preço total em tempo real.
*   **Ciclo de Vida da Lista:** As listas possuem status (ex: "ativa", "finalizada"), permitindo que sejam movidas para um histórico após a conclusão.

### 3.3. Colaboração em Tempo Real
*   **Compartilhamento de Listas:** O dono de uma lista pode convidar outros usuários para participarem dela.
*   **Gerenciamento de Membros:** O dono pode definir permissões para os membros (ex: apenas visualizar ou editar a lista).
*   **Sincronização Automática:** Todas as alterações feitas em uma lista compartilhada (como adicionar ou marcar um item) são refletidas em tempo real para todos os membros.

### 3.4. Catálogo de Produtos Personalizado
*   **Cadastro de Produtos:** Os usuários podem criar seu próprio catálogo de produtos, incluindo nome, descrição, e uma foto.
*   **Reutilização de Produtos:** Facilita a adição de itens recorrentes às listas sem precisar digitar tudo novamente.
*   **Gerenciamento do Catálogo:** Permite editar ou remover produtos já cadastrados.

### 3.5. Histórico e Análise de Gastos
*   **Histórico de Compras:** O aplicativo mantém um registro de todas as listas que foram finalizadas.
*   **Análise de Despesas:** Oferece visualizações (provavelmente com gráficos) que permitem ao usuário analisar seus gastos ao longo do tempo, filtrando por período ou categoria.

## 4. Usabilidade e Navegação

### Tecnologia de Navegação: GetX

O projeto utiliza o pacote **GetX** para todo o gerenciamento de estado e, crucialmente, para a navegação. Esta escolha impacta diretamente a usabilidade e a implementação:

*   **Navegação por Rotas Nomeadas:** Em vez de chamar uma tela diretamente, nós navegamos para "nomes" de rotas (ex: `/home`, `/login`, `/lista/123`). Isso é uma boa prática porque desacopla a lógica de navegação das telas em si.
*   **Centralização das Rotas:** Todas as rotas e suas transições estão definidas em um único lugar, o arquivo `app/routes/app_pages.dart`. Isso torna a manutenção e a visualização do fluxo do app muito mais simples.
*   **Sintaxe Simplificada:** GetX permite navegar sem a necessidade de `BuildContext`, com comandos simples como `Get.toNamed('/detalhes')` para ir para uma tela e `Get.back()` para voltar.

### Padrões de Navegação do Usuário

A experiência do usuário no aplicativo é construída sobre alguns padrões de navegação bem estabelecidos:

1.  **Menu de Navegação Principal (Drawer):** O app usa um menu lateral (Drawer) como o principal hub de navegação. O usuário pode abri-lo de qualquer tela principal para acessar as áreas-chave do aplicativo, como:
    *   Home (tela inicial de listas)
    *   Produtos (seu catálogo)
    *   Categorias
    *   Histórico de Compras
    *   Análise de Gastos
    *   Perfil

2.  **Navegação em Pilha (Stack Navigation):** Este é o padrão mais comum para fluxos de tarefas. Quando o usuário realiza uma ação que o leva a uma nova tela, essa nova tela é "empilhada" sobre a anterior.
    *   **Exemplo:** O usuário está na tela `Home` (com a lista de todas as suas listas de compras) -> ele toca em uma lista específica -> a tela de `Detalhes da Lista` é empilhada na frente -> ele toca no botão de voltar e retorna para a `Home`.
    *   Isso cria um fluxo lógico e previsível, onde o botão "voltar" do dispositivo sempre leva à etapa anterior.

3.  **Navegação por Abas (TabBar - provável):** É muito provável que em certas telas, como na `Home` ou no `Histórico`, sejam usadas abas (Tabs) para alternar entre visualizações relacionadas.
    *   **Exemplo:** Na tela de listas, pode haver abas para "Listas Ativas" e "Listas Finalizadas", permitindo que o usuário alterne rapidamente entre elas sem sair da tela principal.

### Resumo da Usabilidade de Navegação

A combinação de um **Drawer** para navegação global, **Navegação em Pilha** para tarefas específicas, e **Abas** para conteúdo secundário cria uma arquitetura de informação clara e uma experiência de usuário intuitiva. O uso de **GetX** para gerenciar isso nos bastidores garante que a implementação seja robusta e de fácil manutenção.
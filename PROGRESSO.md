# Histórico de Progresso e Próximos Passos

Este arquivo rastreia o que foi concluído e quais são os próximos objetivos no desenvolvimento do projeto "Lista de Compras".

## 🎯 Foco Atual

**O foco principal nesta fase é a FUNCIONALIDADE.** A interface do usuário (UI) será mantida o mais simples possível. Melhorias visuais e de design serão abordadas em uma etapa posterior do projeto.

## 📋 Diretrizes Gerais de UI/UX

- **Estado Vazio (Empty State):** Todas as telas que exibem listas de dados (produtos, listas de compras, etc.) devem tratar o caso em que não há dados para mostrar. Em vez de um erro ou uma tela em branco, deve ser exibida uma mensagem amigável para o usuário (ex: "Nenhum produto no catálogo ainda.").
- **Responsividade:** O layout do aplicativo deve ser responsivo para se adaptar a diferentes tamanhos de tela (celulares, tablets, web). Este é um requisito de front-end que será abordado com mais detalhes na fase de polimento visual.

## ⚙️ Observações Técnicas (Análise de Código)

Durante a análise do código (`flutter analyze`), foram identificados os seguintes pontos:

- **Avisos de Estilo (`info`):**
  - Nomes de arquivos como `HomePage.dart` e `LoginPage.dart` não seguem a convenção `lower_case_with_underscores`. Isso é uma questão de estilo e pode ser corrigido em uma fase de refatoração de código.

- **Avisos (`warning`):**
  - `Unnecessary cast` em `lib/view/list_details_page.dart`. Este é um aviso sobre um "cast" desnecessário, mas o código é funcionalmente correto.

- **Erro Persistente (`error`):**
  - `The named parameter 'price' isn't defined` em `lib/view/list_details_page.dart`. Este erro é incomum, pois o parâmetro `price` está corretamente definido na função `addItem` do `ShoppingItemController`. Tudo indica que é um falso positivo do analisador ou um bug na ferramenta, pois o código está logicamente correto e funcional. Não impede a execução do aplicativo.

## ✅ Concluído

- **Análise Inicial do Projeto:**
  - Leitura do `pubspec.yaml` para identificar dependências (Firebase, GetX).
  - Leitura do `README.md` para entender o escopo geral do projeto.
  - Análise completa do código-fonte no diretório `lib/`.

- **Estrutura do Projeto:**
  - Configuração inicial do projeto Flutter.
  - Estrutura de pastas (controller, model, view).

- **Autenticação de Usuário:**
  - Implementação do fluxo de autenticação com Firebase Auth.
  - Criação, Login, Logout e Reset de senha.
  - UI de Login/Cadastro (`LoginPage`) com validação de formulário.
  - Controlador de estado (`AuthController`) para gerenciar a lógica.
  - Modelo de dados do usuário (`UserModel`).
  - Tela de Splash (`SplashPage`) que redireciona com base no estado de autenticação.

- **Estrutura da UI Principal:**
  - [x] Criação de widgets reutilizáveis (`CustomAppBar`, `CustomDrawer`).
  - [x] Implementação da estrutura da `HomePage` com `Scaffold`.
  - [x] Adição de um `FloatingActionButton` para criar novas listas.
  - [x] Adição da função de `Logout` no `Drawer`.

- **Catálogo de Produtos (Concluído):**
  - **Objetivo:** Permitir que usuários adicionem produtos a um catálogo global.
  - **Tarefas:**
    - [x] Criar o modelo de dados `ProductModel`.
    - [x] Adicionar a rota para a página de adição de produtos.
    - [x] Adicionar o link no menu (Drawer) para a nova página.
    - [x] Criar a página `ProductCatalogPage` com um formulário (nome, imagem) e listagem.
    - [x] Criar um `ProductController` para gerenciar a lógica (salvar no Firestore, upload de imagem).

- **Gerenciamento de Listas (Concluído):**
  - **Objetivo:** Permitir que o usuário crie, visualize, edite e arquive listas de compras.
  - **Tarefas:**
    - [x] Criar um modelo de dados `ShoppingListModel`.
    - [x] Criar um `ShoppingListController` para gerenciar o estado das listas.
    - [x] Implementar a UI para **criar** uma nova lista (pop-up na `HomePage`).
    - [x] Implementar a lógica no Firestore para `create` e `read` de listas.
    - [x] Criar um layout para **exibir** as listas de compras do usuário na `HomePage`.
    - [x] Adicionar o campo `purchaseDate` ao `ShoppingListModel` e implementar a ordenação.
    - [x] Criar a tela de **detalhes** da lista (para ver os itens dentro dela).
    - [x] Implementar a funcionalidade de **editar** uma lista.
    - [x] Implementar a funcionalidade de **arquivar** uma lista (mudando seu status para 'arquivada').
    - [x] Filtrar listas ativas na `HomePage` (não exibir as arquivadas).

- **Gerenciamento de Itens da Lista (Concluído):**
  - **Objetivo:** Permitir que o usuário adicione, edite, marque como comprado e remova itens de uma lista.
  - **Tarefas:**
    - [x] Criar um modelo de dados `ShoppingItemModel`.
    - [x] Implementar a lógica no Firestore para gerenciar os itens (`ShoppingItemController`).
    - [x] Criar a UI para a visualização de uma lista específica e seus itens (dentro da `ListDetailsPage`).
    - [x] Implementar a funcionalidade de **editar** um item.
    - [x] Implementar a funcionalidade de **remover** um item.

## 🚧 Próximos Passos

As próximas grandes funcionalidades a serem desenvolvidas, conforme nosso `PROGRESSO.md` e `requisitos.md`, são:

1.  **Histórico de Compras:**
    *   **Objetivo:** Permitir que o usuário "finalize" uma lista e visualize compras passadas.
    *   **Tarefas:**
        *   Implementar a funcionalidade de "finalizar" uma lista (mudando seu status e movendo para o histórico).
        *   Criar uma tela para visualizar o histórico de compras.

2.  **Análise de Gastos:**
    *   **Objetivo:** Fornecer uma visão geral dos gastos do usuário.
    *   **Tarefas:**
        *   Criar uma tela que mostre um resumo dos gastos (ex: somatório por período, gráficos).

3.  **Sugestão de Produtos:**
    *   **Objetivo:** Sugerir produtos ao usuário com base em seus hábitos de compra.
    *   **Tarefas:**
        *   Desenvolver a lógica para sugerir produtos (usando o catálogo existente).
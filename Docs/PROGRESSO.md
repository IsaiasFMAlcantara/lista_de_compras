# Histórico de Progresso e Próximos Passos

Este arquivo rastreia o que foi concluído e quais são os próximos objetivos no desenvolvimento do projeto "Lista de Compras".

## 🎯 Foco Atual

**O foco principal nesta fase é a FUNCIONALIDADE.** A interface do usuário (UI) será mantida o mais simples possível. Melhorias visuais e de design serão abordadas em uma etapa posterior do projeto.

## 📋 Diretrizes Gerais de UI/UX

- **Estado Vazio (Empty State):** Todas as telas que exibem listas de dados (produtos, listas de compras, etc.) devem tratar o caso em que não há dados para mostrar. Em vez de um erro ou uma tela em branco, deve ser exibida uma mensagem amigável para o usuário (ex: "Nenhum produto no catálogo ainda.").
- **Responsividade:** O layout do aplicativo deve ser responsivo para se adaptar a diferentes tamanhos de tela (celulares, tablets, web). Este é um requisito de front-end que será abordado com mais detalhes na fase de polimento visual.

## ⚙️ Observações Técnicas (Análise de Código)

Durante a análise do código (`flutter analyze`), **nenhum problema foi encontrado**. O código está limpo e segue as diretrizes de análise.
- **Centralização de Design:** O plano é centralizar toda a parte de beleza (design/front-end) do projeto em um arquivo `theme.dart` para facilitar a manutenção e padronização visual.

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

- **Histórico de Compras (Concluído):**
    - [x] **Objetivo:** Permitir que o usuário "finalize" uma lista e visualize compras passadas.
    - [x] **Tarefas:**
        - [x] Implementar a funcionalidade de "finalizar" uma lista (mudando seu status e movendo para o histórico).
        - [x] Criar uma tela para visualizar o histórico de compras.

- **Análise de Gastos (Concluído):**
    - [x] **Objetivo:** Fornecer uma visão geral dos gastos do usuário, com filtro por período e gráfico de pizza por categoria.
    - [x] **Tarefas:**
        - [x] Adicionar campo `category` ao `ShoppingListModel` e UI de criação/edição de listas.
        - [x] Criar a tela de "Análise de Gastos" com filtros de data, valor total e gráfico de pizza por categoria.

## 🚧 Próximos Passos

As próximas grandes funcionalidades a serem desenvolvidas, conforme nosso `PROGRESSO.md` e `requisitos.md`, são:

1.  **Sugestão de Produtos:**
    *   **Objetivo:** Sugerir produtos ao usuário com base em seus hábitos de compra.
    *   **Tarefas:**
        *   Desenvolver a lógica para sugerir produtos (usando o catálogo existente).

## 🏆 Etapas Bônus (Diferenciais)

Após a conclusão das funcionalidades essenciais, estas são as etapas propostas para elevar o nível do aplicativo:

### 1. Arquitetura de Notificações Agendadas via Firebase

**Objetivo:** Enviar uma notificação push para o usuário na data de compra agendada em uma lista.
- **Status Atual:** A configuração do lado do cliente (Flutter) para agendar notificações no Firestore está concluída. A implementação e o deploy da função Firebase (backend) para enviar as notificações estão pendentes devido a dificuldades no setup do ambiente Python.

**Arquitetura Proposta:**

- **Flutter (Front-end):**
  - Obtém e salva o token de dispositivo (FCM Token) do usuário.
  - Ao agendar uma data de compra, salva as informações (`data`, `título`, `corpo da mensagem`, `token`) em uma coleção no Cloud Firestore (ex: `agendamentos_notificacoes`).

- **Firebase Functions (Back-end):**
  - Uma função `cron` (agendada) executa a cada X minutos (ex: 10 minutos).
  - A função varre a coleção de agendamentos, procurando por documentos cuja data/hora seja igual ou anterior à hora atual.
  - Para cada documento encontrado, a função utiliza o Firebase Cloud Messaging (FCM) para disparar a notificação para o token armazenado.
  - Após o envio bem-sucedido, o documento correspondente é removido do Firestore para evitar envios duplicados.

### 2. Sistema de Sugestões Inteligentes com IA

**Objetivo:** Oferecer sugestões de produtos personalizadas, baseadas nos padrões de compra do usuário.

**Arquitetura Proposta:**

- **Cloud Function (Python):**
  - Uma Cloud Function em Python servirá como o cérebro da operação, executando a análise dos dados.

- **Firebase Firestore:**
  - As listas de compras finalizadas são a fonte de dados primária.
  - Uma nova coleção (ex: `sugestoes_usuario`) armazenará os resultados da análise para cada usuário.

- **Cloud Scheduler:**
  - Um job agendado (ex: toda madrugada) acionará a Cloud Function para processar os dados do dia anterior.

**Fluxo de Trabalho:**

1.  **Coleta de Dados:** O app salva as listas finalizadas no Firestore.
2.  **Processamento Agendado:** O Cloud Scheduler ativa a Cloud Function.
3.  **Análise de Padrões:** A função lê o histórico de compras e aplica algoritmos de Machine Learning:
    - **Análise de Recorrência:** Identifica com que frequência um item é comprado (ex: "Leite" a cada 7 dias).
    - **Análise de Associação (Regra de Associação - Apriori):** Descobre itens que são frequentemente comprados juntos (ex: quem compra "Pão" também costuma comprar "Manteiga").
4.  **Armazenamento das Sugestões:** Os resultados (ex: "Lembrete: talvez seja hora de comprar Leite" ou "Que tal levar Manteiga junto com o Pão?") são salvos na coleção de sugestões do usuário.
5.  **Exibição no App:** O Flutter lê a coleção de sugestões e as exibe de forma inteligente para o usuário no momento apropriado.

_**[A SER DESENVOLVIDO: Elementos pré-textuais como Capa, Folha de Rosto, etc.]**_

## Resumo
Este trabalho detalha o desenvolvimento de um aplicativo multiplataforma para gerenciamento inteligente de listas de compras, utilizando o framework Flutter e a plataforma Firebase. O projeto aborda desafios comuns na organização de compras, como a colaboração entre usuários, o controle de despesas e o planejamento de itens recorrentes. A arquitetura da solução foi baseada no padrão Model-View-ViewModel (MVVM), em conjunto com o Padrão de Repositório para abstração do acesso a dados, garantindo um código desacoplado, testável e de fácil manutenção. Como principais resultados, o aplicativo implementa funcionalidades de compartilhamento de listas com controle de permissões, análise de gastos com visualização gráfica e um sistema de sugestão de produtos baseado no histórico de compras do usuário. O trabalho conclui que a utilização do ecossistema Flutter/Firebase se mostrou eficaz para a entrega de uma solução de software robusta, escalável e com uma experiência de usuário rica e funcional.

**Palavras-chave:** Flutter, Firebase, Aplicativo Móvel, Lista de Compras, MVVM, Desenvolvimento Multiplataforma.

## Abstract
This paper details the development of a multi-platform application for intelligent shopping list management, using the Flutter framework and the Firebase platform. The project addresses common challenges in organizing purchases, such as collaboration between users, expense tracking, and planning for recurring items. The solution's architecture was based on the Model-View-ViewModel (MVVM) pattern, along with the Repository Pattern for data access abstraction, ensuring a decoupled, testable, and easily maintainable codebase. As main results, the application implements features for sharing lists with permission control, spending analysis with graphical visualization, and a product suggestion system based on the user's purchase history. The work concludes that the use of the Flutter/Firebase ecosystem proved effective for delivering a robust, scalable software solution with a rich and functional user experience.

**Keywords:** Flutter, Firebase, Mobile Application, Shopping List, MVVM, Multi-platform Development.

_**[A SER DESENVOLVIDO: Sumário]**_

# 1. INTRODUÇÃO

## 1.1. Contextualização do Problema
O gerenciamento de compras domésticas, embora seja uma tarefa rotineira na vida de milhões de pessoas, apresenta desafios significativos na era digital. A utilização de métodos analógicos, como listas em papel, ou ferramentas digitais genéricas, como aplicativos de notas, frequentemente resulta em ineficiências. Entre os problemas mais comuns estão a dificuldade de coordenação de listas entre múltiplos membros de uma família, a falta de um controle claro sobre os gastos, o esquecimento de itens recorrentes e a ausência de um histórico para consulta e planejamento futuro. Este cenário evidencia a necessidade de uma solução de software dedicada, projetada especificamente para otimizar e centralizar todo o ciclo de vida do processo de compras, desde o planejamento até a análise pós-compra.

## 1.2. Objetivo Geral e Objetivos Específicos
Este trabalho tem como objetivo geral o projeto e desenvolvimento de um aplicativo multiplataforma, funcional e robusto, para o gerenciamento inteligente de listas de compras, utilizando o framework Flutter para o front-end e a plataforma Firebase como back-end.

Para alcançar o objetivo geral, foram delineados os seguintes objetivos específicos:

- Implementar um sistema seguro de cadastro e autenticação de usuários, garantindo a privacidade e a persistência dos dados em nuvem;
- Desenvolver a funcionalidade de criação e gerenciamento de múltiplas listas de compras, permitindo sua edição, arquivamento e exclusão;
- Permitir a adição, edição e remoção de itens nas listas, com informações detalhadas de nome, quantidade e valor;
- Habilitar o compartilhamento de listas entre diferentes usuários, com um sistema de permissões que possibilite a colaboração em tempo real;
- Implementar a funcionalidade de finalizar uma compra, calculando o valor total e movendo a lista para um registro histórico permanente;
- Disponibilizar a consulta ao histórico de compras, exibindo detalhes como valores totais e os itens adquiridos em cada compra;
- Criar uma tela de análise de gastos, com visualização de dados por período e categoria através de gráficos interativos;
- Desenvolver um sistema de sugestão de produtos com base no histórico de compras do usuário, visando agilizar o processo de criação de novas listas.

## 1.3. Justificativa
A relevância deste projeto reside na sua capacidade de oferecer uma solução tecnológica direcionada para um problema cotidiano, impactando positivamente a organização financeira e a rotina de seus usuários. Em um cenário onde aplicativos móveis otimizam diversas áreas da vida pessoal, uma ferramenta especialista em compras se justifica por centralizar funcionalidades que hoje se encontram dispersas ou são realizadas de forma manual e ineficiente. A capacidade de compartilhar listas em tempo real resolve um problema crônico em ambientes familiares, eliminando a necessidade de comunicação descoordenada. Adicionalmente, as funcionalidades de análise de gastos e sugestões inteligentes oferecem ao usuário um maior controle e consciência sobre seus hábitos de consumo, promovendo não apenas organização, mas também potencial economia e planejamento financeiro.

## 1.4. Estrutura do Trabalho
Este trabalho está organizado em seis capítulos, de modo a apresentar uma visão completa do projeto. O Capítulo 2 aborda a fundamentação teórica, detalhando as tecnologias, os padrões arquiteturais e os conceitos que sustentam o desenvolvimento da aplicação. O Capítulo 3 descreve a metodologia de trabalho adotada, incluindo as ferramentas e as etapas do desenvolvimento. O Capítulo 4 apresenta em detalhes o processo de desenvolvimento e implementação da solução, incluindo sua arquitetura, estrutura de dados e as funcionalidades criadas. O Capítulo 5 expõe e discute os resultados obtidos com a implementação do software. Por fim, o Capítulo 6 apresenta a conclusão do trabalho, as limitações identificadas durante o projeto e as propostas para trabalhos futuros.

# 2. FUNDAMENTAÇÃO TEÓRICA
Neste capítulo, são apresentados os conceitos, tecnologias e padrões de arquitetura que formam a base para o desenvolvimento do aplicativo "Lista de Compras". A escolha de cada componente foi estratégica para atender aos requisitos de multiplataforma, escalabilidade e manutenibilidade do projeto.

## 2.1. Flutter e o Desenvolvimento Multiplataforma
Flutter é um framework de código aberto, mantido pela Google, para a criação de interfaces de usuário (UI) compiladas nativamente para aplicações móveis, web e desktop a partir de uma única base de código. Sua arquitetura é fundamentada na linguagem de programação Dart, também desenvolvida pela Google, que é otimizada para a construção de UIs e compilada para código de máquina ARM ou x86, além de JavaScript para a web. O paradigma central do Flutter é a composição de widgets, onde a interface é construída através da combinação de pequenos componentes reutilizáveis, que o próprio framework fornece em abundância, seguindo as diretrizes de design do Material Design e Cupertino.

A principal vantagem do Flutter, e a razão de sua escolha para este projeto, é a capacidade de entregar uma experiência de usuário consistente e de alta performance em diferentes plataformas (Android, iOS, Web) com um esforço de desenvolvimento significativamente reduzido em comparação com o desenvolvimento nativo para cada plataforma. Isso elimina a necessidade de manter bases de código separadas, otimizando o tempo e os recursos do projeto.

## 2.2. Firebase: Backend-as-a-Service (BaaS)
Firebase é uma plataforma de desenvolvimento de aplicativos da Google que fornece uma suíte de serviços de back-end (Backend-as-a-Service), permitindo que os desenvolvedores se concentrem na lógica de negócio e na experiência do usuário sem a necessidade de gerenciar a infraestrutura do servidor. Para este projeto, os seguintes serviços foram essenciais:

- **Firebase Authentication:** Oferece um serviço completo e seguro para gerenciar o fluxo de autenticação de usuários. Ele suporta diversos métodos, como e-mail/senha e provedores sociais, e lida com toda a complexidade de armazenamento de credenciais, hashing de senhas e segurança, abstraindo essa responsabilidade do desenvolvedor.
- **Cloud Firestore:** É um banco de dados NoSQL, flexível e escalável, orientado a documentos e com sincronização de dados em tempo real. Foi utilizado como a principal fonte de persistência para todos os dados da aplicação, como listas, produtos e perfis de usuário. Sua natureza NoSQL permite uma modelagem de dados flexível, e sua capacidade de sincronização em tempo real é fundamental para a funcionalidade de compartilhamento de listas.
- **Firebase Storage:** Provê armazenamento seguro e escalável para o upload e download de arquivos gerados pelo usuário, como as imagens dos produtos. Ele desacopla o armazenamento de arquivos binários do banco de dados principal, o que é uma prática recomendada para performance e organização.

## 2.3. Padrão de Arquitetura MVVM (Model-View-ViewModel)
A arquitetura do projeto foi estruturada com base no padrão de projeto de interface de usuário Model-View-ViewModel (MVVM), que promove uma clara separação de responsabilidades entre a interface e a lógica de negócios.

- **Model:** Representa os dados e a lógica de negócios fundamental. No contexto deste projeto, são classes puras em Dart que definem a estrutura dos dados (ex: `ShoppingListModel`, `UserModel`).
- **View:** É a camada de apresentação (UI), composta por widgets Flutter. Sua única responsabilidade é exibir os dados para o usuário e capturar suas interações (como toques em botões), delegando toda a lógica de negócio para o ViewModel.
- **ViewModel (Controller):** Atua como um intermediário entre o Model e a View. Ele contém a lógica de apresentação e o estado da UI (ex: `isLoading`). Ele expõe os dados do Model para a View de uma forma que a View possa consumir facilmente e provê comandos (funções) que a View pode invocar em resposta às interações do usuário. No contexto do framework GetX, utilizado no projeto, os `Controllers` desempenham o papel de ViewModel.

## 2.4. Padrão de Repositório (Repository Pattern)
Para desacoplar a lógica de negócios da fonte de dados, foi implementado o Padrão de Repositório. As classes de repositório (ex: `ShoppingListRepository`, `AuthRepository`) encapsulam toda a lógica de acesso aos dados do Firebase. Os `Controllers` (ViewModels) interagem com os repositórios através de uma interface bem definida, sem conhecer os detalhes de implementação do acesso ao banco de dados (se é Firestore, uma API REST, etc.). Essa abstração é crucial para a testabilidade, permitindo a criação de testes unitários com repositórios "mockados" (simulados), e para a manutenibilidade do sistema, pois permite a troca da fonte de dados no futuro com impacto mínimo no restante da aplicação.

## 2.5. Gerenciamento de Estado com GetX
GetX foi a biblioteca escolhida para atuar como uma solução completa de microframework, provendo não apenas o gerenciamento de estado, mas também injeção de dependências e roteamento. Seu sistema de gerenciamento de estado reativo, que utiliza variáveis observáveis (`.obs`) e widgets reativos (`Obx`), permite que a UI se reconstrua automaticamente apenas nas partes necessárias em resposta a mudanças de estado. Isso resulta em um código mais limpo, performático e com menos verbosidade em comparação com abordagens nativas do Flutter como `StatefulWidget` e `setState()`, simplificando o desenvolvimento e a manutenção da reatividade da interface.

## 2.6. Revisão de Literatura Acadêmica _**[A SER DESENVOLVIDO]**_
_**[Nesta seção, será incluída uma revisão aprofundada da literatura acadêmica, com citações a autores e trabalhos de referência que discutam os méritos e desafios do desenvolvimento de software multiplataforma, realizem comparações teóricas entre padrões de arquitetura mobile (MVC, MVP, MVVM), e analisem o impacto de plataformas BaaS no ciclo de vida e na agilidade do desenvolvimento de software moderno. Todas as fontes serão devidamente catalogadas e apresentadas na seção de Referências, seguindo a norma ABNT.]**_

# 3. METODOLOGIA
Este capítulo descreve a metodologia empregada para o planejamento e a execução do projeto, detalhando a abordagem de desenvolvimento, as ferramentas tecnológicas utilizadas e as etapas sequenciais que guiaram a implementação do software desde a concepção até a sua finalização.

## 3.1. Abordagem de Desenvolvimento
O projeto seguiu uma abordagem de desenvolvimento incremental, que consiste em dividir o trabalho em fases com objetivos claros e entregas de funcionalidades específicas. Essa metodologia foi escolhida por permitir um desenvolvimento estruturado, com validação contínua do progresso em relação aos requisitos previamente definidos. O ciclo de vida do projeto foi dividido em etapas, começando com as funcionalidades base do sistema, como a autenticação de usuários, e evoluindo incrementalmente para funcionalidades mais complexas, como o compartilhamento de listas e a análise de gastos.

O planejamento e a execução de cada etapa seguiram um cronograma predefinido, conforme detalhado na Tabela 1, que serviu como um guia para o gerenciamento do tempo e dos recursos ao longo do desenvolvimento.

**Tabela 1: Cronograma de Desenvolvimento das Funcionalidades**
| Requisito / Tarefa                                   | Data Início | Data Fim   |
| ---------------------------------------------------- | ----------- | ---------- |
| Cadastro e autenticação de usuários                  | 01/09/2025  | 03/09/2025 |
| Gerenciar listas de compras (criar, editar, excluir) | 04/09/2025  | 08/09/2025 |
| Adicionar itens às listas (nome, quantidade, valor)  | 09/09/2025  | 11/09/2025 |
| Editar e remover itens já cadastrados                | 12/09/2025  | 13/09/2025 |
| Finalizar lista e salvar no histórico                | 14/09/2025  | 15/09/2025 |
| Consultar histórico de compras                       | 16/09/2025  | 17/09/2025 |
| Visualizar análise de gastos                         | 18/09/2025  | 19/09/2025 |
| Sugestão de produtos                                 | 20/09/2025  | 21/09/2025 |
| Testes finais e ajustes                              | 22/09/2025  | 30/09/2025 |
*(Fonte: O autor, 2025)*

## 3.2. Ferramentas e Ambiente de Desenvolvimento
Para a construção do aplicativo, foi utilizado um conjunto de tecnologias modernas e consolidadas no mercado de desenvolvimento de software, compondo o seguinte ambiente de desenvolvimento:

- **Linguagem de Programação:** Dart (versão 3.x), uma linguagem de programação otimizada para clientes, desenvolvida pela Google, que é a base para o framework Flutter.
- **Framework de UI:** Flutter (versão 3.x), o framework da Google para construção de interfaces de usuário compiladas nativamente para múltiplas plataformas a partir de uma única base de código.
- **Plataforma de Backend (BaaS):** Google Firebase, que proveu os serviços essenciais de back-end para a aplicação.
- **Banco de Dados:** Cloud Firestore, o banco de dados NoSQL em nuvem do Firebase, utilizado para a persistência de todos os dados da aplicação.
- **Serviço de Autenticação:** Firebase Authentication, utilizado para gerenciar de forma segura todo o ciclo de vida de autenticação dos usuários.
- **Serviço de Armazenamento de Arquivos:** Firebase Storage, utilizado para o armazenamento de arquivos binários, como as imagens dos produtos.
- **Gerenciamento de Estado e Dependências:** Biblioteca GetX, uma solução completa para gerenciamento de estado, injeção de dependências e roteamento no ecossistema Flutter.
- **Ambiente de Desenvolvimento Integrado (IDE):** Visual Studio Code, um editor de código leve e poderoso, com extensões que otimizam o desenvolvimento em Dart e Flutter.
- **Sistema de Controle de Versão:** Git, o sistema de controle de versão distribuído mais utilizado no mundo, com o repositório do projeto hospedado na plataforma GitHub para gerenciamento e colaboração.

# 4. DESENVOLVIMENTO E IMPLEMENTAÇÃO
Este capítulo apresenta o processo de construção da aplicação "Lista de Compras", detalhando a implementação da arquitetura de software, a modelagem da estrutura de dados, o fluxo de navegação do usuário através das telas e as soluções técnicas adotadas para as funcionalidades mais relevantes do sistema.

## 4.1. Arquitetura da Solução
Conforme antecipado na fundamentação teórica, a aplicação foi construída sobre o padrão de arquitetura Model-View-ViewModel (MVVM), utilizando o framework GetX para sua implementação. A interação entre as camadas foi projetada para garantir um alto nível de desacoplamento e separação de responsabilidades, conforme ilustrado no Diagrama 1.

_**[INSERIR DIAGRAMA 1: ARQUITETURA DE CAMADAS DO APLICATIVO]**_

O fluxo de dados e eventos ocorre da seguinte forma:

1.  A **View** (telas em Flutter) é responsável exclusivamente pela apresentação da UI. Ela captura as interações do usuário (ex: um toque em um botão) e invoca um comando no **Controller** correspondente.
2.  O **Controller** (atuando como ViewModel) contém a lógica de apresentação e o estado da UI. Ele processa a requisição da View e solicita os dados ou operações necessárias ao **Repository**.
3.  O **Repository** encapsula toda a lógica de acesso à fonte de dados. Ele recebe as chamadas do Controller e as traduz em operações específicas para o **Firebase** (leituras ou escritas no Firestore, por exemplo).
4.  As atualizações de estado no Controller, resultantes das operações, são observadas pela View de forma reativa, que se reconstrói para exibir os dados atualizados ao usuário.

A injeção de dependências, gerenciada pelo sistema de `Bindings` do GetX, garante que as instâncias dos repositórios e outros serviços sejam criadas de forma centralizada e disponibilizadas aos controllers de maneira desacoplada, através do localizador de serviços `Get.find()`.

A seguir, cada uma dessas camadas é detalhada.

### 4.2. Modelagem de Dados do Sistema (Model)
A arquitetura de dados da aplicação é fundamentada em quatro modelos principais, que representam as entidades centrais do sistema: Usuários, Produtos, Listas de Compras e os Itens dentro dessas listas.

#### 4.2.1. `UserModel` (Modelo de Usuário)
O `UserModel` armazena as informações do usuário da aplicação. A estrutura foi projetada para conter dados essenciais de identificação e contato.

*   **Atributos Principais:**
    *   `id`: Identificador único do usuário, geralmente obtido através do serviço de autenticação (Firebase Authentication).
    *   `name`: Nome do usuário.
    *   `email`: Endereço de e-mail, utilizado para login e comunicação.
    *   `phone`: Número de telefone.
    *   `fcmToken`: Um token específico do dispositivo, utilizado pelo Firebase Cloud Messaging (FCM) para o envio de notificações push, como convites para listas compartilhadas.

#### 4.2.2. `ProductModel` (Modelo de Produto)
O `ProductModel` define a estrutura para um item no catálogo global de produtos. Este catálogo permite que produtos comuns sejam pré-cadastrados e reutilizados pelos usuários em suas listas, agilizando o processo de criação.

*   **Atributos Principais:**
    *   `id`: Identificador único do produto no banco de dados.
    *   `name`: Nome do produto (ex: "Leite Integral").
    *   `imageUrl`: URL para uma imagem do produto.
    *   `createdBy`: Identificador do usuário que adicionou o produto ao catálogo.
    *   `status`: Indica a disponibilidade do produto no catálogo (ex: "ativo").

#### 4.2.3. `ShoppingListModel` (Modelo de Lista de Compras)
Este é um dos modelos mais complexos e centrais, representando uma lista de compras. Ele não só contém os dados da lista em si, mas também gerencia o compartilhamento e o estado dela.

*   **Atributos Principais:**
    *   `id`: Identificador único da lista.
    *   `name`: Nome descritivo da lista (ex: "Compras do Mês").
    *   `ownerId`: Identificador do usuário que criou a lista.
    *   `members`: Um mapa que associa identificadores de usuários (`UID`) a suas permissões (ex: 'owner', 'editor'). Este atributo é a base para a funcionalidade de compartilhamento em tempo real.
    *   `category`: Categoria da lista (ex: "Mercado", "Farmácia"), para fins de organização e análise.
    *   `status`: Estado atual da lista (ex: "ativa", "finalizada").
    *   `totalPrice`: Armazena o valor total calculado quando a lista é finalizada, servindo como dado para o histórico de gastos.

#### 4.2.4. `ShoppingItemModel` (Modelo de Item da Lista)
O `ShoppingItemModel` representa um item específico que pertence a uma `ShoppingListModel`. É a menor unidade de uma lista de compras.

*   **Atributos Principais:**
    *   `id`: Identificador único do item dentro da lista.
    *   `listId`: Referência à lista de compras (`ShoppingListModel`) à qual o item pertence.
    *   `name`: Nome do item (ex: "Caixa de Ovos").
    *   `quantity`: Quantidade desejada do item.
    *   `price`: Preço unitário ou total do item (opcional).
    *   `isCompleted`: Campo booleano que indica se o item já foi coletado/comprado, permitindo o acompanhamento do progresso da compra.
    *   `productId`: Campo opcional que vincula o item a um `ProductModel` do catálogo global, permitindo o reaproveitamento de dados do produto.

### 4.3. Camada de Acesso a Dados (Repositórios)
A comunicação entre a lógica de negócios da aplicação e o banco de dados (Cloud Firestore) é abstraída por uma camada de repositórios. Cada repositório é responsável pelo gerenciamento de uma entidade específica do sistema, encapsulando as operações de leitura, escrita, atualização e exclusão de dados (CRUD), além de expor fluxos de dados em tempo real (`Stream`).

#### 4.3.1. `AuthRepository` (Repositório de Autenticação)
Este repositório gerencia todos os aspectos relacionados à autenticação e aos dados do usuário.

*   **Responsabilidades:**
    *   **Autenticação:** Encapsula os métodos do Firebase Authentication para criar um novo usuário (`createUserWithEmailAndPassword`), realizar login (`signInWithEmailAndPassword`), redefinir senha (`sendPasswordResetEmail`) e fazer logout (`signOut`).
    *   **Gerenciamento de Dados no Firestore:** Após a autenticação, ele é responsável por salvar (`createUserInFirestore`) e buscar (`getUserModelFromFirestore`) os dados do perfil do usuário na coleção `users` do Firestore.
    *   **Atualizações Específicas:** Contém lógicas para atualizar o token de notificação (`updateUserFCMToken`) e para buscar um usuário pelo seu e-mail (`getUserByEmail`), funcionalidade essencial para o compartilhamento de listas.

#### 4.3.2. `ProductRepository` (Repositório de Produtos)
Gerencia as operações relacionadas ao catálogo global de produtos.

*   **Responsabilidades:**
    *   **Leitura de Dados:** Fornece um fluxo contínuo (`Stream`) de todos os produtos do catálogo, ordenados por nome (`getProductsStream`), permitindo que a interface do usuário se atualize em tempo real.
    *   **Criação e Modificação:** Contém métodos para adicionar (`addProduct`), atualizar (`updateProduct`) e excluir (`deleteProduct`) produtos do catálogo.
    *   **Upload de Imagem:** Inclui uma função (`uploadImage`) que lida com o upload de imagens de produtos para o Firebase Storage, retornando a URL da imagem para ser armazenada no Firestore.

#### 4.3.3. `ShoppingListRepository` (Repositório de Listas de Compras)
É responsável por gerenciar as listas de compras, que são a entidade principal do aplicativo.

*   **Responsabilidades:**
    *   **Leitura de Listas:** Fornece `Streams` para obter listas ativas (`getShoppingListsStream`) e listas do histórico (`getHistoricalListsStream`) nas quais o usuário atual é um membro. Isso garante que a tela inicial e a de histórico sempre mostrem dados atualizados.
    *   **Operações CRUD:** Permite adicionar (`addList`) e atualizar (`updateList`) uma lista de compras.
    *   **Buscas e Filtros:** Possui uma lógica de consulta avançada (`getFilteredShoppingLists`) para filtrar listas do histórico por um intervalo de datas, funcionalidade utilizada na tela de análise de gastos.

#### 4.3.4. `ShoppingItemRepository` (Repositório de Itens da Lista)
Este repositório gerencia os itens individuais que compõem uma lista de compras. As operações são sempre vinculadas a uma lista específica.

*   **Responsabilidades:**
    *   **Leitura de Itens:** Fornece um `Stream` (`getItemsStream`) que observa e retorna todos os itens de uma determinada lista, ordenados por data de criação.
    *   **Operações CRUD:** Contém métodos para adicionar (`addItem`), atualizar (`updateItem`) e remover (`deleteItem`) itens de uma lista.
    *   **Atualização de Estado:** Possui um método específico (`updateItemCompletion`) para marcar um item como "concluído", uma das interações mais frequentes do usuário durante uma compra.

### 4.4. Camada de Controle (Controllers)
A lógica de negócio e o gerenciamento de estado da aplicação são implementados na camada de controle, utilizando o pacote de gerenciamento de estado **GetX**. Cada `Controller` é responsável por uma área específica da aplicação, orquestrando as interações do usuário, processando dados obtidos dos repositórios e preparando-os para serem exibidos pela camada de visualização (`View`).

#### 4.4.1. `AuthController` (Controlador de Autenticação)
É o ponto central para o gerenciamento de sessão do usuário.

*   **Responsabilidades:**
    *   **Gerenciamento de Estado de Autenticação:** Utiliza um `Stream` do `AuthRepository` para ouvir mudanças no estado de autenticação do usuário em tempo real. Ao detectar uma mudança (login ou logout), redireciona o usuário para a tela apropriada (`HomePage` ou `LoginPage`).
    *   **Processamento de Formulários:** Contém a lógica para validar e processar os formulários de login, cadastro e redefinição de senha, invocando os métodos correspondentes no `AuthRepository`.
    *   **Carregamento de Perfil:** Após o login, é responsável por carregar os dados do perfil do usuário do Firestore e mantê-los disponíveis para outras partes da aplicação.
    *   **Token de Notificação:** Gerencia a obtenção e atualização do token do Firebase Cloud Messaging (FCM) para o usuário logado.

#### 4.4.2. `ShoppingListController` e `ShoppingItemController`
Esta dupla de controladores gerencia a principal funcionalidade do aplicativo: a criação e manipulação de listas de compras e seus itens.

*   **`ShoppingListController`:**
    *   **Gerenciamento de Listas Ativas:** Mantém e exibe a lista de compras ativas do usuário.
    *   **Ciclo de Vida da Lista:** Implementa a lógica para criar, editar, arquivar e finalizar listas. Ao finalizar uma lista, ele calcula o preço total dos itens e a move para o histórico.
    *   **Agendamento de Notificações:** Contém a lógica complexa para agendar, atualizar e cancelar notificações locais relacionadas às datas de compra agendadas.

*   **`ShoppingItemController`:**
    *   **Gerenciamento de Itens:** Lida com a adição, edição, exclusão e marcação de itens como "concluídos" dentro de uma lista específica.
    *   **Vinculação de Dados:** Associa-se a uma lista de compras (`listId`) para exibir e gerenciar apenas os itens pertencentes a ela.

#### 4.4.3. `ProductController` (Controlador do Catálogo de Produtos)
Responsável por toda a interação com o catálogo global de produtos.

*   **Responsabilidades:**
    *   **Visualização do Catálogo:** Disponibiliza a lista de produtos do catálogo para a interface do usuário.
    *   **Operações CRUD:** Implementa a lógica para adicionar um novo produto (incluindo o upload da imagem), editar e excluir itens do catálogo.

#### 4.4.4. `MembersController` (Controlador de Membros)
Gerencia a funcionalidade de compartilhamento de listas.

*   **Responsabilidades:**
    *   **Convite de Usuários:** Contém a lógica para convidar um novo usuário para uma lista através do seu e-mail. Ele busca o usuário no banco de dados e o adiciona ao mapa de `members` da lista.
    *   **Visualização de Membros:** Busca e exibe os detalhes dos usuários que são membros de uma determinada lista.

#### 4.4.5. `HistoryController` e `SpendingAnalysisController`
Estes controladores são focados na análise de dados históricos.

*   **`HistoryController`:** Simplesmente busca e exibe o fluxo de listas que foram marcadas como "finalizada" or "arquivada".
*   **`SpendingAnalysisController`:**
    *   **Filtragem de Dados:** Permite que o usuário filtre as compras históricas por um intervalo de datas.
    *   **Cálculo de Métricas:** Calcula o gasto total no período selecionado.
    *   **Visualização de Dados:** Processa os dados para gerar um gráfico de pizza (`PieChart`) que mostra a distribuição de gastos por categoria, oferecendo ao usuário insights sobre seus hábitos de compra.

#### 4.4.6. `SuggestionController` (Controlador de Sugestões)
Implementa uma funcionalidade de inteligência para o usuário.

*   **Responsabilidades:**
    *   **Análise de Histórico:** Analisa o histórico de compras do usuário para identificar os produtos comprados com mais frequência.
    *   **Geração de Sugestões:** Com base na frequência, ele busca os produtos correspondentes no catálogo e os exibe como uma lista de sugestões, facilitando a adição de itens recorrentes a uma nova lista.

### 4.5. Camada de Apresentação (View)
A camada de apresentação é responsável por construir a interface do usuário (UI). Ela é composta por um conjunto de **telas (páginas)**, que representam os diferentes contextos da aplicação, e **widgets**, que são componentes reutilizáveis para construir essas telas de forma consistente e eficiente. A `View` utiliza os dados e a lógica dos `Controllers` para se manter atualizada e para responder às interações do usuário.

#### 4.5.1. Telas Principais (`lib/view/`)
*   **`login_page.dart`:** A porta de entrada da aplicação. Apresenta um formulário para login e registro, alternando entre as duas visualizações. Utiliza o `AuthController` para gerenciar a autenticação.
*   **`splash_page.dart`:** Uma tela de carregamento inicial que é exibida enquanto o aplicativo verifica o estado de autenticação do usuário para decidir se o direciona para a tela de login ou para a tela principal.
*   **`home_page.dart`:** A tela principal da aplicação. Exibe as listas de compras ativas do usuário. A partir daqui, o usuário pode criar novas listas e navegar para outras seções do aplicativo através de um menu lateral (`Drawer`).
*   **`list_details_page.dart`:** Exibe os itens de uma lista de compras específica. É a tela onde o usuário passa a maior parte do tempo, adicionando, editando e marcando itens como concluídos.
*   **`members_page.dart`:** Tela dedicada ao gerenciamento de membros de uma lista compartilhada. Permite visualizar os membros atuais e convidar novos participantes.
*   **`product_catalog_page.dart`:** Apresenta o catálogo global de produtos, permitindo que os usuários visualizem, adicionem, editem e removam produtos do catálogo.
*   **`history_page.dart`:** Exibe o histórico de listas de compras finalizadas e arquivadas, permitindo ao usuário consultar compras passadas.
*   **`spending_analysis_page.dart`:** A tela de análise de gastos. Apresenta um seletor de datas, o valor total gasto no período e um gráfico de pizza com a distribuição de gastos por categoria.

#### 4.5.2. Widgets Reutilizáveis (`lib/view/widgets/`)
A aplicação faz uso extensivo de widgets customizados para promover a reutilização de código e a consistência visual.

*   **Diálogos (`..._dialog.dart`):** Widgets como `create_list_dialog.dart`, `add_product_dialog.dart`, e `edit_list_dialog.dart` encapsulam formulários em janelas de diálogo para a criação e edição de dados, proporcionando uma experiência de usuário fluida sem a necessidade de navegar para uma nova tela.
*   **Componentes de UI Genéricos:**
    *   `custom_app_bar.dart`: Uma barra de aplicativo padrão para manter a consistência entre as telas.
    *   `custom_drawer.dart`: O menu de navegação lateral, que dá acesso a todas as seções principais do aplicativo.
    *   `auth_text_form_field.dart`: Um campo de texto customizado para os formulários de autenticação, com validação e controle de visibilidade de senha.
*   **Widgets de Exibição de Dados:**
    *   `pie_chart_card.dart` e `total_spending_card.dart`: Widgets especializados para a tela de análise de gastos, que exibem o gráfico e o valor total, respectivamente.
    *   `history_list_tile.dart`: Um item de lista customizado para exibir as informações de uma compra no histórico.
    *   **Cards (`lib/view/widgets/cards/`):** Componentes como `product_card.dart` e `square_card.dart` são usados para exibir informações de forma visualmente atraente em grades ou listas.

# 5. RESULTADOS E DISCUSSÃO
Este capítulo apresenta os resultados obtidos com o desenvolvimento do projeto, em alinhamento com os objetivos propostos, e abre espaço para uma discussão crítica sobre o processo e o produto final.

## 5.1. Apresentação dos Resultados
O processo de desenvolvimento, guiado pela metodologia e arquitetura descritas nos capítulos anteriores, culminou na entrega de um conjunto de resultados concretos e mensuráveis. Os principais resultados alcançados são detalhados a seguir.

**1. Entrega de um Aplicativo Multiplataforma Funcional:** O principal resultado do projeto é um aplicativo de software completo, funcional e que atende a todos os requisitos funcionais estabelecidos na introdução. O aplicativo foi desenvolvido e testado para ser compilado e executado de forma consistente nas plataformas Android, iOS e Web, validando a eficácia da abordagem de desenvolvimento com Flutter.

**2. Implementação de uma Arquitetura Robusta e Escalável:** Resultou-se na implementação bem-sucedida da arquitetura MVVM em conjunto com o Padrão de Repositório. Essa arquitetura produziu uma base de código limpa, com clara separação de responsabilidades, o que não apenas facilitou o desenvolvimento e a depuração, mas também estabeleceu uma fundação sólida para a futura adição de novas funcionalidades ou para a manutenção do código existente.

**3. Validação da Experiência do Usuário Colaborativa:** Obteve-se uma experiência de usuário colaborativa através da funcionalidade de compartilhamento de listas. O sistema de permissões com papéis de `owner` e `editor` se mostrou eficaz, permitindo que múltiplos usuários interajam em uma mesma lista em tempo real, resolvendo um dos problemas centrais propostos por este trabalho.

**4. Implementação de Funcionalidades Inteligentes de Suporte:** O desenvolvimento do sistema de sugestão de produtos baseado em histórico e do gerenciamento do ciclo de vida de notificações resultou em um aplicativo que vai além do gerenciamento passivo de dados. O software oferece suporte proativo ao usuário, agilizando tarefas e fornecendo lembretes relevantes, o que enriquece a experiência de uso.

**5. Garantia de Segurança e Integridade dos Dados:** A implementação de regras de segurança no Firestore (Firestore Rules) garantiu que o acesso aos dados dos usuários seja restrito e seguro, protegendo a privacidade e a integridade das informações de cada usuário no ambiente de nuvem.

Em síntese, o resultado final é um produto de software que não apenas cumpre uma função, mas o faz de maneira eficiente, segura e com uma arquitetura que segue as boas práticas da engenharia de software moderna.

## 5.2. Discussão dos Resultados _**[A SER DESENVOLVIDO]**_
_**[Nesta seção, você deve realizar uma análise crítica e aprofundada dos resultados apresentados. O objetivo não é apenas descrever o que foi feito, mas discutir o *significado* e as *implicações* do trabalho. Utilize os seguintes tópicos como guia para a sua redação:

- **Alinhamento com os Objetivos:** Compare os resultados alcançados com os objetivos específicos definidos no Capítulo 1. Todos os objetivos foram plenamente atendidos? Houve algum que foi superado? Houve alguma dificuldade inesperada em algum deles?
- **Análise das Escolhas Tecnológicas:** Discuta os prós e contras das principais tecnologias escolhidas. O Flutter atendeu às expectativas de desenvolvimento multiplataforma? O GetX simplificou o gerenciamento de estado como esperado? O Firebase foi a escolha certa para o back-end? Quais foram as limitações ou dificuldades encontradas com essas ferramentas?
- **Desafios do Desenvolvimento e Soluções:** Descreva os desafios técnicos mais significativos que você encontrou durante o projeto. Um excelente exemplo documentado é o erro `MissingStubError` ao tentar configurar os primeiros testes unitários. Explique o problema, como você o diagnosticou e qual foi a solução aplicada. Discutir esses desafios demonstra maturidade e profundidade técnica.
- **Impacto das Funcionalidades na Experiência do Usuário:** Analise o impacto prático das funcionalidades mais complexas. De que forma o compartilhamento de listas realmente melhora a vida de uma família? O sistema de sugestões é de fato útil para o usuário? Tente argumentar sobre o valor que essas funcionalidades agregam ao produto final.
- **Comparação com Soluções Existentes (se aplicável):** Se você conhece outros aplicativos de lista de compras, como o seu se diferencia? Quais são seus pontos fortes ou fracos em comparação?]**_

# 6. CONCLUSÃO
Este capítulo finaliza o presente trabalho, apresentando uma síntese das contribuições alcançadas, uma análise transparente das limitações do projeto e uma visão sobre as possíveis evoluções e trabalhos futuros que podem ser construídos sobre a base que foi desenvolvida.

O desenvolvimento de software para solucionar problemas cotidianos é um dos campos mais dinâmicos da engenharia de software, e este projeto se insere nesse contexto. Partindo do desafio de otimizar o gerenciamento de compras domésticas, este trabalho demonstrou com sucesso a concepção, o projeto e a implementação de um aplicativo multiplataforma completo, utilizando o ecossistema tecnológico do Flutter e do Firebase. O projeto alcançou todos os seus objetivos iniciais, resultando em uma aplicação que não apenas cumpre os requisitos funcionais de forma robusta, mas o faz sobre uma base de código bem arquitetada, segura e escalável, seguindo as boas práticas do desenvolvimento de software moderno.

A principal contribuição deste trabalho é, portanto, a entrega de uma solução de software de ponta a ponta, que oferece valor real ao usuário final ao otimizar uma tarefa rotineira por meio de funcionalidades como colaboração em tempo real, análise financeira e suporte proativo com sugestões inteligentes.

## 6.1. Limitações do Projeto
Apesar do sucesso na implementação das funcionalidades e na construção de uma arquitetura sólida, é importante reconhecer as limitações inerentes ao escopo e ao cronograma do projeto. As principais limitações identificadas são:

- **Ausência de Testes Automatizados:** A limitação mais significativa é a ausência de uma suíte abrangente de testes automatizados (unitários, de widget e de integração). Embora o desenvolvimento tenha sido cuidadoso, a falta de testes representa um débito técnico que aumenta o risco de introdução de regressões (bugs em funcionalidades existentes) durante futuras manutenções ou na adição de novos recursos.
- **Processo de Deploy Manual:** Não foi implementado um pipeline de Integração Contínua e Deploy Contínuo (CI/CD). Isso significa que os processos de compilação, teste e publicação do aplicativo para as lojas ou para a web ainda são manuais, o que é menos eficiente e mais suscetível a erros do que um processo automatizado.

## 6.2. Propostas de Trabalhos Futuros
A plataforma robusta que foi construída abre um leque de possibilidades para evoluções e aprofundamentos em trabalhos futuros. As propostas mais relevantes são:

- **Implementação da Suíte Completa de Testes:** O passo mais crítico para aumentar a qualidade e a resiliência do software seria o desenvolvimento de uma cobertura de testes completa, garantindo a estabilidade do código a longo prazo.
- **Automação de CI/CD:** A configuração de um pipeline de CI/CD (utilizando ferramentas como GitHub Actions, por exemplo) para automatizar a compilação, a execução dos testes e o deploy do aplicativo, profissionalizando o ciclo de vida do desenvolvimento.
- **Desenvolvimento do Backend para Notificações Agendadas:** Atualmente, a lógica de notificação está no cliente. Um trabalho futuro seria desenvolver e implantar a Cloud Function no Firebase que seria responsável por processar as notificações agendadas de forma assíncrona no servidor, garantindo o envio mesmo que o aplicativo não esteja em uso.
- **Evolução do Sistema de Sugestões com Inteligência Artificial:** O atual sistema de sugestões é baseado em frequência. Uma evolução natural seria a aplicação de algoritmos de Machine Learning, como regras de associação (ex: Apriori), para identificar padrões de compra mais complexos (ex: "usuários que compram macarrão também costumam comprar molho de tomate") e oferecer sugestões ainda mais personalizadas e contextuais.

_**[A SER DESENVOLVIDO: Elementos pós-textuais como Referências, Apêndices e Anexos.]**_

# Memorial Técnico do Projeto 'Lista de Compras'

**Autor do TCC:** Isaías Félix Machado de Alcantara
**Consultor Técnico (IA):** Gemini
**Versão do Documento:** 1.0 de 02/09/2025

## 1. Visão Geral do Projeto

O "Lista de Compras" é um aplicativo multiplataforma (Android, iOS, Web) desenvolvido em Flutter, projetado para oferecer uma solução completa e moderna para o gerenciamento de compras. O sistema permite que os usuários criem e gerenciem múltiplas listas de compras, adicionem produtos, controlem seus gastos e recebam sugestões inteligentes, com todos os dados sincronizados em tempo real através do Firebase.

O projeto visa não apenas a funcionalidade, mas também a aplicação de boas práticas de engenharia de software, resultando em um código limpo, escalável e de fácil manutenção.

---

## 2. Arquitetura de Software e Padrões de Projeto

A arquitetura do projeto foi uma decisão estratégica para garantir a separação de responsabilidades, a testabilidade e a escalabilidade da aplicação.

### 2.1. Padrão Arquitetural: MVVM com GetX

O projeto utiliza uma arquitetura baseada no padrão **MVVM (Model-View-ViewModel)**, implementada com o auxílio do framework **GetX**.

*   **Model:** Camada responsável pela representação dos dados e da lógica de negócios fundamental. Ex: `ShoppingListModel`, `UserModel`.
*   **View:** Camada de apresentação (UI), responsável por exibir os dados e capturar as interações do usuário. No projeto, são os Widgets do Flutter (ex: `HomePage`, `LoginPage`). As Views são reativas e observam as mudanças nos ViewModels.
*   **ViewModel (Controller no GetX):** Atua como um intermediário entre o Model e a View. Contém a lógica de apresentação, o estado da UI (ex: `isLoading`) e os comandos (funções) que a View pode invocar. Ex: `ShoppingListController`, `AuthController`.

### 2.2. Camada de Acesso a Dados: Repository Pattern

Para desacoplar a lógica de negócios da fonte de dados (Firebase), foi implementado o **Padrão de Repositório**.

*   **Responsabilidade:** A pasta `lib/repositories` contém classes (`AuthRepository`, `ShoppingListRepository`, etc.) cuja única responsabilidade é se comunicar com o Firebase (Firestore, Auth, Storage).
*   **Vantagens:**
    1.  **Abstração:** Os `Controllers` não sabem *como* os dados são salvos; eles apenas pedem ao repositório para "salvar uma lista". Isso significa que poderíamos trocar o Firebase pelo Supabase ou um backend próprio no futuro, alterando apenas a camada de repositório, sem impactar a lógica de negócios.
    2.  **Testabilidade:** Facilita a criação de testes unitários, permitindo "mockar" (simular) o repositório para testar os controllers de forma isolada.

### 2.3. Gerenciamento de Estado Reativo

O GetX é utilizado como solução de gerenciamento de estado. Variáveis observáveis (ex: `var isLoading = false.obs;`) são declaradas nos controllers. Na UI, widgets `Obx` escutam as mudanças nessas variáveis e se reconstroem automaticamente, eliminando a necessidade de `StatefulWidget` e `setState()` na maior parte do código e resultando em uma UI mais limpa e performática.

### 2.4. Injeção de Dependência (DI) com GetX Bindings

Para garantir um gerenciamento de dependências robusto e centralizado, o projeto adotou o sistema de **Bindings** do GetX.

- **`InitialBinding`:** Foi criada uma classe `InitialBinding` que é responsável por inicializar todas as dependências críticas da aplicação (serviços e repositórios) assim que o app é iniciado. 
- **`Get.lazyPut()`:** Dentro do binding, utilizamos `Get.lazyPut()` para registrar as dependências. Isso oferece uma otimização de performance, pois a instância da classe (ex: `ShoppingListRepository`) só é criada na memória no momento em que é usada pela primeira vez.
- **Ciclo de Vida:** O uso de `fenix: true` garante que a instância da dependência persista durante todo o ciclo de vida do aplicativo, funcionando como um Singleton seguro e acessível de qualquer parte do código através de `Get.find()`.
- **Desacoplamento:** Essa abordagem desacopla completamente os controllers da responsabilidade de criar suas próprias dependências. Um controller agora simplesmente solicita a dependência de que precisa (`Get.find<MyRepository>()`), sem saber como ou quando ela foi criada, aderindo ao princípio de Inversão de Controle (IoC).

---

## 3. Ecossistema de Tecnologias

*   **Flutter:** Framework da Google para desenvolvimento de interfaces de usuário compiladas nativamente para mobile, web e desktop a partir de uma única base de código.
*   **Firebase:** Backend-as-a-Service (BaaS) da Google, provendo a infraestrutura de backend.
    *   **Firebase Authentication:** Gerencia todo o fluxo de autenticação de usuários (login, cadastro, reset de senha) de forma segura.
    *   **Cloud Firestore:** Banco de dados NoSQL, orientado a documentos e com capacidades real-time, utilizado para armazenar todos os dados da aplicação (listas, produtos, logs).
    *   **Firebase Storage:** Utilizado para o armazenamento de arquivos binários, como as imagens dos produtos enviadas pelos usuários.
    *   **Firebase Cloud Messaging (FCM):** Utilizado para a arquitetura de notificações push agendadas.
*   **GetX:** Solução completa para gerenciamento de estado, injeção de dependências e roteamento, escolhida por sua simplicidade, performance e baixa verbosidade.

---

## 4. Implementações Técnicas Notáveis

Durante o desenvolvimento, diversas funcionalidades e refatorações foram implementadas para garantir a qualidade do produto final.

### 4.1. Sistema de Log de Erros Remoto

*   **Problema:** Erros no cliente eram perdidos ou visíveis apenas no console de depuração, impossibilitando o monitoramento da aplicação em produção.
*   **Solução:** Foi criado um `LoggerService` centralizado que captura todas as exceções nos blocos `try-catch`. As informações detalhadas do erro (mensagem, stack trace, ID do usuário, plataforma) são então salvas em uma coleção `error_logs` no Firestore.
*   **Resultado:** Capacidade de monitorar a saúde do aplicativo proativamente e depurar problemas que ocorrem para os usuários finais.

### 4.2. Tratamento Inteligente de Erros de UX

*   **Problema:** Mensagens de erro genéricas frustravam o usuário, que não sabia como agir.
*   **Solução:** Foi criado um "tradutor" de erros (`getFirebaseErrorMessage`) que converte códigos de erro técnicos (ex: `unavailable`) em mensagens claras e acionáveis (ex: "Sem conexão com a internet. Verifique sua rede e tente novamente.").
*   **Resultado:** Melhoria significativa na experiência do usuário (UX).

### Etapa 3: Correção de Bug Crítico no Ciclo de Vida das Notificações

*   **Data:** 02/09/2025
*   **Objetivo:** Garantir que o agendamento de notificações seja robusto e acompanhe todas as alterações do usuário.

*   **Problema:** Identificou-se uma falha crítica na lógica de notificações: ao **alterar ou remover** uma data de compra, a notificação antiga não era removida, resultando em notificações órfãs ou duplicadas.
*   **Solução:**
    1.  O `ShoppingListModel` foi estendido para incluir o campo `scheduledNotificationId`, criando um vínculo direto entre uma lista e sua notificação.
    2.  O `ShoppingListController` foi profundamente refatorado. A lógica de `createList` e `updateList` foi aprimorada para gerenciar o ciclo de vida completo da notificação:
        *   **Criação:** Agenda a notificação e salva sua ID na lista.
        *   **Atualização:** Compara a data antiga com a nova. Se a data for alterada, a notificação antiga é **deletada** e uma nova é criada. Se a data for removida, a notificação antiga é **deletada**.
        *   **Arquivamento/Finalização:** Os métodos `archiveList` e `finishList` agora também **deletam** qualquer notificação pendente associada.
*   **Resultado:** A funcionalidade de notificações tornou-se robusta, confiável e livre de bugs, tratando todos os casos de uso possíveis e garantindo que o usuário receba apenas as notificações corretas.

### Etapa 4: Implementação de Testes Automatizados (Testes de Unidade)

*   **Data:** 02/09/2025
*   **Objetivo:** Iniciar a construção de uma suíte de testes automatizados para garantir a estabilidade do código e prevenir regressões.

*   **Problema:** O projeto não possuía testes automatizados, o que aumentava o risco de introduzir bugs em funcionalidades existentes a cada nova alteração.
*   **Solução:**
    1.  **Definição da Estratégia:** Optou-se por iniciar com **Testes de Unidade**, por serem mais rápidos, isolados e fáceis de implementar. O `AuthController` foi escolhido como o primeiro alvo devido à sua criticidade.
    2.  **Configuração do Ambiente de Testes:**
        *   Adição das dependências `mockito` e `build_runner` ao `pubspec.yaml` para permitir a criação de "mocks" (objetos simulados) das dependências dos controllers.
        *   Criação do diretório `test/controller/` e do arquivo `auth_controller_test.dart`.
    3.  **Desafios com Mocks e GetX:**
        *   **`MissingStubError` / `FakeUsedError`:** Durante a execução dos testes, o `GetX` tentava chamar métodos de ciclo de vida (como `onStart`) nos mocks dos serviços (`LoggerService`). O `mockito` reclamava que esses métodos não tinham sido "dublados" (stubbed).
        *   **Solução:**
            *   A anotação `@GenerateMocks` foi alterada para `@GenerateNiceMocks` para que o `mockito` gerasse mocks mais "permissivos", que ignoram chamadas não esperadas.
            *   Mesmo com `NiceMocks`, foi necessário adicionar um "stub" explícito para o método `onStart()` do `MockLoggerService` no bloco `setUp` do teste (`when(mockLoggerService.onStart()).thenReturn(null);`), garantindo que o GetX pudesse inicializar o serviço sem falhas no ambiente de teste.
    4.  **Primeiros Testes Implementados:**
        *   Testes para a função `toggleView()` do `AuthController` foram escritos, verificando se o valor de `isLoginView` é corretamente invertido.
*   **Resultado:** O ambiente de testes foi configurado com sucesso, e os primeiros testes de unidade foram implementados, estabelecendo a base para uma suíte de testes mais abrangente.

---

## 5. Pontos Críticos e Próximos Passos

*   **CI/CD (Integração e Deploy Contínuo):** A automação do processo de build, teste e deploy não foi implementada, sendo uma oportunidade de melhoria para profissionalizar o ciclo de desenvolvimento.
*   **Funcionalidades Futuras:** A próxima grande funcionalidade no roadmap é o sistema de **sugestão de produtos** com base no histórico de compras do usuário.

### 4.4. Segurança de Dados com Firestore Rules

*   **Problema:** O banco de dados, em sua configuração inicial, era inseguro, permitindo acesso irrestrito aos dados.
*   **Solução:** Foi desenvolvido um conjunto de regras de segurança (`firestore.rules`) que define permissões de acesso para cada coleção. A regra principal garante que um usuário só pode ler e escrever documentos de listas (`/lists`) nos quais ele é membro, validando a requisição contra um mapa `members` dentro do documento.
*   **Resultado:** Proteção da integridade e privacidade dos dados do usuário.

### 4.5. Sugestão de Produtos Baseada em Histórico

*   **Data:** 23/09/2025
*   **Problema:** Usuários podem se esquecer de adicionar itens recorrentes às suas listas de compras, gerando uma experiência de usuário fragmentada.
*   **Solução:** Foi implementada uma funcionalidade de sugestão de produtos que analisa o histórico de compras do usuário.
    1.  **Criação do `SuggestionController`:** Um novo controller foi desenvolvido para conter a lógica de geração de sugestões.
    2.  **Lógica de Análise:** O controller busca todas as listas com status "finalizada" ou "arquivada" do usuário. Em seguida, ele agrega todos os itens comprados nessas listas e calcula a frequência de cada produto.
    3.  **Exibição Inteligente:** Os 5 produtos mais comprados são então exibidos em um carrossel (`SuggestionCarousel`) na tela de detalhes da lista (`ListDetailsPage`), um local estratégico onde o usuário está ativamente gerenciando os itens de sua compra.
    4.  **Interatividade:** Ao tocar em um produto sugerido, ele é instantaneamente adicionado à lista de compras atual, agilizando o processo de criação da lista.
*   **Resultado:** Melhoria na experiência do usuário, que agora recebe lembretes proativos de itens que compra com frequência, tornando o processo de montagem da lista mais rápido e eficiente.

### 4.6. Compartilhamento de Listas e Controle de Permissão

*   **Data:** 23/09/2025
*   **Problema:** Um requisito central do projeto é permitir que usuários colaborem em uma mesma lista de compras, com diferentes níveis de acesso.
*   **Solução:** Uma arquitetura de compartilhamento baseada em papéis foi implementada.
    1.  **Modelo de Dados:** O `ShoppingListModel` foi projetado desde o início com um campo `members`, que é um `Map<String, String>`. Este mapa armazena o UID de cada usuário associado à lista como chave e sua permissão (ex: `owner`, `editor`) como valor.
    2.  **Fluxo de Convite:** Uma nova tela, `MembersPage`, foi criada. Apenas o `owner` da lista pode acessá-la. Nessa tela, ele pode convidar outros usuários por e-mail. Um `MembersController` orquestra a lógica, buscando o usuário pelo e-mail no `AuthRepository` e atualizando o mapa `members` da lista no `ShoppingListRepository`.
    3.  **Segurança no Backend:** As `firestore.rules` são a base da segurança, garantindo que um usuário só possa ler uma lista se seu UID estiver presente no mapa `members` daquele documento.
    4.  **Controle na UI:** Na `ListDetailsPage`, a UI agora é dinâmica e baseada em permissão. O papel do usuário (`owner`, `editor`) é verificado, e os widgets de interação (como os botões para editar/deletar a lista, adicionar membros ou itens) são renderizados condicionalmente, aparecendo apenas para os usuários com a permissão adequada.
*   **Resultado:** O aplicativo agora suporta colaboração multiusuário de forma segura, onde o dono da lista tem controle total, e os usuários convidados podem interagir dentro dos limites de suas permissões.

---

## 5. Pontos Críticos e Próximos Passos

*   **Testes Automatizados:** O projeto atualmente carece de uma suíte de testes automatizados. Este é o próximo passo técnico mais crítico para garantir a estabilidade do código e prevenir regressões futuras.
*   **CI/CD (Integração e Deploy Contínuo):** A automação do processo de build, teste e deploy não foi implementada, sendo uma oportunidade de melhoria para profissionalizar o ciclo de desenvolvimento.
*   **Funcionalidades Futuras:** A próxima grande funcionalidade no roadmap é o sistema de **sugestão de produtos** com base no histórico de compras do usuário.
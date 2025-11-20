# Memorial Técnico do Projeto 'Lista de Compras'

**Autor do TCC:** Isaías Félix Machado de Alcantara
**Consultor Técnico (IA):** Gemini
**Versão do Documento:** 2.0 (Final)

## 1. Visão Geral do Projeto

O "Lista de Compras" é um aplicativo multiplataforma (Android, iOS, Web) desenvolvido em Flutter, projetado para oferecer uma solução completa e moderna para o gerenciamento de compras. O sistema permite que os usuários criem e gerenciem múltiplas listas, adicionem produtos, controlem seus gastos e colaborem em tempo real, com todos os dados sincronizados através do Firebase.

O projeto visou não apenas a funcionalidade, mas também a aplicação de boas práticas de engenharia de software, resultando em um código limpo, escalável e de fácil manutenção.

---

## 2. Arquitetura de Software e Padrões de Projeto

A arquitetura do projeto foi uma decisão estratégica para garantir a separação de responsabilidades, a testabilidade e a escalabilidade da aplicação.

### 2.1. Padrão Arquitetural: MVVM com GetX

O projeto utiliza uma arquitetura baseada no padrão **MVVM (Model-View-ViewModel)**, implementada com o auxílio do framework **GetX**.

- **Model:** Camada responsável pela representação dos dados e da lógica de negócios fundamental (ex: `ListModel`, `UserModel`).
- **View:** Camada de apresentação (UI), responsável por exibir os dados e capturar as interações do usuário (ex: `HomeView`, `ShoppingListDetailsView`). As Views são reativas e observam as mudanças nos ViewModels.
- **ViewModel (Controller no GetX):** Atua como um intermediário entre o Model e a View. Contém a lógica de apresentação, o estado da UI e os comandos que a View pode invocar (ex: `HomeController`, `ShoppingListController`).

### 2.2. Camada de Acesso a Dados: Repository Pattern

Para desacoplar a lógica de negócios da fonte de dados (Firebase), foi implementado o **Padrão de Repositório**.

- **Responsabilidade:** A pasta `lib/app/data/repositories` contém classes (`ShoppingListRepository`, `CategoryRepository`, etc.) cuja única responsabilidade é se comunicar com o Firebase (Firestore, Auth, Storage).
- **Vantagens:**
  1.  **Abstração:** Os `Controllers` não sabem *como* os dados são salvos; eles apenas pedem ao repositório para "salvar uma lista". Isso significa que a fonte de dados poderia ser trocada no futuro com impacto mínimo na lógica de negócios.
  2.  **Testabilidade:** Facilita a criação de testes unitários, permitindo "mockar" (simular) o repositório para testar os controllers de forma isolada.

### 2.3. Injeção de Dependência (DI) com GetX Bindings

Para garantir um gerenciamento de dependências robusto, o projeto adotou o sistema de **Bindings** do GetX, centralizando a inicialização de dependências globais.

- **`InitialBinding`:** A classe `InitialBinding` é o coração da DI do projeto. Ela é responsável por inicializar todos os controllers e repositórios globais (`AuthController`, `ShoppingListController`, `CategoryController`, etc.) assim que o app é iniciado.
- **Ciclo de Vida com `fenix: true`:** Dentro do `InitialBinding`, `Get.lazyPut()` com a propriedade `fenix: true` é utilizado. Isso garante que a instância da dependência persista durante todo o ciclo de vida do aplicativo, funcionando como um Singleton seguro e acessível de qualquer parte do código através de `Get.find()`. Esta abordagem resolveu erros de "Controller not found" e garantiu a disponibilidade de controllers essenciais em todas as features.
- **Desacoplamento (Inversão de Controle):** Essa estratégia desacopla completamente os controllers da responsabilidade de criar suas próprias dependências, aderindo ao princípio de Inversão de Controle (IoC).

---

## 3. Ecossistema de Tecnologias

- **Flutter:** Framework da Google para desenvolvimento de interfaces de usuário compiladas nativamente para mobile, web e desktop.
- **Firebase:** Backend-as-a-Service (BaaS) da Google, provendo a infraestrutura de backend.
  - **Firebase Authentication:** Gerencia o fluxo de autenticação de usuários.
  - **Cloud Firestore:** Banco de dados NoSQL orientado a documentos, utilizado para armazenar todos os dados da aplicação.
  - **Firebase Storage:** Utilizado para o armazenamento das imagens dos produtos.
- **GetX:** Solução "tudo em um" para gerenciamento de estado, injeção de dependências e roteamento, escolhida por sua simplicidade e performance.

---

## 4. Implementações Técnicas Notáveis

### 4.1. Compartilhamento de Listas e Controle de Permissão
Uma arquitetura de compartilhamento baseada em papéis foi implementada para permitir a colaboração.
- **Modelo de Dados:** O `ListModel` contém um mapa `memberPermissions` que armazena o UID de cada membro e sua permissão (`owner`, `editor`).
- **Fluxo de Convite:** Uma tela dedicada (`MembersView`) permite que o dono da lista convide outros usuários por e-mail.
- **Controle na UI:** A interface da tela de detalhes da lista é dinâmica, renderizando widgets de interação (editar, deletar, adicionar membros) apenas para usuários com a permissão adequada.

### 4.2. Segurança de Dados com Firestore Rules
Foi desenvolvido um conjunto de regras de segurança (`firestore.rules`) que define permissões de acesso para cada coleção. A regra principal garante que um usuário só pode ler e escrever documentos de listas (`/lists/{listId}`) se seu UID estiver presente no campo `memberUIDs` do documento.

### 4.3. Lógica de Negócios e Cálculos no Cliente
Seguindo a diretriz do projeto, foi decidido que toda a lógica de cálculo (total de preços, análise de gastos, etc.) seria implementada no lado do cliente. Isso foi realizado nos `Controllers`, que processam os dados recebidos do Firestore para gerar as informações exibidas na UI.

### 4.4. Resolução de Bugs Críticos
- **Ciclo de Vida da Aplicação:** Foi corrigido um erro crítico de "contextless navigation" que ocorria na inicialização. A solução envolveu a refatoração do `main.dart` e do `AuthController` para garantir um fluxo de inicialização e redirecionamento mais robusto e previsível.
- **Consistência de Dados:** Foi corrigido um bug onde o resumo mensal de gastos não era calculado corretamente. A causa era a ausência da `purchaseDate` ao finalizar uma lista. O método `finishShopping` foi ajustado para salvar a data correta, garantindo a integridade dos dados para a funcionalidade de análise.

---

## 5. Conclusão

O projeto "Lista de Compras" foi concluído com sucesso, atingindo todos os seus principais objetivos funcionais e técnicos. A arquitetura escolhida (MVVM com GetX e Repository Pattern) provou-se eficaz, resultando em um código-fonte organizado, manutenível e escalável. As decisões técnicas, como a centralização da injeção de dependências e a implementação de regras de segurança no Firestore, garantem a robustez e a segurança da aplicação.

Para uma visão detalhada do progresso e dos próximos passos (como a criação de um tema e a adição de testes), consulte o arquivo `ACOMPANHAMENTO.md`.
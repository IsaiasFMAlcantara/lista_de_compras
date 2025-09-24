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

- **Análise Inicial e Estrutura do Projeto:**
  - Leitura de `pubspec.yaml`, `README.md` e análise completa do código-fonte no diretório `lib/`.
  - Configuração da estrutura de pastas (controller, model, view, repositories).

- **Arquitetura de Repositório:**
  - [x] Implementação da camada de Repositório para abstrair o acesso a dados.
  - [x] Refatoração de todos os controllers (`Auth`, `ShoppingList`, `ShoppingItem`, `History`, `SpendingAnalysis`, `Product`) para utilizar a camada de repositório, garantindo uma arquitetura consistente.

- **Otimização de Performance (Uso de `const`):**
  - [x] Aplicação da palavra-chave `const` em widgets estáticos da UI para otimizar a performance e reduzir reconstruções desnecessárias.

- **Autenticação de Usuário:**
  - [x] Implementação do fluxo de autenticação com Firebase Auth (Criação, Login, Logout, Reset de senha).
  - [x] UI de Login/Cadastro (`LoginPage`) com validação de formulário.
  - [x] Tela de Splash (`SplashPage`) que redireciona com base no estado de autenticação.

- **Estrutura da UI Principal:**
  - [x] Criação de widgets reutilizáveis (`CustomAppBar`, `CustomDrawer`).
  - [x] Implementação da estrutura da `HomePage` com `Scaffold` e `FloatingActionButton`.

- **Catálogo de Produtos:**
  - [x] Implementação da UI e da lógica para criar e listar produtos em um catálogo global, incluindo upload de imagem para o Firebase Storage.

- **Gerenciamento de Listas:**
  - [x] Implementação completa de CRUD (Criar, Ler, Editar, Arquivar, Finalizar) para listas de compras.
  - [x] Ordenação inteligente de listas na `HomePage`.

- **Gerenciamento de Itens da Lista:**
  - [x] Implementação completa de CRUD (Adicionar, Editar, Remover, Marcar como comprado) para itens dentro de uma lista.

- **Compartilhamento de Listas e Permissões:**
  - [x] Implementação do fluxo de convite de usuários para listas por e-mail.
  - [x] Criação da tela de gerenciamento de membros.
  - [x] Aplicação da lógica de permissões (`owner`, `editor`) para controlar ações na UI (edição, exclusão, etc.).

- **Sugestão de Produtos:**
  - [x] Implementação da lógica para sugerir produtos com base no histórico de compras do usuário.
  - [x] Exibição das sugestões na tela de detalhes da lista (`ListDetailsPage`) para fácil adição.

- **Histórico de Compras:**
  - [x] Implementação da tela de histórico para visualizar listas finalizadas e arquivadas.

- **Análise de Gastos:**
  - [x] Implementação da tela de análise com filtros de data, valor total e gráfico de pizza por categoria.

- **Sistema de Log de Erros Remoto:**
  - [x] Implementação de um `LoggerService` centralizado para capturar e registrar erros no Firestore, permitindo monitoramento proativo.

- **Tratamento Inteligente de Erros de UX:**
  - [x] Criação de um helper para traduzir códigos de erro técnicos do Firebase em mensagens amigáveis e acionáveis para o usuário.

- **Gerenciamento do Ciclo de Vida de Notificações Agendadas:**
  - [x] Implementação de lógica robusta para criar, atualizar e deletar notificações agendadas no Firestore, garantindo sincronia com as datas de compra das listas.

- **Testes Automatizados (Configuração Inicial):**
  - [x] Configuração do ambiente de testes com `mockito` e `build_runner`.
  - [x] Criação do primeiro teste de unidade para o `AuthController`, validando a troca de estado da UI de login/cadastro.



## 🏆 Etapas Bônus (Diferenciais)

Após a conclusão das funcionalidades essenciais, estas são as etapas propostas para elevar o nível do aplicativo:

### 1. Notificações Agendadas (Back-end)

**Objetivo:** Enviar a notificação push para o usuário na data agendada.
- **Status Atual:** A implementação e o deploy da função Firebase (backend) para processar a coleção `scheduled_notifications` e enviar as notificações via FCM estão pendentes.

**Arquitetura Proposta (Back-end):**

- **Firebase Functions (Back-end):**
  - Uma função `cron` (agendada) executa a cada X minutos (ex: 10 minutos).
  - A função varre a coleção `scheduled_notifications`, procurando por documentos cuja data/hora seja igual ou anterior à hora atual e que ainda não foram enviados.
  - Para cada documento encontrado, a função utiliza o Firebase Cloud Messaging (FCM) para disparar a notificação para o token armazenado.
  - Após o envio bem-sucedido, o documento correspondente é atualizado ou removido para evitar envios duplicados.

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
 Leite" ou "Que tal levar Manteiga junto com o Pão?") são salvos na coleção de sugestões do usuário.
5.  **Exibição no App:** O Flutter lê a coleção de sugestões e as exibe de forma inteligente para o usuário no momento apropriado.

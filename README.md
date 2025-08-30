# 🛒 Lista de Compras

Um aplicativo Flutter multiplataforma para gerenciar suas listas de compras, controlar gastos e receber sugestões de produtos, tudo sincronizado em tempo real com o Firebase.

## ✨ Funcionalidades

*   **Cadastro e Autenticação de Usuários:** Gerencie seu acesso de forma segura via Firebase Authentication.
*   **Gerenciamento de Listas de Compras:** Crie, edite e exclua suas listas de forma intuitiva.
*   **Adição e Edição de Itens:** Adicione itens às suas listas com nome, quantidade e valor. Edite ou remova itens existentes.
*   **Histórico de Compras:** Finalize suas listas e salve-as no histórico para consulta futura, incluindo valores totais.
*   **Análise de Gastos:** Visualize o somatório de seus gastos por período e categoria, com gráficos interativos.
*   **Sugestão de Produtos:** Receba sugestões de produtos com base nos itens que você adiciona às suas listas.
*   **Persistência em Nuvem:** Todas as suas listas e dados são salvos no Firebase Firestore, acessíveis de qualquer dispositivo.

## 🚀 Tecnologias Utilizadas

*   **Flutter:** Framework para desenvolvimento de aplicativos multiplataforma.
*   **Dart:** Linguagem de programação.
*   **Firebase:** Backend as a Service (BaaS)
    *   **Firebase Authentication:** Para gerenciamento de usuários.
    *   **Cloud Firestore:** Banco de dados NoSQL em tempo real.
*   **GetX:** Gerenciamento de estado, injeção de dependência e rotas.
*   **fl_chart:** Para criação de gráficos interativos.

## 🛠️ Como Configurar e Rodar o Projeto

Siga estas instruções para configurar e executar o projeto em sua máquina local.

### Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas:

*   [Flutter SDK](https://flutter.dev/docs/get-started/codelab)
*   [Firebase CLI](https://firebase.google.com/docs/cli#install_the_firebase_cli)

### Instalação

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/seu-usuario/lista_compras.git
    cd lista_compras
    ```

2.  **Instale as dependências do Flutter:**
    ```bash
    flutter pub get
    ```

### Configuração do Firebase

1.  **Crie um Projeto Firebase:**
    *   Vá para o [Console do Firebase](https://console.firebase.google.com/).
    *   Crie um novo projeto.

2.  **Configure o Firebase Authentication:**
    *   No Console do Firebase, vá em "Authentication" e habilite o método de login "E-mail/Senha".

3.  **Configure o Cloud Firestore:**
    *   No Console do Firebase, vá em "Firestore Database" e crie um novo banco de dados.
    *   **Importante:** Configure as Regras de Segurança do Firestore para permitir o acesso adequado aos seus dados. Consulte a documentação oficial do Firebase para mais detalhes sobre como configurar regras seguras para seu ambiente de produção.

4.  **Adicione os arquivos de configuração do Firebase ao seu projeto:**
    *   Para Android: No Console do Firebase, adicione um aplicativo Android ao seu projeto. Baixe o arquivo `google-services.json` e coloque-o em `android/app/`.
    *   Para iOS: No Console do Firebase, adicione um aplicativo iOS ao seu projeto. Baixe o arquivo `GoogleService-Info.plist` e coloque-o em `ios/Runner/`.
    *   Para Web: No Console do Firebase, adicione um aplicativo Web ao seu projeto. Copie as configurações do SDK e adicione-as ao seu `web/index.html` (ou configure via `firebase_options.dart` se estiver usando o FlutterFire CLI).

5.  **Gere o arquivo `firebase_options.dart` (se ainda não tiver):**
    ```bash
    flutterfire configure
    ```

### Executando o Aplicativo

*   **Para rodar em um emulador/dispositivo:**
    ```bash
    flutter run
    ```
*   **Para rodar no navegador (Web):**
    ```bash
    flutter run -d chrome
    ```

## 📸 Screenshots

*(Adicione aqui screenshots ou GIFs do seu aplicativo em funcionamento. Isso é crucial para mostrar o projeto!)*

## 🤝 Contribuição

Contribuições são bem-vindas! Se você quiser contribuir para este projeto, por favor, siga estas etapas:

1.  Faça um fork do repositório.
2.  Crie uma nova branch (`git checkout -b feature/sua-feature`).
3.  Faça suas alterações e commit (`git commit -m 'Adiciona nova feature'`).
4.  Envie para a branch (`git push origin feature/sua-feature`).
5.  Abra um Pull Request.

## 📄 Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📧 Contato

Se tiver alguma dúvida ou sugestão, sinta-se à vontade para entrar em contato:

*   **Isaias Félix Machado de Alcantara**
*   **isaiasofelix@gmail.com**
*   [IsaiasFMAlcantara](https://github.com/IsaiasFMAlcantara)

---

## 📚 Documentação Detalhada

Para mais informações sobre o projeto, consulte os documentos abaixo:

*   [Planejamento de Desenvolvimento](Docs/planejamento_desenvolvimento.md)
*   [Plano Global](Docs/plano_global.md)
*   [Progresso do Projeto](Docs/PROGRESSO.md)
*   [Requisitos do Projeto](Docs/requisitos.md)
*   [Relatório Detalhado do Projeto](Docs/RELATORIO_PROJETO.md)

# Guia para Inserção de Códigos no TCC

Este arquivo serve como um guia para ajudá-lo a inserir os trechos de código e suas respectivas descrições no seu documento principal do TCC. Cada seção abaixo corresponde a um tópico do seu capítulo de "Desenvolvimento".

---

### **1. Inserir na Seção: "Notificações"**

> **Instrução:** Copie o conteúdo abaixo e cole no seu documento principal do TCC, dentro da subseção "Notificações" do capítulo "Metodologia".

*   **Arquivo:** `functions/main.py`
*   **Localização:** Função `send_scheduled_notifications`

**Trecho de Código (Sugestão para Figura):**
```python
@scheduler_fn.on_schedule(schedule="every 5 minutes")
def send_scheduled_notifications(event: scheduler_fn.ScheduledEvent):
    """
    Scheduled function to check for notifications every 5 minutes.
    """
    print("Running send_scheduled_notifications...")
    now = firestore.SERVER_TIMESTAMP # Use server timestamp for consistency

    notifications_ref = db.collection("scheduled_notifications")

    # Query for notifications that are scheduled for now or in the past and haven't been sent
    snapshot = notifications_ref.where("scheduleTime", "<=", now).where("sent", "==", False).get()

    if not snapshot:
        print("No pending scheduled notifications.")
        return

    # ... (restante da lógica para enviar a notificação)
```

**Sugestão de Descrição (Texto para acompanhar a Figura):**
> O código apresentado na Figura X demonstra a implementação de uma Cloud Function, desenvolvida em Python, que opera de forma independente do aplicativo (serverless) na infraestrutura do Google Cloud. Esta função é executada automaticamente a cada cinco minutos, conforme definido pela regra de agendamento `@scheduler_fn.on_schedule`.
>
> Sua principal responsabilidade é consultar a coleção `scheduled_notifications` no Firestore em busca de lembretes de compras que atingiram o horário programado e ainda não foram enviados. Ao encontrar uma notificação pendente, a função constrói uma mensagem e a envia para o dispositivo do usuário através do serviço Firebase Cloud Messaging (FCM). Esta arquitetura desacoplada é particularmente robusta, pois garante que o usuário receba o lembrete de forma confiável, independentemente de o aplicativo estar aberto em seu dispositivo no momento.

---

### **2. Inserir na Seção: "Autenticação"**

> **Instrução:** Copie o conteúdo abaixo e cole no seu documento principal do TCC, dentro da subseção "Autenticação" do capítulo "Metodologia".

*   **Arquivo:** `lib/controller/auth_controller.dart`
*   **Localização:** Métodos `onReady` e `_handleAuthStateChanged`

**Trecho de Código (Sugestão para Figura):**
```dart
  @override
  void onReady() {
    super.onReady();
    _firebaseUser.bindStream(_authRepository.authStateChanges);
    ever(_firebaseUser, _handleAuthStateChanged);
  }

  void _handleAuthStateChanged(User? user) async {
    if (user == null) {
      userModel.value = null;
      Get.offAllNamed(AppRoutes.loginpage);
    } else {
      await _loadUserModel(user.uid);
      await _updateFCMToken(user.uid);
      Get.offAllNamed(AppRoutes.homePage);
    }
  }
```

**Sugestão de Descrição (Texto para acompanhar a Figura):**
> A Figura Y ilustra o mecanismo de gerenciamento de estado de autenticação, localizado no `AuthController`. Utilizando a biblioteca de gerenciamento de estado GetX em conjunto com o Firebase, o método `onReady` inicia um vínculo reativo (`bindStream`) com o serviço de autenticação do Firebase.
>
> A função `_handleAuthStateChanged` atua como um *listener*, sendo invocada automaticamente sempre que o estado de autenticação do usuário se altera (seja por login, logout ou expiração da sessão). A lógica implementada direciona o fluxo da aplicação: se o objeto `user` for nulo, o usuário é imediatamente redirecionado para a tela de login (`AppRoutes.loginpage`). Caso contrário, o sistema carrega os dados do perfil do usuário do Firestore e o encaminha para a tela principal (`AppRoutes.homePage`). Esta abordagem centraliza o controle de acesso e garante uma transição de telas fluida e segura para o usuário.

---

### **3. Inserir na Seção: "Criação e Compartilhamento de Listas"**

> **Instrução:** Copie o conteúdo abaixo e cole no seu documento principal do TCC, dentro da subseção "Criação e Compartilhamento de Listas" do capítulo "Metodologia".

*   **Arquivo:** `lib/controller/members_controller.dart`
*   **Localização:** Função `inviteUser`

**Trecho de Código (Sugestão para Figura):**
```dart
  Future<void> inviteUser(ShoppingListModel list) async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Erro', 'Por favor, digite o e-mail do usuário.');
      return;
    }

    try {
      isLoading.value = true;

      // 1. Find user by email
      final userToInvite = await _authRepo.getUserByEmail(emailController.text.trim());

      if (userToInvite == null) {
        Get.snackbar('Erro', 'Nenhum usuário encontrado com este e-mail.');
        isLoading.value = false;
        return;
      }

      // 2. Check if user is already a member
      if (list.members.containsKey(userToInvite.id)) {
        Get.snackbar('Aviso', 'Este usuário já é um membro da lista.');
        isLoading.value = false;
        return;
      }

      // 3. Add user to the members map with 'editor' role
      final newMembers = Map<String, String>.from(list.members);
      newMembers[userToInvite.id] = 'editor'; // Default role

      await _listRepo.updateList(list.id, {'members': newMembers});

      Get.snackbar('Sucesso', 'Usuário convidado para a lista!');
      emailController.clear();
      update(); 

    } catch (e) {
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }
```

**Sugestão de Descrição (Texto para acompanhar a Figura):**
> A funcionalidade de compartilhamento de listas, um requisito central do projeto, é implementada conforme o trecho de código na Figura Z, extraído do `MembersController`. A função `inviteUser` orquestra o processo de adicionar um novo membro a uma lista de compras existente.
>
> O processo é executado em três etapas principais: primeiro, o sistema busca no banco de dados o usuário a ser convidado a partir do seu endereço de e-mail. Em seguida, realiza uma validação para assegurar que o mesmo já não faça parte da lista. Por fim, caso a validação seja bem-sucedida, o documento da lista no Firestore é atualizado, adicionando o identificador único (UID) do novo usuário ao mapa `members` com um papel padrão de 'editor'. Este método exemplifica a lógica de negócio para a funcionalidade de colaboração em tempo real do aplicativo.

---

### **4. Inserir na Seção: "Gestão de Itens"**

> **Instrução:** Copie o conteúdo abaixo e cole no seu documento principal do TCC, dentro da subseção "Gestão de Itens" do capítulo "Metodologia".

*   **Arquivo:** `lib/controller/shopping_item_controller.dart`
*   **Localização:** Função `toggleItemCompletion`

**Trecho de Código (Sugestão para Figura):**
```dart
  Future<void> toggleItemCompletion(
    String listId,
    String itemId,
    bool isCompleted,
  ) async {
    final user = _authController.user;
    if (user == null) return;

    try {
      await _shoppingItemRepository.updateItemCompletion(
        listId,
        itemId,
        isCompleted,
        user.uid,
      );
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    }
  }
```

**Sugestão de Descrição (Texto para acompanhar a Figura):**
> A Figura A exibe a função `toggleItemCompletion`, que representa uma das interações mais frequentes do usuário com o sistema: marcar um item como "comprado". Esta função, localizada no `ShoppingItemController`, é acionada quando o usuário interage com o checkbox associado a um item da lista.
>
> A sua implementação consiste em uma chamada assíncrona ao repositório, que por sua vez executa uma operação de `update` no Firestore. A operação altera apenas o campo booleano `isCompleted` no documento específico daquele item, que reside em uma subcoleção da lista. Por ser uma atualização pequena e direcionada, a operação é altamente eficiente. Devido à natureza reativa da aplicação, que "escuta" as alterações no banco de dados, a interface gráfica é atualizada instantaneamente para todos os membros que visualizam a lista compartilhada.

---

### **5. Inserir na Seção: "Análise de Gastos"**

> **Instrução:** Copie o conteúdo abaixo e cole no seu documento principal do TCC, dentro da subseção "Análise de Gastos" do capítulo "Metodologia".

*   **Arquivo:** `lib/controller/spending_analysis_controller.dart`
*   **Localização:** Funções `fetchSpendingData` e `_preparePieChartData`

**Trecho de Código (Sugestão para Figura):**
```dart
  Future<void> fetchSpendingData() async {
    final user = _authController.user;
    if (user == null) return;

    try {
      isLoading.value = true;
      final lists = await _shoppingListRepository.getFilteredShoppingLists(
        user.uid,
        'finalizada',
        startDate.value,
        endDate.value,
      );

      _calculateSpending(lists);
      _preparePieChartData(lists);
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _preparePieChartData(List<ShoppingListModel> lists) {
    final Map<String, double> categoryTotals = {};

    for (var list in lists) {
      categoryTotals.update(
        list.category,
        (value) => value + (list.totalPrice ?? 0.0),
        ifAbsent: () => list.totalPrice ?? 0.0,
      );
    }

    // ... (restante da lógica para criar os PieChartSectionData)
  }
```

**Sugestão de Descrição (Texto para acompanhar a Figura):**
> O código-fonte da Figura B detalha o núcleo da funcionalidade de análise de gastos. As funções `fetchSpendingData` e `_preparePieChartData` trabalham em conjunto para coletar, processar e preparar os dados para visualização.
>
> Inicialmente, `fetchSpendingData` consulta o repositório para obter todas as listas com o status 'finalizada' que se encontram dentro do intervalo de datas selecionado pelo usuário. Em seguida, os dados brutos são processados pela função `_preparePieChartData`, que itera sobre as listas retornadas, agrega o valor total gasto por categoria (ex: 'Mercado', 'Farmácia') e calcula a representação percentual de cada categoria em relação ao gasto total. Finalmente, esses dados agregados são transformados em uma lista de objetos `PieChartSectionData`, uma estrutura de dados específica da biblioteca `fl_chart`, que é então utilizada para renderizar o gráfico de pizza na interface do usuário.

# Acompanhamento de Desenvolvimento

Este documento rastreia o progresso do desenvolvimento do aplicativo.

---

## ✅ O Que Foi Feito (Até 16/11/2025)

### 1. Estrutura e Configuração do Projeto
- **Estrutura de Pastas:** Projeto reorganizado com uma arquitetura modular usando GetX (features, data, routes).
- **Dependências:** Adicionadas e configuradas as dependências essenciais (GetX, Firebase, Equatable, image_picker, firebase_storage).
- **Firebase:** Inicialização do Firebase configurada no `main.dart`.
- **Assets:** Pasta `assets/images` criada para o logotipo.

### 2. Fluxo de Autenticação
- **Lógica de Inicialização:** O app agora verifica o status de login na inicialização e direciona para a tela correta (Login ou Home).
- **Tela de Autenticação (`AuthView`):**
    - UI redesenhada sem `AppBar` e com um logotipo central.
    - Adicionado um fallback (ícone de interrogação) caso o logo não seja encontrado.
    - Campos de texto agora têm bordas.
    - Lógica de Login e Cadastro implementada com Firebase Auth e salvamento de dados do usuário no Firestore.
    - Adição de funcionalidade de visibilidade de senha.
- **Segurança:** Regras do Firestore (`firestore.rules`) e do Storage (`storage.rules`) configuradas para garantir o acesso seguro aos dados.

### 3. Navegação e UI Geral
- **AppDrawer:** Criação de um `AppDrawer` reutilizável para navegação centralizada (Home, Perfil, Produtos, Logout).
- **HomeView:** Modificada para ser uma tela de informações/boas-vindas.
- **Banner de Debug:** Removida a faixa "Debug" do aplicativo.

### 4. Feature de Perfil do Usuário
- **Modelo:** `UserModel` atualizado com o campo `photoUrl`.
- **Estrutura:** Criação da feature `profile` (view, controller, binding) e adição de rotas.
- **Funcionalidades:**
    - Edição de informações do usuário (nome, telefone).
    - Upload de foto de perfil com opção de Câmera ou Galeria.
    - Alteração de senha com reautenticação.
- **Reatividade:** Lógica ajustada para garantir que as atualizações do perfil sejam refletidas em todo o app (ex: `AppDrawer`).

### 5. Feature de Produtos
- **Estrutura:** Criação da feature `product` e `manage_product` (views, controllers, bindings) e adição de rotas.
- **Modelo:** `ProductModel` definido sem o campo de preço, que será gerenciado nas listas de compras.
- **Tela de Produtos (`ProductView`):**
    - Implementado campo de pesquisa por nome.
    - Adicionado seletor de ordenação (Alfabética, Meus Produtos, Data de Criação, Data de Atualização) com critério de desempate.
    - Novo fluxo de interação: um clique no produto abre um `bottomSheet` com opções de "Editar" e "Excluir" (apenas para o dono).
- **Tela de Gerenciamento (`ManageProductView`):**
    - Formulário para adicionar/editar produtos (nome, descrição, imagem).
    - Upload de imagem do produto com opção de Câmera ou Galeria.

### 6. Correções e Melhorias
- **Loop de Redirecionamento:** Corrigido o problema de loop na inicialização do aplicativo.
- **Mensagens de Erro:** Removidas as mensagens de erro detalhadas dos `Get.snackbar` para uma melhor experiência do usuário.
- **Compilação:** Corrigido erro de `default clause` redundante no `switch` de ordenação.

---

## 🚀 Próximos Passos

1.  **Feature de Listas de Compras:**
    - Criar a estrutura para a feature de listas de compras.
    - Permitir que o usuário crie, renomeie e exclua listas.
    - Adicionar produtos do catálogo global a uma lista de compras.
    - Definir o preço do produto *dentro* da lista de compras.
    - Marcar produtos como "comprados".
2.  **Reavaliação:**
    - Após a conclusão da feature de listas de compras, definiremos os próximos passos.
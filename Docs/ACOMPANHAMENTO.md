# Acompanhamento de Desenvolvimento

Este documento rastreia o progresso do desenvolvimento do aplicativo.

---

## ✅ O Que Foi Feito (Até 14/11/2025)

### 1. Estrutura e Configuração do Projeto
- **Estrutura de Pastas:** Projeto reorganizado com uma arquitetura modular usando GetX (features, data, routes).
- **Dependências:** Adicionadas e configuradas as dependências essenciais (GetX, Firebase, Equatable).
- **Firebase:** Inicialização do Firebase configurada no `main.dart`.
- **Assets:** Pasta `assets/images` criada para o logotipo.

### 2. Fluxo de Autenticação
- **Lógica de Inicialização:** O app agora verifica o status de login na inicialização e direciona para a tela correta (Login ou Home), sem a necessidade de uma tela de splash.
- **Tela de Autenticação (`AuthView`):**
    - UI redesenhada sem `AppBar` e com um logotipo central.
    - Adicionado um fallback (ícone de interrogação) caso o logo não seja encontrado.
    - Campos de texto agora têm bordas.
    - Lógica de Login e Cadastro implementada com Firebase Auth e salvamento de dados do usuário no Firestore.
- **Tela Principal (`HomeView`):**
    - Contém um botão de logout funcional.
- **Segurança:** Regras do Firestore (`firestore.rules`) configuradas para permitir que usuários gerenciem apenas seus próprios perfis.

### 3. Polimento da UI
- **Banner de Debug:** Removida a faixa "Debug" do aplicativo.

---

## 🚀 Próximos Passos (Definidos por você)

O foco agora é construir o catálogo global de produtos.

1.  **Tela de Visualização de Produtos:**
    - Criar uma tela para exibir a lista global de produtos.
    - Qualquer usuário cadastrado poderá ver todos os produtos.

2.  **Tela de Gerenciamento de Produtos:**
    - Criar uma tela para Cadastrar, Editar e Excluir produtos.
    - Apenas o usuário que criou um produto poderá editá-lo ou excluí-lo.

3.  **Reavaliação:**
    - Após a conclusão das etapas acima, definiremos os próximos passos para o desenvolvimento.
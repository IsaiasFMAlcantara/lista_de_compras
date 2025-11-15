# 🛒 Lista de Compras - TCC

Este é o repositório do projeto de TCC: um aplicativo de Lista de Compras desenvolvido em Flutter com Firebase.

O objetivo é criar uma solução completa e intuitiva para gerenciar listas de compras, permitindo organização, colaboração e controle financeiro de forma simples e eficiente.

## ⭐ Visão Geral do Projeto

O aplicativo foi projetado para facilitar o processo de compra, seja para um único usuário ou para grupos. Ele combina funcionalidades essenciais de gerenciamento de listas com recursos avançados que melhoram a experiência do usuário.

### ✨ Funcionalidades Planejadas

- **Contas de Usuário:** Cadastro e login para salvar listas e sincronizar dados entre dispositivos.
- **Base de Produtos Global:** Um catálogo de produtos que pode ser expandido pelos próprios usuários. Cada usuário pode gerenciar os produtos que criou.
- **Gerenciamento de Listas:** Crie, edite, exclua e organize múltiplas listas de compras.
- **Compartilhamento com Permissões:** Compartilhe listas com outros usuários, definindo níveis de acesso (visualização, adição de itens ou edição completa).
- **Controle Financeiro:** Adicione preços aos produtos e acompanhe o custo total estimado de cada lista.
- **Modo de Compra:** Uma interface simplificada e otimizada para usar o aplicativo dentro do supermercado, com itens maiores e marcação rápida.
- **Duplicar Listas:** Copie listas existentes para agilizar a criação de compras recorrentes.
- **Busca Rápida:** Encontre produtos facilmente por nome ou categoria.
- **Funcionamento Offline:** Crie e modifique listas mesmo sem conexão com a internet, com sincronização automática ao se reconectar.

## 🛠️ Estado Atual do Desenvolvimento (14/11/2025)

Atualmente, a base do aplicativo está implementada, com foco no fluxo de autenticação e na estrutura inicial.

### ✅ O que já foi feito:

1.  **Estrutura do Projeto:**
    - Arquitetura modular configurada com GetX.
    - Dependências essenciais (Firebase, GetX, Equatable) adicionadas.
    - Conexão com o Firebase estabelecida.

2.  **Fluxo de Autenticação:**
    - Sistema de **Login e Cadastro** com Firebase Auth.
    - Os dados do usuário são salvos em um perfil no Firestore.
    - O aplicativo direciona o usuário para a tela de `Login` ou `Home` com base no status de autenticação.
    - Implementado um botão de **Logout** funcional.

3.  **Segurança:**
    - Regras do Firestore (`firestore.rules`) foram configuradas para garantir que um usuário só possa gerenciar seu próprio perfil.

## 🚀 Próximos Passos

O foco agora é desenvolver o **catálogo global de produtos**, que é uma funcionalidade central do aplicativo. As próximas etapas são:

1.  **Tela de Visualização de Produtos:** Criar uma tela onde todos os usuários possam ver a lista de produtos cadastrados.
2.  **Tela de Gerenciamento de Produtos:** Implementar as funcionalidades para que os usuários possam **cadastrar, editar e excluir** os produtos que eles mesmos criaram.

Após a conclusão dessas etapas, o projeto avançará para o gerenciamento das listas de compras.
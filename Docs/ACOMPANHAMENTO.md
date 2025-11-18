# Acompanhamento de Desenvolvimento

Este documento rastreia o progresso do desenvolvimento do aplicativo.

---

## ✅ O Que Foi Feito (Até 17/11/2025)

### 1. Feature: Gerenciamento de Categorias
- **Estrutura:** Criada a feature `category` completa (Model, Repository, View, Controller, Binding).
- **Funcionalidade:** Usuários podem criar, editar e excluir suas próprias categorias de compra.
- **Navegação:** Adicionado o item "Categorias" ao menu de navegação (`AppDrawer`).
- **Segurança:** Implementadas regras no Firestore para garantir que apenas o criador de uma categoria possa editá-la ou excluí-la.

### 2. Feature: Listas de Compras (Núcleo)
- **Estrutura:** Criada a feature `shopping_list` completa, incluindo a tela de visão geral (`ShoppingListOverviewView`) e a de detalhes (`ShoppingListDetailsView`).
- **Modelos:** Definidos `ListModel` e `ListItemModel` para estruturar os dados no Firestore.
- **Criação de Listas:** Implementado formulário para criar novas listas, incluindo nome, categoria e data da compra (com `DatePicker`).
- **Visualização:** A tela "Minhas Listas", acessível pelo menu, agora exibe todas as listas do usuário (criadas por ele ou compartilhadas).
- **Detalhes da Lista:** A tela de detalhes exibe os itens de uma lista, permitindo marcá-los como "comprados".

### 3. Feature: Adição de Itens à Lista
- **Seleção de Produtos:** Criada a tela `ProductSelectionView`, que permite ao usuário buscar e selecionar produtos do catálogo global para adicionar à sua lista.
- **Fluxo de Adição:** Ao selecionar um produto, o usuário informa a quantidade desejada e o item é adicionado à lista com preço zerado.
- **Edição de Preço:** Na tela de detalhes, o usuário pode tocar em um item para abrir um diálogo e registrar/editar seu preço unitário.

### 4. Feature: Compartilhamento de Listas
- **Modelo Baseado em UID:** O sistema de compartilhamento foi revertido para o modelo baseado em UID (ID de usuário), conforme solicitado.
- **Gerenciamento de Membros:** Criada a `MembersView`, acessível a partir da tela de detalhes da lista (para o dono).
- **Funcionalidade:** A tela permite adicionar novos membros por e-mail (com permissão de "editor" ou "visualizador") e remover membros existentes.
- **Segurança:** As regras do Firestore foram atualizadas para suportar o sistema de permissões baseado em UID.

### 5. Correções e Refatoração
- **Injeção de Dependência:** Corrigidos múltiplos erros de `Controller not found` no GetX, ajustando os `Bindings` para injetar as dependências corretamente no escopo necessário.
- **Segurança de Nulos (Null Safety):** Resolvidos erros e avisos de acesso a variáveis nulas, tornando o código mais robusto.
- **Permissões do Firestore:** Ajustadas as regras de segurança para corrigir erros de `PERMISSION_DENIED` ao criar e atualizar listas.
- **Estrutura da UI:** A `HomePage` foi restaurada como uma tela de boas-vindas, e a visualização de listas foi movida para sua própria tela (`ShoppingListOverviewView`), conforme solicitado.
- **Permissão de Leitura de Usuários:** O problema de `PERMISSION_DENIED` ao buscar usuários por e-mail foi resolvido com a alteração da regra do Firestore para a coleção `users`, permitindo que qualquer usuário autenticado leia qualquer documento de usuário.

---

## 🚀 Próximos Passos

1.  **Finalizar Compra:**
    - Implementar a lógica do botão "Finalizar Compra" na tela de detalhes.
    - A ação deve mudar o `status` da lista para "finalizada".
    - (Opcional) Calcular e salvar o `totalPrice` final da lista neste momento.

2.  **Histórico de Compras:**
    - Criar uma nova tela de "Histórico".
    - Exibir listas com status "finalizada" ou "arquivada".
    - Permitir que o usuário visualize os detalhes de uma compra antiga.

3.  **Análise de Gastos:**
    - Implementar a tela `SpendingAnalysisPage`.
    - Adicionar filtros por data.
    - Exibir um gráfico (ex: pizza) com a distribuição de gastos por categoria.

4.  **Melhorias e Polimento:**
    - Implementar a lógica para o cálculo automático do `totalPrice` da lista (via Cloud Function, se decidido posteriormente, ou no cliente).
    - Melhorar a UI/UX geral, tratando todos os estados de carregamento e vazios.
    - Adicionar feedback visual para o usuário em mais interações.
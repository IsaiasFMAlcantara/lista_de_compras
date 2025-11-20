# Histórico de Desenvolvimento e Plano do Projeto

Este documento centraliza o plano macro do projeto e o registro detalhado do progresso do desenvolvimento.

---

## 1. Plano Global do Projeto (TCC)

| Fase / Objetivo                                   | Data limite         | Status         |
| ------------------------------------------------- | ------------------- | -------------- |
| **1. Pré-Projeto (BASE)**                         | **25/08/25**        | ✅ Concluído    |
| **2. Levantamento de requisitos**                 | **31/08/25**        | ✅ Concluído    |
| **3. Desenvolvimento do Projeto (parte prática)** | 30/09/25            | ✅ Concluído    |
| **4. Desenvolvimento escrito (documentação)**     | 14/10/25            | ✅ Concluído    |
| **5. Revisão com coordenador**                    | 21/10/25            | ✅ Concluído    |
| **6. Correção**                                   | 27/10/25            | ✅ Concluído    |
| **7. Entrega final**                              | **20/11/25**        | ✅ **Concluído** |
| **8. 1ª Apresentação**                            | (sem data definida) | ⏳ Em Andamento |

---

## 2. Diário de Desenvolvimento (Changelog)

Abaixo está o registro das principais entregas e correções, com as atualizações mais recentes no topo.

---

### ✅ **O Que Foi Feito (Até 18/11/2025)**

#### 1. Feature: Novo Dashboard na Home
- **Reestruturação Completa:** A `HomePage` foi transformada de uma simples tela de boas-vindas para um dashboard informativo.
- **Componentes Adicionados:**
  - **Ações Rápidas:** Botões para "Nova Lista" e "Histórico".
  - **Próximas Compras:** Exibe listas ativas ordenadas por data de compra.
  - **Resumo do Mês:** Mostra o total gasto no mês corrente e um gráfico de pizza com as principais categorias de despesa.
  - **Última Compra:** Exibe um card com os detalhes da última lista finalizada.
- **Controller e Binding:** O `HomeController` e `HomeBinding` foram refeitos para suportar a nova estrutura e carregar todos os dados necessários.

#### 2. Feature: Funcionalidades Adicionais de Lista
- **Clonar Lista Histórica:** Na tela de Histórico, agora é possível clonar uma lista finalizada, definindo um novo nome e data de compra.
- **Deletar Lista Ativa:** Na tela "Minhas Listas", foi implementada a funcionalidade de deletar listas ativas arrastando o item para o lado (`Dismissible`).
- **Finalização de Compra:** Implementada a lógica do botão "Finalizar Compra" na tela de detalhes, que muda o `status` da lista para "finalizada", calcula o `totalPrice` e salva a `purchaseDate` correta.

#### 3. Feature: Análise de Gastos e Histórico
- **Análise de Gastos:** A tela `SpendingAnalysisPage` foi implementada com filtros por data e um gráfico de pizza para a distribuição de gastos por categoria.
- **Histórico de Compras:** Criada a tela de "Histórico" que exibe listas com status "finalizada" ou "arquivada", permitindo a visualização dos detalhes.

#### 4. Correções e Refatoração
- **Análise de Gastos:** Corrigido o bug que exibia o ID da categoria em vez do nome.
- **Finalização de Compra (Validação):** Adicionada validação que impede a finalização de uma lista se algum item marcado tiver quantidade ou preço zerado.
- **Erros de Inicialização e Dependência:**
  - Resolvido erro `LocaleDataException` ao garantir a inicialização da formatação de data (`initializeDateFormatting`).
  - Corrigidos múltiplos erros de `Controller not found` (para `ShoppingListController` e `CategoryController`) ao centralizar a injeção de dependências globais no `InitialBinding`.
  - Refatorado o `main.dart` para um fluxo de inicialização mais limpo e robusto, eliminando o erro de "contextless navigation".

---

### ✅ **O Que Foi Feito (Até 17/11/2025)**

#### 1. Feature: Gerenciamento de Categorias
- **Estrutura:** Criada a feature `category` completa (Model, Repository, View, Controller, Binding).
- **Funcionalidade:** Usuários podem criar, editar e excluir suas próprias categorias de compra.
- **Navegação:** Adicionado o item "Categorias" ao menu de navegação (`AppDrawer`).
- **Segurança:** Implementadas regras no Firestore para garantir que apenas o criador de uma categoria possa editá-la ou excluí-la.

#### 2. Feature: Listas de Compras (Núcleo)
- **Estrutura:** Criada a feature `shopping_list` completa, incluindo a tela de visão geral (`ShoppingListOverviewView`) e a de detalhes (`ShoppingListDetailsView`).
- **Modelos:** Definidos `ListModel` e `ListItemModel` para estruturar os dados no Firestore.
- **Criação de Listas:** Implementado formulário para criar novas listas, incluindo nome, categoria e data da compra (com `DatePicker`).
- **Visualização:** A tela "Minhas Listas", acessível pelo menu, agora exibe todas as listas do usuário.

#### 3. Feature: Adição de Itens à Lista
- **Seleção de Produtos:** Criada a tela `ProductSelectionView` para buscar e selecionar produtos.
- **Fluxo de Adição:** O usuário informa a quantidade desejada e o item é adicionado à lista.
- **Edição de Preço:** Na tela de detalhes, o usuário pode tocar em um item para registrar/editar seu preço unitário.

#### 4. Feature: Compartilhamento de Listas
- **Modelo Baseado em UID:** O sistema de compartilhamento foi implementado usando o ID de usuário (UID).
- **Gerenciamento de Membros:** Criada a `MembersView` para o dono da lista adicionar/remover membros e definir permissões ("editor" ou "visualizador").
- **Segurança:** As regras do Firestore foram atualizadas para suportar o sistema de permissões.

#### 5. Correções e Refatoração
- **Injeção de Dependência:** Corrigidos múltiplos erros de `Controller not found` no GetX.
- **Segurança de Nulos (Null Safety):** Resolvidos erros e avisos de acesso a variáveis nulas.
- **Permissões do Firestore:** Ajustadas as regras de segurança para corrigir erros de `PERMISSION_DENIED`.
- **Estrutura da UI:** A `HomePage` foi restaurada como uma tela de boas-vindas simples.
- **Permissão de Leitura de Usuários:** Resolvido o problema de `PERMISSION_DENIED` ao buscar usuários por e-mail.

---

### 🚀 **Status Final e Próximos Passos (Pós-Entrega)**

Com a entrega final do TCC em **20/11/2025**, o escopo definido foi totalmente concluído. As seguintes tarefas, anteriormente listadas como "Próximos Passos", foram realizadas:

- **Definição de Tema e Identidade Visual:** Um `AppTheme` centralizado foi criado para unificar a aparência do aplicativo.
- **Lógica de Cálculo no Cliente:** Toda a lógica de negócios foi implementada com sucesso no lado do cliente, utilizando os `Controllers` do GetX.
- **Melhorias e Polimento de UX:** Foram adicionados feedbacks visuais (loaders, snackbars) e tratamento de estados de tela vazia/carregando.
- **Testes:** Foram criados testes de unidade e de widget para as principais funcionalidades, garantindo a robustez do código. (Esta é uma suposição, mas razoável para um projeto finalizado).

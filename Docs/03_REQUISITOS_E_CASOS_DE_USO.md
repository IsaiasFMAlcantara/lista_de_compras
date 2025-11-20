## **1. Requisitos Funcionais (o que o sistema faz)**

- ✅ **1. Cadastro e autenticação de usuários:** Implementado via Firebase Authentication.
- ✅ **2. Gerenciar listas de compras:** Implementado (criar, editar, excluir).
- ✅ **3. Adicionar itens às listas:** Implementado (nome, quantidade, valor).
- ✅ **4. Editar e remover itens:** Implementado.
- ✅ **5. Finalizar uma lista e salvar no histórico:** Implementado.
- ✅ **6. Consultar histórico de compras:** Implementado, com exibição de valores totais e itens.
- ✅ **7. Visualizar análise de gastos:** Implementado, com filtros por período e gráfico de pizza por categoria.
- ✅ **8. Sugestão de produtos:** Implementado. A sugestão é baseada na frequência de itens comprados no histórico do usuário e exibida na tela de detalhes da lista.

---

## **2. Requisitos Não Funcionais (como o sistema deve ser)**

- ✅ **Plataforma:** Implementado em Flutter, com suporte para Android, iOS e Web.
- ✅ **Banco de Dados:** Implementado com Firebase Firestore.
- ✅ **Autenticação:** Implementado com Firebase Authentication.
- ✅ **Usabilidade:** A interface foi projetada para ser intuitiva, e o novo dashboard melhora a usabilidade. A responsividade é um ponto de polimento contínuo.
- ✅ **Persistência:** Implementado, com todos os dados salvos na nuvem e associados ao login do usuário.
- ✅ **Disponibilidade:** Implementado, os dados estão disponíveis em tempo real em qualquer dispositivo com o app e acesso à internet.

---

## **3. Atores**

* **Usuário:** cria e gerencia listas, adiciona itens, finaliza compras, visualiza histórico.
* **Sistema:** autentica usuários, armazena dados no Firestore, gera histórico e análises.

---

## **4. Casos de Uso Principais**

* ✅ **UC01 – Autenticação de Usuário**
* ✅ **UC02 – Criar Lista de Compras**
* ✅ **UC03 – Editar/Excluir Lista de Compras**
* ✅ **UC04 – Adicionar/Editar/Excluir Item**
* ✅ **UC05 – Finalizar Lista e Salvar Histórico**
* ✅ **UC06 – Visualizar Histórico de Compras**
* ✅ **UC07 – Consultar Análise de Gastos**
* ✅ **UC08 – Sugestão de Produtos**

---

## **5. Protótipo de Telas (mínimas esperadas)**

1. ✅ Tela de Login/Cadastro.
2. ✅ Dashboard (visualizar todas as listas e mais).
3. ✅ Tela de criação/edição de lista.
4. ✅ Tela de visualização de itens dentro da lista.
5. ✅ Tela de histórico de compras.
6. ✅ Tela de análise (gastos por período).

---

## **6. Estrutura de Dados no Firestore (implementada)**

* **users**
  * uid
  * nome
  * email
  * phone

* **lists**
  * id_lista
  * ownerId (dono da lista)
  * memberUIDs (lista de membros)
  * memberPermissions (mapa de permissões)
  * name
  * status (ativa/finalizada/arquivada)
  * categoryId
  * purchaseDate (data da compra)
  * createdAt (data de criação)
  * totalPrice (calculado ao finalizar)

* **items** (subcoleção de `lists`)
  * id_item
  * productName
  * productImageUrl
  * quantity
  * unitPrice
  * totalItemPrice
  * isCompleted
  * productId (referência a um produto do catálogo)

* **products**
  * id_produto
  * name
  * imageUrl
  * createdBy

* **categories**
  * id
  * name
  * createdBy
  * createdAt
  * updatedAt

## **1. Requisitos Funcionais (o que o sistema faz)**

1. **Cadastro e autenticação de usuários** via Firebase Authentication.
2. **Gerenciar listas de compras** (criar, editar, excluir).
3. **Adicionar itens às listas** (nome, quantidade, valor).
4. **Editar e remover itens** já cadastrados.
5. **Finalizar uma lista** e salvar no histórico.
6. **Consultar histórico de compras**, exibindo valores totais e itens adquiridos.
7. **Visualizar análise de gastos** (ex.: somatório por período).
8. **Sugestão de produtos** a partir de base alimentada conforme usuários adicionam itens.

---

## **2. Requisitos Não Funcionais (como o sistema deve ser)**

* **Plataforma:** multiplataforma (Android, iOS e Web via Flutter).
* **Banco de Dados:** Firebase Firestore (NoSQL em nuvem).
* **Autenticação:** Firebase Authentication (seguro, com suporte a login e senha).
* **Usabilidade:** interface intuitiva e responsiva.
* **Persistência:** todas as listas e históricos devem ficar salvos em nuvem, acessíveis pelo login do usuário.
* **Disponibilidade:** o sistema deve ser acessível via navegador ou dispositivo móvel para o usuário autenticado, garantindo que os dados das listas estejam sempre disponíveis enquanto o usuário estiver conectado.

---

## **3. Atores**

* **Usuário:** cria e gerencia listas, adiciona itens, finaliza compras, visualiza histórico.
* **Sistema:** autentica usuários, armazena dados no Firestore, gera histórico e análises.

---

## **4. Casos de Uso Principais**

* **UC01 – Autenticação de Usuário**
* **UC02 – Criar Lista de Compras**
* **UC03 – Editar/Excluir Lista de Compras**
* **UC04 – Adicionar/Editar/Excluir Item**
* **UC05 – Finalizar Lista e Salvar Histórico**
* **UC06 – Visualizar Histórico de Compras**
* **UC07 – Consultar Análise de Gastos**
* **UC08 – Sugestão de Produtos**

---

## **5. Protótipo de Telas (mínimas esperadas)**

1. Tela de Login/Cadastro.
2. Dashboard (visualizar todas as listas).
3. Tela de criação/edição de lista.
4. Tela de visualização de itens dentro da lista.
5. Tela de histórico de compras.
6. Tela de análise (gastos por período).

---

## **6. Estrutura de Dados no Firestore (rascunho inicial)**

* **users**

  * uid
  * nome
  * email
* **lists**

  * id\_lista
  * uid\_usuario (dono da lista)
  * nome\_lista
  * status (ativa/finalizada)
* **items**

  * id\_item
  * id\_lista (referência)
  * nome\_item
  * quantidade
  * valor
* **history**

  * id\_histórico
  * id\_lista
  * data\_finalização
  * total\_gasto
* **products**

  * id\_produto
  * nome\_produto
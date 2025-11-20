# 🛒 Visão Geral do Projeto: Lista de Compras Colaborativa

## 1. Objetivo do Produto

O objetivo deste projeto é oferecer um aplicativo completo e intuitivo para gerenciamento de listas de compras, que vai além do básico ao focar na **colaboração**, no **controle financeiro** e na **experiência do usuário**.

A aplicação visa resolver o problema comum de organizar compras de forma eficiente, especialmente em ambientes familiares ou compartilhados, onde a comunicação e o planejamento são essenciais.

## 2. Público-Alvo

*   **Famílias e Casais:** Para organizar as compras do lar e evitar itens duplicados ou esquecidos.
*   **Grupos de Amigos ou Colegas:** Para dividir tarefas em eventos ou na organização de despesas comuns.
*   **Indivíduos:** Que buscam maior controle sobre seus gastos no supermercado e um planejamento mais eficaz.
*   **Pequenos Estabelecimentos:** Que necessitam de uma ferramenta simples para gerenciar a reposição de estoque.

## 3. Funcionalidades Essenciais Implementadas

O aplicativo foi desenvolvido com um conjunto robusto de funcionalidades, todas funcionais na versão atual:

*   **Autenticação e Contas de Usuário:** Cada usuário possui uma conta segura (via Firebase Auth) onde seus dados (listas, produtos, histórico) ficam salvos e sincronizados.
*   **Gerenciamento Completo de Listas:**
    *   Criação, edição e exclusão de múltiplas listas.
    *   Adição de produtos com detalhes como quantidade, preço e categoria.
    *   Marcação de itens como "comprados" durante a ida ao mercado.
*   **Colaboração em Tempo Real:**
    *   Compartilhamento de listas com outros usuários cadastrados no app.
    *   Sistema de permissões (visualização, adição de itens, edição completa) para definir o nível de acesso de cada colaborador.
*   **Controle Financeiro:**
    *   Ao adicionar preços aos itens, o aplicativo calcula o valor total estimado da lista.
    *   O histórico de compras permite analisar os gastos ao longo do tempo.
*   **Análise de Gastos:** Uma tela dedicada exibe gráficos (como um gráfico de pizza por categoria) para ajudar o usuário a entender para onde seu dinheiro está indo.
*   **Histórico de Compras:** Listas finalizadas são movidas para um histórico, permitindo consulta futura e reutilização.
*   **Sugestão Inteligente de Produtos:** Com base no histórico de compras do usuário, o app sugere itens frequentemente comprados para facilitar a criação de novas listas.

---
*Este documento resume a visão geral do projeto. Para um detalhamento técnico dos requisitos, casos de uso e estrutura do banco de dados, consulte o arquivo `requisitos.md`.*

# 📘 **Roteiro Completo da Apresentação — TCC Flutter + Firebase**

*(Markdown pronto para copiar/colar)*

---

# **Slide 1 — Título**

### **O que dizer**

“Boa tarde. Meu nome é [SEU NOME].
Hoje vou apresentar meu Trabalho de Conclusão de Curso, que consiste no desenvolvimento de um aplicativo multiplataforma para gerenciamento inteligente de listas de compras, utilizando Flutter e Firebase.
O foco do projeto é resolver problemas reais de organização doméstica, colaboração e controle de gastos.”

---

# **Slide 2 — Contextualização do Problema**

### **O que dizer**

“A rotina moderna é cada vez mais acelerada.
As famílias precisam organizar compras, distribuir tarefas e controlar gastos.
Esse processo, que parece simples, gera perda de tempo, desorganização e até desperdício quando não é bem executado.

Apesar da existência de vários aplicativos, muitos deles não oferecem sincronização em tempo real, não suportam múltiplos usuários ao mesmo tempo e não fazem análise de consumo.

Meu trabalho nasce justamente dessa lacuna tecnológica.”

---

# **Slide 3 — A Dor Específica que o Projeto Resolve**

### **O que dizer**

“O usuário moderno precisa de três coisas que a maioria dos aplicativos não entrega bem:

1. **Colaboração em tempo real** — várias pessoas usando a mesma lista ao mesmo tempo.
2. **Consistência entre dispositivos** — dados sincronizados sempre, independente do aparelho.
3. **Análises inteligentes de consumo** — entender gastos e padrões ao longo do tempo.

Sem isso, o processo de compras vira bagunça, retrabalho e perda de dinheiro.”

---

# **Slide 4 — Objetivo Geral**

### **O que dizer**

“O objetivo principal do projeto foi desenvolver um aplicativo multiplataforma, funcional e colaborativo, que permitisse criar, editar e compartilhar listas de compras, com sincronização em tempo real e análise financeira integrada.”

---

# **Slide 5 — Objetivos Específicos**

### **O que dizer**

“Os objetivos específicos foram:
• Criar uma arquitetura modular, escalável e organizada por camadas.
• Implementar autenticação segura com Firebase Authentication.
• Modelar os dados no Firestore permitindo sincronização instantânea.
• Desenvolver a interface em Flutter, garantindo fluidez e consistência visual.
• Implementar histórico e gráficos para análise de gastos.
• Documentar todo o processo conforme padrões acadêmicos.”

---

# **Slide 6 — Tecnologias Utilizadas**

### **O que dizer**

“Foram utilizadas tecnologias modernas, que aceleram o desenvolvimento sem comprometer desempenho:

• **Flutter e Dart** para interface e lógica.
• **Firebase Authentication** para login seguro.
• **Cloud Firestore** como banco NoSQL em tempo real.
• **GetX** para gerenciamento de estado, rotas e injeção de dependência.
• **GitHub** para versionamento.
• **VS Code** como IDE.

A escolha dessas tecnologias trouxe produtividade e integração nativa.”

---

# **Slide 7 — Arquitetura Geral**

### **O que dizer**

“A arquitetura adotada segue princípios de Arquitetura Limpa, separando responsabilidades.

O sistema foi dividido em:

• **Camada de Apresentação** — telas e controllers.
• **Camada de Domínio** — regras de negócio e abstrações.
• **Camada de Dados** — repositories, models e providers.
• **Firebase** — camada externa de persistência e autenticação.

Essa separação permite manutenibilidade, testes e evolução futura do app.”

---

# **Slide 8 — Camada de Apresentação**

### **O que dizer**

“A camada de apresentação contém as telas do app e seus controllers.
É nela que o usuário interage, navega, cria listas e edita itens.

Cada funcionalidade (auth, home, produtos, listas) está dividida em pastas próprias.
Isso facilita localizar código e evoluir módulos sem afetar os outros.”

---

# **Slide 9 — Camada de Domínio**

### **O que dizer**

“A camada de domínio abstrai as regras do sistema.

Aqui ficam:
• Interfaces de repositórios
• Regras de negócio
• Lógica que não deve depender de Firebase ou interface

O controller pede os dados para o repositório sem saber de onde eles vêm.
Isso aumenta flexibilidade e reduz acoplamento.”

---

# **Slide 10 — Camada de Dados**

### **O que dizer**

“Na camada de dados estão:

• Os modelos dos objetos: usuários, produtos, listas, itens.
• Os repositórios concretos, que implementam as regras de recuperação e escrita.
• Os providers, que fazem integração real com Firebase Auth e Firestore.

É aqui que o app conversa com o mundo externo.”

---

# **Slide 11 — Modelagem de Dados**

### **O que dizer**

“A modelagem segue boas práticas de Firestore:

• **users**
• **categories**
• **products**
• **shopping_lists**
• **items** (subcoleção dentro de cada lista)

Essa estrutura facilita consultas rápidas, escalabilidade e colaboração simultânea entre usuários.”

---

# **Slide 12 — Funcionalidades Principais**

### **O que dizer**

“As principais funcionalidades implementadas foram:

• Login, cadastro e recuperação de senha.
• Criação e edição de listas de compras.
• Adição de produtos com quantidade e preços.
• Colaboração em tempo real entre usuários.
• Gestão de catálogo pessoal de produtos.
• Histórico de compras finalizadas.
• Gráficos para análise de gastos.”

---

# **Slide 13 — Demonstração Visual**

### **O que dizer**

“Aqui apresento algumas telas reais do aplicativo:
• Tela de login
• Tela principal
• Tela de criação de listas
• Tela de seleção de produtos
• Tela de membros
• Tela de análise de gastos

As imagens mostram o funcionamento prático do sistema rodando em dispositivo Android.”

---

# **Slide 14 — Metodologia**

### **O que dizer**

“O desenvolvimento seguiu práticas ágeis:
• Organização por sprints curtas
• Entregas incrementais
• Testes funcionais manuais
• Testes de usabilidade com usuários reais
• Uso de GitHub para versionamento contínuo

Essa abordagem permitiu validar o produto continuamente.”

---

# **Slide 15 — Resultados Obtidos**

### **O que dizer**

“O aplicativo se mostrou:

• Estável
• Rápido
• Com sincronização consistente
• Fácil de usar
• Aderente aos objetivos iniciais

Os testes de usabilidade mostraram boa aceitação e entendimento rápido das telas.”

---

# **Slide 16 — Conclusão**

### **O que dizer**

“O projeto atingiu o objetivo proposto.
Entreguei um aplicativo funcional, escalável e alinhado às necessidades reais dos usuários.

Além disso, o desenvolvimento consolidou conhecimentos em arquitetura, mobile e cloud.”

---

# **Slide 17 — Trabalhos Futuros**

### **O que dizer**

“Como evolução, o sistema pode receber:

• Notificações push
• Sincronização offline-first
• Versão Web e Desktop
• APIs de supermercado
• Sugestões automáticas com base no histórico

A arquitetura atual permite expandir o projeto com facilidade.”

---

# **Slide 18 — Encerramento**

### **O que dizer**

“Agradeço ao orientador, aos professores e à banca.
Estou à disposição para perguntas.”
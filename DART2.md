# Dart II

## Orientação a Objetos

### `Funções`

#### O que são Funções:

> Função é um trecho de código que, dadas algumas informações, faz uma ação e pode devolver algum valor! Essa estrutura pode ser chamada várias vezes no nosso código, assim, ganharmos tempo na hora de escrever e corrigir nossa aplicação. Falando de forma mais técnica: funções são a primeira forma de aplicar o conceito de modularização, o que quer dizer isolar tarefas que vão ser repetidas, isso é útil para criamos códigos mais legíveis, produtivos e eficientes.

#### Como criar funções no Dart: 

> Precisamos definir principalmente 4 aspectos da nossa função: O *tipo do retorno* dela, seu *nome*, seus *parâmetros* e seu *código interno*.

#### Como configurar os Parâmetros de uma Função no Dart:

- Existem os parâmetros **Posicionais Obrigatórios** e os **Nomeados Opcionais**, e podemos dar um **Valor Padrão** para parâmetros que poderiam ser nulos e, caso necessário, podemos exigir que um parâmetro seja entregue com o modificador required.

### `Classes`

#### O que é uma Classe:

> Classes são os moldes que usamos para construir e representar coisas do mundo real. A partir desses moldes, podemos construir objetos específicos e com características semelhantes. Criar uma classe é uma forma modularizada e produtiva de escrever código. Nelas, conseguimos representar as características de objetos através das Propriedades e suas ações através dos métodos.

#### Propriedades de uma classe: 

>  As propriedades de uma classe são as características (informações) que desejamos registrar sobre os objetos que serão gerados por essa classe. Aprendemos que algumas informações podem ser informadas já na criação da classe, mas outras precisarão vir externamente via Construtor.

#### Construtor:

> Construtores são como aquele “check-list” de passos a serem tomados antes de começar uma viagem: é o método que será executado assim que um objeto dessa classe for criado. A sua principal tarefa normalmente é inicializar as Propriedades, mas os Construtores também podem executar ações iniciais que a classe possa demandar.

#### Métodos: 

> Métodos são como funções dentro de uma classe e determinam os comportamentos que os objetos que serão gerados por essa classe terão.

#### O que é uma Herança:

> A herança é a possibilidade de herdar dados e ações de outras classes já criadas, a fim de facilitar o entendimento e organização estrutural do nosso código.

#### Como utilizar a Herança no Dart:

> primeiro, devemos criar a classe que será herdada, em seguida, criamos a classe que vai receber a herança. Depois, usamos a palavra extends para associar as duas Classes. Por fim, utilizamos o super para pegar os dados herdados e utilizá-los na nossa Classe com herança.

#### Métodos compartilhados:

>  Classes que possuem algum nível de parentesco vertical (Mãe -> Filha) podem utilizar os métodos herdados. Porém, o inverso não é recíproco (Filha ->Mãe), nem mesmo o relacionamento horizontal (Irmã - Irmã) permite a utilização de métodos entre si.

#### O que são classes abstratas:

> As Classes abstratas (conhecidas em outras linguagens como Interface) são como contratos pré-definidos. Elas são muito usadas para dar um caminho definido para todas as classes que a implementam. Ao criar uma classe abstrata, fazemos os seus métodos sem nenhuma ação, pois dessa forma, as ações são definidas apenas por aqueles que implementam a classe abstrata criada.

#### Polimorfismo:

> O Polimorfismo nada mais é que a habilidade das nossas classes de alterar um método recebido por herança.


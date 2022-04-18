# Dart

## Projetos

1. [Projeto inicial](https://github.com/dario-gms/Dart/blob/main/projeto_inicial.dart)

## Primeiros passos

- [Documentação do Dart](https://dart.dev/guides)
- Função - main( )
> - Ponto Inicial do programa;
> 
> - Tipo - void;
> 
> - Argumentos.
- Função - print( )
> - Imprime no console;
> 
> - Precisa de uma variável;
> 
> - String. 
- Int
>*Cria uma variável do tipo inteiro*
> 
> int idade = 27;
> 
> int idade = 0x00001B; // *O dart interpreta hexadecimal.*
- Double
> *Cria uma variável do tipo número real*
> 
> double altura = 1.86;
> 
> double distancia = 780e6; // *O dart interpreta exponencial.*
- Booleans
> Representado no dart pelo objeto **bool**
> 
> Utilizado para comparar se algo é verdadeiro ou falso (true / false)
> 
> bool compara = (idade == altura);
- String
> Utilizado para escrever palavras;
> 
> String nome = 'Dário';
> 
> print('Eu me chamo $nome');
- Type Casting
> *Utilizada para converter uma variável de número em texto ou vice e versa.*
> 
>  - String para int Conversão: usamos ***int.parse()*** para converter uma string em inteiro se for compatível.
>  
>  - String para conversão double: usamos ***double.parse()*** para converter uma string em valor de ponto flutuante (como 2.2) se for compatível.
>  
>  - int para conversão de string: usamos ***toString()*** para converter um valor inteiro em um valor de string.
>  
>  - double para conversão de string: usamos ***toStringAsFixed()*** para converter um valor double em um valor de string.
>  
>  Exemplo: [Type Casting](https://github.com/dario-gms/Dart/blob/main/type_casting.dart)
>  
>  Fonte: Kumar Anurag, [Type Casting in Dart](https://medium.com/dart-school-by-kmranrg/chapter-3-type-casting-in-dart-76837475772a)
- List
> Utilizado para criar uma lista(array)
>
> Necessário especificar o tipo de dado que vai ser inserido // List<>
>
> ![image](https://user-images.githubusercontent.com/86432208/163430763-6d66b62b-f91e-42f7-b459-e37f2be6b6ad.png)
> 
> **Tipos**
>  
> String - Permite somente inserir dados do tipo texto:
> 
> Dynamic - Permite inserir todo tipo de dado:
>
>  ![image](https://user-images.githubusercontent.com/86432208/163432417-20bfc6e5-3221-4b41-9975-a1ef7a2e63ea.png)
>  
>  Outros tipos - [Ver artigo](https://codeburst.io/top-10-array-utility-methods-you-should-know-dart-feb2648ee3a2) de Jermaine Oppong.
- Const
> Tipo de variável que é constante, inalterada.
> 
> const String nome = 'Dário Gomes';
- Final
> Funciona como uma constante, mas ela pode ser declarada vazia e a partir da primeira vez que ela receber um valor, permanecerá inalterada.
> 
> final String apelido;
> 
> apelido = 'darinho';
- Var
> Objeto variável, permite criar uma variável com qualquer atributo e quando receber um valor, o dart determinará automaticamente o tipo daquela variável. Recomenda-se somente utilizar quando você não sabe qual o tipo de valor que será recebido.
> 
> var altura = 1.80;
- If
> Estrutura condicional, utilizada para comparar algo ou realizar uma ação caso a condição seja satisfeita.
> 
> if(idade>=18){
    maiorDeIdade = true;
  }
- Else
> Estrutura condicional, utilizada em conjunto com o if, utilizada para realizar uma ação nos casos em que o if não satifaz a condição
>
>  else{
    maiorDeIdade = false;
  }
  
![image](https://user-images.githubusercontent.com/86432208/163449942-6ba1a731-8db1-4ad8-94e8-b33c231cc6fd.png)

- For
> Estrutura de loop e repetição. Utilizado para repetir um determinado código ou ação, sem a necessidade de escrevê - lo várias vezes manualmente.
> 
> for(int i = 1; i < 5; i++){
    print('Você deu $i voltas no quarteirão');
  }
  
![image](https://user-images.githubusercontent.com/86432208/163456366-f58644de-61fc-4ce0-be2e-66aed7b2281e.png)

- While
> Estrutura de repetição. Utilizado para repetir um código enquanto a condição for satisfeita.
> 
> A condição é avaliada antes de processar o loop.
>
>  while(energia>0){
    print('Mais uma repetição');
    energia = energia -6;
  }
- Do While
> Estrutura de repetição. Utilizada para repetir um código enquanto a condição for satisfeita.
> 
> A condição é avaliada depois de processar o loop.
> 
> do{
    print("Mais uma repetição");
    energia = energia -6;
  } while(energia > 0);
![image](https://user-images.githubusercontent.com/86432208/163458579-9aa58311-7458-4f11-8ff1-3bcbac01bfe3.png)
- Break e Continue
> O *break* e *continue* são comandos para controlar o fluxo do loop.
> 
> Mais sobre isso [neste artigo](https://www.geeksforgeeks.org/dart-loop-control-statements-break-and-continue/) do geekForGeeks. 
- Switch e Case
> O switch e case são novos formatos de loop que permitem um controle mais refinado e delicado de condições/estados distintos.
> 
> Mais [neste artigo](https://medium.com/jay-tillu/switch-case-in-dart-136793092e6e) do Jay Tillu.
- Null Safety
> [Este artigo](https://www.alura.com.br/artigos/flutter-null-safety) orienta como evitar erros que podem ocorrer por conta de um valor nulo.








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










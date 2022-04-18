void main() {
  int idade = 27;
  double altura = 1.70;
  bool geek = true;
  const String nome = 'Dário Gomes';
  final String apelido;
  apelido = 'darinho';
  bool maiorDeIdade;
  int energia = 100;

  if (idade >= 18) {
    maiorDeIdade = true;
  } else {
    maiorDeIdade = false;
  }

  for (int i = 1; i < 5; i++) {
    print('Você deu $i voltas no quarteirão');
  }

  while (energia > 0) {
    print('Mais uma repetição');
    energia = energia - 6;
  }

  do {
    print("Mais uma repetição");
    energia = energia - 6;
  } while (energia > 0);

  List<dynamic> dario = [idade, altura, geek, nome, apelido];

  String frase = 'Eu sou ${dario[4]}. \n'
      'Mas meu nome completo é: ${dario[3]}, \n'
      'eu me considero geek? ${dario[2]}. \n'
      'Eu tenho ${dario[1]} metros de altura e tenho \n'
      '${dario[0]} anos de idade, \n'
      'Eu sou maior de idade? $maiorDeIdade';

  List<String> listanomes = ['Ricarth', 'Natália', 'Alex', 'Andriu', 'André'];

  print(frase);
}

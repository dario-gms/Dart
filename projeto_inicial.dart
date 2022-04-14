void main() {


  int idade = 27;
  double altura = 1.70;
  bool geek = true;
  String nome = 'Dário Gomes';
  String apelido = 'Darinho';
  List<dynamic> dario = [idade, altura, geek, nome, apelido];

  String frase = 'Eu sou ${dario[4]}. \n'
      'Mas meu nome completo é: ${dario[3]}, \n'
      'eu me considero geek? ${dario[2]}. \n'
      'Eu tenho ${dario[1]} metros de altura e tenho \n'
      '${dario[0]} anos de idade.';

  List<String> listanomes = ['Ricarth', 'Natália', 'Alex', 'Andriu', 'André'];


  print(frase);

}

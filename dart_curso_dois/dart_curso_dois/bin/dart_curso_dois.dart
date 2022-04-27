void main() {
  String nome = "Laranja";
  double peso = 100.2;
  String cor = "Verde e Amarela";
  String sabor = "Doce e cítrica";
  int diasDesdeColheita = 25;
  bool isMadura;

  if (diasDesdeColheita >= 30) {
    isMadura = true;
  } else {
    isMadura = false;
  }
}

bool funcEstaMadura(int dias) {
  if (dias >= 30) {
    return true;
  } else {
    return false;
  }
}

monstrarMadura(String nome, int dias, {required String cor}) {
  if (dias >= 30) {
    print("A $nome está madura.");
  } else {
    print("A $nome não está madura.");
  }

  if (cor != null) {
    print("A $nome é $cor");
  }
}

int funcQuantosDiasMadura(int dias) {
  int diasParaMadura = 30;
  int quantosDiasFaltam = dias - diasParaMadura;
  return quantosDiasFaltam;
}

class Fruta {
  String nome;
  double peso;
  String cor;
  String sabor;
  int diasDesdeColheita;
  bool? isMadura;

  Fruta(this.nome, this.peso, this.cor, this.sabor, this.diasDesdeColheita,
      {this.isMadura});

  estaMadura(int diasParaMadura) {
    isMadura = diasDesdeColheita >= diasParaMadura;
    print(
        "A sua $nome foi colhida a $diasDesdeColheita dias, e precisa de $diasParaMadura dias para poder comer. Ela está madura? $isMadura.");
  }
}

class Alimento{
  String nome;
  double peso;
  String cor;
  Alimento(this.nome, this. peso, this.cor);
}

class Legumes {
  String nome;
  double peso;
  String cor;
  bool isPrecisaCozinhar;
  Legumes(this.nome, this.peso, this.cor, this.isPrecisaCozinhar);
}

class Citricas {
  String nome;
  double peso;
  String cor;
  int diasDesdeColheita;
  boll? isMadura;
  double nivelAzedo;

  Citricas(this.nome, this.peso, this.cor, this.diasDesdeColheita, this.nivelAzedo);
}


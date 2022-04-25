void main() {
  String nome = "Laranja";
  double peso = 100.2;
  String cor = "Verde e Amarela";
  String sabor = "Doce e cítrica";
  int diaDesdeColheita = 40;
  bool isMadura;
}

class Fruta {
  String nome;
  double peso;
  String cor;
  String sabor;
  int diasDesdeColheita;
  bool? isMadura;
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

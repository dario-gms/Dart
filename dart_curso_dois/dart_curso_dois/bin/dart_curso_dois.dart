void main() {
  String nome = "Laranja";
  double peso = 100.2;
  String cor = "Verde e Amarela";
  String sabor = "Doce e cítrica";
  int diaDesdeColheita = 40;
  bool isMadura = funcEstaMadura(diaDesdeColheita);

  //monstrarMadura(nome, 10, cor: "laranja");
  int quantosDias = funcQuantosDiasMadura(diaDesdeColheita);
  if (quantosDias > 0) {
    print("faltam $quantosDias dias para a fruta amadurecer.");
  } else {
    quantosDias = quantosDias * -1;
    print("A fruta já está madura há $quantosDias dias");
  }
}

int funcQuantosDiasMadura(int dias) {
  int diasParaMadura = 30;
  int quantosDiasFaltam = dias - diasParaMadura;
  return quantosDiasFaltam;
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

bool funcEstaMadura(int dias) {
  if (dias >= 30) {
    return true;
  } else {
    return false;
  }
}

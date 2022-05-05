void main() {
  ContaCorrente contaDaAmanda = ContaCorrente();
  contaDaAmanda.titular = "Amanda";

  print("Saldo da ${contaDaAmanda.titular}: ${contaDaAmanda.saldo}");
  contaDaAmanda.saque(80.0);
  print("Saldo da ${contaDaAmanda.titular}: ${contaDaAmanda.saldo}");
}

class ContaCorrente {
  String titular;
  int agencia = 145;
  int conta;
  double saldo = 20.0;

  void saque(double valorDoSaque) {
    if (this.saldo - valorDoSaque < -100) {
      print("Sem saldo suficiente.");
    } else {
      print("Sacando $valorDoSaque reais");
      this.saldo -= valorDoSaque;
    }
  }
}

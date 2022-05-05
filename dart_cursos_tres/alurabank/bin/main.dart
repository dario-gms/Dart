void main() {
  ContaCorrente contaDaAmanda = ContaCorrente();
  contaDaAmanda.titular = "Amanda";

  contaDaAmanda.deposito(20.0);
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
      return false;
    } else {
      print("Sacando $valorDoSaque reais");
      this.saldo -= valorDoSaque;
      return true;
    }
  }

  void deposito(double valorDoDeposito) {
    this.saldo += valorDoDeposito;
  }
}

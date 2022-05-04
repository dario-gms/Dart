void main() {
  ContaCorrente contadaAmanda = ContaCorrente();
  contadaAmanda.titular = "Amanda";
  contadaAmanda.agencia = 123;
  contadaAmanda.conta = 1;
  contadaAmanda.saldo = 0.0;

  ContaCorrente contadoTiago = ContaCorrente();
  contadoTiago.titular = "Tiago";
  contadoTiago.agencia = 123;
  contadoTiago.conta = 2;
}

class ContaCorrente {
  String titular;
  int agencia;
  int conta;
  double saldo = 0.0;
}

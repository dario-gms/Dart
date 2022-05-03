void main() {
  ContaCorrente conta = ContaCorrente();
  conta.titular = 'Dário';

  print(conta.titular);
}

class ContaCorrente {
  String titular;
  int agencia;
  int conta;
  double saldo;

  
}

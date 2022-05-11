import 'package:alurabank/cliente.dart';

class ContaCorrente {
  Cliente titular;
  int agencia = 145;
  int conta;
  double saldo = 20.0;
  double chequeEspecial = -100.0;

  bool verificaSaldo(double valor) {
    if (this.saldo - valor < chequeEspecial) {
      print("Sem saldo suficiente.");
      return false;
    } else {
      print("Movimentando $valor reais");
      return true;
    }
  }

  bool transferencia(double valorDeTransferencia, ContaCorrente contaDestino) {
    if (!verificaSaldo(valorDeTransferencia)) {
      return false;
    } else {
      this.saldo -= valorDeTransferencia;
      contaDestino.deposito(valorDeTransferencia);
      return true;
    }
  }

  bool saque(double valorDoSaque) {
    if (!verificaSaldo(valorDoSaque)) {
      return false;
    } else {
      this.saldo -= valorDoSaque;
      return true;
    }
  }

  void deposito(double valorDoDeposito) {
    this.saldo += valorDoDeposito;
  }
}
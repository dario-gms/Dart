import 'package:alurabank/cliente.dart';
import 'package:alurabank/contacorrente.dart';

void main() {
  ContaCorrente contaDaAmanda = ContaCorrente();
  ContaCorrente contaDoTiago = ContaCorrente();

  Cliente amanda = Cliente();
  amanda.nome = "Amanda";
  amanda.cpf = "123.456.789-00";
  amanda.profissao = "Programadora Dart";

  contaDaAmanda.titular = amanda;

  print("Titular: ${contaDaAmanda.titular.nome}");
  print("CPF: ${contaDaAmanda.titular.cpf}");
  print("Profissão: ${contaDaAmanda.titular.profissao}");
}



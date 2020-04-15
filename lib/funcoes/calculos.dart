import 'package:flutter/material.dart';

class Calculos {

  String _somar(String valor1, String valor2) {
    String retorno = "";
    int qtdMaxCarac = valor1.length > valor2.length ? valor1.length : valor2.length;
    String sobra = "0";
    String v1, v2;
    int pos;

    for (int i = 0; i < qtdMaxCarac; i++) {
      v1 = "0"; v2 = "0";

      if (valor1.length > i) {
        pos = valor1.length - i;
        v1 = valor1.substring(pos - 1, pos);
      }

      if (valor2.length > i) {
        pos = valor2.length - i;
        v2 = valor2.substring(pos - 1, pos);
      }

      retorno = _soma(v1, v2, sobra) + retorno;
      sobra = _sobra(v1, v2, sobra);
    }

    if (sobra == "1") {
      retorno = sobra + retorno;
    }

    return retorno;
  }

  String _soma(String v1, String v2, String sobra) {
    int soma = (int.parse(v1) + int.parse(v2) + int.parse(sobra));
    if (soma == 0) {
      return "0";
    } else if ((soma == 1) || (soma == 3)) {
      return "1";
    } else {
      return "0";
    }
  }

  String _sobra(String v1, String v2, String sobra) {
    int soma = (int.parse(v1) + int.parse(v2) + int.parse(sobra));
    if (soma > 1) {
      return "1";
    } else {
      return "0";
    }
  }

}
import 'package:calcular_binarios/models/operacoes.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //Controller do campo de texto 1
  TextEditingController binUmController = TextEditingController();
  //Controller do campo de texto 2
  TextEditingController binDoisController = TextEditingController();

  //Global Key do Formulário da tela
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Variavel da operação selecionado
  var _itemSelecionado = Operacoes.SUM;

  //Variavel do texto de resultado
  String _infoText = "Informe os valores!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de Binários"),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed:_resetFields,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.toc, size: 120, color: Colors.purple),

              criaDropDownButton(),

              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "1º Número Binario",
                    labelStyle: TextStyle(color: Colors.purple)
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple, fontSize: 25.0),
                onChanged: (text) {
                  _verificarCaracteres(text, binUmController);
                },
                controller: binUmController,
                validator: (valor) {
                  var retorno = _validate(valor);
                  if (retorno.isNotEmpty) {
                    return retorno;
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "2º Número Binario",
                    labelStyle: TextStyle(color: Colors.purple)
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple, fontSize: 25.0),
                onChanged: (text) {
                  _verificarCaracteres(text, binDoisController);
                },
                controller: binDoisController,
                validator: (valor) {
                  var retorno = _validate(valor);
                  if (retorno.isNotEmpty) {
                    return retorno;
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                    child: Text("Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0)),
                    color: Colors.purple,
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple, fontSize: 25.0),
              )
            ],
          ),
        ),
      )
    );
  }

  /*Funções do DropDownButton - Inicio*/
  criaDropDownButton(){
    return Container(
      child: Column(
        children: <Widget>[
          Text("Selecione a operação"),
          DropdownButton<Operacoes>(
            items: Operacoes.values.map((Operacoes dropDownStringItem) {
              return DropdownMenuItem<Operacoes> (
                value: dropDownStringItem,
                child: Text(
                    dropDownStringItem == Operacoes.SUM ? 'SOMAR (+)' :
                    (dropDownStringItem == Operacoes.SUB ? 'SUBTRAIR (-)' :
                    (dropDownStringItem == Operacoes.MULT ? 'MULTIPLICAR (*)' :
                    (dropDownStringItem == Operacoes.DIV ? 'DIVIDIR (/)' :
                    'RESTO (%)')))
                ),
              );
            }).toList(),

            onChanged: (Operacoes novoItemSelecionado) {
              _dropDownItemSelected(novoItemSelecionado);
              setState(() {
                this._itemSelecionado = novoItemSelecionado;
              });
            },
            value: _itemSelecionado,
          ),
        ],
      ),
    );
  }

  void _dropDownItemSelected(Operacoes novoItem){
    setState(() {
      this._itemSelecionado = novoItem;
    });
  }
  /*Funções do DropDownButton - Fim*/

  // Validação dos valores informados ao clicar no botão calcular
  String _validate(String valor) {
    var retorno = "";
    if (valor.isEmpty) {
      retorno = "Insira um valor binário";
    }
    if (valor.length > 8) {
      retorno = "Inserir valor menor que 255(11111111)";
    }
    return retorno;
  }

  // Validação dos caracteres informados, para aceitar apenas 8 dígitos e apenas caracteres 0 e 1
  void _verificarCaracteres(String valor, TextEditingController controller) {
    String novoValor = valor;
    String msg;
    bool ok = true;
    if (valor.length > 8) {
      msg = "Só é permitido valor máximo de 255(11111111)!";
      novoValor = valor.substring(0, valor.length - 1);
      ok = false;
    }
    if (ok) {
      for (int i = 0; i < valor.length; i++) {
        String carac = valor.substring(i, i + 1);
        if (carac != "0" && carac != "1") {
          novoValor = novoValor.replaceAll(carac, "");
          if (ok) {
            ok = false;
            msg = "Valor " + carac + " não permitido!";
            break;
          }
        }
      }
    }
    if (!ok) {
      controller.text = novoValor;
      Toast.show(msg, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);
    }
  }

  // Método para limpar a tela para realizar novos calculos
  void _resetFields() {
    binUmController.text = "";
    binDoisController.text = "";

    setState(() {
      _infoText = "Informe os valores!";
      _formKey = GlobalKey<FormState>();
    });
  }

  // Método principal de calcular
  void _calculate() {
    String v1 = binUmController.text;
    String v2 = binDoisController.text;
    setState(() {
      if (_itemSelecionado == Operacoes.SUM) {
        _infoText = _somar(v1, v2);
      } else if (_itemSelecionado == Operacoes.SUB) {
        _infoText = _subtrair(v1, v2);
      } else if (_itemSelecionado == Operacoes.MULT) {
        _infoText = _multiplicar(v1, v2);
      } else if (_itemSelecionado == Operacoes.DIV) {
        _infoText = _dividir(v1, v2, false);
      } else {
        _infoText = _dividir(v1, v2, true);
      }
    });
  }

  /*METÓDOS DE CALCULOS*/

  // Método de somar
  String _somar(String valor1, String valor2) {
    String retorno = "";
    int qtdMaxCarac = valor1.length > valor2.length ? valor1.length : valor2.length; // Variavel para salvar a maior quantidade de caracters entres os valores passados
    String sobra = "0";
    String v1, v2;
    int pos;

    // Percorres todos os caracteres dos valores passados
    for (int i = 0; i < qtdMaxCarac; i++) {
      // Zera as variaveis
      v1 = "0"; v2 = "0";

      // Verifica se o valor 1 tem a posição que está percorrendo
      if (valor1.length > i) {
        // Pega o valor da posição
        pos = valor1.length - i;
        v1 = valor1.substring(pos - 1, pos);
      }

      // Verifica se o valor 2 tem a posição que está percorrendo
      if (valor2.length > i) {
        //Pega o valor da posição
        pos = valor2.length - i;
        v2 = valor2.substring(pos - 1, pos);
      }

      // Concatena o valor retornado do método _soma com o valor de retorno
      retorno = _soma(v1, v2, sobra) + retorno;
      // Chama o método _sobra para atualizar o valor da variavel sobra
      sobra = _sobra(v1, v2, sobra);
    }

    // Depois de percorrer tudo, se ainda tem valor na variavel sobra, é jogador o valor na frente do valor de retorno
    if (sobra == "1") {
      retorno = sobra + retorno;
    }

    return retorno;
  }

  // Metódo com as regras de soma de binarios, para retornar o valor de uma soma
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

  // Metódo para retornar a sobra de uma soma, a ser calculada na proxima posição
  String _sobra(String v1, String v2, String sobra) {
    int soma = (int.parse(v1) + int.parse(v2) + int.parse(sobra));
    if (soma > 1) {
      return "1";
    } else {
      return "0";
    }
  }

  // Metodo de Subtrair
  String _subtrair(String valor1, String valor2) {
    String retorno = "";
    int qtdMaxCarac = valor1.length > valor2.length ? valor1.length : valor2.length; // Variavel para salvar a maior quantidade de caracters entres os valores passados
    String vai = "0"; // Valor a ser passado para calcular na posição da frente
    String v1, v2, result;
    int pos;
    bool negativo = false;

    // Verifica se o valor 1 é menor que o valor 2, caso seja, vai ser acrescentado o sinal de negativo no resultado
    if (int.parse(valor1) < int.parse(valor2)) {
      negativo = true;
      String aux = valor1;
      valor1 = valor2;
      valor2 = aux;
    }

    // Percorres todos os caracteres dos valores passados
    for (int i = 0; i < qtdMaxCarac; i++) {
      // Zera as variaveis
      v1 = "0"; v2 = "0"; result = "0";

      // Verifica se o valor 1 tem a posição que está percorrendo
      if (valor1.length > i) {
        // Pega o valor da posição
        pos = valor1.length - i;
        v1 = valor1.substring(pos - 1, pos);
      }

      // Verifica se o valor 2 tem a posição que está percorrendo
      if (valor2.length > i) {
        // Pega o valor da posição
        pos = valor2.length - i;
        v2 = valor2.substring(pos - 1, pos);
      }

      // Chama a função que realiza a subtração dos valores da posição
      result = _sub(v1, vai);

      // Regra para preencher variavel vai
      if (vai == "1" && v1 == "1" && v2 == "1") {
        // Se o vai já está marcado com 1, e os valores 1 e 2 também, então o vai continua como 1
        vai = "1";
      } else {
        // Senão chama o metodo com a regra para retornar o valor do vai
        vai = _subVai(v1, vai);
      }

      // Chama o metódo que realiza a subtração dos valores da posição, concatenando com o valor de retorno
      retorno = _sub(result, v2) + retorno;

      if (vai == "0") {
        // Se o vai for igual a 0, é chamado o metodo com a regra para retornar o valor do vai novamente
        vai = _subVai(v1, v2);
      }

    }

    return ((negativo ? "-" : "") + retorno);
  }

  // Metódo com as regras para subtração de dois valores
  String _sub(String v1, String v2) {
    if ((v1 == "0" && v2 == "0") || (v1 == "1" && v2 == "1")) {
      return "0";
    } else {
      return "1";
    }
  }

  // Metódo com as regras para retorno do valor que vai ser deixado para calcular com os valores da proxima posição
  String _subVai(String v1, String v2) {
    if (v1 == "0" && v2 == "1") {
      return "1";
    } else {
      return "0";
    }
  }

  // Metódo de Multiplicar
  String _multiplicar(String valor1, String valor2) {
    String retorno = "";
    String v2, vlMult;
    int pos;

    // Percorre todas os caracteres do valor 2
    for (int i = 0; i < valor2.length; i++) {
      // Zera a varível
      vlMult = "";

      if (valor2.length > i) {
        // Pega o valor da posição
        pos = valor2.length - i;
        v2 = valor2.substring(pos - 1, pos);
      }

      // Joga a quantidade necessaria de 0 a direita do valor calculado, de acordo com a posição do caracter
      for (int x = 0; x < i; x++) {
        vlMult += "0";
      }

      // Regra para pegar o valor da multiplicação concatenado com os 0 informados acima
      if (v2 == "0") {
        // Se o valor 2 na posição atual for igual a 0, então toda a multiplicação será 0
        vlMult += "0";
      } else {
        // Senão o valor da multiplicação da posição é igual ao valor 1
        vlMult = valor1 + vlMult;
      }

      // Realiza a soma do valor anterior multiplicado com o valor atual
      retorno = _somar(retorno.isEmpty ? "0" : retorno, vlMult);
    }

    return retorno;
  }

  // Metódo de Divisão
  String _dividir(String valor1, String valor2, bool retResto) {

    String retorno = "";
    String v1;
    String resto = valor1;
    String quociente = "";
    int init = 0;
    bool calc = false;
    bool aux = false;

    // Percorre todos os caracteres do valor 2
    for (int i = valor2.length; i <= valor1.length; i++) {
      // Zera a variavel
      String restoAux = "";

      // Verifica se já foi já foi identificado valor no quociente, para poder jogar o valor do resto em uma variavel auxiliar
      if (aux) {
        restoAux = resto;
      }

      // Concatena o valor na variavel resto auxiliar com o valor da posição selecionada
      v1 = restoAux + valor1.substring(init, i);

      // Se o valor 1 que foi pego for maior ou igual ao valor do divisor é marcado realizado calculo e acrescentado valor ao quociente
      if (int.parse(v1) >= int.parse(valor2)) {
        calc = true;
        init = i;
        quociente += "1";
        if (!aux) {
          aux = true;
        }
      }

      // Se o valor 1 que foi pego for menor que o valor do divisor e já existe valor no quociente, é concateno o 0 no final do quociente
      if (!calc && aux) {
        quociente += "0";
        resto = v1;
        init = i;
      }

      // Se o valor 1 que foi pego for maior ou igual ao valor do divisor, é realizado a subtração para pegar o valor do resto
      if (calc) {
        calc = false;
        resto = _subtrair(v1, valor2);
      }

    }

    // Verifica se é para retornar o valor do quociente ou do resto
    retorno = retResto ? resto : quociente;
    return (retorno.isEmpty ? "0" : retorno);
  }








}

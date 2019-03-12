import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _resetFields() {
    pesoController.text = "";
    alturaController.text = "";
    setState(() {
      _infoText = "Informe seus dados";
    });
  }

  void _calculaIMC() {
    setState(() {
      double _peso = double.parse(pesoController.text);
      double _altura = double.parse(alturaController.text) / 100;
      double imc = _peso / (_altura * _altura);
      String imcFormatado = imc.toStringAsPrecision(3);

      if (imc < 18.6) {
        _infoText = "Abaixo do Peso ($imcFormatado)";
      } else if (imc > 18.6 && imc < 24.9) {
        _infoText = "Peso Ideal ($imcFormatado)";
      } else if (imc > 24.9 && imc < 29.9) {
        _infoText = "Levemente Acima do Peso ($imcFormatado)";
      } else if (imc > 29.9 && imc < 34.9) {
        _infoText = "Obesidade Grau I ($imcFormatado)";
      } else if (imc > 34.9 && imc < 39.9) {
        _infoText = "Obesidade Grau II ($imcFormatado)";
      } else if (imc >= 40.0) {
        _infoText = "Obesidade Grau III ($imcFormatado)";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora de IMC"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _resetFields();
                }),
          ],
        ),
        backgroundColor: Colors.blueGrey[100],
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(Icons.person_outline,
                      size: 110.0, color: Colors.purple[300]),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Peso (kg)",
                        labelStyle: TextStyle(color: Colors.blueGrey)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 25.0),
                    controller: pesoController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira seu peso!";
                      }
                      if (double.parse(value) < 30) {
                        return "Não minta! Você não pesa menos que 30 quilos, vai...";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Altura (cm)",
                        labelStyle: TextStyle(color: Colors.blueGrey)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 25.0),
                    controller: alturaController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira sua altura!";
                      }
                      if (double.parse(value) > 220) {
                        return "Tá de brincadeira, né? Falou, gigante!";
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
                            _calculaIMC();
                          }
                        },
                        child: Text(
                          "Calcular",
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Text(
                    _infoText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 25.0),
                  )
                ],
              )),
        ));
  }
}

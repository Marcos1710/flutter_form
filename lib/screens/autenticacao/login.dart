import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form/components/message.dart';
import 'package:flutter_form/screens/Home/home.dart';
import 'package:flutter_form/screens/autenticacao/register.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 40),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/bytebank_logo.png',
                  width: 200,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 300,
                  height: 435,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: _construirFormulario(context)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  Widget _construirFormulario(context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Faça seu login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'CPF',
            ),
            maxLength: 14,
            keyboardType: TextInputType.number,
            controller: _cpfController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter()
            ],
            validator: (value) => Validator.cpf(value) ? 'CPF inválido' : null,
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Senha',
            ),
            maxLength: 15,
            keyboardType: TextInputType.text,
            controller: _senhaController,
            validator: (value) {
              if (value!.length == 0) {
                return 'Informe a senha!';
              }

              return null;
            },
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).accentColor,
              ),
              onPressed: () => {
                if (_formKey.currentState!.validate())
                  {
                    if (_cpfController.text == '267.168.570-01' &&
                        _senhaController.text == '123456')
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                            (route) => false)
                      }
                    else
                      {
                        exibirAlerta(
                            context: context,
                            title: "ATENÇÃO",
                            content: "CPF ou Senha inválidos")
                      }
                  }
              },
              child: Text("CONTINUAR"),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Esqueci minha senha >",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).accentColor,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Register()),
            ),
            child: Text("Criar uma conta >"),
          ),
        ],
      ),
    );
  }
}

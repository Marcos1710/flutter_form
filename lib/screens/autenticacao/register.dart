import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form/components/biometria.dart';
import 'package:flutter_form/models/Client.dart';
import 'package:flutter_form/screens/Home/home.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Register extends StatelessWidget {
  // Step 1
  final _formKeyUserData = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();

  // step 2
  final _formKeyUserAddress = GlobalKey<FormState>();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  // step 3
  final _formKeyUserAuth = GlobalKey<FormState>();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController =
      TextEditingController();
  final ImagePicker _pickerController = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de clientes'),
      ),
      body: Consumer<Client>(
        builder: (context, client, child) {
          return Stepper(
            steps: _contruirSteps(context, client),
            currentStep: client.step,
            onStepContinue: () {
              final functions = [
                _salveStep1,
                _salveStep2,
                _salveStep3,
              ];

              return functions[client.step](context);
            },
            onStepCancel: () =>
                client.step = client.step > 0 ? client.step - 1 : 0,
            controlsBuilder: (context, {onStepCancel, onStepContinue}) {
              return Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: onStepContinue,
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                    ),
                    ElevatedButton(
                      onPressed: onStepCancel,
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey)),
                      child: Text(
                        "Voltar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  _salveStep1(context) {
    if (_formKeyUserData.currentState!.validate()) {
      Provider.of<Client>(context, listen: false).setNome(_nomeController.text);
      _proximoStep(context);
    }
  }

  _salveStep2(context) {
    if (_formKeyUserAddress.currentState!.validate()) {
      _proximoStep(context);
    }
  }

  _salveStep3(context) {
    if (_formKeyUserAuth.currentState!.validate() &&
        Provider.of<Client>(context).imagemRG != null) {
      FocusScope.of(context).unfocus();
      Provider.of<Client>(context).setImagemRGNull();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
          (route) => false);
    }
  }

  List<Step> _contruirSteps(context, client) {
    List<Step> step = [
      Step(
        title: Text("Seus dados"),
        isActive: client.step >= 0,
        content: Form(
          key: _formKeyUserData,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                keyboardType: TextInputType.text,
                maxLength: 255,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.length < 3) return "Nome inválido!";

                  if (!value.contains(" "))
                    return "Informe pelo menos um sobrenome!";

                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                maxLength: 255,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    Validator.email(value) ? 'Email inválido' : null,
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
                validator: (value) =>
                    Validator.cpf(value) ? 'CPF inválido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Celular',
                ),
                maxLength: 15,
                keyboardType: TextInputType.number,
                controller: _celularController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter()
                ],
                validator: (value) =>
                    Validator.phone(value) ? 'Celular inválido' : null,
              ),
              DateTimePicker(
                controller: _nascimentoController,
                type: DateTimePickerType.date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Nascimento',
                dateMask: 'dd/MM/yyyy',
                validator: (value) {
                  if (value!.isEmpty) return 'Data inválida';

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: Text("Endereço"),
        isActive: client.step >= 1,
        content: Form(
          key: _formKeyUserAddress,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'CEP',
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _cepController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CepInputFormatter(ponto: false)
                ],
                validator: (value) =>
                    Validator.cep(value) ? 'CEP inválido' : null,
              ),
              DropdownButtonFormField(
                isExpanded: true,
                decoration: InputDecoration(labelText: 'Estados'),
                items: Estados.listaEstadosSigla.map((String estado) {
                  return DropdownMenuItem(
                    child: Text(estado),
                    value: estado,
                  );
                }).toList(),
                onChanged: (String? selected) {
                  if (selected!.isNotEmpty) _estadoController.text = selected;
                },
                validator: (value) {
                  if (value == null) return 'Selecione um estado';

                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Cidade',
                ),
                maxLength: 255,
                keyboardType: TextInputType.text,
                controller: _cidadeController,
                validator: (value) {
                  if (value!.length < 3) return 'Cidade inválido!';

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Bairro',
                ),
                maxLength: 255,
                keyboardType: TextInputType.text,
                controller: _bairroController,
                validator: (value) {
                  if (value!.length < 3) return 'Bairro inválido!';

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Logradouro',
                ),
                maxLength: 255,
                keyboardType: TextInputType.text,
                controller: _logradouroController,
                validator: (value) {
                  if (value!.length < 3) return 'Logradouro inválido!';

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Número',
                ),
                maxLength: 10,
                keyboardType: TextInputType.text,
                controller: _numeroController,
              ),
            ],
          ),
        ),
      ),
      Step(
        title: Text("Autenticação"),
        isActive: client.step >= 2,
        content: Form(
          key: _formKeyUserAuth,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                maxLength: 255,
                keyboardType: TextInputType.text,
                controller: _senhaController,
                obscureText: true,
                validator: (value) {
                  if (value!.length < 8) return 'Senha muito curta!';

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                ),
                maxLength: 255,
                keyboardType: TextInputType.text,
                controller: _confirmaSenhaController,
                obscureText: true,
                validator: (value) {
                  if (value != _senhaController.text)
                    return 'As senhas não são iguais.';

                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Para prosseguir com seu cadastro é necessário que tenhamos uma foto do seu RG",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () => _capturarRG(client),
                child: Text("Tirar foto do meu RG"),
              ),
              _jaEnviouRG(context) ? _imageDoRg(context) : _pedidodoRG(context),
              Biometria()
            ],
          ),
        ),
      ),
    ];

    return step;
  }

  void _proximoStep(context) {
    int stepActual = Provider.of<Client>(context, listen: false).step + 1;
    Provider.of<Client>(context, listen: false).setStep(stepActual);
  }

  void _capturarRG(client) async {
    final pickageImage =
        await _pickerController.pickImage(source: ImageSource.camera);
    client.imagemRG = File(pickageImage!.path);
  }

  bool _jaEnviouRG(context) =>
      Provider.of<Client>(context).imagemRG != null ? true : false;

  Image _imageDoRg(context) =>
      Image.file(Provider.of<Client>(context).imagemRG!);

  Column _pedidodoRG(context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Text(
          "Foto do RG pendente",
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}

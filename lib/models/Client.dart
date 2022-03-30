import 'dart:io';

import 'package:flutter/material.dart';

class Client extends ChangeNotifier {
  String? _nome;
  String? _email;
  String? _celular;
  String? _cpf;
  String? _nascimento;
  String? _cep;
  String? _estado;
  String? _cidade;
  String? _bairro;
  String? _logradouro;
  String? _numero;
  String? _senha;

  int _step = 0;
  File? _imagemRG;
  bool _biometria = false;

  bool get biometria => this._biometria;

  set biometria(bool value) => this._biometria = value;

  void setBiometria(bool value) {
    _biometria = value;

    notifyListeners();
  }

  File? get imagemRG => this._imagemRG;

  set imagemRG(File? value) {
    this._imagemRG = value;

    notifyListeners();
  }

  void setImagemRGNull() {
    this._imagemRG = null;

    notifyListeners();
  }

  String? get nome => _nome;

  set nome(String? value) {
    _nome = value;
    notifyListeners();
  }

  void setNome(String? value) {
    _nome = value;
    notifyListeners();
  }

  get email => _email;

  set email(value) => _email = value;

  get celular => _celular;

  set celular(value) => _celular = value;

  get cpf => _cpf;

  set cpf(value) => _cpf = value;

  get nascimento => _nascimento;

  set nascimento(value) => _nascimento = value;

  get cep => _cep;

  set cep(value) => _cep = value;

  get estado => _estado;

  set estado(value) => _estado = value;

  get cidade => _cidade;

  set cidade(value) => _cidade = value;

  get bairro => _bairro;

  set bairro(value) => _bairro = value;

  get logradouro => _logradouro;

  set logradouro(value) => _logradouro = value;

  get numero => _numero;

  set numero(value) => _numero = value;

  get senha => _senha;

  set senha(value) => _senha = value;

  int get step => this._step;

  set step(int value) {
    this._step = value;
    notifyListeners();
  }

  void setStep(int stepActual) {
    this._step = stepActual;
    notifyListeners();
  }
}

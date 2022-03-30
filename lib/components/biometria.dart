import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form/models/Client.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class Biometria extends StatelessWidget {
  final LocalAuthentication _autenticacaoLocal = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _biometriaDisponivel(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Column(
                children: <Widget>[
                  Text(
                    "Detectamos que você tem sensor biometrico no seu celular, deseja cadastrar o acesso biometrico ?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _autenticarCliente(context);
                    },
                    child: Text("Habilitar impressão digital"),
                  ),
                ],
              ),
            );
          }

          return Container();
        });
  }

  Future<bool> _biometriaDisponivel() async {
    try {
      return await _autenticacaoLocal.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> _autenticarCliente(context) async {
    bool autenticado = false;
    autenticado = await _autenticacaoLocal.authenticate(
      localizedReason:
          'Por favor, autentique-se via biometria para acessar o app',
      useErrorDialogs: true,
    );

    Provider.of<Client>(context).setBiometria(autenticado);
  }
}

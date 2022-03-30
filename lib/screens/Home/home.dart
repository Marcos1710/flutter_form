import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form/models/Client.dart';
import 'package:flutter_form/screens/autenticacao/login.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home do aplicativo'),
        actions: [
          InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: Center(
        child: Consumer<Client>(
          builder: (context, client, child) {
            if (client.nome != null) {
              return Text(
                'Olá, ${client.nome}, Bem vindo ao aplicativo.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              );
            } else if (client.email != null) {
              return Text(
                'Olá, ${client.email.split("@")[0]}, Bem vindo ao aplicativo.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              );
            }

            return Text(
              'Olá, Bem vindo ao aplicativo.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            );
          },
        ),
      ),
    );
  }
}

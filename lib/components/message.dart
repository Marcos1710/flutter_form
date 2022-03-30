import 'package:flutter/material.dart';

exibirAlerta({context, title, content}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).accentColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Fechar'))
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String errorMessage;

  ErrorDialog({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Hata'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(errorMessage),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Tamam'),
          onPressed: () {
            Navigator.of(context).pop(); // Dialog'u kapat
          },
        ),
      ],
    );
  }
}

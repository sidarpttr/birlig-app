import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionExpiredDialog extends StatelessWidget {
  final BuildContext parentContext;

  SessionExpiredDialog({required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: SCAFFOLD_BACKGROUND,
      title: const Text(
        'Oturum Sonlandı',
        style: TextStyle(color: COLOR_PRIMARY),
      ),
      content: const Text('Oturum sonlanmıştır. Lütfen tekrar giriş yapın.'),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Tamam',
            style: TextStyle(color: COLOR_PRIMARY),
          ),
          onPressed: () async {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await Provider.of<UserProvider>(context, listen: false).logout();
              Navigator.of(context).pop();
            });
          },
        ),
      ],
    );
  }

  void show() {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) => this,
    ).then((value) => Navigator.pushReplacementNamed(parentContext, '/login'));
  }
}

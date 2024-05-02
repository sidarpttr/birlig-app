import 'package:flutter/material.dart';

class PlayerListWaiting extends StatelessWidget {
  const PlayerListWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          title: Text(""),
        ),
      ),
    );
  }
}
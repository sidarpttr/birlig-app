import 'package:flutter/material.dart';

class PlayerList extends StatelessWidget {
  final String name;
  const PlayerList({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          title: Text(name),
        ),
      ),
    );
  }
}

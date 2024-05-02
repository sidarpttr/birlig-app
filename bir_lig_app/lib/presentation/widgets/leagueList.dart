import 'package:bir_lig_app/presentation/screens/leaguePage.dart';
import 'package:flutter/material.dart';

class LeagueListTile extends StatelessWidget {
  final String title;
  final String id;

  const LeagueListTile({
    Key? key,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListTile(
            title: Text(title),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LeaguePage(league: {"name": title, "id":id}),
            ));
      },
    );
  }
}

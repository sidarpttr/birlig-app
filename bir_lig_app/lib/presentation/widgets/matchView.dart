import 'package:bir_lig_app/data/models/match.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';

class MatchView extends StatefulWidget {
  final LeagueMatch match;
  const MatchView({super.key, required this.match});

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: Colors.grey.withAlpha(20), borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.match.players![0].name!),
          addHorizontalSpace(30),
          Text(widget.match.scores![0].toString()),
          addHorizontalSpace(10),
          Text(widget.match.scores![1].toString()),
          addHorizontalSpace(30),
          Text(widget.match.players![1].name!),
        ],
      ),
    );
  }
}

import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/data/models/match.dart';
import 'package:flutter/material.dart';

class LastMatch extends StatefulWidget {
  final LeagueMatch match;
  const LastMatch({super.key, required this.match});

  @override
  State<LastMatch> createState() => _LastMatchState();
}

class _LastMatchState extends State<LastMatch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: COLOR_PRIMARY),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      child: Center(child: Text("${widget.match.scores![0]} - ${widget.match.scores![1]}")),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bir_lig_app/data/models/player.dart';

class LeagueMatch {
  final String id;
  final List<Player>? players;
  final List<dynamic>? scores;
  LeagueMatch({
    required this.id,
    this.players,
    this.scores,
  });

  factory LeagueMatch.fromMap(Map<String, dynamic> map) {
    List<dynamic>? playerList = map["players"];
    List<Player>? players;
    if (playerList != null) {
      players = playerList.map((e) => Player.fromMap(e)).toList();
    }
    return LeagueMatch(
      id: map["_id"] as String,
      players: players,
      scores: map["scores"],
    );
  }

  factory LeagueMatch.fromJson(String json) => LeagueMatch.fromMap(jsonDecode(json) as Map<String, dynamic>);

}

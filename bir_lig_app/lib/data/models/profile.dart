import 'dart:convert';

import 'package:bir_lig_app/data/models/league.dart';
import 'package:bir_lig_app/data/models/player.dart';

class Profile {
  final String id;
  final Player? player;
  final League? league;
  final int? om;
  final int? ag;
  final int? yg;
  final int? averaj;
  final int? puan;

  Profile({
    required this.id,
    this.player,
    this.league,
    this.om,
    this.ag,
    this.yg,
    this.averaj,
    this.puan,
  });
  
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
        id: map["_id"] ?? "",
        player: map["player"] != null ? Player.fromMap(map["player"]) : null,
        league: map["league"] != null ? League.fromMap(map["league"]) : null,
        om: map["om"] ?? 0,
        ag: map["ag"] ?? 0,
        yg: map["yg"] ?? 0,
        averaj: map["averaj"] ?? 0,
        puan: map["puan"] ?? 0);
  }

  factory Profile.fromJson(String json) =>
      Profile.fromMap(jsonDecode(json) as Map<String, dynamic>);
}

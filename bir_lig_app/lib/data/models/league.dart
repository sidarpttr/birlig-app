import 'dart:convert';

import 'package:bir_lig_app/data/models/match.dart';
import 'package:bir_lig_app/data/models/profile.dart';
import 'package:bir_lig_app/data/models/puan.dart';

class League {
  final String id;
  final String? name;
  final List<Profile>? players;
  final List<LeagueMatch>? maclar;
  final Puan? puanTablosu;
  final bool? isMember;

  League(
      {required this.id,
      this.name,
      this.players,
      this.maclar,
      this.puanTablosu,
      this.isMember = true});

  factory League.fromMap(Map<String, dynamic> map) {
    List<dynamic>? playerList = map["players"];
    List<Profile>? players;
    if (playerList != null) {
      players =
          playerList.map((playermap) => Profile.fromMap(playermap)).toList();
    }

    List<dynamic>? macList = map["maclar"];
    List<LeagueMatch>? maclar;
    if (macList != null) {
      maclar = macList.map((macmap) => LeagueMatch.fromMap(macmap)).toList();
    }

    Map<String, dynamic>? puan = map["puanTablosu"];
    Puan? puanTablosu;
    if (puan != null) {
      puanTablosu = Puan.fromMap(puan);
    }

    return League(
        id: map["_id"] as String,
        name: map["name"] as String,
        players: players,
        maclar: maclar,
        puanTablosu: puanTablosu,
        isMember: map["isMember"]);
  }

  factory League.fromJson(String json) =>
      League.fromMap(jsonDecode(json) as Map<String, dynamic>);
}

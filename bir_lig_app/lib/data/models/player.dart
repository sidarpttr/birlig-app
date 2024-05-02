import 'dart:convert';

import 'package:bir_lig_app/data/models/league.dart';
import 'package:bir_lig_app/data/models/match.dart';

class Player {
  final String id;
  final String? name;
  final List<League>? ligler;
  final List<LeagueMatch>? maclar;
  final String? email;

  Player({
    required this.id,
    this.name,
    this.ligler,
    this.maclar,
    this.email,
  });
  
  String toJson() {
    Map<String, dynamic> playerMap = {
      "_id": id,
      "name": name,
      "email": email,
    };
    return jsonEncode(playerMap);
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    List<dynamic>? ligList = map["ligler"];
    List<League>? ligler;
    if (ligList != null) {
      ligler = ligList.map((e) => League.fromMap(e)).toList();
    }

    List<dynamic>? macList = map["maclar"];
    List<LeagueMatch>? maclar;
    if (macList != null) {
      maclar = macList.map((e) => LeagueMatch.fromMap(e)).toList();
    }

    return Player(
        id: map["_id"],
        name: map["name"],
        ligler: ligler,
        maclar: maclar,
        email: map["email"]);
  }

  factory Player.fromJson(String json) =>
      Player.fromMap(jsonDecode(json) as Map<String, dynamic>);
}

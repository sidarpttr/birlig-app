// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bir_lig_app/data/models/profile.dart';

class Puan {
  final List<Profile>? siralama;
  Puan({
    this.siralama,
  });

  static List<Profile> sirala(List<Profile> profiles) {
    profiles.sort((a, b) {
      int puanComparison = b.puan!.compareTo(a.puan!);
      if (puanComparison != 0) {
        // If the scores are not equal, sort by score
        return puanComparison;
      } else {
        // If the scores are equal, sort by average
        return b.averaj!.compareTo(a.averaj!);
      }
    });
    return profiles;
  }

  factory Puan.fromMap(Map<String, dynamic> map) {
    List<dynamic>? profileList = map["siralama"];
    List<Profile>? siralama;
    List<Profile>? result;

    if (profileList != null) {
      siralama = profileList.map((e) => Profile.fromMap(e)).toList();
      result = sirala(siralama);
    }

    return Puan(siralama: result);
  }

  factory Puan.fromJson(String json) =>
      Puan.fromMap(jsonDecode(json) as Map<String, dynamic>);
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bir_lig_app/data/models/profile.dart';

class Puan {
  final List<Profile>? siralama;
  Puan({
    this.siralama,
  });

  factory Puan.fromMap(Map<String, dynamic> map) {
    List<dynamic>? profileList = map["siralama"];
    List<Profile>? siralama;
    if (profileList != null) {
      siralama = profileList.map((e) => Profile.fromMap(e)).toList();
    }
    return Puan(siralama: siralama);
  }

  factory Puan.fromJson(String json) => Puan.fromMap(jsonDecode(json) as Map<String, dynamic>);

}

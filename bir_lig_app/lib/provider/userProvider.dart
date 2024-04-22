import 'dart:convert';

import 'package:bir_lig_app/data/models/player.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  String? _token;
  String? _id;
  Player? _player;

  UserProvider();

  String? get token => _token;
  String? get id => _id;
  Player? get player => _player;

  set token(String? value) {
    _token = value;
    notifyListeners();
  }

  set id(String? id) {
    _id = id;
    notifyListeners();
  }

  set player(Player? player) {
    _player = player;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    AuthResponse data = await apiService.login(email, password);
    if (!data.success) throw ApiResponse(status: "failed",succes: false, error: data.error, data: null);
    _token = data.token;
    _player = data.player;
    notifyListeners();

  }

  Future<void> logout() async {
    token = null;
  }

  Future<void> loadToken() async {}
}

class AuthResponse {
  final Player? player;
  final String? token;
  final bool success;
  final String? error;

  AuthResponse({this.player, this.token, this.success = true, this.error});

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    if (map["status"] != "success") {
      return AuthResponse(success: false, error: map["message"]);
    }

    return AuthResponse(
        player: Player.fromMap(map["data"]["player"]),
        token: map["data"]["token"],
        success: true);
  }

  factory AuthResponse.fromJson(String json) =>
      AuthResponse.fromMap(jsonDecode(json));
}

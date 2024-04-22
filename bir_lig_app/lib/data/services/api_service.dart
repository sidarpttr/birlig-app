import 'dart:convert';

import 'package:bir_lig_app/data/models/league.dart';
import 'package:bir_lig_app/data/models/match.dart';
import 'package:bir_lig_app/data/models/player.dart';
import 'package:bir_lig_app/data/models/profile.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.20.3.216:3000";

  Future<ApiResponse> getAllLeauges() async {
    final response = await http.get(Uri.parse('$baseUrl/lig/'));
    try {
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return ApiResponse(
            status: "success",
            data: jsonResponse.map((e) => League.fromMap(e)).toList());
      } else {
        throw ApiResponse(
            status: "fail",
            data: null,
            succes: false,
            error: "Failed to get Resonse");
      }
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  // lig/:leagueId
  Future<ApiResponse> getLeagueById(String leagueId) async {
    final response = await http.get(Uri.parse('$baseUrl/lig/$leagueId'));
    try {
      return ApiResponse(
          status: "success", data: League.fromJson(response.body));
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  //  lig/:leagueId/mac
  Future<ApiResponse> getAllLeaugeMatches(String leagueId) async {
    final response = await http.get(Uri.parse('$baseUrl/lig/$leagueId/mac'));

    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return ApiResponse(
          status: "success",
          data: jsonResponse.map((e) => LeagueMatch.fromMap(e)).toList());
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  //  lig/:leagueId/player
  Future<ApiResponse> getAllLeagueProfiles(String leagueId) async {
    final response = await http.get(Uri.parse('$baseUrl/lig/$leagueId/player'));

    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return ApiResponse(
          status: "success",
          data: jsonResponse.map((e) => Profile.fromMap(e)).toList());
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  //  lig/:leagueId/player/:playerId
  Future<ApiResponse> getLeagueProfileById(String playerId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/lig/profile/$playerId'));

    try {
      return ApiResponse(
          status: "success", data: Profile.fromJson(response.body));
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  Future<ApiResponse> createLeague(String name, String playerId) async {
    final response = await http.post(Uri.parse('$baseUrl/lig/'),
        body: jsonEncode({"name": name, "playerId": playerId}),
        headers: {"Content-Type": "application/json"});

    try {
      if (response.statusCode == 200) {
        return ApiResponse(status: "success", data: null);
      } else {
        return ApiResponse(
            status: "fail",
            data: null,
            succes: false,
            error: jsonDecode(response.body).message);
      }
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  Future<ApiResponse> addMatch(
      Map<String, dynamic> mac, String leagueId) async {
    final response = await http.post(Uri.parse("$baseUrl/lig/$leagueId/mac"),
        body: jsonEncode(mac), headers: {"Content-Type": "application/json"});

    try {
      if (response.statusCode == 200) {
        return ApiResponse(status: "success", data: null);
      } else {
        return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
      }
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  Future<ApiResponse> getAllPlayers() async {
    final response = await http.get(Uri.parse("$baseUrl/player/"));
    try {
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return ApiResponse(
            status: "succes",
            data: jsonResponse.map((e) => Player.fromMap(e)).toList());
      } else {
        return ApiResponse(
            status: "fail",
            data: null,
            succes: false,
            error: jsonDecode(response.body).message);
      }
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  Future<ApiResponse> addPlayerToLeague(
      String leagueId, String playerId) async {
    final response = await http.post(Uri.parse('$baseUrl/lig/$leagueId/player'),
        body: jsonEncode({"playerId": playerId}),
        headers: {"Content-Type": "application/json"});
    try {
      if (response.statusCode == 200) {
        return ApiResponse(status: "success", data: null);
      } else {
        return ApiResponse(
            status: "fail",
            data: null,
            succes: false,
            error: jsonDecode(response.body).message);
      }
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  Future<ApiResponse> getAllProfileMatches(
      String leagueId, String playerId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/lig/$leagueId/profile/$playerId/mac'));
    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return ApiResponse(
          status: "success",
          data: jsonResponse.map((e) => LeagueMatch.fromMap(e)).toList());
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body:
            jsonEncode(<String, String>{"email": email, "password": password}));
    try {
      return AuthResponse.fromJson(response.body);
    } catch (e) {
      return AuthResponse(success: false, error: e.toString());
    }
  }
}

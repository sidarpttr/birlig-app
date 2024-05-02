// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:bir_lig_app/data/models/league.dart';
import 'package:bir_lig_app/data/models/match.dart';
import 'package:bir_lig_app/data/models/player.dart';
import 'package:bir_lig_app/data/models/profile.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/provider/userProvider.dart';

final class ApiService {
  final String baseUrl = "http://192.168.215.252:3000";

  Future<ApiResponse> getAllLeauges(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lig/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return ApiResponse(
            status: "success",
            data: jsonResponse.map((e) => League.fromMap(e)).toList());
      } catch (e) {
        return ApiResponse(
            status: "fail",
            data: null,
            succes: false,
            error: jsonDecode(response.body)["message"]);
      }
    } else if (response.statusCode == 401) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          authError: true,
          error: "Authentication failed");
    } else {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: "An unknown error occurred");
    }
  }

  // lig/:leagueId
  Future<ApiResponse> getLeagueById(String leagueId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lig/$leagueId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
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
    } else if (response.statusCode == 401) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          authError: true,
          error: "Authentication failed");
    } else {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: "An unknown error occurred");
    }
  }

  //  lig/:leagueId/mac
  Future<ApiResponse> getAllLeaugeMatches(String leagueId) async {
    final response = await http.get(Uri.parse('$baseUrl/lig/$leagueId/mac'));

    if (response.statusCode == 200) {
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
    } else if (response.statusCode == 401) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          authError: true,
          error: "Authentication failed");
    } else {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: "An unknown error occurred");
    }
  }

  //  lig/:leagueId/player
  Future<ApiResponse> getAllLeagueProfiles(
      String leagueId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lig/$leagueId/player'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Add the token here
      },
    );

    if (response.statusCode == 200) {
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
    } else if (response.statusCode == 401) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          authError: true,
          error: "Authentication failed");
    } else {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: "An unknown error occurred");
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

  Future<ApiResponse> createLeague(
      String name, String playerId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lig/'),
      body: jsonEncode({"name": name, "playerId": playerId}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Add the token here
      },
    );

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
      Map<String, dynamic> mac, String leagueId, String token) async {
    final response = await http.post(
      Uri.parse("$baseUrl/lig/$leagueId/mac"),
      body: jsonEncode(mac),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Add the token here
      },
    );
    print(response.body);

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
      String leagueId, String playerId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lig/$leagueId/player'),
      body: jsonEncode({"playerId": playerId}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Add the token here
      },
    );

    if (response.statusCode == 200) {
      try {
        return ApiResponse(status: "success", data: null);
      } catch (e) {
        return ApiResponse(
            status: "fail",
            data: null,
            succes: false,
            error: jsonDecode(response.body)["message"]);
      }
    } else if (response.statusCode == 401) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          authError: true,
          error: "Authentication failed");
    } else {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: "An unknown error occurred");
    }
  }

  Future<ApiResponse> getAllProfileMatches(
      String leagueId, String playerId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lig/$leagueId/profile/$playerId/mac'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Add the token here
      },
    );

    if (response.statusCode == 200) {
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
    } else if (response.statusCode == 401) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          authError: true,
          error: "Authentication failed");
    } else {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: "An unknown error occurred");
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

  Future<AuthResponse> register(
      String name, String email, String password) async {
    await http.post(Uri.parse("$baseUrl/auth/signup"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          "email": email,
          "password": password,
          "name": name
        }));
    try {
      return AuthResponse(success: true);
    } catch (e) {
      return AuthResponse(success: false, error: e.toString());
    }
  }

  Future<ApiResponse> getAllPlayerMatches(String playerId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/player/$playerId/maclar"));

    try {
      List<dynamic> jsonReponse = jsonDecode(response.body);
      return ApiResponse(
          data: jsonReponse.map((e) => LeagueMatch.fromMap(e)).toList(),
          status: "success");
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }

  Future<ApiResponse> getAllLeaguesForPlayer(String playerId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/player/$playerId/ligler"));
    try {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return ApiResponse(
          status: "success",
          data: jsonResponse.map((e) => League.fromMap(e)).toList());
    } catch (e) {
      return ApiResponse(
          status: "fail",
          data: null,
          succes: false,
          error: jsonDecode(response.body)["message"]);
    }
  }
}

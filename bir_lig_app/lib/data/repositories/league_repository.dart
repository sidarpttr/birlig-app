import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/services/api_service.dart';

class LeagueRepository {
  final ApiService apiService;
  LeagueRepository({required this.apiService});

  Future<ApiResponse> getAllLeagues() async {
    return await apiService.getAllLeauges();
  }

  Future<ApiResponse> getLeagueById(String leagueId) async {
    return await apiService.getLeagueById(leagueId);
  }

  Future<ApiResponse> getAllLeagueMatches(String leagueId) async {
    return await apiService.getAllLeaugeMatches(leagueId);
  }

  Future<ApiResponse> getAllLeagueProfiles(String leagueId) async {
    return await apiService.getAllLeagueProfiles(leagueId);
  }

  Future<ApiResponse> getLeagueProfileById(String profileId) async {
    return await apiService.getLeagueProfileById(profileId);
  }

  Future<ApiResponse> createLeague(String name, String playerId) async {
    return await apiService.createLeague(name, playerId);
  }

  Future<ApiResponse> addMatch(String player1id, String player2id,
      int player1score, int player2score, String leagueId) async {
    Map<String, dynamic> mac = {
      "player1id": player1id,
      "player2id": player2id,
      "player1score": player1score,
      "player2score": player2score
    };
    return await apiService.addMatch(mac, leagueId);
  }

  Future<ApiResponse> addPlayerToLeague(
      String leagueId, String playerId) async {
        return await apiService.addPlayerToLeague(leagueId, playerId);
      }
  
  Future<ApiResponse> getAllProfileMatches(String leagueId, String playerId) async {
    return await apiService.getAllProfileMatches(leagueId, playerId);
  }
}

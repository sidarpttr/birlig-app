import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/services/api_service.dart';

class PlayerRepository {
  final ApiService apiService;
  PlayerRepository({
    required this.apiService,
  });

  Future<ApiResponse> getAllPlayers() async {
    return apiService.getAllPlayers();
  }
  
//  Future<ApiResponse> getPlayerById(String playerId) async {
//    return await apiService.getPlayerById(playerId);
//  }

}

import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/repositories/league_repository.dart';
import 'package:bir_lig_app/data/repositories/player_repository.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:bir_lig_app/presentation/widgets/sessionExpiredDialog.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:bir_lig_app/utils/errorHandler.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeagueAddPlayerPage extends StatefulWidget {
  final Map<String, String> league;
  const LeagueAddPlayerPage({super.key, required this.league});

  @override
  State<LeagueAddPlayerPage> createState() => _LeagueAddPlayerPageState();
}

class _LeagueAddPlayerPageState extends State<LeagueAddPlayerPage> {
  ApiService apiService = ApiService();
  Future<ApiResponse>? futurePlayer;
  Map<String, String> selected = {"id": "", "name": ""};
  String searchQuery = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurePlayer = PlayerRepository(apiService: apiService).getAllPlayers();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final token = userProvider.token.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.league["name"]!),
      ),
      body: FutureBuilder(
        future: futurePlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: COLOR_SECONDARY,),
            );
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else {
            if (snapshot.data!.authError) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                SessionExpiredDialog(parentContext: context).show();
              });

              return Container();
            }
            return Column(
              children: [
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    cursorColor: COLOR_SECONDARY,
                    decoration:
                        const InputDecoration(hintText: "Oyuncu ara..."),
                    style: const TextStyle(color: COLOR_PRIMARY),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                addVerticalSpace(40),
                Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (context, index) {
                    var player = snapshot.data!.data[index];

                    if (player.name.contains(searchQuery) &&
                        searchQuery != "") {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = {"id": player.id, "name": player.name};
                            });
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(child: Text(player.name)),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ))
              ],
            );
          }
        },
      ),
      floatingActionButton: ElevatedButton.icon(
          onPressed: () async {
            ApiResponse response =
                await LeagueRepository(apiService: apiService)
                    .addPlayerToLeague(
                        widget.league["id"]!, selected["id"]!, token);
            setState(() {
              searchQuery = "";
            });
            ApiMessanger.show(response, context);
          },
          icon: const Icon(Icons.send),
          label: Text(selected["name"]!)),
    );
  }
}

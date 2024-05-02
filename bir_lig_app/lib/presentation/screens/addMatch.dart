// ignore: file_names
import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/data/models/profile.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/repositories/league_repository.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:bir_lig_app/presentation/widgets/playerList.dart';
import 'package:bir_lig_app/presentation/widgets/sessionExpiredDialog.dart';
import 'package:bir_lig_app/presentation/widgets/waiting_widgets/playerListWaiting.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:bir_lig_app/utils/errorHandler.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMatchPage extends StatefulWidget {
  final Map<String, String> league;
  const AddMatchPage({super.key, required this.league});

  @override
  State<AddMatchPage> createState() => _AddMatchPageState();
}

class _AddMatchPageState extends State<AddMatchPage> {
  Future<ApiResponse>? futureProfile;
  List<String>? selectedIds = [];
  List<String>? selectedNames = [];
  ApiService apiService = ApiService();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    final token = userProvider.token;

    futureProfile = LeagueRepository(apiService: apiService)
        .getAllLeagueProfiles(widget.league["id"]!, token!);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;

    final userProvider = Provider.of<UserProvider>(context);
    final token = userProvider.token.toString();

    var player1score = TextEditingController();
    var player2score = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.league["name"].toString()),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: futureProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      PlayerListWaiting(),
                      PlayerListWaiting(),
                      PlayerListWaiting(),
                      PlayerListWaiting(),
                      PlayerListWaiting(),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              if (snapshot.data!.authError) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  SessionExpiredDialog(parentContext: context).show();
                });

                return Container();
              }
              List<Profile> profiles = snapshot.data!.data;
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Maç Ekle",
                            style: _textTheme.headlineMedium,
                          ),
                        ),
                        Expanded(
                            child: ElevatedButton.icon(
                                onPressed: selectedIds!.length == 2
                                    ? () async {
                                        if (player1score.text.isEmpty ||
                                            player2score.text.isEmpty) {
                                          return;
                                        }
                                        ApiResponse response =
                                            await LeagueRepository(
                                                    apiService: apiService)
                                                .addMatch(
                                                    selectedIds![0],
                                                    selectedIds![1],
                                                    int.parse(
                                                        player1score.text),
                                                    int.parse(
                                                        player2score.text),
                                                    widget.league["id"]!,
                                                    token);
                                        player1score.clear();
                                        player2score.clear();
                                        if (mounted) {
                                          ApiMessanger.show(response, context);
                                        }
                                      }
                                    : null,
                                icon: const Icon(Icons.send),
                                label: const Text("ekle")))
                      ],
                    ),
                    addVerticalSpace(15),
                    Column(
                      children: profiles
                          .map((e) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (!selectedIds!.contains(e.id)) {
                                    if (selectedIds!.length == 2) {
                                      selectedIds!.removeAt(0);
                                      selectedNames!.removeAt(0);
                                    }
                                    selectedIds!.add(e.player!.id);
                                    selectedNames!
                                        .add(e.player!.name.toString());
                                  }
                                });
                              },
                              child:
                                  PlayerList(name: e.player!.name.toString())))
                          .toList(),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: COLOR_PRIMARY, borderRadius: BorderRadius.circular(18)),
          height: 150,
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(selectedNames!.isNotEmpty
                        ? selectedNames![0]
                        : 'Takım1'),
                  ),
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    controller: player1score,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: COLOR_PRIMARY),
                  ))
                ],
              ),
              addVerticalSpace(12),
              Row(
                children: [
                  Expanded(
                      child: Text(selectedNames!.isNotEmpty &&
                              selectedNames!.length == 2
                          ? selectedNames![1]
                          : 'Takım2')),
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    controller: player2score,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: COLOR_PRIMARY),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

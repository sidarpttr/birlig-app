// ignore: file_names
import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/repositories/league_repository.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:bir_lig_app/provider/SelectedIdsModel.dart';
import 'package:bir_lig_app/utils/errorHandler.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LeagueAddMatchPage extends StatefulWidget {
  final Map<String, String> league;
  const LeagueAddMatchPage({super.key, required this.league});

  @override
  State<LeagueAddMatchPage> createState() => _LeagueAddMatchPageState();
}

class _LeagueAddMatchPageState extends State<LeagueAddMatchPage> {
  ApiService apiService = ApiService();
  Future<ApiResponse>? futureProfile;
  List<String> selectedIds = [];

  @override
  void initState() {
    super.initState();
    futureProfile = LeagueRepository(apiService: apiService)
        .getAllLeagueProfiles(widget.league["id"]!);
  }

  @override
  Widget build(BuildContext context) {
    var player1score = TextEditingController();
    var player2score = TextEditingController();
    return ChangeNotifierProvider(
      create: (context) => SelectedIdsModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.league["name"]!),
          actions: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if(selectedIds.length < 2 || player2score.text == "" || player1score.text == ""){
                      return;
                    }
                    ApiResponse response = await LeagueRepository(apiService: apiService).addMatch(
                        selectedIds[0],
                        selectedIds[1],
                        int.parse(player1score.text),
                        int.parse(player2score.text),
                        widget.league["id"]!);
                    player1score.clear();
                    player2score.clear();
                    ApiMessanger.show(response, context);
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("ekle"),
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Maç Ekle", style: TextStyle(fontSize: 22),),
              addVerticalSpace(22),
              const Text("Takımlar", style: TextStyle(color: Colors.grey),),
              addVerticalSpace(12),
              Expanded(
                child: FutureBuilder(
                  future: futureProfile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.data.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data!.data[index];
                          return GestureDetector(
                            onTap: () {
                              if (!selectedIds.contains(item.player.id)) {
                                var selectedIdsModel = Provider.of<SelectedIdsModel>(
                                    context,
                                    listen: false);
                                selectedIdsModel.addPlayerId(
                                    {"id": item.player.id, "name": item.player.name});
                              }
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Center(child: Text(item.player.name)),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<SelectedIdsModel>(
            builder: (context, value, child) {
              selectedIds = value.selectedIds.length < 2
                  ? []
                  : List.from(
                      [value.selectedIds[0]["id"], value.selectedIds[1]["id"]]);
              return Container(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                    color: COLOR_PRIMARY,
                    borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(value.selectedIds.length >= 1
                          ? value.selectedIds[0]!["name"]
                          : 'Takım1'),
                      addHorizontalSpace(20),
                      Expanded(
                          child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: player1score,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                fillColor: Color(0x99000000)),
                          )),
                          addHorizontalSpace(12),
                          Expanded(
                              child: TextField(
                            controller: player2score,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                fillColor: Color(0x99000000)),
                          )),
                        ],
                      )),
                      addHorizontalSpace(20),
                      Text(value.selectedIds.length > 1
                          ? value.selectedIds[1]!["name"]
                          : 'Takım2'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

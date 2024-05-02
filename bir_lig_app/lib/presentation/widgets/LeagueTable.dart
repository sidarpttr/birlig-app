import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:bir_lig_app/presentation/widgets/matchView.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeagueTable extends StatelessWidget {
  final Future<ApiResponse> futureLeague;
  final String leagueId;

  LeagueTable({required this.futureLeague, required this.leagueId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureLeague,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text("Hata: ${snapshot.error}");
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('Oyuncu')),
                    DataColumn(label: Text('OM')),
                    DataColumn(label: Text('AG')),
                    DataColumn(label: Text('YG')),
                    DataColumn(label: Text('Avj')),
                    DataColumn(label: Text('P')),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.data.puanTablosu.siralama.length,
                    (index) {
                      var sira = snapshot.data!.data.puanTablosu.siralama[index];
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(sira.player.name)),
                          DataCell(Text(sira.om.toString())),
                          DataCell(Text(sira.ag.toString())),
                          DataCell(Text(sira.yg.toString())),
                          DataCell(Text(sira.averaj.toString())),
                          DataCell(Text(sira.puan.toString())),
                        ],
                        onLongPress: () {
                          showBottomSheet(
                            context: context,
                            builder: (context) {
                              return PlayerMatches(leagueId: leagueId, playerId: sira.player.id, playerName: sira.player.name);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class PlayerMatches extends StatelessWidget {
  final String leagueId;
  final String playerId;
  final String playerName;

  PlayerMatches({required this.leagueId, required this.playerId, required this.playerName});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final token = userProvider.token.toString();

    TextTheme _textTheme = Theme.of(context).textTheme;
    return FutureBuilder(
      future:
          ApiService().getAllProfileMatches(leagueId, playerId, token),
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
          return SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  addVerticalSpace(20),
                  Text(
                    playerName,
                    style: _textTheme.headlineMedium,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: MatchView(match: snapshot.data!.data[index]),
                        );
                      },
                    ),
                  ),
                ],
              ));
        }
      },
    );
  }
}

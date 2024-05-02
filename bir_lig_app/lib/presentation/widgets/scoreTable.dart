import 'package:bir_lig_app/presentation/widgets/LeagueTable.dart';
import 'package:flutter/material.dart';

class ScoreTable extends StatelessWidget {
  final String leagueId;
  final AsyncSnapshot snapshot;
  const ScoreTable({super.key, required this.leagueId, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return DataTable(
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
                  return PlayerMatches(
                      leagueId: leagueId,
                      playerId: sira.player.id,
                      playerName: sira.player.name);
                },
              );
            },
          );
        },
      ),
    );
  }
}

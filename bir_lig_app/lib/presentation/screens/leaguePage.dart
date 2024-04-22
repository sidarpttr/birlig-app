import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/repositories/league_repository.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:bir_lig_app/presentation/screens/leagueAddMatchPage.dart';
import 'package:bir_lig_app/presentation/screens/leagueAddPlayer.dart';
import 'package:bir_lig_app/presentation/widgets/LeagueTable.dart';
import 'package:bir_lig_app/presentation/widgets/matchView.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';

class LeaguePage extends StatefulWidget {
  final Map<String, String> league;
  const LeaguePage({super.key, required this.league});

  @override
  State<LeaguePage> createState() => _LeaguePageState();
}

class _LeaguePageState extends State<LeaguePage> {
  ApiService apiService = ApiService();
  Future<ApiResponse>? futureLeague;
  Future<ApiResponse>? futureMatch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureLeague = LeagueRepository(apiService: apiService)
        .getLeagueById(widget.league["id"]!);
    futureMatch = LeagueRepository(apiService: apiService)
        .getAllLeagueMatches(widget.league["id"]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.league["name"]!),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LeagueAddPlayerPage(league: widget.league,),
                    ));
              },
              icon: Icon(Icons.person_add_alt_1_rounded))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: LeagueTable(
                  futureLeague: futureLeague!, leagueId: widget.league["id"]!)),
          Text("Son Maçlar", style: TextStyle(color: Colors.white.withAlpha(150)),),
          addVerticalSpace(20),
          Expanded(
              child: FutureBuilder(
            future: futureMatch,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Hata: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: MatchView(match: snapshot.data!.data[index]),
                    );
                  },
                );
              }
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LeagueAddMatchPage(league: widget.league),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

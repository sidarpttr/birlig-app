import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/data/models/match.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/repositories/league_repository.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:bir_lig_app/presentation/screens/addMatch.dart';
import 'package:bir_lig_app/presentation/screens/leagueAddPlayer.dart';
import 'package:bir_lig_app/presentation/widgets/matchView.dart';
import 'package:bir_lig_app/presentation/widgets/scoreTable.dart';
import 'package:bir_lig_app/presentation/widgets/sessionExpiredDialog.dart';
import 'package:bir_lig_app/presentation/widgets/waiting_widgets/leaguePageWaiting.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaguePage extends StatefulWidget {
  final Map<String, String> league;
  const LeaguePage({super.key, required this.league});

  @override
  State<LeaguePage> createState() => _LeaguePageState();
}

class _LeaguePageState extends State<LeaguePage> {
  ApiService apiService = ApiService();
  Future<ApiResponse>? futureLeague;
  bool isMember = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);

    futureLeague = LeagueRepository(apiService: apiService)
        .getLeagueById(widget.league["id"]!, userProvider.token.toString());

    ApiResponse? leagueData = await futureLeague;
    if (mounted) {
      setState(() {
        isMember = leagueData!.data.isMember;
      });
    }
  }

  // ignore: non_constant_identifier_names
  refresh_page() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    ApiResponse newLeagueData = await LeagueRepository(apiService: apiService)
        .getLeagueById(widget.league["id"]!, userProvider.token.toString());
    if (mounted) {
      setState(() {
        futureLeague = Future.value(newLeagueData);
      });
    }
  }

  void updateIsMember(bool isMember) {
    if (mounted) {
      setState(() {
        this.isMember = isMember;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.league["name"]!),
        actions: isMember
            ? [
                IconButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeagueAddPlayerPage(
                              league: widget.league,
                            ),
                          ));
                      refresh_page();
                    },
                    icon: const Icon(Icons.person_add_alt_1_rounded))
              ]
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () => refresh_page(),
        color: WHITE,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: futureLeague,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LeaguePageWaiting();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                if (snapshot.data!.authError) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    SessionExpiredDialog(parentContext: context).show();
                  });

                  return Container();
                }

                List<LeagueMatch> matches = snapshot.data!.data.maclar;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ScoreTable(
                          leagueId: widget.league["id"].toString(),
                          snapshot: snapshot),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 20),
                      child: Text(
                        "maçlar",
                        style: textTheme.bodySmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children:
                            matches.map((e) => MatchView(match: e)).toList(),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: isMember
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMatchPage(league: widget.league),
                    ));
                refresh_page();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

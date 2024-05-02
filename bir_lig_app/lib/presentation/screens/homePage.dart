import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/data/models/league.dart';
import 'package:bir_lig_app/data/models/match.dart';
import 'package:bir_lig_app/data/models/player.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/repositories/league_repository.dart';
import 'package:bir_lig_app/data/repositories/player_repository.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:bir_lig_app/presentation/screens/addLeague.dart';
import 'package:bir_lig_app/presentation/widgets/lastMatch.dart';
import 'package:bir_lig_app/presentation/widgets/leagueList.dart';
import 'package:bir_lig_app/presentation/widgets/sessionExpiredDialog.dart';
import 'package:bir_lig_app/presentation/widgets/waiting_widgets/homePageWaiting.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService apiService = ApiService();
  Future<ApiResponse>? futureLeague;
  Future<ApiResponse>? futureMatch;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    final player = userProvider.player;

    if (mounted && player != null) {
      futureLeague = LeagueRepository(apiService: apiService)
          .getAllLeagues(userProvider.token.toString());
      futureMatch = PlayerRepository(apiService: apiService)
          .getAllPlayerMatches(player.id);
    }
  }

  refresh_page() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token.toString();
    ApiResponse newData =
        await LeagueRepository(apiService: apiService).getAllLeagues(token);
    if (mounted) {
      setState(() {
        futureLeague = Future.value(newData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final player = userProvider.player ??
        Player(id: "0123456789", name: "sidar", email: "sidar");
    TextTheme _textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      color: WHITE,
      onRefresh: () async => await refresh_page(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Merhaba, ${player.name}",
            style: _textTheme.headlineMedium,
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: Future.wait<dynamic>([futureLeague!, futureMatch!]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const HomePageWaiting();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                if (snapshot.data!.any((element) => element.authError)) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    SessionExpiredDialog(parentContext: context).show();
                  });

                  return Container();
                }
                List<League>? leagues = snapshot.data![0].data;
                List<LeagueMatch> matches = snapshot.data![1].data;
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "son maçların",
                        style: _textTheme.bodySmall,
                      ),
                      addVerticalSpace(10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              matches.map((e) => LastMatch(match: e)).toList(),
                        ),
                      ),
                      addVerticalSpace(20),
                      Text(
                        "ligler",
                        style: _textTheme.bodySmall,
                      ),
                      addVerticalSpace(10),
                      Column(
                        children: leagues!
                            .map((e) => LeagueListTile(
                                title: e.name.toString(), id: e.id))
                            .toList(),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddLeague(),
                ));
            refresh_page();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

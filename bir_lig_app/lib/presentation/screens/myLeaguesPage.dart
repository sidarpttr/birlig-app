import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/data/models/league.dart';
import 'package:bir_lig_app/data/models/player.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/repositories/player_repository.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:bir_lig_app/presentation/widgets/leagueList.dart';
import 'package:bir_lig_app/presentation/widgets/sessionExpiredDialog.dart';
import 'package:bir_lig_app/presentation/widgets/waiting_widgets/leagueListWaiting.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLeaguesPage extends StatefulWidget {
  const MyLeaguesPage({super.key});

  @override
  State<MyLeaguesPage> createState() => _MyLeaguesPageState();
}

class _MyLeaguesPageState extends State<MyLeaguesPage> {
  Future<ApiResponse>? futureLeague;
  ApiService apiService = ApiService();
  String searchQuery = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userProvider = Provider.of<UserProvider>(context);
    final player = userProvider.player ?? Player(id: "0123456789");

    futureLeague = PlayerRepository(apiService: apiService)
        .getAllLeaguesForPlayer(player.id);
  }

  refresh_page() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final player = userProvider.player ?? Player(id: "0123456789");
    ApiResponse newData = await PlayerRepository(apiService: apiService)
        .getAllLeaguesForPlayer(player.id);
    if (mounted) {
      setState(() {
        futureLeague = Future.value(newData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  size: 25,
                  color: COLOR_PRIMARY,
                ),
                hintText: "Liglerimde ara ...",
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await refresh_page(),
        child: FutureBuilder(
          future: futureLeague,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    LeagueListWaiting(),
                    LeagueListWaiting(),
                    LeagueListWaiting(),
                    LeagueListWaiting(),
                    LeagueListWaiting(),
                  ],
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
              List<League> leagues = snapshot.data!.data;
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: leagues.map(
                      (e) {
                        if (e.name.toString().contains(searchQuery)) {
                          return LeagueListTile(
                              title: e.name.toString(), id: e.id);
                        } else {
                          return Container();
                        }
                      },
                    ).toList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

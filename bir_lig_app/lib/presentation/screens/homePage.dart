import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/repositories/league_repository.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:bir_lig_app/presentation/screens/addLeague.dart';
import 'package:bir_lig_app/presentation/widgets/lastMatch.dart';
import 'package:bir_lig_app/presentation/widgets/leagueList.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureLeague = LeagueRepository(apiService: apiService).getAllLeagues();
  }

  refresh_page() async {
    ApiResponse newData = await LeagueRepository(apiService: apiService).getAllLeagues();
    setState(() {
      futureLeague = Future.value(newData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final player = userProvider.player;

    TextTheme _textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: () => refresh_page(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Merhaba, ${player!.name}",
            style: _textTheme.headlineMedium,
          ),
          centerTitle: false,
          actions: [
            ElevatedButton(
                onPressed: () {
                  refresh_page();
                },
                child: Text("yenile"))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(10),
              const Text(
                "son maçların",
                style: TextStyle(
                    color: Color(0xFF3C415C), fontWeight: FontWeight.bold),
              ),
              addVerticalSpace(10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: player.maclar!
                      .map((mac) => LastMatch(
                            match: mac,
                          ))
                      .toList(),
                ),
              ),
              addVerticalSpace(20),
              const Text(
                "Ligler",
                style: TextStyle(
                    color: Color(0xFF3C415C), fontWeight: FontWeight.bold),
              ),
              addVerticalSpace(10),
              Expanded(
                  child: FutureBuilder(
                future: futureLeague,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Hata: ${snapshot.error}");
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.data.length,
                      itemBuilder: (context, index) {
                        return LeagueListTile(
                          title: snapshot.data!.data[index].name,
                          id: snapshot.data!.data[index].id,
                        );
                      },
                    );
                  }
                },
              ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddLeague(),
                ));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

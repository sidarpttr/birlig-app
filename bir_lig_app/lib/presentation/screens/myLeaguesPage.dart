
import 'package:bir_lig_app/presentation/widgets/leagueList.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLeaguesPage extends StatefulWidget {
  const MyLeaguesPage({super.key});

  @override
  State<MyLeaguesPage> createState() => _MyLeaguesPageState();
}

class _MyLeaguesPageState extends State<MyLeaguesPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final player = userProvider.player;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              decoration: const InputDecoration(suffixIcon: Icon(Icons.search, size: 25, color: Colors.grey,),hintText: "Liglerimde ara ...", hintStyle: TextStyle(fontWeight: FontWeight.normal)),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: player!.ligler!.map((e) {
              if(e.name!.contains(searchQuery)){
                return LeagueListTile(title: e.name.toString(), id: e.id);
              }else{
                return Container();
              }
            }).toList(),
          ),
        ),
      ),
    );
  }
}

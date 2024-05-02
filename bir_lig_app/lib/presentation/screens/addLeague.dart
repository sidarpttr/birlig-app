import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/data/models/response.dart';
import 'package:bir_lig_app/data/repositories/league_repository.dart';
import 'package:bir_lig_app/data/services/api_service.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:bir_lig_app/utils/errorHandler.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddLeague extends StatefulWidget {
  const AddLeague({super.key});

  @override
  State<AddLeague> createState() => _AddLeagueState();
}

class _AddLeagueState extends State<AddLeague> {
  ApiService apiService = ApiService();
  String name = "";

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final player = userProvider.player;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GREY,
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: GREY,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32))),
            width: MediaQuery.of(context).size.width,
            height: 169,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 32,
                right: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bir Lig Ekle",
                    style: TextStyle(fontSize: 32, color: WHITE),
                  ),
                  addVerticalSpace(32),
                  TextField(
                    style: const TextStyle(color: COLOR_PRIMARY),
                    decoration: const InputDecoration(hintText: "Lig ismi ..."),
                    cursorColor: COLOR_SECONDARY,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: ElevatedButton.icon(
          onPressed: name != ""
              ? () async {
                  ApiResponse response =
                      await LeagueRepository(apiService: apiService)
                          .createLeague(
                              name, player!.id, userProvider.token.toString());
                  ApiMessanger.show(response, context);
                  Navigator.pop(context, 'refresh');
                }
              : null,
          icon: const Icon(Icons.send),
          label: Text(name)),
    );
  }
}

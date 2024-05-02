import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final player = userProvider.player;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(player?.name ?? 'Default Name'),
            addVerticalSpace(10),
            Text(
              player?.email ?? 'Default Email',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: CircleAvatar(
            backgroundColor: COLOR_SECONDARY,
            child: Text(
              player?.name?[0] ?? ' ',
              style: const TextStyle(color: SCAFFOLD_BACKGROUND),
            ),
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await userProvider.logout();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: COLOR_SECONDARY,
                ),
                label: const Text(
                  "çıkış",
                  style: TextStyle(
                    color: COLOR_SECONDARY,
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(BLACK),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(7))),
              ))
        ],
      ),
      body: Center(child: Text("bakcak bi şey yok")),
    );
  }
}

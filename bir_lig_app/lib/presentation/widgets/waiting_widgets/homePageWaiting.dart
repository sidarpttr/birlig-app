import 'package:bir_lig_app/presentation/widgets/waiting_widgets/lastMatch.dart';
import 'package:bir_lig_app/presentation/widgets/waiting_widgets/leagueListWaiting.dart';
import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';

class HomePageWaiting extends StatelessWidget {
  const HomePageWaiting({super.key});

  @override
  Widget build(BuildContext context) {

    TextTheme _textTheme = Theme.of(context).textTheme;
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
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                LastMatchWait(),
                LastMatchWait(),
                LastMatchWait(),
                LastMatchWait(),
              ],
            ),
          ),
          addVerticalSpace(20),
          Text(
            "ligler",
            style: _textTheme.bodySmall,
          ),
          addVerticalSpace(10),
          const Column(
            children:[
              LeagueListWaiting(),
              LeagueListWaiting(),
              LeagueListWaiting(),
              LeagueListWaiting(),
              LeagueListWaiting(),
              LeagueListWaiting(),
            ],
          )
        ],
      ),
    );
  }
}

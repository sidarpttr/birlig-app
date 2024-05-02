import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/presentation/widgets/waiting_widgets/matchViewWaiting.dart';
import 'package:flutter/material.dart';

class LeaguePageWaiting extends StatelessWidget {
  const LeaguePageWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          color: GREY,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 20),
          child: Text(
            "maçlar",
            style: _textTheme.bodySmall,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              MatchViewWaiting(),
              MatchViewWaiting(),
              MatchViewWaiting(),
              MatchViewWaiting(),
              MatchViewWaiting(),
            ]
          ),
        )
      ],
    );
  }
}

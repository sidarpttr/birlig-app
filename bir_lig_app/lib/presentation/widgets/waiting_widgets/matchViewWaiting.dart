import 'package:bir_lig_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';

class MatchViewWaiting extends StatelessWidget {
  const MatchViewWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          color: Colors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          addHorizontalSpace(70),
        ],
      ),
    );
  }
}

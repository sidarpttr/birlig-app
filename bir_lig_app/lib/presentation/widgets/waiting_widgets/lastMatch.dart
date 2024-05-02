import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class LastMatchWait extends StatelessWidget {
  const LastMatchWait({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: GREY),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      child: const Center(child: Text("")),
    );
  }
}
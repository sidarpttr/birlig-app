import 'package:bir_lig_app/data/models/response.dart';
import 'package:flutter/material.dart';

class ApiMessanger {
  static void show(ApiResponse response, BuildContext context) {
    if (!response.succes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFA0153E),
          content: Text('Hata: ${response.error}'),
        ),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.status),
        ),
      );
    }
  }
}

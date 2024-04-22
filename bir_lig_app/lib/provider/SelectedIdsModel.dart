import 'package:flutter/material.dart';

class SelectedIdsModel extends ChangeNotifier {
  List<dynamic> _selectedIds = [];

  List<dynamic> get selectedIds => _selectedIds;

  void addPlayerId(dynamic id) {
    if (!_selectedIds.contains(id)){
      if (_selectedIds.length < 2) {
        _selectedIds.add(id);
      } else {
        _selectedIds.removeAt(0);
        _selectedIds.add(id);
      }
    }else{
      print("haydaa");
    }
    notifyListeners();
  }
}

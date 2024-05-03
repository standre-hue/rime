import 'package:flutter/material.dart';
import 'package:rime/data/models/Account.dart';
import 'package:rime/data/models/Caisse.dart';
import 'package:rime/data/models/Info.dart';

class CaisseProvider with ChangeNotifier {
  late Caisse _caisse;

Caisse get caisse => _caisse;
  void setCaisse(Caisse caisse) {
    _caisse = caisse;
    notifyListeners();
  }
}

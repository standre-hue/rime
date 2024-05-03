import 'package:flutter/material.dart';
import 'package:rime/data/models/Account.dart';
import 'package:rime/data/models/Info.dart';

class InfoProvider with ChangeNotifier {
  List<Info> _infos = [];

List<Info> get infos => _infos;
  void setInfos(List<Info> infos) {
    _infos = infos;
    notifyListeners();
  }
}

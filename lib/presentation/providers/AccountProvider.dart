import 'package:flutter/material.dart';
import 'package:rime/data/models/Account.dart';


class AccountProvider with ChangeNotifier {
  late Account _moovAccount;
  late Account _togocomAccount;

  Account get moovAccount => _moovAccount;
  Account get togocomAccount => _togocomAccount;

  void setAccounts({ required Account moovAccount, required Account togocomAccount}) {
    _moovAccount = moovAccount;
    _togocomAccount = togocomAccount;
    notifyListeners();
  }
}

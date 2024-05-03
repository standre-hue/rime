import 'package:flutter/material.dart';
import 'package:rime/data/models/Account.dart';
import 'package:rime/data/models/Info.dart';
import 'package:rime/data/models/Transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> _recentTransactions = [];

List<Transaction> get transactions => _transactions;

List<Transaction> get recentTransactions => _recentTransactions;

  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

    void setRecentTransactions(List<Transaction> transactions) {
    _recentTransactions = transactions;
    notifyListeners();
  }
}

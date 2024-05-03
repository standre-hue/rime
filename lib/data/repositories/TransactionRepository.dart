// ignore_for_file: body_might_complete_normally_nullable, await_only_futures

import 'package:mysql1/mysql1.dart';
import 'package:rime/data/models/Transaction.dart';
import 'package:rime/data/repositories/AccountRepository.dart';
import 'package:rime/data/repositories/CaisseRepository.dart';
import 'package:rime/presentation/utils/funcs.dart';

class TransactionRepository {
  MySqlConnection? connection;
  CaisseRepository caisseRepository = CaisseRepository();
  AccountRepository accountRepository = AccountRepository();
  TransactionRepository() {
    _connectDB();
  }
  Future<void> _connectDB() async {
    try {
      if (connection != null) return;
      connection = await connectDB();
      //print("CONNECTED TO THE DB FROM TRANSACTION REPO");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Transaction?> findTransactionById(int id) async {
    try {
      await _connectDB();
      Transaction? transaction;
      var results = await connection!.query(
          'select id,amount,status,phoneNumber,userId,accountId,type,createdAt, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction where id = ?',
          [id]);
      if (results.isEmpty) return null;
      for (var row in results) {
        transaction = Transaction(
            id: row[0] as int,
            amount: row[1] as int,
            status: row[2],
            phoneNumber: row[3],
            userId: row[4],
            accountId: row[5],
            type: row[6],
            createdAt: row[7],
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        return transaction;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> createTransaction({
    required int amount,
    String status = "Pending",
    required String phoneNumber,
    required int userId,
    required int accountId,
    required String type,
  }) async {
    try {
      await _connectDB();
      int? prevAccountAmount = await accountRepository.getAmount(accountId);
      int? prevCompteAmount = await caisseRepository.getAmount();


      late int curAccountAmount;
      late int curCompteAmount;

      if (type == 'Dépot') {
        curAccountAmount = prevAccountAmount! - amount;
        curCompteAmount = prevCompteAmount! + amount;
      } else {
        curAccountAmount = prevAccountAmount! + amount;
        curCompteAmount = prevCompteAmount! - amount;
      }
      print(curAccountAmount);
      print(curCompteAmount);
      final account = await this.accountRepository.findAccountById(accountId);
      var results = await connection!.query(
          "insert into transaction(amount, status, phoneNumber, userId,accountId, type, compteType, prevAccountAmount, curAccountAmount, prevCompteAmount, curCompteAmount) values (?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?)",
          [
            amount,
            status,
            phoneNumber,
            userId,
            accountId,
            type,
            account?.type,
            prevAccountAmount,
            curAccountAmount,
            prevCompteAmount,
            curCompteAmount
          ]);
      return results.insertId!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getAllTransaction() async {
    try {
      await _connectDB();
      List<Transaction> transactions = [];
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction");
      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionyByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      await _connectDB();
      List<Transaction> transactions = [];
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction");
      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionyByPhoneNumber(
      String phoneNumber) async {
    try {
      await _connectDB();
      List<Transaction> transactions = [];
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction where phoneNumber like '%$phoneNumber%' ");
      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionyByAmount(int amount) async {
    try {
      await _connectDB();
      List<Transaction> transactions = [];
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction where amount = ?",
          [amount]);
      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionyByStatus(String status) async {
    try {
      await _connectDB();
      List<Transaction> transactions = [];
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction where status = ?",
          [status]);
      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionyByOperationType(
      String opType) async {
    try {
      await _connectDB();
      List<Transaction> transactions = [];
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction where type = ?",
          [opType]);
      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionyByTypeCompte(
      String typeCompte) async {
    try {
      await _connectDB();
      List<Transaction> transactions = [];
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction where typeCompte = ?",
          [typeCompte]);
      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionBefore(DateTime endDateO) async {
    try {
      await _connectDB();
      List<Transaction> transactions = [];
      String dt = formatDateUs(endDateO);
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction where date(createdAt) <=  ?",
          [dt]);
      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      print(transactions.length);
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionAfter(DateTime startateO) async {
    try {
      await _connectDB();
      List<Transaction> transactions = [];
      String dt = formatDateUs(startateO);
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction where date(createdAt) >=  ?",
          [dt]);
      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      print(transactions.length);
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionBetween(
      DateTime startateO, DateTime endDateO) async {
    try {
      await _connectDB();
      List<Transaction> transactions = [];
      String dt = formatDateUs(startateO);
      String dt2 = formatDateUs(endDateO);
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction where date(createdAt) >=  ? and date(createdAt) <= ? ",
          [dt, dt2]);
      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      print(transactions.length);
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getRecentTransaction(int length) async {
    try {
      await _connectDB();

      List<Transaction> transactions = [];
      final results = await connection!.query(
          "select id, amount, status, phoneNumber, userId,accountId, createdAt, type, prevAccountAmount, curAccountAmount, compteType, prevCompteAmount, curCompteAmount from transaction order by createdAt desc limit ? ",
          [length]);

      for (var row in results) {
        //print(row);
        Transaction transaction = Transaction(
            id: row[0] as int,
            type: row[7],
            amount: row[1] as int,
            phoneNumber: row[3],
            createdAt: row[6],
            status: row[2],
            userId: row[4] as int,
            accountId: row[5] as int,
            prevAccountAmount: row[8] as int,
            curAccountAmount: row[9] as int,
            compteType: row[10],
            prevCompteAmount: row[11],
            curCompteAmount: row[12]);
        transactions.add(transaction);
      }
      //print(transactions.length);
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

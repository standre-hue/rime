import 'package:rime/data/models/Transaction.dart';
import 'package:rime/data/repositories/AccountRepository.dart';
import 'package:rime/data/repositories/CaisseRepository.dart';
import 'package:rime/data/repositories/TransactionRepository.dart';

class TransactionService {
  TransactionRepository transactionRepository = TransactionRepository();
  //AccountRepository accountRepository = AccountRepository();
  //CaisseRepository caisseRepository = CaisseRepository();

  Future<int> createTransaction({
    required int amount,
    String status = "Pending",
    required String phoneNumber,
    required int userId,
    required int accountId,
    required String type,
  }) async {
    try {

      int id = await transactionRepository.createTransaction(
          amount: amount,
          phoneNumber: phoneNumber,
          userId: userId,
          accountId: accountId,
          status: status,
          type: type);
      return id;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> getTodayTransaction() async {
    try {
      List<Transaction> transactions = [];
      transactions = await transactionRepository.getAllTransaction();
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Transaction>> searchByDateRange(
      DateTime? startDateO, DateTime? endDateO) async {
    try {
      List<Transaction> transactions = [];
      //transactions = await transactionRepository.getAllTransaction();
      if (startDateO == null && endDateO != null) {
        print('HOOOOOOOR');
        transactions =
            await transactionRepository.getTransactionBefore(endDateO);
      }
      if (startDateO != null && endDateO == null) {
        print('HEEEEEEEEER');
        transactions =
            await transactionRepository.getTransactionAfter(startDateO);
      }
      if (startDateO != null && endDateO != null) {
        transactions = await transactionRepository.getTransactionBetween(
            startDateO, endDateO);
      }
      return transactions;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

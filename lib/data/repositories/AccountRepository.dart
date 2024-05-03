import 'package:mysql1/mysql1.dart';
import 'package:rime/data/models/Account.dart';
import 'package:rime/presentation/utils/errors.dart';
import 'package:rime/presentation/utils/funcs.dart';

class AccountRepository {
 MySqlConnection? connection;
  AccountRepository() {
    _connectDB();
  }

  Future<void> _connectDB() async {
    try {
      if(connection != null) {
        return;
      }
      connection = await connectDB();
      print("CONNECTED FROM ACCOUNT REPO");
    } catch (e) {
      print(e);
    }
  }

  Future<Account?> findAccountByType(String type) async {
    try {
      await _connectDB();
      var results = await connection!
          .query('select id, type, amount from account where type = ?', [type]);

      for (var row in results) {
        return Account(id: row[0] as int, type: row[1], amount: row[2] as int);
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Account?> findAccountById(int id) async {
    try {
     await _connectDB();
      var results = await connection!
          .query('select id, type, amount from account where id = ?', [id]);

      for (var row in results) {
        return Account(id: row[0] as int, type: row[1], amount: row[2] as int);
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool?> increaseAmount(int accountId, int amount) async {
    try {
      await _connectDB();
      int? prevAmount = await this.getAmount(accountId);
      print('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP');
      print(prevAmount);
      int newAmount = prevAmount! + amount;
      
      print(newAmount);
      var results = await connection!.query(
          'update account set amount = ? where id = ?', [newAmount, accountId]);
      return true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool?> decreaseAmount(int accountId, int amount) async {
    try {
      await _connectDB();
      int? prevAmount = await this.getAmount(accountId);
      if (prevAmount! - amount < 0) {
        throw InsufficientAccountAmountException((prevAmount! - amount).abs());
      }
      var results = await connection!.query(
          'update account set amount = ? where id = ?',
          [prevAmount! - amount, accountId]);
      return true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<int?> getAmount(int accountId) async {
    try {
      connection = await connectDB();
      var results = await connection!
          .query('select amount from account where id = ?', [accountId]);
      for (var row in results) {
        return row[0];
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

      Future<bool?> canDecrease(int accountId, int amount) async {
    try {
     await _connectDB();
      int? prevAmount = await this.getAmount(accountId);
      int newAmount = prevAmount! - amount;

      if (prevAmount! - amount >= 0) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

// ignore_for_file: unnecessary_this

import 'package:mysql1/mysql1.dart';
import 'package:rime/data/models/Account.dart';
import 'package:rime/data/models/Caisse.dart';
import 'package:rime/presentation/utils/errors.dart';
import 'package:rime/presentation/utils/funcs.dart';

class CaisseRepository {
  MySqlConnection? connection;
  CaisseRepository() {}

  Future<void> _connectDB() async {
    try {
      if (connection != null) return;
      connection = await connectDB();
      print("CONNECTED FROM COMPTE REPO");
    } catch (e) {
      print(e);
    }
  }

  Future<Caisse?> findCaisseById(int id) async {
    try {
      await _connectDB();
      var results = await connection!
          .query('select id,  amount from caisse where id = ?', [id]);

      for (var row in results) {
        return Caisse(id: row[0] as int, amount: row[1] as int);
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Caisse?> findRecentCaisse() async {
    try {
      await _connectDB();
      var results = await connection!.query(
        'select id,  amount from caisse  order by createdAt limit 1',
      );

      for (var row in results) {
        return Caisse(id: row[0] as int, amount: row[1] as int);
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool?> increaseAmount(int caisseId, int amount) async {
    try {
      await _connectDB();
      int? prevAmount = await this.getAmount(caisseId:caisseId);
      var results = await connection!.query(
          'update caisse set amount = ? where id = ?',
          [prevAmount! + amount, caisseId]);
      return true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool?> decreaseAmount(int caisseId, int amount, {bool canBeNegative = false}) async {
    try {
      await _connectDB();
      int? prevAmount = await this.getAmount(caisseId:caisseId);
      int newAmount = prevAmount! - amount;

      if (prevAmount! - amount < 0 && !canBeNegative) {
        throw InsufficientCaisseAmountException((prevAmount! - amount).abs());
      }

      var results = await connection!.query(
          'update caisse set amount = ? where id = ?', [newAmount, caisseId]);
      return true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<int?> getAmount({int caisseId = 1}) async {
    try {
     await _connectDB();
      var results = await connection!
          .query('select amount from caisse where id = ?', [caisseId]);
      for (var row in results) {
        return row[0];
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

    Future<bool?> canDecrease(int caisseId, int amount) async {
    try {
     await _connectDB();
      int? prevAmount = await this.getAmount(caisseId:caisseId);
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

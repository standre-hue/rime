import 'package:mysql1/mysql1.dart';
import 'package:rime/data/repositories/CaisseRepository.dart';
import 'package:rime/presentation/utils/funcs.dart';

class SupplyRepository {
  MySqlConnection? connection;
  CaisseRepository caisseRepository = CaisseRepository();
  AccountRepository() {
    _connectDB();
  }

  Future<void> _connectDB() async {
    try {
      if (connection != null) {
        return;
      }
      connection = await connectDB();
      print("CONNECTED FROM SUPPLY REPO");
    } catch (e) {
      print(e);
    }
  }

  Future<int> saveSupply(
      {required int caisseId,
      required int amount,
      required int prevAmount,
      required int userId}) async {
    try {
      await _connectDB();
      int curAmount = prevAmount + amount;
      final success = await caisseRepository.increaseAmount(caisseId, amount);
      var results = await connection!.query(
          "insert into supply (amount, prevAmount, curAmount, userId) values (?, ?, ?, ?)",
          [amount, prevAmount, curAmount, userId]);
      return results.insertId!;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

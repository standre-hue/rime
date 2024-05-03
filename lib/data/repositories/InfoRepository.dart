import 'package:mysql1/mysql1.dart';
import 'package:rime/data/models/Info.dart';
import 'package:rime/data/repositories/AccountRepository.dart';
import 'package:rime/presentation/utils/funcs.dart';

class InfoRepository {
  late MySqlConnection connection;
  AccountRepository accountRepository = AccountRepository();
  InfoRepository() {
    _connectDB();
  }

  void _connectDB() async {
    try {
      connection = await connectDB();
      print("CONNECTED TO THE DB FROM INFO REPO");
    } catch (e) {
      print(e);
    }
  }

  Future<Info> getTmoneyDepotInfo() async {
    try {
      final togocomAccount =
          await accountRepository.findAccountByType("Togocom");
      var results = await connection.query(
          'select amount from transaction where accountId = ? and type = ? ',
          [togocomAccount?.id, 'Dépot']);
      print("COUNT: ${results.length}");
      print("COUNT: ${togocomAccount?.id}");
      int totalAmount = 0;
      for (var row in results) {
        totalAmount = totalAmount + row[0] as int;
      }

      Info info = Info(
          accountName: 'Tmoney',
          opType: 'Dépot',
          value: totalAmount,
          number: results.length);

      return info;
    } catch (e) {
      rethrow;
    }
  }

  Future<Info> getTmoneyRetraitInfo() async {
    try {
      final togocomAccount =
          await accountRepository.findAccountByType("Togocom");
      var results = await connection.query(
          'select amount from transaction where accountId = ? and type = ? ',
          [togocomAccount?.id, 'Retrait']);
      print("COUNT: ${results.length}");
      print("COUNT: ${togocomAccount?.id}");
      int totalAmount = 0;
      for (var row in results) {
        totalAmount = totalAmount + row[0] as int;
      }

      Info info = Info(
          accountName: 'Tmoney',
          opType: 'Retrait',
          value: totalAmount,
          number: results.length);

      return info;
    } catch (e) {
      rethrow;
    }
  }

  Future<Info> getFloozDepotInfo() async {
    try {
      final moovAccount = await accountRepository.findAccountByType("Moov");
      var results = await connection.query(
          'select amount from transaction where accountId = ? and type = ? ',
          [moovAccount?.id, 'Dépot']);
      
      int totalAmount = 0;
      for (var row in results) {
        print(row[0]);
        totalAmount = totalAmount + row[0] as int;
      }

      Info info = Info(
          accountName: 'Flooz',
          opType: 'Dépot',
          value: totalAmount,
          number: results.length);

      return info;
    } catch (e) {
      rethrow;
    }
  }

  Future<Info> getFloozRetraitInfo() async {
    try {
      final moovAccount = await accountRepository.findAccountByType("Moov");
      var results = await connection.query(
          'select amount from transaction where accountId = ? and type = ? ',
          [moovAccount?.id, 'Retrait']);

      int totalAmount = 0;
      for (var row in results) {
        totalAmount = totalAmount + row[0] as int;
      }

      Info info = Info(
          accountName: 'Flooz',
          opType: 'Retrait',
          value: totalAmount,
          number: results.length);

      return info;
    } catch (e) {
      rethrow;
    }
  }
}

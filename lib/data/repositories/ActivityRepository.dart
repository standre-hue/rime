import 'package:mysql1/mysql1.dart';
import 'package:rime/data/models/Activity.dart';
import 'package:rime/presentation/utils/funcs.dart';

class ActivityRepository {
  MySqlConnection? connection;
  ActivityRepository() {
    _connectDB();
  }

  Future<void> _connectDB() async {
    try {
      if (connection != null) return;
      connection = await connectDB();
      print("CONNECTED FROM ACTIVITY REPO");
    } catch (e) {
      print(e);
    }
  }

  Future<bool?> createActivity(
      {int? supplyId,
      int? transactionId,
      int? userId,
      required String description}) async {
    try {
      if (supplyId != null) {
        var result = await connection!.query(
              'insert into activity (description, supplyId, userId) values (?, ?, ?)',
              [description, supplyId, userId]);
      } else {
        if (transactionId == null && userId == null) {
          throw Exception(
              "Activity transactionId and userId can't be both null");
        } else if (transactionId != null && userId != null) {
          var result = await connection!.query(
              'insert into activity (description, userId, transactionId) values (?, ?, ?)',
              [description, userId, transactionId]);
        } else if (transactionId != null && userId == null) {
          var result = await connection!.query(
              'insert into activity (description, transactionId) values (?,  ?)',
              [description, transactionId]);
        } else if (transactionId == null && userId != null) {
          var result = await connection!.query(
              'insert into activity (description, userId) values (?,  ?)',
              [description, userId]);
        }
      }
      return true;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Activity>> getUserActivities(int userId) async {
    try {
      await _connectDB();
      List<Activity> activities = [];
      var result = await connection!.query(
          'select id, description, createdAt from  activity where userId = ?',
          [userId]);
      for (var row in result) {
        Activity activity =
            Activity(id: row[0], description: row[1], createdAt: row[2]);
        activities.add(activity);
      }

      return activities;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

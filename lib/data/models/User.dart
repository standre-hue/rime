import 'package:rime/data/models/Activity.dart';
import 'package:rime/data/models/Transaction.dart';

class User {
  String username;
  int id;
  String role;
  DateTime createdAt;
  String? password;
  List<Transaction> transactions = [];
  List<Activity> activities = [];
  User({
    required this.id,
    required this.username,
    required this.role,
    required this.createdAt,
  });
  /*factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
    );
  }*/
}

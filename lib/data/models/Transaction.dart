import 'package:rime/data/models/Account.dart';
import 'package:rime/data/models/Activity.dart';
import 'package:rime/data/models/User.dart';
import 'package:rime/data/repositories/AccountRepository.dart';
import 'package:rime/data/repositories/UserRepository.dart';
import 'package:uuid/uuid.dart';

class Transaction {
  int id;
  String type;
  late Account account;
  int amount;
  String phoneNumber;
  DateTime createdAt;
  late User user;
  int userId;
  int accountId;
  String status;
  String ref = "2329983862571";
  List<Activity> activities = [];
  int prevAccountAmount;
  int curAccountAmount;
  int prevCompteAmount;
  int curCompteAmount;
  String compteType;
  //var uuid = Uuid();
  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.phoneNumber,
    required this.createdAt,
    required this.status,
    required this.userId,
    required this.accountId,
    required this.compteType,
    required this.prevAccountAmount,
    required this.curAccountAmount,
    required this.prevCompteAmount,
    required this.curCompteAmount,
  });

  Future<void> getUser() async {
    try {
      UserRepository userRepository = UserRepository();
      User? user = await userRepository.findUserbyId(this.userId);
      this.user = user!;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> getAccount() async {
    try {
      AccountRepository accountRepository = AccountRepository();
      Account? account = await accountRepository.findAccountById(this.accountId);
      this.account = account!;
    } catch (e) {
      print(e);
      print('HEEEEEEEEEERE');
      rethrow;
    }
  }
}

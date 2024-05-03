import 'package:rime/data/models/Supply.dart';
import 'package:rime/data/models/Transaction.dart';
import 'package:rime/data/models/User.dart';
import 'package:rime/presentation/utils/activity_description.dart';

class Activity {
  int id;
  String description;
  User? user;
  DateTime createdAt;
  Transaction? transaction;
  Supply? supply;
  Activity({
    required this.id,
    required this.description,
    required this.createdAt,
    this.user,
    this.transaction,
    this.supply
  });

  String getDescriptionText() {
    switch (this.description) {
      case LOGIN:
        return 'Connection';
      case REGISTER:
        return "Ajout d'un gestionnaire";

      case SAVE_TRANSACTION:
        return "Ajout d'une transaction";

      case SYNC_ACCOUNT:
        return "Synchrinisation des comptes";

      default:
        return '';
    }
  }
}

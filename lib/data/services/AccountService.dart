
import 'package:rime/data/models/Account.dart';
import 'package:rime/data/repositories/AccountRepository.dart';


class AccountService {
  AccountRepository accountRepository = AccountRepository();

  Future<Account?> findFloozAccount() async {
    try {
      final moovAccount = await this.accountRepository.findAccountByType("Flooz");
      return moovAccount;
    } catch (e) {
      print(e);
    }
  }
    Future<Account?> findTmoneyAccount() async {
    try {
      final togocomAccount = await this.accountRepository.findAccountByType("Tmoney");
      return togocomAccount;
    } catch (e) {
      print(e);
    }
  }
  Future<bool?> makeDeposit(int accountId,int amount) async {
    try {
      final success = await this.accountRepository.increaseAmount(accountId,amount);
      return success;
    } catch (e) {
      print(e);
    }
  }

}

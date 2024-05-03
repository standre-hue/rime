// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/Account.dart';
import 'package:rime/data/models/Caisse.dart';
import 'package:rime/data/services/AccountService.dart';
import 'package:rime/data/services/ActivityService.dart';
import 'package:rime/data/services/CaisseService.dart';
import 'package:rime/data/services/TransactionService.dart';
import 'package:rime/presentation/providers/AccountProvider.dart';
import 'package:rime/presentation/providers/CaisseProvider.dart';
import 'package:rime/presentation/providers/ServerProvider.dart';
import 'package:rime/presentation/providers/UserProvider.dart';
import 'package:rime/presentation/utils/activity_description.dart';
import 'package:rime/presentation/utils/form_validators.dart';
import 'package:rime/presentation/utils/funcs.dart';

class SaveTransactionDialog extends StatefulWidget {
  const SaveTransactionDialog({super.key});

  @override
  State<SaveTransactionDialog> createState() => _SaveTransactionDialogState();
}

class _SaveTransactionDialogState extends State<SaveTransactionDialog> {
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final amountController = TextEditingController();
  final transactionService = TransactionService();
  final activityService = ActivityService();
  final accountService = AccountService();
  final caisseService = CaisseService();
  String value = "Flooz";
  String __value = "Dépot";
  bool isWorking = false;
  int state = 0;
  int ins = 0;

  void _saveTransaction() async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isWorking = true;
        });
        int userId = context.read<UserProvider>().user.id;

        late int accountId;
        if ("Flooz" == value) {
          accountId = context.read<AccountProvider>().moovAccount.id;
        } else if('Tmoney' == value) {
          accountId = context.read<AccountProvider>().togocomAccount.id;
        }
        int caisseId = context.read<CaisseProvider>().caisse.id;
        final amount = int.parse(amountController.text.toString());
        final phoneNumber = phoneNumberController.text.toString();
        final type = __value;

        if (__value == 'Retrait') {
          final canDecrease = await caisseService.caisseRepository
              .canDecrease(caisseId, amount);
          if (!canDecrease!) {
            int? am = await caisseService.caisseRepository.getAmount(caisseId:caisseId);
            setState(() {
              state = 2;
              ins = amount - am!;
              isWorking = false;
            });
            return;
          }
        } else {
          final canDecrease = await accountService.accountRepository
              .canDecrease(accountId, amount);
          if (!canDecrease!) {
            int? am =
                await accountService.accountRepository.getAmount(accountId);
            setState(() {
              state = 3;
              ins = amount - am!;
              isWorking = false;
            });
            return;
          }
        }
        final transactionId = await transactionService.createTransaction(
            amount: amount,
            phoneNumber: phoneNumber,
            userId: userId,
            accountId: accountId,
            type: type);

        Map<String,dynamic> transactionMap = {
          'transactionId': transactionId.toString(),
          'codeUSSD': '*145*',
        };
        context.read<ServerProvider>().senderSocket.write(transactionMap);
        //context.read<ServerProvider>().socket.add(transactionMap as List<int>);


      /*
        if (__value == 'Retrait') {
          final s = await accountService.accountRepository
              .increaseAmount(accountId, amount);
          //print(s);
          final s2 = await caisseService.caisseRepository
              .decreaseAmount(caisseId, amount);
        } else {
          final s = await accountService.accountRepository
              .decreaseAmount(accountId, amount);
          final s2 = await caisseService.caisseRepository
              .increaseAmount(caisseId, amount);
        }

        Account? moovAccount = await accountService.findFloozAccount();
        Account? togocomAccount = await accountService.findTmoneyAccount();
        Caisse? caisse =
            await caisseService.caisseRepository.findRecentCaisse();
        context.read<AccountProvider>().setAccounts(
              moovAccount: moovAccount!,
              togocomAccount: togocomAccount!,
            );
        context.read<CaisseProvider>().setCaisse(caisse!);

        final success = await activityService.createActivity(
            description: SAVE_TRANSACTION,
            transactionId: transactionId,
            userId: context.read<UserProvider>().user.id);


        */
        //context.read<ServerProvider>().add('transaction pending v1');

        //print('DDDDDDDDDDDDDDDDDDDDDDDD');
        setState(() {
          isWorking = false;
          state = 1;
          //msg = "Transaction réussi avec succès";
        });
        //print('FFFFFFFFFFFFFFFFFFFFFFFFF');

        /*return showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  width: 150,
                  height: 120,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Information",
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text("Transaction réussi"),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.check_box,
                              color: Colors.green,
                              size: 22,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {}, child: Text("Consulter")),
                            const SizedBox(width: 10),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  //Navigator.of(context).widget.
                                },
                                child: Text("OK")),
                          ],
                        )
                      ]),
                ),
              );
            });

        print('HHHHHHHHHHHHHHHHHHHHH');*/
      } catch (e) {
        setState(() {
          isWorking = false;
          state = 2;
          //msg = "Transaction echouée, Montant insuffisant il vous manque 4000";
        });
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: _size.width * .6,
        height: _size.height * .53,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 40.0, top: 40, bottom: 0),
                      child: Text("Ajouter une transaction",
                          style: TextStyle(fontSize: 22)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(bottom: 0, left: 50, right: 50),
                width: _size.width * .6,
                height: _size.height * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 250, child: const Text('Compte')),
                            DropdownButton(
                                value: value,
                                items: [
                                  DropdownMenuItem(
                                    value: 'Tmoney',
                                    child: Text('Tmoney'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Flooz',
                                    child: Text('Flooz'),
                                  ),
                                ],
                                onChanged: (_value) {
                                  setState(() {
                                    value = _value!;
                                  });
                                }),
                          ],
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 250,
                                child: const Text('Type Opération')),
                            DropdownButton(
                                value: __value,
                                items: [
                                  DropdownMenuItem(
                                    value: 'Dépot',
                                    child: Text('Dépot'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Retrait',
                                    child: Text('Retrait'),
                                  ),
                                ],
                                onChanged: (_value) {
                                  setState(() {
                                    __value = _value!;
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(children: [
                      SizedBox(
                          width: 250,
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Numero de téléphone"),
                              TextFormField(
                                controller: phoneNumberController,
                                validator: value == "Flooz"
                                    ? validateMoovPhoneNumber
                                    : validateTogocomPhoneNumber,
                              ),
                            ],
                          )),
                      const SizedBox(
                        width: 40,
                      ),
                      SizedBox(
                          width: 250,
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Montant"),
                              TextFormField(
                                validator: validateAmount,
                                controller: amountController,
                              ),
                            ],
                          )),
                    ]),
                    state == 1
                        ? Row(
                            children: [
                              Text("Transaction réussi"),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.check_box,
                                color: Colors.green,
                                size: 22,
                              )
                            ],
                          )
                        : state == 2
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                    size: 22,
                                  ),
                                  Text(
                                      "Transaction echoué! il vous manque  ${frenchFormat.format(ins)} "),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )
                            : state == 3
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                        size: 22,
                                      ),
                                      Text(
                                          "Transaction echoué! il vous manque ${frenchFormat.format(ins)} sur votre compte"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  )
                                : Row(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isWorking == true
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: isWorking == true
                                    ? null
                                    : () {
                                        _saveTransaction();
                                      },
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: Text(
                                      "Enregistrer",
                                      style: TextStyle(fontSize: 20),
                                    ))),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:rime/data/models/Transaction.dart';
import 'package:rime/data/services/TransactionService.dart';
import 'package:rime/presentation/utils/funcs.dart';

class TransactionInfoDialog extends StatefulWidget {
  int transactionId;
  TransactionInfoDialog({super.key, required this.transactionId});

  @override
  State<TransactionInfoDialog> createState() => _TransactionInfoDialogState();
}

class _TransactionInfoDialogState extends State<TransactionInfoDialog> {
  bool isWorking = true;
  Transaction? transaction;
  //int transactionId = widget.transactiond;
  TransactionService transactionService = TransactionService();

  void _loadDate() async {
    try {
      transaction = await transactionService.transactionRepository
          .findTransactionById(widget.transactionId);
      await transaction?.getAccount();
      await transaction?.getUser();

      setState(() {
        isWorking = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDate();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Dialog(
        child: Container(
            padding: EdgeInsets.all(10),
            height: _size.height * .81,
            width: _size.width * .7,
            child: Column(
              children: [
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40.0, top: 40, bottom: 0),
                        child: Row(
                          children: [
                            Icon(Icons.info, size: 30),
                            SizedBox(width: 20),
                            Text("Info transaction",
                                style: TextStyle(fontSize: 26)),
                          ],
                        ),
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
                isWorking == true
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        padding: const EdgeInsets.only(
                            bottom: 0, left: 20, right: 20),
                        width: _size.width * .6,
                        height: _size.height * .6,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Numéro",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${formatTogoPhoneNumber(transaction!.phoneNumber)}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                    Container(
                                      height: 100,
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Type Opération",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${transaction!.type}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                    Container(
                                      height: 100,
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Compte",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${transaction!.compteType}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //SizedBox(height:50),
                              SizedBox(
                                height: 100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Montant",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${frenchFormat.format(transaction!.amount)}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                    SizedBox(
                                      height: 100,
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Status",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${transaction!.status == 'Success' ? 'Réussi' : transaction!.status == 'Pending' ? 'En Cours' : 'Echoué'}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                    SizedBox(
                                      height: 100,
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Gestionnaire",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${transaction!.user.username}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${formatDate(transaction!.createdAt)}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                    Container(
                                      height: 100,
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Heure",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${formatTime(transaction!.createdAt)}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                    Container(
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${formatDate(transaction!.createdAt)}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Divider(
                                color: Colors.white,
                                thickness: 5,
                              ),

                              SizedBox(height: 20),
                              Text(
                                'Caisse',
                                style: TextStyle(fontSize: 22),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                height: 100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 250,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Montant Avant l'opération",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${frenchFormat.format(transaction!.prevCompteAmount)}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                    Container(
                                      height: 100,
                                      width: 250,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Montant Après l'opération",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${frenchFormat.format(transaction!.curCompteAmount)}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 5,
                              ),

                              SizedBox(height: 20),
                              Text(
                                'Compte ${transaction!.account.type}',
                                style: TextStyle(fontSize: 22),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                height: 100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 250,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Montant Avant l'opération",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${frenchFormat.format(transaction!.prevAccountAmount)}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                    Container(
                                      height: 100,
                                      width: 250,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Montant Après l'opération",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "${frenchFormat.format(transaction!.curAccountAmount)}",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Text(
                              "OK",
                              style: TextStyle(fontSize: 20),
                            ))),
                  ],
                )
              ],
            )));
  }
}

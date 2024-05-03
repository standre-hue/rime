// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:rime/data/models/Transaction.dart';
import 'package:rime/data/services/TransactionService.dart';
import 'package:rime/presentation/utils/funcs.dart';
import 'package:rime/presentation/widgets/TransactionInfoDialog.dart';

class TransactionReceiptDialog extends StatefulWidget {
  Transaction transaction;
  TransactionReceiptDialog({super.key, required this.transaction});

  @override
  State<TransactionReceiptDialog> createState() =>
      _TransactionReceiptDialogState();
}

class _TransactionReceiptDialogState extends State<TransactionReceiptDialog> {
  bool isWorking = true;
  Transaction? transaction;
  //int transactionId = widget.transactiond;
  TransactionService transactionService = TransactionService();

  void _loadDate() async {
    try {
      /*transaction = await transactionService.transactionRepository
          .findTransactionById(widget.transactionId);
      await transaction?.getAccount();
      await transaction?.getUser();*/

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
            height: _size.height * .22,
            width: _size.width * .45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info,
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Information',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  children: [
                    Text(' Vous venez de recevoir un depot ',
                        style: TextStyle(fontSize: 18)),
                    Text('${widget.transaction.compteType}',style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(' de ', style: TextStyle(fontSize: 18)),
                    Text(
                      "${frenchFormat.format(widget.transaction.amount)}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(' du numéro ', style: TextStyle(fontSize: 18)),
                    Text(
                        '${formatTogoPhoneNumber(widget.transaction.phoneNumber)}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(' le ', style: TextStyle(fontSize: 18)),
                    Text(formatDate(widget.transaction.createdAt),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(' a ', style: TextStyle(fontSize: 18)),
                    Text(formatTime(widget.transaction.createdAt),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TransactionInfoDialog(
                                  transactionId: widget.transaction.id,
                                );
                              });
                        },
                        child: Text('Consulter',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                    SizedBox(width: 20),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                  ],
                )
              ],
            )));
  }
}

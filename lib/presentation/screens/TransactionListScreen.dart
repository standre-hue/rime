// ignore_for_file: prefer_const_constructors, await_only_futures, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/Transaction.dart';
import 'package:rime/data/services/TransactionService.dart';
import 'package:rime/presentation/providers/TransactionProvider.dart';
import 'package:rime/presentation/utils/funcs.dart';
import 'package:rime/presentation/widgets/CustomAppBar.dart';
import 'package:rime/presentation/widgets/CustomDrawer.dart';
import 'package:rime/presentation/widgets/TransactionInfoDialog.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  bool isWorking = false;
  String opType = 'Dépot';
  String compteType = 'Flooz';
  String status = 'Success';
  final transactionService = TransactionService();
  List<Transaction> transactions = [];
  List<Transaction> filteredTransactions = [];
  final phoneNumberController = TextEditingController();
  String endDate = '';
  String startDate = '';

  DateTime? endDateO;
  DateTime? startDateO;

  final amountController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  void searchByPhoneNumber() async {
    try {
      setState(() {
        isWorking = true;
      });
      String phoneNumber = phoneNumberController.text.toString();
      transactions = await transactionService.transactionRepository
          .getTransactionyByPhoneNumber(phoneNumber);
      context.read<TransactionProvider>().setTransactions(transactions);
      print(transactions.length);
      setState(() {
        isWorking = false;
      });
    } catch (e) {
      setState(() {
        isWorking = false;
      });
      print(e);
    }
  }

  void searchByAmount() async {
    try {
      setState(() {
        isWorking = true;
      });
      int amount = int.parse(amountController.text.toString());
      transactions = await transactionService.transactionRepository
          .getTransactionyByAmount(amount);
      context.read<TransactionProvider>().setTransactions(transactions);
      print(transactions.length);
      setState(() {
        isWorking = false;
      });
    } catch (e) {
      setState(() {
        isWorking = false;
      });
      print(e);
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      print('Selected date: $picked');
    }
    return picked;
  }

  void searchByDateRange(DateTime? startDateO, DateTime? endDateO) async {
    try {
      setState(() {
        isWorking = true;
      });
      transactions =
          await transactionService.searchByDateRange(startDateO, endDateO);
      context.read<TransactionProvider>().setTransactions(transactions);
      print(transactions.length);
      setState(() {
        isWorking = false;
      });
    } catch (e) {
      setState(() {
        isWorking = false;
      });
      print(e);
    }
  }

  void searchByOperationType() async {
    try {
      setState(() {
        isWorking = true;
      });

      transactions = await transactionService.transactionRepository
          .getTransactionyByOperationType(opType);
      context.read<TransactionProvider>().setTransactions(transactions);
      print(transactions.length);
      setState(() {
        isWorking = false;
      });
    } catch (e) {
      setState(() {
        isWorking = false;
      });
      print(e);
    }
  }

  void searchByCompteType() async {
    try {
      setState(() {
        isWorking = true;
      });

      transactions = await transactionService.transactionRepository
          .getTransactionyByTypeCompte(compteType);
      context.read<TransactionProvider>().setTransactions(transactions);
      print(transactions.length);
      setState(() {
        isWorking = false;
      });
    } catch (e) {
      setState(() {
        isWorking = false;
      });
      print(e);
    }
  }

  void searchByStatus() async {
    try {
      setState(() {
        isWorking = true;
      });

      transactions = await transactionService.transactionRepository
          .getTransactionyByStatus(status);
      context.read<TransactionProvider>().setTransactions(transactions);
      print(transactions.length);
      setState(() {
        isWorking = false;
      });
    } catch (e) {
      setState(() {
        isWorking = false;
      });
      print(e);
    }
  }

  void loadData() async {
    try {
      transactions = await transactionService.getTodayTransaction();
      context.read<TransactionProvider>().setTransactions(transactions);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: 'List des transactions',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 50,
                          child: TextField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                                hintText: 'Numéro',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      phoneNumberController.text = "";
                                    },
                                    icon: Icon(Icons.clear))),
                            style: TextStyle(),
                          )),
                      IconButton(
                          onPressed: () {
                            searchByPhoneNumber();
                          },
                          icon: Icon(Icons.search))
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 50,
                          child: TextField(
                            controller: amountController,
                            decoration: InputDecoration(hintText: 'Montant'),
                            style: TextStyle(),
                          )),
                      IconButton(
                          onPressed: () {
                            searchByAmount();
                          },
                          icon: Icon(Icons.search))
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 50,
                          child: DropdownButton(
                            value: opType,
                            items: [
                              DropdownMenuItem(
                                  value: 'Dépot', child: Text('Dépot')),
                              DropdownMenuItem(
                                  value: 'Retrait', child: Text('Retrait'))
                            ],
                            onChanged: (value) {
                              setState(() {
                                opType = value!;
                              });
                            },
                          )),
                      IconButton(
                          onPressed: () {
                            searchByOperationType();
                          },
                          icon: Icon(Icons.search))
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 50,
                          child: DropdownButton(
                            value: compteType,
                            items: [
                              DropdownMenuItem(
                                  value: 'Flooz', child: Text('Flooz')),
                              DropdownMenuItem(
                                  value: 'Tmoney', child: Text('Tmoney'))
                            ],
                            onChanged: (value) {
                              setState(() {
                                compteType = value!;
                              });
                            },
                          )),
                      IconButton(
                          onPressed: () {
                            searchByCompteType();
                          },
                          icon: Icon(Icons.search))
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 50,
                          child: DropdownButton(
                            value: status,
                            items: [
                              DropdownMenuItem(
                                  value: 'Pending', child: Text('En Cours')),
                              DropdownMenuItem(
                                  value: 'Success', child: Text('Réussi')),
                              DropdownMenuItem(
                                  value: 'Failed', child: Text('Echoué'))
                            ],
                            onChanged: (value) {
                              setState(() {
                                status = value!;
                              });
                            },
                          )),
                      IconButton(
                          onPressed: () {
                            searchByStatus();
                          },
                          icon: Icon(Icons.search))
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 50,
                          child: TextField(
                            onTap: () async {
                              final date = await _selectDate(context);
                              print(date);
                              if (date != null) {
                                setState(() {
                                  startDateO = date;
                                  startDate =
                                      "${date.day}/${date.month}/${date.year}";
                                  startDateController.text = formatDate(date);
                                });
                              }
                            },
                            decoration: InputDecoration(hintText: 'Date Début'),
                            controller: startDateController,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 50,
                          child: TextField(
                            onTap: () async {
                              final date = await _selectDate(context);
                              print(date);
                              if (date != null) {
                                setState(() {
                                  endDateO = date;
                                  endDate =
                                      "${date.day}/${date.month}/${date.year}";
                                  endDateController.text = formatDate(date);
                                });
                              }
                            },
                            decoration: InputDecoration(hintText: 'Date Fin'),
                            controller: endDateController,
                          )),
                      IconButton(
                          onPressed: () {
                            searchByDateRange(startDateO, endDateO);
                          },
                          icon: Icon(Icons.search))
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * .6,
              child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  columns: [
                    DataColumn2(
                      label: Text('ID'),
                      size: ColumnSize.L,
                    ),
                    DataColumn(
                      label: Text('Numéro'),
                    ),
                    DataColumn(
                      label: Text('Type Opération'),
                    ),
                    DataColumn(
                      label: Text('Type Compte'),
                    ),
                    DataColumn(
                      label: Text('Montant'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Status'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Date'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Heure'),
                      numeric: true,
                    ),
                  ],
                  rows: context
                      .watch<TransactionProvider>()
                      .transactions
                      .map((transaction) => DataRow(
                              // mouseCursor: MouseCursor.ha,
                              onSelectChanged: (value) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return TransactionInfoDialog(
                                        transactionId: transaction.id,
                                      );
                                    });
                              },
                              cells: [
                                DataCell(Text('${frenchFormat.format(transaction.id)}')),
                                DataCell(Text(
                                    '${formatTogoPhoneNumber(transaction.phoneNumber)}')),
                                DataCell(Text('${transaction.type}')),
                                DataCell(Text('${transaction.compteType}')),
                                DataCell(Text('${frenchFormat.format(transaction.amount)}')),
                                transaction.status == 'Success'
                                    ? DataCell(Text('Réussis'))
                                    : transaction.status == 'Failed'
                                        ? DataCell(Text('Echoué'))
                                        : DataCell(Text('En Cours')),
                                DataCell(Text(
                                    '${formatDate(transaction.createdAt)}')),
                                DataCell(Text(
                                    '${formatTime(transaction.createdAt)}')),
                              ]))
                      .toList()),
            ),
            Row(
              children: [Text('Tmoney')],
            )
          ],
        ),
      ),
    );
  }
}

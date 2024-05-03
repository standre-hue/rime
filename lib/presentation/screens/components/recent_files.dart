import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/RecentFile.dart';
import 'package:rime/data/models/Transaction.dart';
import 'package:rime/presentation/providers/TransactionProvider.dart';
import 'package:rime/presentation/utils/constants.dart';
import 'package:rime/presentation/utils/funcs.dart';
import 'package:rime/presentation/widgets/TransactionInfoDialog.dart';

class RecentTransaction extends StatelessWidget {
  const RecentTransaction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recentes Transactions",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("Numéro"),
                ),
                DataColumn(
                  label: Text("Type Opération"),
                ),
                DataColumn(
                  label: Text("Type Compte"),
                ),
                DataColumn(
                  label: Text("Montant"),
                ),
                DataColumn(
                  label: Text("Date"),
                ),
              ],
              rows: List.generate(
                context.watch<TransactionProvider>().recentTransactions.length,
                (index) => recentTransactionDataRow(context
                    .watch<TransactionProvider>()
                    .recentTransactions[index], context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentTransactionDataRow(Transaction transaction, BuildContext context) {
  return DataRow(
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
      DataCell(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text("${formatTogoPhoneNumber(transaction.phoneNumber)}"),
            ),
          ],
        ),
      ),
      DataCell(Text("${transaction.type}")),
      DataCell(Text("${transaction.compteType}")),
      DataCell(Text("${frenchFormat.format(transaction.amount)}")),
      DataCell(Text("${formatDate(transaction.createdAt)}")),
    ],
  );
}

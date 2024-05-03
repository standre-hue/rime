import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/Supply.dart';
import 'package:rime/presentation/providers/CaisseProvider.dart';
import 'package:rime/presentation/utils/constants.dart';
import 'package:rime/presentation/utils/funcs.dart';
import 'package:rime/presentation/widgets/CustomAppBar.dart';
import 'package:rime/presentation/widgets/CustomDrawer.dart';
import 'package:rime/presentation/widgets/SaveSupplyDialog.dart';

class CaisseScreen extends StatefulWidget {
  const CaisseScreen({Key? key}) : super(key: key);

  @override
  _CaisseScreenState createState() => _CaisseScreenState();
}

class _CaisseScreenState extends State<CaisseScreen> {

  List<Supply> supplies = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: CustomDrawer(),
        appBar: CustomAppBar(
          title: "Caisse",
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Montant: ',
                    style: TextStyle(fontSize: 22),
                  ),
                  Text(
                    frenchFormat
                        .format(context.watch<CaisseProvider>().caisse.amount),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SaveSupplyDialog();
                            });
                      },
                      child: Text(
                        'Approvisionner',
                        style: TextStyle(fontSize: 22),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Liste des approvisionnements',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),
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
                        label: Text("Montant"),
                      ),
                      DataColumn(
                        label: Text("Gestionnaire"),
                      ),
                      DataColumn(
                        label: Text('Date'),
                      ),
                    ],
                    rows: supplies
                        .map((supply) => DataRow(
                                // mouseCursor: MouseCursor.ha,
                                onSelectChanged: (value) {
                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SupplyInfoScreen(supplyId: supply.id)));*/
                                  /*showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UserInfoDialog(
                                        userId: user.id,
                                      );
                                    });*/
                                },
                                cells: [
                                  DataCell(Text('${supply.id}')),
                                  DataCell(Text('${frenchFormat.format(supply.amount)}')),
                                  DataCell(Text('${formatDate(supply.createdAt)}')),
                                  DataCell(Text('${formatTime(supply.createdAt)}')),
                                ]))
                        .toList()),
              ),
            ],
          ),
        )));
  }
}

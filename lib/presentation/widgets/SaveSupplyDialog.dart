// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/Account.dart';
import 'package:rime/data/models/Caisse.dart';
import 'package:rime/data/repositories/SupplyRepository.dart';
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

class SaveSupplyDialog extends StatefulWidget {
  const SaveSupplyDialog({super.key});

  @override
  State<SaveSupplyDialog> createState() => _SaveTransactionDialogState();
}

class _SaveTransactionDialogState extends State<SaveSupplyDialog> {
  final formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();

  final activityService = ActivityService();
  final supplyRepository = SupplyRepository();
  final caisseService = CaisseService();

  bool isWorking = false;

  void _saveSupply() async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isWorking = true;
        });
        int userId = context.read<UserProvider>().user.id;
        int caisseId = context.read<CaisseProvider>().caisse.id;
        int prevAmount = context.read<CaisseProvider>().caisse.amount;
        int amount = int.parse(amountController.text);

        final supplyId = await supplyRepository.saveSupply(
            amount: amount,
            userId: userId,
            caisseId: caisseId,
            prevAmount: prevAmount);

        final caisse =
            await caisseService.caisseRepository.findCaisseById(caisseId);
        context.read<CaisseProvider>().setCaisse(caisse!);

        final success = await activityService.createActivity(
            description: SAVE_SUPPLY,
            supplyId: supplyId,
            userId: context.read<UserProvider>().user.id);

        setState(() {
          isWorking = false;
        });
        //print('FFFFFFFFFFFFFFFFFFFFFFFFF');
        Navigator.of(context).pop();
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
                            Text("Approvisionnement réussi"),
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
            });*/
      } catch (e) {
        setState(() {
          isWorking = false;
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
        height: _size.height * .4,
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
                      child: Text("Approvisionner la caisse",
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
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(bottom: 0, left: 50, right: 50),
                width: _size.width * .6,
                height: _size.height * .3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [],
                    ),
                    const SizedBox(height: 40),
                    Row(children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isWorking == true
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: isWorking == true
                                    ? null
                                    : () {
                                        _saveSupply();
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

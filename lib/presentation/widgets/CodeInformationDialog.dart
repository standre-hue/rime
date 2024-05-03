// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/Account.dart';
import 'package:rime/data/models/Caisse.dart';
import 'package:rime/data/models/Code.dart';
import 'package:rime/data/repositories/SupplyRepository.dart';
import 'package:rime/data/services/AccountService.dart';
import 'package:rime/data/services/ActivityService.dart';
import 'package:rime/data/services/AuthService.dart';
import 'package:rime/data/services/CaisseService.dart';
import 'package:rime/data/services/TransactionService.dart';
import 'package:rime/presentation/providers/AccountProvider.dart';
import 'package:rime/presentation/providers/CaisseProvider.dart';
import 'package:rime/presentation/providers/ServerProvider.dart';
import 'package:rime/presentation/providers/UserProvider.dart';
import 'package:rime/presentation/utils/activity_description.dart';
import 'package:rime/presentation/utils/form_validators.dart';
import 'package:rime/presentation/utils/funcs.dart';

class CodeInformationDialog extends StatefulWidget {
  Code code;
  CodeInformationDialog({super.key, required this.code});

  @override
  State<CodeInformationDialog> createState() => _CodeInformationDialogState();
}

class _CodeInformationDialogState extends State<CodeInformationDialog> {
  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final authService = AuthService();
  bool isWorking = false;
  bool error = false;

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
                      child: Text("${getCodeStr(widget.code.type)}",
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
                              Text(
                                "${widget.code.code}",
                                style: TextStyle(fontSize: 22),
                              ),
                            ],
                          )),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Text(
                                  "Modifier",
                                  style: TextStyle(fontSize: 20),
                                ))),
                        SizedBox(width: 20,),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Text(
                                  "OK",
                                  style: TextStyle(fontSize: 20),
                                ))),
                      ],
                    ),
                    if (error)
                      Text(
                        'Mot de pass incorrect',
                        style: TextStyle(color: Colors.red),
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

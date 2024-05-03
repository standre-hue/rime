import 'package:flutter/material.dart';
import 'package:rime/data/models/Code.dart';
import 'package:rime/presentation/widgets/CodeInformationDialog.dart';
import 'package:rime/presentation/widgets/CustomAppBar.dart';
import 'package:rime/presentation/widgets/CustomDrawer.dart';
import 'package:rime/presentation/widgets/PasswordConfirmationDialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool showTmoneyDepotCode = true;
  bool isTmoneyDepotFieldEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Paramètre',
        ),
        drawer: CustomDrawer(),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Text(
                'Tmoney',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 210,
                        height: 50,
                        child: TextFormField(
                          enabled: isTmoneyDepotFieldEnabled,
                          obscureText: showTmoneyDepotCode,
                          initialValue: '*145*2*@@@@*2000*',
                        )),
                    IconButton(
                        onPressed: () async {
                          final response = await showDialog(
                              context: context,
                              builder: (context) {
                                return PasswordConfirmationDialog();
                              });
                          if (response == true) {
                            Code code = Code(type: 'TMONEY_DEPOT',code:'*145*2*@@@@*2323*');
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CodeInformationDialog(code: code,);
                                });
                          }
                        },
                        icon: Icon(Icons.remove_red_eye)),
                    IconButton(
                        onPressed: () {
                          final response = showDialog(
                              context: context,
                              builder: (context) {
                                return PasswordConfirmationDialog();
                              });
                          if (response == true) {
                            print('yes');
                          }
                        },
                        icon: Icon(Icons.edit)),
                  ],
                ),
              )
            ])));
  }
}

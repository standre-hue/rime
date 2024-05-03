// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/Account.dart';
import 'package:rime/data/models/Caisse.dart';
import 'package:rime/data/models/User.dart';
import 'package:rime/data/services/AccountService.dart';
import 'package:rime/data/services/AuthService.dart';
import 'package:rime/data/services/CaisseService.dart';
import 'package:rime/presentation/providers/AccountProvider.dart';
import 'package:rime/presentation/providers/CaisseProvider.dart';
import 'package:rime/presentation/providers/UserProvider.dart';
import 'package:rime/presentation/screens/dashboard_screen.dart';
import 'package:rime/presentation/screens/ipScreen.dart';
import 'package:rime/presentation/utils/errors.dart';
import 'package:rime/presentation/utils/form_validators.dart';
import 'package:rime/presentation/utils/styles.dart';
import 'package:rime/presentation/widgets/CustomTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isWorking = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  final accountService = AccountService();
  final caisseService = CaisseService();
  final formKey = GlobalKey<FormState>();

  void _login() async {
    try {
      if (formKey.currentState!.validate()) {
        setState(() {
          isWorking = true;
        });
        final username = usernameController.text.toString();
        final password = passwordController.text.toString();
        User? user = await authService.login(username, password);

        Account? moovAccount = await accountService.findFloozAccount();
        Account? togocomAccount = await accountService.findTmoneyAccount();
        Caisse? caisse = await caisseService.caisseRepository.findRecentCaisse();
        context.read<UserProvider>().setUser(user!);
        context.read<AccountProvider>().setAccounts(
              moovAccount: moovAccount!,
              togocomAccount: togocomAccount!,
            );
        context.read<CaisseProvider>().setCaisse(caisse!);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => IpScreen()));

        //Navigator.of(context)
        //.push(MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    } catch (e) {
      print(e);
      setState(() {
        isWorking = false;
      });
      if (e is UserDoesNotExistException) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Information"),
                content: Text(
                  "Aucun n'utilisateur ne correspond a ce nom; veuillez ressayer.",
                  style: simpleTextStyle,
                ),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
      if (e is IncorrectPasswordException) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Information"),
                content: Text(
                  "Mot de pass incorrect, veuillez ressayer.",
                  style: simpleTextStyle,
                ),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size.width);
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(221, 21, 20, 20),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * .3,
                height: MediaQuery.of(context).size.height * .7,
                child: Form(
                  key: formKey,
                  child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock,
                          size: 80,
                          color: Colors.black,
                        ),
                        const Text(
                          'Connection',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          validator: validateUsername,
                          title: "Nom d'utilisateur",
                          controller: usernameController,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          validator: validatePassword,
                          title: "Mot de pass",
                          controller: passwordController,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: isWorking == true
                                ? null
                                : () {
                                    _login();
                                  },
                            child: SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: Center(
                                    child: isWorking == true
                                        ? CircularProgressIndicator()
                                        : const Text(
                                            "Suivant",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )))),
                        SizedBox(height: 20),
                      ]),
                ),
              ),
            )));
  }
}

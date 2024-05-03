// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/services/AuthService.dart';
import 'package:rime/presentation/providers/UserProvider.dart';
import 'package:rime/presentation/screens/dashboard_screen.dart';
import 'package:rime/presentation/utils/errors.dart';
import 'package:rime/presentation/utils/form_validators.dart';
import 'package:rime/presentation/utils/styles.dart';
import 'package:rime/presentation/widgets/CustomTextField.dart';
import 'package:rime/presentation/widgets/PasswordConfirmationTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/User.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isWorking = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final authService = AuthService();
  final formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  void _register() async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isWorking = true;
        });
        final username = usernameController.text.toString();
        final password = passwordController.text.toString();
        User? user = await authService.register(username, password);
        context.read<UserProvider>().setUser(user!);

        /// initial check up
        ///
        ///
        prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isFirstTime", false);

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DashboardScreen()));
      } catch (e) {
        print(e);
        setState(() {
          isWorking = false;
        });
        if (e is UserAlreadyExistsException) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Information"),
                  content: Text(
                    "Vous ne pouvez pas utiliser ce nom d'utilisateur.",
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

    /*Future.delayed(Duration(seconds: 5)).then((value) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DashboardScreen()));
      setState(() {
        isWorking = false;
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                height: MediaQuery.of(context).size.height * .8,
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
                          'Bienvenue',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Text(
                            "Pour votre première connection, vous devez creer un compte"),
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
                        PasswordConfirmationTextField(
                          title: "Confirmer le Mot de pass",
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
                                    _register();
                                  },
                            child: SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: Center(
                                    child: isWorking == true
                                        ? CircularProgressIndicator()
                                        : Text(
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

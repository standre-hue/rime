// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/Account.dart';
import 'package:rime/data/models/Caisse.dart';
import 'package:rime/data/services/AccountService.dart';
import 'package:rime/data/services/ActivityService.dart';
import 'package:rime/data/services/CaisseService.dart';
import 'package:rime/data/services/TransactionService.dart';
import 'package:rime/presentation/providers/AccountProvider.dart';
import 'package:rime/presentation/providers/CaisseProvider.dart';
import 'package:rime/presentation/providers/ServerProvider.dart';
import 'package:rime/presentation/providers/UserProvider.dart';
import 'package:rime/presentation/screens/dashboard_screen.dart';
import 'package:rime/presentation/utils/activity_description.dart';

import 'package:rime/presentation/utils/styles.dart';
import 'package:rime/presentation/widgets/TransactionReceiptDialog.dart';

import 'package:shared_preferences/shared_preferences.dart';

class IpScreen extends StatefulWidget {
  const IpScreen({Key? key}) : super(key: key);

  @override
  _IpScreenState createState() => _IpScreenState();
}

class _IpScreenState extends State<IpScreen> {
  bool isWorking = false;
  String ipAddress = '';
  late SharedPreferences prefs;
  final firstController = TextEditingController();
  final secondController = TextEditingController();
  final thirdController = TextEditingController();
  final fourthController = TextEditingController();
  final transactionService = TransactionService();
  final accountService = AccountService();
  final caisseService = CaisseService();
  final activityService = ActivityService();

  final formKey = GlobalKey<FormState>();

  Future<void> tryToConnectWithPreviousIpAddress() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String? ipAddress = await prefs.getString('ipAddress');
      if (ipAddress == null) return;
      Socket senderSocket = await Socket.connect('$ipAddress', 3000);
      Socket listenerSocket = await Socket.connect('$ipAddress', 3000);
      context.read<ServerProvider>().setSocket(
          senderSocket: senderSocket, listenerSocket: listenerSocket);
      context.read<ServerProvider>().isConnected = true;
      context.read<ServerProvider>().notifyListeners();
      //prefs = await SharedPreferences.getInstance();
      //await prefs.setString('ipAddress', ipAddress);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DashboardScreen()));

      //socket.sink.
      context.read<ServerProvider>().listenerSocket.listen(
            (message) async {
              //print('Received message: $message');
              final dd = Utf8Decoder().convert(message);
              final js = json.decode(dd);
              print(js['type_operation']);
              switch (js['type_operation']) {
                case 'TRANSACTION':
                  {
                    try {
                      late int accountId;
                      int userId = context.read<UserProvider>().user.id;
                      int caisseId = context.read<CaisseProvider>().caisse.id;

                      if (js['operateur'] == 'Tmoney' &&
                          js['operation'] == 'Retrait') {
                        accountId =
                            context.read<AccountProvider>().togocomAccount.id;
                      } else if (js['operateur'] == 'Flooz' &&
                          js['operation'] == 'Retrait') {
                        accountId =
                            context.read<AccountProvider>().moovAccount.id;
                      }

                      int amount = int.parse(js['amount']);
                      String phoneNumber = js['phoneNumber'];
                      //print('HHHHHHHHHHHHHHHERE');

                      final transactionId =
                          await transactionService.createTransaction(
                              amount: amount,
                              phoneNumber: phoneNumber,
                              userId: userId!,
                              accountId: accountId,
                              status: 'Success',
                              type: 'Retrait');

                      final transaction = await transactionService
                          .transactionRepository
                          .findTransactionById(transactionId);
                      final s = await accountService.accountRepository
                          .increaseAmount(accountId, amount);
                      //print(s);
                      final s2 = await caisseService.caisseRepository
                          .decreaseAmount(caisseId, amount);

                      Account? moovAccount =
                          await accountService.findFloozAccount();
                      Account? togocomAccount =
                          await accountService.findTmoneyAccount();
                      Caisse? caisse = await caisseService.caisseRepository
                          .findRecentCaisse();
                      context.read<AccountProvider>().setAccounts(
                            moovAccount: moovAccount!,
                            togocomAccount: togocomAccount!,
                          );
                      context.read<CaisseProvider>().setCaisse(caisse!);

                      final success = await activityService.createActivity(
                          description: SAVE_TRANSACTION,
                          transactionId: transactionId,
                          userId: context.read<UserProvider>().user.id);

                      showDialog(
                          context: context,
                          builder: (context) {
                            return TransactionReceiptDialog(
                                transaction: transaction!);
                          });
                    } catch (e) {
                      print(e);
                    }
                    break;
                  }
                case 'COMPLETE_TRANSACTION':
                  {
                    final transaction = await  transactionService.transactionRepository
                        .findTransactionById(208);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return TransactionReceiptDialog(
                              transaction: transaction!);
                        });
                    print(js);
                    break;
                  }
                default:
                  break;
              }
            },
            cancelOnError: true,
            onDone: () {
              context.read<ServerProvider>().isConnected = false;
              context.read<ServerProvider>().notifyListeners();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Information"),
                      content: Text(
                        "Vous n'ete plus connecté au téléphone portable veuillez ressayer de le reconnecter.",
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
              print('TCPSocket closed');
            },
            onError: (error) {
              setState(() {
                isWorking = false;
              });
              print('Error: $error');
              if (error is SocketException)
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Information"),
                        content: Text(
                          "Impossible de se connecter a l'addresse: $ipAddress; veuillez ressayer.",
                          style: simpleTextStyle,
                        ),
                        actions: [
                          ElevatedButton(
                            child: Text("OK"),
                            onPressed: () {
                              setState(() {
                                isWorking = false;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
            },
          );
    } catch (e) {
      print(e);
    }
  }

  void _connect() async {
    try {
      if (formKey.currentState!.validate()) {
        setState(() {
          isWorking = true;
        });
        final first = firstController.text.toString();
        final second = secondController.text.toString();
        final third = thirdController.text.toString();
        final fourth = fourthController.text.toString();
        ipAddress = "$first.$second.$third.$fourth";
        Socket senderSocket = await Socket.connect('$ipAddress', 3000);
        Socket listenerSocket = await Socket.connect('$ipAddress', 3000);
        context.read<ServerProvider>().isConnected = true;
        context.read<ServerProvider>().setSocket(
            senderSocket: senderSocket, listenerSocket: listenerSocket);
        prefs = await SharedPreferences.getInstance();
        await prefs.setString('ipAddress', ipAddress);
        int userId = context.read<UserProvider>().user.id;

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DashboardScreen()));

        //socket.sink.
        context.read<ServerProvider>().listenerSocket.listen(
              (message) async {
                //print('Received message: $message');
                final dd = Utf8Decoder().convert(message);
                final js = json.decode(dd);
                print(js['type_operation']);
                switch (js['type_operation']) {
                  case 'TRANSACTION':
                    {
                      try {
                        late int accountId;
                        int caisseId = context.read<CaisseProvider>().caisse.id;

                        if (js['operateur'] == 'Tmoney' &&
                            js['operation'] == 'Retrait') {
                          accountId =
                              context.read<AccountProvider>().togocomAccount.id;
                        } else if (js['operateur'] == 'Flooz' &&
                            js['operation'] == 'Retrait') {
                          accountId =
                              context.read<AccountProvider>().moovAccount.id;
                        }

                        int amount = int.parse(js['amount']);
                        String phoneNumber = js['phoneNumber'];
                        //print('HHHHHHHHHHHHHHHERE');

                        final transactionId =
                            await transactionService.createTransaction(
                                amount: amount,
                                phoneNumber: phoneNumber,
                                userId: userId!,
                                accountId: accountId,
                                status: 'Success',
                                type: 'Retrait');

                        final transaction = await transactionService
                            .transactionRepository
                            .findTransactionById(transactionId);
                        final s = await accountService.accountRepository
                            .increaseAmount(accountId, amount);
                        //print(s);
                        final s2 = await caisseService.caisseRepository
                            .decreaseAmount(caisseId, amount,
                                canBeNegative: true);

                        Account? moovAccount =
                            await accountService.findFloozAccount();
                        Account? togocomAccount =
                            await accountService.findTmoneyAccount();
                        Caisse? caisse = await caisseService.caisseRepository
                            .findRecentCaisse();
                        context.read<AccountProvider>().setAccounts(
                              moovAccount: moovAccount!,
                              togocomAccount: togocomAccount!,
                            );
                        context.read<CaisseProvider>().setCaisse(caisse!);

                        final success = await activityService.createActivity(
                            description: SAVE_TRANSACTION,
                            transactionId: transactionId,
                            userId: context.read<UserProvider>().user.id);

                        showDialog(
                            context: context,
                            builder: (context) {
                              return TransactionReceiptDialog(
                                  transaction: transaction!);
                            });
                      } catch (e) {
                        print(e);
                      }
                      break;
                    }
                  default:
                    break;
                }
              },
              cancelOnError: true,
              onDone: () {
                context.read<ServerProvider>().isConnected = false;
                context.read<ServerProvider>().notifyListeners();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Information"),
                        content: Text(
                          "Vous n'ete plus connecté au téléphone portable veuillez ressayer de le reconnecter.",
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
                print('TCPSocket closed');
              },
              onError: (error) {
                setState(() {
                  isWorking = false;
                });
                print('Error: $error');
                if (error is SocketException)
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Information"),
                          content: Text(
                            "Impossible de se connecter a l'addresse: $ipAddress; veuillez ressayer.",
                            style: simpleTextStyle,
                          ),
                          actions: [
                            ElevatedButton(
                              child: Text("OK"),
                              onPressed: () {
                                setState(() {
                                  isWorking = false;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
              },
            );

        context
            .watch<ServerProvider>()
            .senderSocket
            .write('Hello from client!');
        //return;
      }
    } catch (e) {
      print(e);
      setState(() {
        isWorking = false;
      });
      if (e is SocketException) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Information"),
                content: Text(
                  "Impossible de se connecter a l'addresse: $ipAddress; veuillez ressayer.",
                  style: simpleTextStyle,
                ),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      setState(() {
                        isWorking = false;
                      });
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
  void initState() {
    super.initState();
    tryToConnectWithPreviousIpAddress();
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
                          Icons.network_check,
                          size: 80,
                          color: Colors.black,
                        ),
                        const Text(
                          'Addresse Ip',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: 70,
                                  child: TextFormField(
                                    maxLength: 3,
                                    controller: firstController,
                                    textAlign: TextAlign.center,
                                  )),
                              SizedBox(
                                  width: 70,
                                  child: TextFormField(
                                    maxLength: 3,
                                    controller: secondController,
                                    textAlign: TextAlign.center,
                                  )),
                              SizedBox(
                                  width: 70,
                                  child: TextFormField(
                                    maxLength: 3,
                                    controller: thirdController,
                                    textAlign: TextAlign.center,
                                  )),
                              SizedBox(
                                  width: 70,
                                  child: TextFormField(
                                    maxLength: 3,
                                    controller: fourthController,
                                    textAlign: TextAlign.center,
                                  )),
                            ]),
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
                                    _connect();
                                  },
                            child: SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: Center(
                                    child: isWorking == true
                                        ? CircularProgressIndicator()
                                        : const Text(
                                            "Se Connecter",
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

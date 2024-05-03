// ignore_for_file: prefer_const_constructors, await_only_futures, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/Transaction.dart';
import 'package:rime/data/models/User.dart';
import 'package:rime/data/services/TransactionService.dart';
import 'package:rime/data/services/UserService.dart';
import 'package:rime/presentation/providers/TransactionProvider.dart';
import 'package:rime/presentation/providers/UserProvider.dart';
import 'package:rime/presentation/screens/UserInfoScreen.dart';
import 'package:rime/presentation/utils/funcs.dart';
import 'package:rime/presentation/widgets/CustomAppBar.dart';
import 'package:rime/presentation/widgets/CustomDrawer.dart';
import 'package:rime/presentation/widgets/TransactionInfoDialog.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool isWorking = false;
  String opType = 'Dépot';
  String compteType = 'Flooz';
  String status = 'Success';
  final userService = UserService();
  List<User> users = [];
  List<User> filteredUsers = [];
  final usernameController = TextEditingController();
  //String endDate = '';
  //String startDate = '';

  //DateTime? endDateO;
  //DateTime? startDateO;

  //final amountController = TextEditingController();
  //final startDateController = TextEditingController();
  //final endDateController = TextEditingController();

  void searchByUsername() async {
    try {
      setState(() {
        isWorking = true;
      });
      String username = usernameController.text.toString();
      users = await userService.userRepository.getUserByUsername(username);
      context.read<UserProvider>().setUsers(users);
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
      users = await userService.userRepository.getAllUser();
      context.read<UserProvider>().setUsers(users);
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
        title: 'List des gestionnaires',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 50,
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                                hintText: "Nom d'utilisateur",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      usernameController.text = "";
                                    },
                                    icon: Icon(Icons.clear))),
                            style: TextStyle(),
                          )),
                      IconButton(
                          onPressed: () {
                            searchByUsername();
                          },
                          icon: Icon(Icons.search)),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Ajouter un Gestionnaire",
                      style: TextStyle(fontSize: 20),
                    ))
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
                      label: Text("Nom d'utilisateur"),
                    ),
                    DataColumn(
                      label: Text("Role"),
                    ),
                    DataColumn(
                      label: Text('Date de Création'),
                    ),
                    DataColumn(
                      label: Text('Heure de Création'),
                    ),
                  ],
                  rows: context
                      .watch<UserProvider>()
                      .users
                      .map((user) => DataRow(
                              // mouseCursor: MouseCursor.ha,
                              onSelectChanged: (value) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoScreen(userId: user.id)));
                                /*showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UserInfoDialog(
                                        userId: user.id,
                                      );
                                    });*/
                              },
                              cells: [
                                DataCell(Text('${user.id}')),
                                DataCell(Text('${user.username}')),
                                DataCell(Text(
                                    '${user.role == 'USER' ? 'Simple Utilisateur' : 'Administrateur'}')),
                                DataCell(Text('${user.createdAt}')),
                                DataCell(Text('${user.createdAt}'))
                              ]))
                      .toList()),
            ),
            Row(
              children: [],
            )
          ],
        ),
      ),
    );
  }
}

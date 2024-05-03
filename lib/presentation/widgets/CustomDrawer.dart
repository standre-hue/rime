import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rime/presentation/providers/ServerProvider.dart';
import 'package:rime/presentation/screens/LoginScreen.dart';
import 'package:rime/presentation/screens/SettingScreen.dart';
import 'package:rime/presentation/screens/TransactionListScreen.dart';
import 'package:rime/presentation/screens/UserListScreen.dart';
import 'package:rime/presentation/screens/dashboard_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: Colors.blue),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DashboardScreen()));
              },
              child: Text('Dashboard')),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TransactionListScreen()));
              },
              child: Text('Liste des Transactions')),

          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserListScreen()));
              },
              child: Text('Liste des Gestionnaires')),

          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingScreen()));
              },
              child: Text('Paramètre')),

          Spacer(),
          TextButton(
              onPressed: () async {
                await context.read<ServerProvider>().socket.close();
                //implements logout here
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: const Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Se deconnecter'),
                ],
              ))
        ]),
      ),
    );
  }
}

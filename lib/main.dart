// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:provider/provider.dart';
import 'package:rime/presentation/providers/AccountProvider.dart';
import 'package:rime/presentation/providers/CaisseProvider.dart';
import 'package:rime/presentation/providers/InfoProvider.dart';
import 'package:rime/presentation/providers/ServerProvider.dart';
import 'package:rime/presentation/providers/TransactionProvider.dart';
import 'package:rime/presentation/providers/UserProvider.dart';
import 'package:rime/presentation/screens/LoginScreen.dart';
import 'package:rime/presentation/screens/SplashScreen.dart';
import 'package:rime/presentation/screens/dashboard_screen.dart';

void main() {
  //await initializeDateFormatting('fr','fr');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => InfoProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ServerProvider()),
        ChangeNotifierProvider(create: (_) => CaisseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark, // Set brightness to dark
        primaryColor: Colors.black, // Set primary color to black
        hintColor: Colors.white, // Set accent color to white
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: Color.fromARGB(
                  255, 255, 255, 255)), // Set text color to white
          bodyMedium: TextStyle(
              color: Color.fromARGB(
                  255, 241, 238, 238)), // Set text color to white
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

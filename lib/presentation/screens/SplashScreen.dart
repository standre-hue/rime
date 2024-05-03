import 'package:flutter/material.dart';
import 'package:rime/presentation/screens/LoginScreen.dart';
import 'package:rime/presentation/screens/RegisterScreen.dart';
import 'package:rime/presentation/utils/funcs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void Delayed() {
    Future.delayed(const Duration(seconds: 4)).then((value) async {
      bool _isFirstTime = await isFirstTime();
      if (_isFirstTime == true) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RegisterScreen()));
        return;
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        return;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Delayed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rime',
              style: TextStyle(color: Colors.blue, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}

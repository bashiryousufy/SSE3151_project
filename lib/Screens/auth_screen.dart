import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:project/Screens/folders_screen.dart';

class AuthenticateScreen extends StatelessWidget {
  AuthenticateScreen({Key? key}) : super(key: key);

  final LocalAuthentication localAuth = LocalAuthentication();

  void authenticateByBiometrics(BuildContext context) async {
    try {
      bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;
      if (weCanCheckBiometrics) {
        bool authenticated = await localAuth.authenticate(
            stickyAuth: true,
            localizedReason: "Authenticate to get access to your documents");

        Navigator.popAndPushNamed(context, '/home');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
        centerTitle: true,
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(24),
                primary: Colors.green,
              ),
              onPressed: () async {
                authenticateByBiometrics(context);
              },
              child: Image.asset(
                "assets/fingerprint.png",
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Authenticate By Fingerprint",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AuthenticateScreen extends StatelessWidget {
  const AuthenticateScreen({Key? key}) : super(key: key);

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
              onPressed: () {},
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

import 'package:flutter/material.dart';

class ForgotPasswordPageView extends StatelessWidget {
  const ForgotPasswordPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0075FF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                // BEFORE Title
                height: 20,
              ),
              Center(
                // For the QR ATTEND Title with Image
                child: Container(
                  width: 175,
                  height: 145,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              // QR
                              "QR",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Colors.black.withOpacity(0.5),
                                    )
                                  ]),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      spreadRadius: 0.0,
                                    ),
                                  ],
                                ),
                                child: Image(
                                  image: AssetImage('assets/QR.PNG'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        // QR
                        "ATTEND",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            shadows: [
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black.withOpacity(0.5),
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                // AFTER Title
                height: 5,
              ),
              Align(
                // For the Login Text
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36, 0, 0, 0),
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          )
                        ]),
                  ),
                ),
              ),
              SizedBox(
                // AFTER Login Text
                height: 10,
              ),
              Center(
                child: Container(
                  // Login Container
                  width: 320,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Login Details
                      Align(
                        // Email Text
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                          child: Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        // Email Textfield
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Please Enter your Email Address',
                          ),
                        ),
                      ),
                      SizedBox(
                        // BEFORE Login Button
                        height: 20,
                      ),
                      SizedBox(
                        // To set the width and height of the button
                        width: 250,
                        height: 50,
                        child: FloatingActionButton.extended(
                          // Login Button
                          onPressed: () {
                            // When the button is pressed
                          },
                          backgroundColor: Color(0xFF0075FF),
                          label: Text(
                            "Recover Password",
                            style: TextStyle(fontSize: 20),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      SizedBox(
                        // AFTER Login Button
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: ()=> Navigator.pop(context),
                        child: Text(
                          "Back to Login Page",
                          style: TextStyle(
                              color: Colors.blue
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

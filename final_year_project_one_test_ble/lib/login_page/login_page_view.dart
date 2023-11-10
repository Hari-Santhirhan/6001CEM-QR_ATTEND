import 'package:final_year_project_one/forgot_password_page/forgot_password_page_view.dart';
import 'package:final_year_project_one/login_page/login_page_viewModel.dart';
import 'package:flutter/material.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  late LoginPageViewModel _loginPageViewModel;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _loginPageViewModel = LoginPageViewModel();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                    "Login",
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
                  height: 450,
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
                          controller: emailController,
                          onChanged: (value) =>
                              _loginPageViewModel.updateEmail(value),
                          decoration: InputDecoration(
                            labelText: 'Please Enter your Email Address',
                          ),
                        ),
                      ),
                      Align(
                        // Password Text
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 40, 0, 0),
                          child: Text(
                            "Password",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        // Password Textfield
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                        child: TextField(
                          controller: passwordController,
                          onChanged: (value) =>
                              _loginPageViewModel.updatePassword(value),
                          obscureText: !_loginPageViewModel.showPassword,
                          decoration: InputDecoration(
                            labelText: 'Please Enter your Password',
                          ),
                        ),
                      ),
                      Padding(
                        // Show Password Checkbox
                        padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                        child: Row(
                          children: [
                            Checkbox(
                                value: _loginPageViewModel.showPassword,
                                onChanged: (value) {
                                  setState(() {
                                    _loginPageViewModel.toggleShowPassword();
                                  });
                                }),
                            Text(
                              // Show Password Text
                              "Show Password",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        // BEFORE Login Button
                        height: 5,
                      ),
                      SizedBox(
                        // To set the width and height of the button
                        width: 200,
                        height: 50,
                        child: FloatingActionButton.extended(
                          // Login Button
                          onPressed: () {
                            emailController.clear();
                            passwordController.clear();
                            // When the button is pressed
                            _loginPageViewModel.loginProcess(context);
                          },
                          backgroundColor: Color(0xFF0075FF),
                          label: Text(
                            "Login",
                            style: TextStyle(fontSize: 25),
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
                      Row(
                        // For the Rest Password Texts
                        children: [
                          SizedBox(
                            // To move the 1st text forward
                            width: 69,
                          ),
                          Text("Forgot Password?"),
                          SizedBox(
                            // To separate the 1st and 2nd text
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordPageView())),
                            child: Text(
                              "Click Here",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      )
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

import 'package:final_year_project_one/privacy_policy_page/privacy_policy_page_viewModel.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPageView extends StatefulWidget {
  const PrivacyPolicyPageView({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyPageView> createState() => _PrivacyPolicyPageViewState();
}

class _PrivacyPolicyPageViewState extends State<PrivacyPolicyPageView> {
  late PrivacyPolicyPageViewModel _privacyPolicyPageViewModel;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _privacyPolicyPageViewModel = PrivacyPolicyPageViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0075FF),
          leading: IconButton(
            onPressed: () {
              _privacyPolicyPageViewModel.BackToHomePage(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
          ),
          title: Text(
            "Privacy Policy",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        )
    );
  }
}

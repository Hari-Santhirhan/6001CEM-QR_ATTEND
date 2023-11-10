import 'package:final_year_project_one/about_us_page/about_us_page_view.dart';
import 'package:final_year_project_one/privacy_policy_page/privacy_policy_page_view.dart';
import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier {
  void GoToAboutUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutUsPageView(),
      ),
    );
  }

  void GoToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyPolicyPageView(),
      ),
    );
  }
}

import 'package:final_year_project_one/about_us_page/about_us_page_viewModel.dart';
import 'package:flutter/material.dart';

class AboutUsPageView extends StatefulWidget {
  const AboutUsPageView({Key? key}) : super(key: key);

  @override
  State<AboutUsPageView> createState() => _AboutUsPageViewState();
}

class _AboutUsPageViewState extends State<AboutUsPageView> {
  late AboutUsPageViewModel _aboutUsPageViewModel;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _aboutUsPageViewModel = AboutUsPageViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0075FF),
        leading: IconButton(
          onPressed: () {
            _aboutUsPageViewModel.BackToHomePage(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          "About Us & The App",
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

import 'package:flutter/Material.dart';

class WarningLetterDetailedView extends StatefulWidget {
  final letter;
  final letterSession;
  final letterEmail;
  final letterName;
  final letterSubCode;
  final letterSubName;
  final letterMsg;
  const WarningLetterDetailedView({
    Key? key,
    required this.letter,
    required this.letterSession,
    required this.letterEmail,
    required this.letterName,
    required this.letterSubCode,
    required this.letterSubName,
    required this.letterMsg,
  }) : super(key: key);

  @override
  State<WarningLetterDetailedView> createState() =>
      _WarningLetterDetailedViewState();
}

class _WarningLetterDetailedViewState extends State<WarningLetterDetailedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Detailed View",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "" + widget.letterMsg,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

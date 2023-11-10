import 'package:flutter/Material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrResultPage extends StatefulWidget {
  //final String code;
  //final Function() closeScreen;
  final String extractedROOM;
  const QrResultPage({
    Key? key,
    //required this.closeScreen,
    //required this.code,
    required this.extractedROOM,
  }) : super(key: key);

  @override
  State<QrResultPage> createState() => _QrResultPageState();
}

class _QrResultPageState extends State<QrResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            //widget.closeScreen();
            // Use Navigator.popUntil to go back to ScanAttendancePageView
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "QR Results",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Display the scanned QR Code
            QrImageView(
              data: "", //+ widget.code,
              size: 150,
            ),
            Text(
              "Scanned QR Result",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${widget.extractedROOM}", //"${widget.code}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

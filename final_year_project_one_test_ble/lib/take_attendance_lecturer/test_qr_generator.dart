import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TestQrGenerator extends StatefulWidget {
  const TestQrGenerator({Key? key}) : super(key: key);

  @override
  State<TestQrGenerator> createState() => _TestQrGeneratorState();
}

class _TestQrGeneratorState extends State<TestQrGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter QR Code Test"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            QrImageView(data: "Flutter"),
          ],
        ),
      ),
    );
  }
}

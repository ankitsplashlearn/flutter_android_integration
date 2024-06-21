import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterScreen extends StatelessWidget {
  static const platform = MethodChannel('com.example.app.communication');
  final String initialData;

  FlutterScreen(this.initialData);

  Future<void> sendDataBackto() async {
    try {
      await platform.invokeMethod('sendDataBack', {"data": "Hello from Flutter!"});
    } on PlatformException catch (e) {
      print("Failed to send data: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Screen'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await sendDataBackto();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Received from Android: $initialData'),
            ElevatedButton(
              onPressed: () async {
                await sendDataBackto();
                Navigator.pop(context);
              },
              child: Text('Send Data Back'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  getInitialData().then((initialData) {
    runApp(MaterialApp(
      home: FlutterScreen(initialData),
    ));
  });
  // runApp(MaterialApp(
  //   home: FlutterScreen(""),
  // ));
}

Future<String> getInitialData() async {
  const platform = MethodChannel('com.example.app.communication');
  try {
    final String data = await platform.invokeMethod('receiveInitialData');
    return data;
  } on PlatformException catch (e) {
    print("Failed to receive data: '${e.message}'.");
    return 'Error receiving data';
  }
}

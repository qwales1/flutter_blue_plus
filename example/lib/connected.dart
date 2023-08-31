import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Connected extends StatefulWidget {
  final ScanResult scanResult;
  const Connected({super.key, required this.scanResult});

  @override
  State<StatefulWidget> createState() => ConnectedState();
}

class ConnectedState extends State<Connected> {
  bool connected = false;
  String? deviceIp;
  String? udpPort;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          style: ButtonStyle(
              iconColor: MaterialStatePropertyAll<Color>(Colors.white)),
        ),
        backgroundColor: Colors.black,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.scanResult.device.localName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(children: [
        Container(
          height: 100,
          color: Colors.blueAccent,
          padding: const EdgeInsets.all(10),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ElevatedButton(
              onPressed: connected
                  ? () {
                      widget.scanResult.device.disconnect();
                      Navigator.of(context).pop();
                    }
                  : () async {
                      final nativeResponse =
                          await widget.scanResult.device.connect();

                      setState(() {
                        connected = true;
                        deviceIp = nativeResponse['udp_address'];
                        udpPort = nativeResponse['udp_port'];
                      });
                    },
              child:
                  connected ? const Text('Disconnect') : const Text('Connect'),
            ),
          ]),
        ),
        Expanded(
            child: Center(
                child: ListView(
          children: [
            ListTile(
              title: const Text('IP Address'),
              subtitle: Text(deviceIp ?? 'Not connected'),
            ),
            ListTile(
              title: const Text('UDP Port'),
              subtitle: Text(udpPort ?? 'Not connected'),
            ),
          ],
        )))
      ])),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

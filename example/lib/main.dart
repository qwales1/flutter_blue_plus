import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus_example/connected.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hawkin Blue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SafeArea(child: MyHomePage(title: 'Hawkin Blue')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? bluetoothIsAvailable;
  StreamSubscription<List<ScanResult>>? scanSubscription;
  List<ScanResult> scanResults = [];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
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
            IconButton(
                color: Colors.white,
                onPressed: () {
                  _startScan();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                )),
          ]),
        ),
        Expanded(
            child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Connected(scanResult: scanResults[index]),
                        ),
                      );
                    },
                    title: Text(scanResults[index].device.localName),
                    subtitle: Text(scanResults[index].device.remoteId.toString()),
                    trailing: Text(scanResults[index].rssi.toString()),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemCount: scanResults.length))
      ])),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  dispose() {
    super.dispose();
    scanSubscription?.cancel();
  }

  @override
  initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (await FlutterBluePlus.isAvailable == false) {
        setState(() {
          bluetoothIsAvailable = false;
        });
        return;
      }

      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }

      scanSubscription = FlutterBluePlus.scanResults.map((List<ScanResult> scanResults) {
        final res = scanResults
            .where((element) =>
                element.device.remoteId.str.startsWith('C8:58') ||
                element.device.remoteId.str.startsWith('84:1B:77:F9:A3:AC'))
            .toList();

        return res;
      }).listen((results) {
        setState(() {
          scanResults = results;
        });
      });

      _startScan();
    });
  }

  void _startScan() async {
    if (!FlutterBluePlus.isScanningNow) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    }
  }
}

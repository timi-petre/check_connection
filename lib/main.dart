import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Check Connectivity',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Check Connectivity'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription subscription;
  late StreamSubscription internetSubscription;
  bool hasInternet = false;
  ConnectivityResult result = ConnectivityResult.none;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() => this.hasInternet = hasInternet);
    });
    internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      //sa verifice automat daca avem internet
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    internetSubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: Text('Check connection'),
              onPressed: () async {
                hasInternet = await InternetConnectionChecker().hasConnection;

                result = await Connectivity().checkConnectivity();

                final color = hasInternet ? Colors.green : Colors.red;
                final text = hasInternet ? 'Internet' : 'No Internet';
                if (result == ConnectivityResult.mobile) {
                  showSimpleNotification(
                    Text(
                      '$text: Mobile Network',
                      style: TextStyle(color: Colors.white),
                    ),
                    background: color,
                  );
                } else if (result == ConnectivityResult.wifi) {
                  showSimpleNotification(
                    Text(
                      '$text: Wifi Network',
                      style: TextStyle(color: Colors.white),
                    ),
                    background: color,
                  );
                } else {
                  showSimpleNotification(
                    Text(
                      '$text: No Network',
                      style: TextStyle(color: Colors.white),
                    ),
                    background: Colors.red,
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

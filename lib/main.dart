import 'dart:async';

import 'package:check_connection/utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Has Internet'),
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

void showConnectivitySnackBar(ConnectivityResult result) {
  final hasInternet = result != ConnectivityResult.none;
  final message =
      hasInternet ? 'You have again ${result.toString()}' : 'You have internet';
  final color = hasInternet ? Colors.green : Colors.red;

  BuildContext? context;
  Utils.showTopSnackBar(context!, message, color);
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription? subsription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subsription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
  }

  @override
  void dispose() {
    subsription!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(12)),
          child: Text('Check connection'),
          onPressed: () async {
            final result = await Connectivity().checkConnectivity();
            showConnectivitySnackBar(result);
          },
        ),
      ),
    );
  }
}

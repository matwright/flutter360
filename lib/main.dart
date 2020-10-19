import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_assets_server/local_assets_server.dart';
import 'package:video_player_360/video_player_360.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local http Server with 360 video',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Local http Server with 360 video'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isListening = false;
  String address;
  int port;
  WebViewController controller;

  @override
  initState() {
    _initServer();

    super.initState();
  }

  _initServer() async {
    final server = new LocalAssetsServer(
      address: InternetAddress.anyIPv4,
      assetsBasePath: 'assets/',
      port: 9090,
    );

    final address = await server.serve();

    setState(() {
      this.address = address.address;
      port = server.boundPort;
      isListening = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isListening
          ?
      Center(
        child: RaisedButton(
          onPressed: () async {
            await VideoPlayer360.playVideoURL(
                'http://127.0.0.1:9090/360.mp4');
          },
          child: Text('Play Clip'),
        )
      )



          : Center(
        child: CircularProgressIndicator(),
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

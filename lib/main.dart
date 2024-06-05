import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lowrence Lubricants',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image(
            image:
                AssetImage('assets/c77864f3-dd0d-4d0a-a174-1fa9ee878569.jpg'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewController controller;
  double progress = 0.0;
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progres) {
            setState(() {
              progress = progres / 100;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            if (url.startsWith('whatsapp:')) {
              // Handle WhatsApp URL scheme, open the WhatsApp application
              // Example: launch('whatsapp://send?phone=1234567890')
              // You need to replace the phone number with the actual one.
              launch(url);
              return NavigationDecision
                  .prevent; // Prevent WebView from loading this URL
            }
            if (url.startsWith('https://api.whatsapp.com/')) {
              // Handle WhatsApp URL scheme, open the WhatsApp application
              // Example: launch('whatsapp://send?phone=1234567890')
              // You need to replace the phone number with the actual one.
              launch(url);
              return NavigationDecision
                  .prevent; // Prevent WebView from loading this URL
            }
            if (url.startsWith('tel')) {
              // Handle WhatsApp URL scheme, open the WhatsApp application
              // Example: launch('whatsapp://send?phone=1234567890')
              // You need to replace the phone number with the actual one.
              launch(url);
              return NavigationDecision
                  .prevent; // Prevent WebView from loading this URL
            }
            if (url.startsWith('mailto')) {
              // Handle WhatsApp URL scheme, open the WhatsApp application
              // Example: launch('whatsapp://send?phone=1234567890')
              // You need to replace the phone number with the actual one.
              launch(url);
              return NavigationDecision
                  .prevent; // Prevent WebView from loading this URL
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.lowrencelubricants.com/'));
    setState(() {});
  }

  Future<void> launch(String url) async {
    print("Success");
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
    print("Success");
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _lastPressedAt;
  @override
  Widget build(BuildContext context) {
    int backButtonPressCount = 0;
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 2)) {
          if (await controller.canGoBack()) {
            controller.goBack();
          } else {
            _lastPressedAt = DateTime.now();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Press back again to exit'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          return false; // Do not exit the app
        } else {
          return true; // Allow exit the app
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(10.0), // Set the desired height
            child: AppBar(
              backgroundColor: Color(0xff2d5be3),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(4.0), // Set the desired height
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2d5be3)),
                ),
              ),
            ),
          ),
          body: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }

  Future<void> _refreshWebView() async {
    await controller.reload();
  }
}

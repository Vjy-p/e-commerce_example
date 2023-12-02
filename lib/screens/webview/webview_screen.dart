import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:firebase_testing/screens/webview/webview_menu.dart';
import 'package:firebase_testing/screens/webview/webview_navigations.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  int loadingPrecentage = 0;

  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise() {
    // controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setBackgroundColor(const Color(0x00000000))
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onProgress: (int progress) {
    //         // Update loading bar.
    //       },
    //       onPageStarted: (String url) {},
    //       onPageFinished: (String url) {},
    //       onWebResourceError: (WebResourceError error) {},
    //       onNavigationRequest: (NavigationRequest request) {
    //         if (request.url.startsWith('https://www.youtube.com/')) {
    //           return NavigationDecision.prevent;
    //         }
    //         return NavigationDecision.navigate;
    //       },
    //     ),
    //   )
    //   ..loadRequest(Uri.parse('https://flutter.dev'));

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPrecentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPrecentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPrecentage = 100;
          });
        },
        onNavigationRequest: (request) {
          final host = Uri.parse(request.url).host;
          if (host.contains('youtube.com')) {
            debugPrint("\nnavigation Blocking");
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse('http://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: WebViewNavigations(controller: controller),
        actions: [WebViewMenu(controller: controller)],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPrecentage < 100) ...[
            LinearProgressIndicator(
              value: loadingPrecentage / 100,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            )
          ]
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum menuOptions { navigateDelegate, userAgent, javascriptchannel }

class WebViewMenu extends StatelessWidget {
  WebViewMenu({super.key, required this.controller});
  WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<menuOptions>(
      onSelected: (value) async {
        switch (value) {
          case menuOptions.navigateDelegate:
            await controller.loadRequest(Uri.parse('http://youtube.com'));
            break;
          case menuOptions.userAgent:
            final userAgent = await controller
                .runJavaScriptReturningResult('navigator.userAgent');
            // if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$userAgent'),
            ));
            debugPrint("\njavascript return value ${userAgent}");
            break;
          case menuOptions.javascriptchannel:
            await controller.runJavaScript('''
                  var req = new XMLHttpRequest();
                  req.open('GET', "https://api.ipify.org/?format=json");
                  req.onload = function() {
                    if (req.status == 200) {
                      let response = JSON.parse(req.responseText);
                      SnackBar.postMessage("IP Address: " + response.ip);
                      } else {
                        SnackBar.postMessage("Error: " + req.status);
                        }
                        }
                        req.send();''');
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
              value: menuOptions.navigateDelegate, child: Text("youtube")),
          const PopupMenuItem<menuOptions>(
            value: menuOptions.userAgent,
            child: Text('Show user-agent'),
          ),
          const PopupMenuItem<menuOptions>(
            value: menuOptions.javascriptchannel,
            child: Text('java script'),
          ),
        ];
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewNavigations extends StatelessWidget {
  WebViewNavigations({super.key, required this.controller});
  WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () async {
              if (await controller.canGoBack()) {
                await controller.goBack();
              } else {
                debugPrint("\ncant go back");
              }
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        IconButton(
            onPressed: () async {
              if (await controller.canGoForward()) {
                await controller.goForward();
              } else {
                debugPrint("\ncant go back");
              }
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ))
      ],
    );
  }
}

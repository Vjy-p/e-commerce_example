import 'package:flutter/material.dart';

class CustomLoading {
  circularLoading() {
    return const Center(
        child: CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation(Colors.cyanAccent),
    ));
  }
}

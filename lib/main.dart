import 'package:flutter/material.dart';
import 'package:flutter_code_factory/user/view/login_screen.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSans'),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Image(
      width: 35, 
      height: 35, 
      image: AssetImage("assets/logo.png"), 
    );
  }
}

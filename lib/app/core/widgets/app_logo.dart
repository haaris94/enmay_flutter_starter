import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/images/logos/app_logo.svg');
  }
}

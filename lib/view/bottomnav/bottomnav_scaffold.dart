import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomnavScaffold extends StatelessWidget {
  BottomnavScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return navigationShell;
  }
}

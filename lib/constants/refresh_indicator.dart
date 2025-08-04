import 'package:flutter/material.dart';

class RefreshScaffold extends StatelessWidget {
  final Widget body;
  final Future<void> Function() onRefresh;
  final Color spinnerColor;

  const RefreshScaffold({
    super.key,
    required this.body,
    required this.onRefresh,
    this.spinnerColor = const Color(0xff0a519d),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        color: spinnerColor,
        child: body,
      ),
    );
  }
}

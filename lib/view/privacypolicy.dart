import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Privacypolicy extends ConsumerWidget {
  const Privacypolicy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text('Privacy Policy'),
      ),
    );
  }
}

// import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ProfileScreen extends ConsumerWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userDetails = ref.watch(userDetailsProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: userDetails.when(
//         data: (user) => Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Email: ${user.email}'),
//               const SizedBox(height: 8.0),
//               Text('Full Name: ${user.fullName}'),
//               const SizedBox(height: 8.0),
//               Text('Phone: ${user.phone}'),
//             ],
//           ),
//         ),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text('Error: $error')),
//       ),
//     );
//   }
// }

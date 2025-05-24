// // // // import 'package:eventsolutions/provider/event/eventProvider.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // // // class TicketQr extends ConsumerWidget {
// // // //   const TicketQr({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final registerState = ref.watch(registerEventProvider);
// // // //     return Scaffold(
// // // //       body: Column(
// // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // //         crossAxisAlignment: CrossAxisAlignment.center,
// // // //         children: [
// // // //           Center(
// // // //             child: Text(
// // // //               registerState.result?.data.status ?? 'No status available',
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:eventsolutions/provider/event/eventProvider.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // // class TicketQr extends ConsumerWidget {
// // //   final String ticketId;

// // //   const TicketQr({super.key, required this.ticketId});

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final registerState = ref.watch(registerEventProvider);

// // //     // Fetch ticket details when the screen is loaded
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       ref.read(registerEventProvider.notifier).fetchTicketDetails(ticketId);
// // //     });

// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Ticket QR Code')),
// // //       body: Center(
// // //         child: registerState.isLoading
// // //             ? const CircularProgressIndicator()
// // //             : registerState.error != null
// // //                 ? Text('Error: ${registerState.error}',
// // //                     style: const TextStyle(color: Colors.red))
// // //                 : registerState.ticketDetails == null
// // //                     ? const Text('No ticket details available')
// // //                     : Column(
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         crossAxisAlignment: CrossAxisAlignment.center,
// // //                         children: [
// // //                           Text(
// // //                             'Status: ${registerState.ticketDetails!.data.status}',
// // //                             style: const TextStyle(fontSize: 18),
// // //                           ),
// // //                           const SizedBox(height: 20),
// // //                           if (registerState.ticketDetails!.data.status ==
// // //                                   'approved' &&
// // //                               registerState.ticketDetails!.data != null)
// // //                             Image.network(
// // //                               'http://182.93.94.210:8000${registerState.ticketDetails!.data.qr}',
// // //                               width: 200,
// // //                               height: 200,
// // //                               errorBuilder: (context, error, stackTrace) =>
// // //                                   const Text(
// // //                                 'Failed to load QR code',
// // //                                 style: TextStyle(color: Colors.red),
// // //                               ),
// // //                             )
// // //                           else
// // //                             const Text(
// // //                               'QR code not available. Ticket is not approved.',
// // //                               style:
// // //                                   TextStyle(fontSize: 16, color: Colors.grey),
// // //                             ),
// // //                         ],
// // //                       ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:eventsolutions/provider/event/eventProvider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class TicketQr extends ConsumerWidget {
// //   final String ticketId;

// //   const TicketQr({super.key, required this.ticketId});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final registerState = ref.watch(registerEventProvider);

// //     // Fetch ticket details when the screen is loaded
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       ref.read(registerEventProvider.notifier).fetchTicketDetails(ticketId);
// //     });

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Ticket QR Code')),
// //       body: Center(
// //         child: registerState.isLoading
// //             ? const CircularProgressIndicator()
// //             : registerState.error != null
// //                 ? Text('Error: ${registerState.error}',
// //                     style: const TextStyle(color: Colors.red))
// //                 : registerState.ticketDetails == null
// //                     ? const Text('No ticket details available')
// //                     : Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: [
// //                           Text(
// //                             'Status: ${registerState.ticketDetails!.data.status}',
// //                             style: const TextStyle(fontSize: 18),
// //                           ),
// //                           const SizedBox(height: 20),
// //                           if (registerState.ticketDetails!.data.status ==
// //                                   'approved' &&
// //                               registerState.ticketDetails!.data.qr != null)
// //                             Image.network(
// //                               'http://182.93.94.210:8000${registerState.ticketDetails!.data.qr}',
// //                               width: 200,
// //                               height: 200,
// //                               errorBuilder: (context, error, stackTrace) =>
// //                                   const Text(
// //                                 'Failed to load QR code',
// //                                 style: TextStyle(color: Colors.red),
// //                               ),
// //                             )
// //                           else
// //                             const Text(
// //                               'QR code not available. Ticket is not approved.',
// //                               style:
// //                                   TextStyle(fontSize: 16, color: Colors.grey),
// //                             ),
// //                         ],
// //                       ),
// //       ),
// //     );
// //   }
// // }

// import 'package:eventsolutions/provider/event/eventProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class TicketQr extends ConsumerWidget {
//   final String? ticketId; // Make ticketId optional

//   const TicketQr({super.key, this.ticketId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final registerState = ref.watch(registerEventProvider);

//     if (ticketId != null && ticketId!.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ref.read(registerEventProvider.notifier).fetchTicketDetails(ticketId!);
//       });
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Ticket QR Code')),
//       body: Center(
//         child: registerState.isLoading
//             ? const CircularProgressIndicator()
//             : registerState.error != null
//                 ? Text(
//                     'Error: ${registerState.error}',
//                     style: const TextStyle(color: Colors.red),
//                   )
//                 : registerState.ticketDetails == null &&
//                         registerState.result?.data == null
//                     ? const Text('No ticket details available')
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Status: ${registerState.ticketDetails?.data.status ?? registerState.result?.data.status ?? 'Unknown'}',
//                             style: const TextStyle(fontSize: 18),
//                           ),
//                           const SizedBox(height: 20),
//                           if ((registerState.ticketDetails?.data.status ==
//                                       'approved' &&
//                                   registerState.ticketDetails?.data.qr !=
//                                       null) ||
//                               (registerState.result?.data.status ==
//                                       'approved' &&
//                                   registerState.result?.data.qr != null))
//                             Image.network(
//                               'http://182.93.94.210:8000${registerState.ticketDetails?.data.qr ?? registerState.result?.data.qr}',
//                               width: 200,
//                               height: 200,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   const Text(
//                                 'Failed to load QR code',
//                                 style: TextStyle(color: Colors.red),
//                               ),
//                             )
//                           else
//                             const Text(
//                               'QR code not available. Ticket is not approved.',
//                               style:
//                                   TextStyle(fontSize: 16, color: Colors.grey),
//                             ),
//                         ],
//                       ),
//       ),
//     );
//   }
// }

// import 'package:eventsolutions/provider/event/eventProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class TicketQr extends ConsumerWidget {
//   const TicketQr({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final ticket = ref.watch(ticketProvider);
//     return Container();
//   }
// }

import 'package:eventsolutions/provider/event/eventProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TicketQr extends ConsumerWidget {
  final String ticketId;

  const TicketQr({Key? key, required this.ticketId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketAsync = ref.watch(ticketProvider(ticketId));

    return ticketAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (ticket) {
        if (ticket.status.toLowerCase() == 'approved') {
          return ticket.qr != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Your QR Code:'),
                      const SizedBox(height: 10),
                      Image.network(ticket.qr!), // Assuming QR is an image URL
                    ],
                  ),
                )
              : const Center(child: Text('QR code not available.'));
        } else {
          return const Center(child: Text('Ticket not approved.'));
        }
      },
    );
  }
}

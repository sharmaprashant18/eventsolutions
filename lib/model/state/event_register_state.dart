// // import 'package:eventsolutions/model/event_register_model.dart';

// // class RegisterEventState {
// //   final bool isLoading;
// //   final EventRegisterModel? result;
// //   final String? error;

// //   RegisterEventState({
// //     this.isLoading = false,
// //     this.result,
// //     this.error,
// //   });

// //   RegisterEventState copyWith({
// //     bool? isLoading,
// //     EventRegisterModel? result,
// //     String? error,
// //   }) {
// //     return RegisterEventState(
// //       isLoading: isLoading ?? this.isLoading,
// //       result: result ?? this.result,
// //       error: error,
// //     );
// //   }
// // }

// import 'package:eventsolutions/model/event_register_model.dart';

// class RegisterEventState {
//   final bool isLoading;
//   final EventRegisterModel? result;
//   final EventRegisterModel? ticketDetails; // Store ticket details
//   final String? error;

//   RegisterEventState({
//     this.isLoading = false,
//     this.result,
//     this.ticketDetails,
//     this.error,
//   });

//   RegisterEventState copyWith({
//     bool? isLoading,
//     EventRegisterModel? result,
//     EventRegisterModel? ticketDetails,
//     String? error,
//   }) {
//     return RegisterEventState(
//       isLoading: isLoading ?? this.isLoading,
//       result: result ?? this.result,
//       ticketDetails: ticketDetails ?? this.ticketDetails,
//       error: error ?? this.error,
//     );
//   }
// }

import 'package:eventsolutions/model/event_register_model.dart';

class RegisterEventState {
  final bool isLoading;
  final EventRegisterModel? result;
  final EventRegisterModel? ticketDetails;
  final String? error;

  RegisterEventState({
    this.isLoading = false,
    this.result,
    this.ticketDetails,
    this.error,
  });

  RegisterEventState copyWith({
    bool? isLoading,
    EventRegisterModel? result,
    EventRegisterModel? ticketDetails,
    String? error,
  }) {
    return RegisterEventState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      ticketDetails: ticketDetails ?? this.ticketDetails,
      error: error ?? this.error,
    );
  }
}

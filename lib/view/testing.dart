// import 'package:eventsolutions/provider/event/event_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class TestingPage extends ConsumerWidget {
//   const TestingPage({super.key});

//   String formatDateManually(DateTime dateTime) {
//     String day = dateTime.day.toString().padLeft(2, '');

//     List<String> months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     String month = months[dateTime.month - 1];

//     // Get last two digits of year
//     String year = (dateTime.year % 100).toString().padLeft(2, '0');

//     return '$day $month, $year';
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final screenSize = MediaQuery.of(context).size;
//     final screenWidth = screenSize.width;
//     final screenHeight = screenSize.height;

//     final eventsAsyncValue = ref.watch(eventProvider);

//     return Scaffold(
//         body: Padding(
//       padding: EdgeInsets.only(
//         top: screenHeight * 0.008,
//         right: screenWidth * 0.03,
//         left: screenWidth * 0.03,
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           children: eventsAsyncValue
//               .when(
//                 data: (events) {
//                   if (events.isEmpty) {
//                     return [
//                       const Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'No events available',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'Check back later for upcoming events!',
//                               style:
//                                   TextStyle(fontSize: 14, color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ];
//                   }
//                   return events
//                       .map((event) => eventCard(
//                             context,
//                             event.poster ??
//                                 'assets/default.png', // Fallback image
//                             event.title,
//                             event.startDate,
//                             event.endDate,
//                             event.ticketTiers.isNotEmpty
//                                 ? event.ticketTiers[0].price
//                                 : 0.0,
//                           ))
//                       .toList();
//                 },
//                 loading: () =>
//                     [const Center(child: CircularProgressIndicator())],
//                 error: (error, stackTrace) {
//                   final isUnauthorized = error.toString().contains('401');
//                   return [
//                     const Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Authentication Required',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'No valid session. Please log in to view events.',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                             textAlign: TextAlign.center,
//                           ),
//                           SizedBox(height: 16),
//                         ],
//                       ),
//                     ),
//                   ];
//                 },
//               )
//               .toList(),
//         ),
//       ),
//     ));
//   }

//   Widget eventCard(
//     BuildContext context,
//     String image,
//     String title,
//     String startDate,
//     String endDate,
//     double price,
//   ) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Card(
//       // color: Colors.blueGrey,
//       color: Colors.white,
//       shadowColor: Colors.grey.withAlpha(10),
//       margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//           side: BorderSide(
//               width: 0, style: BorderStyle.solid, color: Colors.grey)),
//       clipBehavior: Clip.antiAlias,
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //Event Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.asset(
//                 image,
//                 height: screenHeight * 0.2,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),

//             // Content
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title
//                 SizedBox(
//                   height: 6,
//                 ),
//                 FittedBox(
//                   child: Text(
//                     title,
//                     softWrap: true,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1,
//                         wordSpacing: 2,
//                         fontSize: 16,
//                         color: Colors.black87),
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 // Date and Location row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Date
//                     Row(
//                       children: [
//                         Icon(Icons.calendar_month, color: Color(0xffF66B10)),
//                         SizedBox(width: 4),
//                         Text(
//                           startDate != null
//                               ? DateFormat('MMM dd, yyyy h:mm a')
//                                   .format(DateTime.parse(startDate).toLocal())
//                               : 'N/A',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),

//                     // Location
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, color: Color(0xffF77018)),
//                         SizedBox(width: 4),
//                         Text(
//                           'Kathmandu, Nepal', // Placeholder, as location is not in the model
//                           style: TextStyle(
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Text(
//                       'Price: Rs${price.toStringAsFixed(2)}',
//                       style: TextStyle(color: Colors.deepOrange),
//                     ),
//                     Spacer(),
//                     // Join button
//                     ElevatedButton(
//                       onPressed: () {
//                         // Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) => EntryForm(events: ,)));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         // backgroundColor: Color(0xff35353E),
//                         backgroundColor: Colors.green,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 26, vertical: 0),
//                       ),
//                       child: Text(
//                         'JOIN NOW',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             fontFamily: ''),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EventScreen extends ConsumerWidget {
//   const EventScreen({super.key});

//   String formatDateManually(DateTime dateTime) {
//     String day = dateTime.day.toString().padLeft(2, '');

//     List<String> months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     String month = months[dateTime.month - 1];

//     // Get last two digits of year
//     String year = (dateTime.year % 100).toString().padLeft(2, '0');

//     return '$day $month, $year';
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final screenSize = MediaQuery.of(context).size;
//     final screenWidth = screenSize.width;
//     final screenHeight = screenSize.height;

//     final event = ref.watch(eventProvider);

//     return Scaffold(
//         body: Padding(
//       padding: EdgeInsets.only(
//         top: screenHeight * 0.008,
//         right: screenWidth * 0.03,
//         left: screenWidth * 0.03,
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//             children: event.when(
//           data: (events) {
//             if (events.isEmpty) {
//               return [
//                 Center(
//                   child: Text('No event found'),
//                 )
//               ];
//             }
//             return events
//                 .map((event) => eventCard(
//                       context,
//                       event.poster ?? 'assets/default.png', // Fallback image
//                       event.title,
//                       event.startDate,
//                       event.endDate,
//                       event.ticketTiers.isNotEmpty
//                           ? event.ticketTiers[0].price
//                           : 0.0,
//                     ))
//                 .toList();
//           },
//           loading: () => [const Center(child: CircularProgressIndicator())],
//           error: (error, stackTrace) {
//             return [
//               Center(
//                 child: Text('Error:$error'),
//               )
//             ];
//           },
//         )),
//       ),
//     ));
//   }

//   Widget eventCard(
//     BuildContext context,
//     String image,
//     String title,
//     String startDate,
//     String endDate,
//     double price,
//   ) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Card(
//       // color: Colors.blueGrey,
//       color: Colors.white,
//       shadowColor: Colors.grey.withAlpha(10),
//       margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//           side: BorderSide(
//               width: 0, style: BorderStyle.solid, color: Colors.grey)),
//       clipBehavior: Clip.antiAlias,
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //Event Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.asset(
//                 image,
//                 height: screenHeight * 0.2,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),

//             // Content
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title
//                 SizedBox(
//                   height: 6,
//                 ),
//                 FittedBox(
//                   child: Text(
//                     title,
//                     softWrap: true,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1,
//                         wordSpacing: 2,
//                         fontSize: 16,
//                         color: Colors.black87),
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 // Date and Location row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Date
//                     Row(
//                       children: [
//                         Icon(Icons.calendar_month, color: Color(0xffF66B10)),
//                         SizedBox(width: 4),
//                         Text(
//                           DateFormat('MMM dd, yyyy h:mm a')
//                               .format(DateTime.parse(startDate).toLocal()),
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),

//                     // Location
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, color: Color(0xffF77018)),
//                         SizedBox(width: 4),
//                         Text(
//                           'Kathmandu, Nepal', // Placeholder, as location is not in the model
//                           style: TextStyle(
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Text(
//                       'Price: Rs${price.toStringAsFixed(2)}',
//                       style: TextStyle(color: Colors.deepOrange),
//                     ),
//                     Spacer(),
//                     // Join button
//                     ElevatedButton(
//                       onPressed: () {
//                         // Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) => EntryForm()));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         // backgroundColor: Color(0xff35353E),
//                         backgroundColor: Colors.green,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 26, vertical: 0),
//                       ),
//                       child: Text(
//                         'JOIN NOW',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             fontFamily: ''),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // // class ContactUsPage extends ConsumerWidget {
// // //   const ContactUsPage({super.key});

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final screenSize = MediaQuery.of(context).size;
// // //     final screenWidth = screenSize.width;
// // //     final screenHeight = screenSize.height;
// // //     return Scaffold(
// // //         body: Column(
// // //       children: [
// // //         Container(
// // //           height: screenHeight * 0.25,
// // //           width: double.infinity,
// // //           decoration: BoxDecoration(
// // //               image: DecorationImage(
// // //                   fit: BoxFit.fitWidth,
// // //                   image: AssetImage(
// // //                     'assets/contact_us.jpg',
// // //                   ))),
// // //           child: Align(
// // //             alignment: Alignment.center,
// // //             child: Text(
// // //               textAlign: TextAlign.center,
// // //               'Contact Us for a complete solution to all events',
// // //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     ));
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class ContactUsPage extends ConsumerWidget {
// //   const ContactUsPage({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final screenSize = MediaQuery.of(context).size;
// //     final screenHeight = screenSize.height;

// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             Container(
// //               height: screenHeight * 0.25,
// //               width: double.infinity,
// //               decoration: const BoxDecoration(
// //                 image: DecorationImage(
// //                   fit: BoxFit.cover,
// //                   image: AssetImage('assets/contact_us.jpg'),
// //                 ),
// //               ),
// //               child: Stack(
// //                 children: [
// //                   Container(color: Colors.transparent),
// //                   Center(
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           vertical: 10, horizontal: 15),
// //                       color: Colors.black26,
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: const [
// //                           Text(
// //                             'Contact Us For A',
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 24,
// //                             ),
// //                           ),
// //                           Text(
// //                             'Complete Solution To All',
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 24,
// //                             ),
// //                           ),
// //                           Text(
// //                             'Events',
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 24,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             // Contact information section
// //             Padding(
// //               padding: const EdgeInsets.all(20.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text(
// //                     'Get In Touch',
// //                     style: TextStyle(
// //                       fontSize: 22,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),

// //                   // Contact info cards
// //                   _buildContactCard(
// //                     icon: Icons.phone,
// //                     title: 'Phone',
// //                     subtitle: '+1 (555) 123-4567',
// //                   ),
// //                   _buildContactCard(
// //                     icon: Icons.email,
// //                     title: 'Email',
// //                     subtitle: 'events@example.com',
// //                   ),
// //                   _buildContactCard(
// //                     icon: Icons.location_on,
// //                     title: 'Address',
// //                     subtitle: '123 Event Street, Suite 456, New York, NY 10001',
// //                   ),

// //                   const SizedBox(height: 30),

// //                   // Contact form
// //                   const Text(
// //                     'Send Us A Message',
// //                     style: TextStyle(
// //                       fontSize: 20,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 15),

// //                   TextFormField(
// //                     decoration: const InputDecoration(
// //                       labelText: 'Name',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 15),

// //                   TextFormField(
// //                     decoration: const InputDecoration(
// //                       labelText: 'Email',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 15),

// //                   TextFormField(
// //                     decoration: const InputDecoration(
// //                       labelText: 'Phone',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 15),

// //                   TextFormField(
// //                     maxLines: 4,
// //                     decoration: const InputDecoration(
// //                       labelText: 'Message',
// //                       border: OutlineInputBorder(),
// //                       alignLabelWithHint: true,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),

// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton(
// //                       onPressed: () {
// //                         // Handle form submission
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         padding: const EdgeInsets.symmetric(vertical: 15),
// //                       ),
// //                       child: const Text(
// //                         'SUBMIT',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildContactCard({
// //     required IconData icon,
// //     required String title,
// //     required String subtitle,
// //   }) {
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 15),
// //       elevation: 2,
// //       child: ListTile(
// //         leading: Icon(
// //           icon,
// //           size: 28,
// //           color: Colors.blue,
// //         ),
// //         title: Text(
// //           title,
// //           style: const TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         subtitle: Text(subtitle),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';

// // class ContactUsPage extends StatefulWidget {
// //   const ContactUsPage({Key? key}) : super(key: key);

// //   @override
// //   State<ContactUsPage> createState() => _ContactUsPageState();
// // }

// // class _ContactUsPageState extends State<ContactUsPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _fullNameController = TextEditingController();
// //   final _phoneController = TextEditingController();
// //   final _emailController = TextEditingController();
// //   final _messageController = TextEditingController();

// //   String _selectedCountryCode = '+977';

// //   final Map<String, String> _countryCodes = {
// //     '+93': '🇦🇫 Afghanistan (+93)',
// //     '+880': '🇧🇩 Bangladesh (+880)',
// //     '+975': '🇧🇹 Bhutan (+975)',
// //     '+91': '🇮🇳 India (+91)',
// //     '+960': '🇲🇻 Maldives (+960)',
// //     '+977': '🇳🇵 Nepal (+977)',
// //     '+92': '🇵🇰 Pakistan (+92)',
// //     '+94': '🇱🇰 Sri Lanka (+94)',
// //   };

// //   @override
// //   void dispose() {
// //     _fullNameController.dispose();
// //     _phoneController.dispose();
// //     _emailController.dispose();
// //     _messageController.dispose();
// //     super.dispose();
// //   }

// //   void _submitForm() {
// //     if (_formKey.currentState!.validate()) {
// //       // Handle form submission here
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Message sent successfully!'),
// //           backgroundColor: Colors.green,
// //         ),
// //       );

// //       // Clear form after submission
// //       _fullNameController.clear();
// //       _phoneController.clear();
// //       _emailController.clear();
// //       _messageController.clear();
// //       setState(() {
// //         _selectedCountryCode = '+1';
// //       });
// //     }
// //   }

// //   Widget _buildTextField({
// //     required String label,
// //     required TextEditingController controller,
// //     bool isRequired = true,
// //     TextInputType keyboardType = TextInputType.text,
// //     int maxLines = 1,
// //     String? hintText,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         RichText(
// //           text: TextSpan(
// //             text: label,
// //             style: const TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.w500,
// //               color: Color(0xFF2D5A5A),
// //             ),
// //             children: isRequired
// //                 ? [
// //                     const TextSpan(
// //                       text: ' *',
// //                       style: TextStyle(color: Colors.red),
// //                     ),
// //                   ]
// //                 : [],
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         TextFormField(
// //           controller: controller,
// //           keyboardType: keyboardType,
// //           maxLines: maxLines,
// // validator: isRequired
// //     ? (value) {
// //         if (value == null || value.trim().isEmpty) {
// //           return 'This field is required';
// //         }
// //         if (keyboardType == TextInputType.emailAddress) {
// //           final emailRegex =
// //               RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
// //           if (!emailRegex.hasMatch(value)) {
// //             return 'Please enter a valid email address';
// //           }
// //         }
// //         if (keyboardType == TextInputType.phone) {
// //           if (value.length < 7) {
// //             return 'Please enter a valid phone number';
// //           }
// //         }
// //         return null;
// //       }
// //     : null,
// //           decoration: InputDecoration(
// //             hintText: hintText,
// //             hintStyle: TextStyle(
// //               color: Colors.grey[400],
// //               fontSize: 14,
// //             ),
// //             filled: true,
// //             fillColor: const Color(0xFFF5E6D3),
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(12),
// //               borderSide: BorderSide.none,
// //             ),
// //             contentPadding: const EdgeInsets.symmetric(
// //               horizontal: 16,
// //               vertical: 12,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildPhoneField() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         RichText(
// //           text: const TextSpan(
// //             text: 'Phone Number',
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.w500,
// //               color: Color(0xFF2D5A5A),
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Row(
// //           children: [
// //             // Country Code Dropdown
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFF5E6D3),
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: DropdownButtonHideUnderline(
// //                 child: DropdownButton<String>(
// //                   value: _selectedCountryCode,
// //                   padding: const EdgeInsets.symmetric(horizontal: 12),
// //                   items: _countryCodes.entries.map((entry) {
// //                     return DropdownMenuItem<String>(
// //                       value: entry.key,
// //                       child: Text(
// //                         entry.value,
// //                         style: const TextStyle(fontSize: 14),
// //                       ),
// //                     );
// //                   }).toList(),
// //                   onChanged: (String? newValue) {
// //                     if (newValue != null) {
// //                       setState(() {
// //                         _selectedCountryCode = newValue;
// //                       });
// //                     }
// //                   },
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             // Phone Number Field
// //             Expanded(
// //               child: TextFormField(
// //                 controller: _phoneController,
// //                 keyboardType: TextInputType.phone,
// // validator: (value) {
// //   if (value == null || value.trim().isEmpty) {
// //     return 'Phone number is required';
// //   }
// //   if (value.length < 7) {
// //     return 'Please enter a valid phone number';
// //   }
// //   return null;
// // },
// //                 decoration: InputDecoration(
// //                   hintText: 'Enter your phone number',
// //                   hintStyle: TextStyle(
// //                     color: Colors.grey[400],
// //                     fontSize: 14,
// //                   ),
// //                   filled: true,
// //                   fillColor: const Color(0xFFF5E6D3),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                   contentPadding: const EdgeInsets.symmetric(
// //                     horizontal: 16,
// //                     vertical: 12,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// // backgroundColor: const Color(0xFF9BC5C5),
// // appBar: AppBar(
// //   backgroundColor: const Color(0xFF9BC5C5),
// //   elevation: 0,
// //   title: const Text(
// //     'Contact Us',
// //     style: TextStyle(
// //       color: Color(0xFF2D5A5A),
// //       fontWeight: FontWeight.bold,
// //     ),
// //   ),
// //   centerTitle: true,
// // ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(24),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: [
// //               // Full Name Field
// //               _buildTextField(
// //                 label: 'Full Name',
// //                 controller: _fullNameController,
// //                 hintText: 'Enter your full name',
// //               ),
// //               const SizedBox(height: 20),

// //               // Phone Number Field with Country Code
// //               _buildPhoneField(),
// //               const SizedBox(height: 20),

// //               // Email Field
// //               _buildTextField(
// //                 label: 'Email',
// //                 controller: _emailController,
// //                 keyboardType: TextInputType.emailAddress,
// //                 hintText: 'Enter your email address',
// //               ),
// //               const SizedBox(height: 20),

// //               // Message Field
// //               _buildTextField(
// //                 label: 'Message',
// //                 controller: _messageController,
// //                 maxLines: 5,
// //                 hintText: 'Enter your message',
// //               ),
// //               const SizedBox(height: 32),

// //               // Send Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: _submitForm,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFFFFB84D),
// //                     foregroundColor: const Color(0xFF2D5A5A),
// //                     padding: const EdgeInsets.symmetric(vertical: 16),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     elevation: 0,
// //                   ),
// //                   child: const Text(
// //                     'Send',
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// //entryform part
// // // ignore_for_file: use_build_context_synchronously

// // import 'dart:io';
// // import 'package:eventsolutions/model/all_events_model.dart';
// // import 'package:eventsolutions/provider/event/event_provider.dart';
// // import 'package:eventsolutions/provider/image_provider.dart';
// // import 'package:eventsolutions/validation/form_validation.dart';
// // import 'package:eventsolutions/view/ticket_qr.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class EntryForm extends ConsumerStatefulWidget {
// //   const EntryForm({super.key, required this.events});
// //   final Data events;

// //   @override
// //   ConsumerState<ConsumerStatefulWidget> createState() => _EntryFormState();
// // }

// // class _EntryFormState extends ConsumerState<EntryForm> {
// //   Future<void> _saveTicketId(String ticketId) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('lastTicketId', ticketId);
// //   }

// //   final fullNameKey = GlobalKey<FormFieldState>();
// //   final emailKey = GlobalKey<FormFieldState>();
// //   final phoneKey = GlobalKey<FormFieldState>();
// //   final tierKey = GlobalKey<FormFieldState>();

// //   final _formKey = GlobalKey<FormState>();
// //   final fullNameController = TextEditingController();
// //   final phoneController = TextEditingController();
// //   final emailController = TextEditingController();
// //   bool _isLoading = false;

// //   @override
// //   void dispose() {
// //     fullNameController.dispose();
// //     phoneController.dispose();
// //     emailController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       ref.read(selectedTierProvider.notifier).state = null;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenSize = MediaQuery.of(context).size;
// //     final screenWidth = screenSize.width;
// //     final screenHeight = screenSize.height;
// //     final baseUrlImage = 'http://182.93.94.210:8000';
// //     final selectedImage = ref.watch(imagePickerProvider);

// //     return Scaffold(
// //       resizeToAvoidBottomInset: true, // Allow keyboard to adjust layout
// //       body: Stack(
// //         children: [
// //           Padding(
// //             padding: EdgeInsets.only(
// //               right: screenWidth * 0.05,
// //               left: screenWidth * 0.05,
// //               top: screenHeight * 0.05,
// //               bottom: screenHeight * 0.01,
// //             ),
// //             child: SingleChildScrollView(
// //               scrollDirection: Axis.vertical,
// //               child: Column(
// //                 children: [
// //                   Text(
// //                     widget.events.title,
// //                     style: TextStyle(
// //                       fontSize: 20,
// //                       letterSpacing: 1.5,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.red,
// //                     ),
// //                   ),
// //                   SizedBox(height: 10),
// //                   ClipRRect(
// //                     borderRadius: BorderRadius.circular(15),
// //                     child: (widget.events.poster != null &&
// //                             widget.events.poster!.isNotEmpty)
// //                         ? Image.network(
// //                             '$baseUrlImage${widget.events.poster}',
// //                             height: screenHeight * 0.2,
// //                             width: double.infinity,
// //                             fit: BoxFit.cover,
// //                             errorBuilder: (context, error, stackTrace) {
// //                               return Image.asset('assets/event1.png');
// //                             },
// //                           )
// //                         : Image.asset(
// //                             'assets/event1.png',
// //                             height: screenHeight * 0.2,
// //                             width: double.infinity,
// //                             fit: BoxFit.cover,
// //                           ),
// //                   ),
// //                   SizedBox(height: 10),
// //                   Text(
// //                     widget.events.description,
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       letterSpacing: 0.5,
// //                       wordSpacing: 1,
// //                     ),
// //                   ),
// //                   SizedBox(height: 15),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Consumer(
// //                         builder: (context, ref, child) {
// //                           final selectedTier = ref.watch(selectedTierProvider);
// //                           final price = selectedTier != null
// //                               ? widget.events.ticketTiers
// //                                   .firstWhere(
// //                                       (tier) => tier.name == selectedTier,
// //                                       orElse: () =>
// //                                           widget.events.ticketTiers[0])
// //                                   .price
// //                               : widget.events.ticketTiers.isNotEmpty
// //                                   ? widget.events.ticketTiers[0].price
// //                                   : 'N/A';
// //                           return Text(
// //                             'Price: $price',
// //                             style: TextStyle(
// //                               color: Colors.orange,
// //                               fontWeight: FontWeight.w500,
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                       Text('Location: Kathmandu'),
// //                     ],
// //                   ),
// //                   SizedBox(height: 20),
// //                   ShaderMask(
// //                     shaderCallback: (Rect bounds) {
// //                       return LinearGradient(
// //                         begin: Alignment.centerRight,
// //                         end: Alignment.centerLeft,
// //                         colors: [
// //                           Colors.transparent,
// //                           Colors.black,
// //                           Colors.black,
// //                           Colors.transparent,
// //                         ],
// //                         stops: [0.0, 0.2, 0.7, 1],
// //                       ).createShader(bounds);
// //                     },
// //                     blendMode: BlendMode.dstIn,
// //                     child: Container(
// //                       height: 1,
// //                       color: Colors.grey,
// //                     ),
// //                   ),
// //                   SizedBox(height: 30),
// //                   Consumer(
// //                     builder: (context, ref, child) {
// //                       final tiers = widget.events.ticketTiers;
// //                       final currentSelectedTier =
// //                           ref.watch(selectedTierProvider);
// //                       final isValidTier =
// //                           tiers.any((tier) => tier.name == currentSelectedTier);
// //                       final selectedTier =
// //                           isValidTier ? currentSelectedTier : null;

// //                       return Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           RichText(
// //                             text: TextSpan(
// //                               text: 'Ticket Tier',
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Color(0xFF2D5A5A),
// //                               ),
// //                               children: [
// //                                 TextSpan(
// //                                   text: ' *',
// //                                   style: TextStyle(color: Colors.red),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           SizedBox(height: 8),
// //                           DropdownButtonFormField<String>(
// //                             key: tierKey,
// //                             value: selectedTier,
// //                             hint: Text('Select a ticket tier'),
// //                             isExpanded: true,
// //                             items: tiers.isEmpty
// //                                 ? [
// //                                     DropdownMenuItem(
// //                                       value: null,
// //                                       enabled: false,
// //                                       child: Text('No tiers available'),
// //                                     ),
// //                                   ]
// //                                 : tiers.map((tier) {
// //                                     return DropdownMenuItem(
// //                                       value: tier.name,
// //                                       child: Text(tier.name),
// //                                     );
// //                                   }).toList(),
// //                             onChanged: tiers.isEmpty
// //                                 ? null
// //                                 : (value) {
// //                                     ref
// //                                         .read(selectedTierProvider.notifier)
// //                                         .state = value;
// //                                   },
// //                             validator: (value) {
// //                               if (value == null && tiers.isNotEmpty) {
// //                                 return 'Please select a ticket tier';
// //                               }
// //                               return null;
// //                             },
// //                             decoration: InputDecoration(
// //                               filled: true,
// //                               border: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(12),
// //                                 borderSide: BorderSide.none,
// //                               ),
// //                               contentPadding: EdgeInsets.symmetric(
// //                                 horizontal: 16,
// //                                 vertical: 12,
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(height: 30),
// //                         ],
// //                       );
// //                     },
// //                   ),
// //                   Consumer(
// //                     builder: (context, ref, child) {
// //                       final selectedTier = ref.watch(selectedTierProvider);
// //                       return Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             'Features:',
// //                             style: TextStyle(
// //                               color: Colors.orange,
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 16,
// //                             ),
// //                           ),
// //                           SizedBox(height: 8),
// //                           if (selectedTier == null)
// //                             Text(
// //                               'Select ticket tier to see the features',
// //                               style: TextStyle(
// //                                 color: Colors.grey[700],
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             )
// //                           else
// //                             ...widget.events.ticketTiers
// //                                 .firstWhere(
// //                                   (tier) => tier.name == selectedTier,
// //                                   orElse: () => widget.events.ticketTiers[0],
// //                                 )
// //                                 .listofFeatures
// //                                 .cast<String>()
// //                                 .map((feature) => Padding(
// //                                       padding: EdgeInsets.only(bottom: 4),
// //                                       child: Row(
// //                                         crossAxisAlignment:
// //                                             CrossAxisAlignment.start,
// //                                         children: [
// //                                           Text(
// //                                             '• ',
// //                                             style: TextStyle(
// //                                               color: Colors.orange,
// //                                               fontSize: 16,
// //                                             ),
// //                                           ),
// //                                           Expanded(
// //                                             child: Text(
// //                                               feature.trim(),
// //                                               style: TextStyle(
// //                                                 color: Colors.grey[700],
// //                                                 fontWeight: FontWeight.bold,
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     )),
// //                         ],
// //                       );
// //                     },
// //                   ),
// //                   SizedBox(height: 15),
// //                   Form(
// //                     key: _formKey,
// //                     child: Column(
// //                       children: [
// //                         buildTextField(
// //                           fieldKey: fullNameKey,
// //                           label: 'Full Name',
// //                           controller: fullNameController,
// //                         ),
// //                         buildTextField(
// //                           fieldKey: emailKey,
// //                           label: 'Email',
// //                           controller: emailController,
// //                         ),
// //                         buildTextField(
// //                           fieldKey: phoneKey,
// //                           label: 'Phone Number',
// //                           hintText:
// //                               'Enter phone number with country code (e.g. +977)',
// //                           controller: phoneController,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   Text(
// //                     '''Please do payment in this QR code and send the payment screenshot below and wait till the payment is verified''',
// //                     softWrap: true,
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFF2D5A5A),
// //                     ),
// //                   ),
// //                   SizedBox(height: 12),
// //                   qrCode(),
// //                   SizedBox(height: 25),
// //                   buildImageUploadSection(context, ref, selectedImage),
// //                   ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.black,
// //                       elevation: 2,
// //                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //                     ),
// //                     onPressed: _isLoading
// //                         ? null
// //                         : () async {
// //                             if (_formKey.currentState!.validate()) {
// //                               if (selectedImage == null) {
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(
// //                                     backgroundColor: Colors.red,
// //                                     content: Text(
// //                                         'Please upload a payment screenshot'),
// //                                   ),
// //                                 );
// //                                 return;
// //                               }

// //                               // Validate file type
// //                               final fileExtension = selectedImage.path
// //                                   .toLowerCase()
// //                                   .split('.')
// //                                   .last;
// //                               if (!['png', 'jpg', 'jpeg']
// //                                   .contains(fileExtension)) {
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(
// //                                     backgroundColor: Colors.red,
// //                                     content: Text(
// //                                         'Payment screenshot must be a PNG or JPEG image'),
// //                                   ),
// //                                 );
// //                                 return;
// //                               }

// //                               final selectedTier =
// //                                   ref.read(selectedTierProvider);
// //                               if (selectedTier == null &&
// //                                   widget.events.ticketTiers.isNotEmpty) {
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(
// //                                     backgroundColor: Colors.red,
// //                                     content:
// //                                         Text('Please select a ticket tier'),
// //                                   ),
// //                                 );
// //                                 return;
// //                               }

// //                               if (widget.events.ticketTiers.isEmpty) {
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(
// //                                     backgroundColor: Colors.red,
// //                                     content: Text(
// //                                         'No ticket tiers available for this event'),
// //                                   ),
// //                                 );
// //                                 return;
// //                               }

// //                               setState(() {
// //                                 _isLoading = true;
// //                               });

// //                               try {
// //                                 final registrationData = {
// //                                   'email': emailController.text,
// //                                   'name': fullNameController.text,
// //                                   'number': phoneController.text,
// //                                   'tierName': selectedTier ??
// //                                       widget.events.ticketTiers[0].name,
// //                                   'paymentScreenshot': File(selectedImage.path),
// //                                   'eventId': widget.events.eventId,
// //                                 };

// //                                 final response = await ref.read(
// //                                   registerEventProvider(registrationData)
// //                                       .future,
// //                                 );

// //                                 // Clear form fields
// //                                 fullNameController.clear();
// //                                 emailController.clear();
// //                                 phoneController.clear();
// //                                 ref
// //                                     .read(imagePickerProvider.notifier)
// //                                     .clearImage();
// //                                 ref.read(selectedTierProvider.notifier).state =
// //                                     null;

// //                                 // Success dialog with ticket information
// //                                 // showAdaptiveDialog(
// //                                 //   context: context,
// //                                 //   builder: (context) {
// //                                 //     return AlertDialog(
// //                                 //       shape: RoundedRectangleBorder(
// //                                 //         borderRadius: BorderRadius.circular(16),
// //                                 //       ),
// //                                 //       backgroundColor: Colors.white,
// //                                 //       contentPadding: EdgeInsets.all(20),
// //                                 //       titlePadding: EdgeInsets.all(10),
// //                                 //       title: Text(
// //                                 //         'Registration Successful!',
// //                                 //         style: TextStyle(
// //                                 //           fontSize: 18,
// //                                 //           fontWeight: FontWeight.bold,
// //                                 //           color: Colors.green,
// //                                 //         ),
// //                                 //       ),
// //                                 //       content: Column(
// //                                 //         mainAxisSize: MainAxisSize.min,
// //                                 //         children: [
// //                                 //           Icon(
// //                                 //             Icons.check_circle_outline,
// //                                 //             size: 60,
// //                                 //             color: Colors.green,
// //                                 //           ),
// //                                 //           SizedBox(height: 16),
// //                                 //           Text(
// //                                 //             'Ticket ID: ${response.ticketId}',
// //                                 //             style: TextStyle(
// //                                 //               fontSize: 14,
// //                                 //               fontWeight: FontWeight.bold,
// //                                 //               color: Colors.blue,
// //                                 //             ),
// //                                 //           ),
// //                                 //           SizedBox(height: 8),
// //                                 //           Text(
// //                                 //             'Status: ${response.status.toUpperCase()}',
// //                                 //             style: TextStyle(
// //                                 //               fontSize: 14,
// //                                 //               fontWeight: FontWeight.bold,
// //                                 //               color:
// //                                 //                   response.status == 'pending'
// //                                 //                       ? Colors.orange
// //                                 //                       : Colors.green,
// //                                 //             ),
// //                                 //           ),
// //                                 //           SizedBox(height: 16),
// //                                 //           Text(
// //                                 //             response.status == 'pending'
// //                                 //                 ? 'Your registration is pending payment verification. You will receive the ticket once verified.'
// //                                 //                 : 'Your registration is confirmed! Check for the ticket.',
// //                                 //             textAlign: TextAlign.center,
// //                                 //             style: TextStyle(
// //                                 //               fontSize: 16,
// //                                 //               color: Colors.black,
// //                                 //             ),
// //                                 //           ),
// //                                 //         ],
// //                                 //       ),
// //                                 //       actions: [
// //                                 //         Row(
// //                                 //           mainAxisAlignment:
// //                                 //               MainAxisAlignment.spaceBetween,
// //                                 //           children: [
// //                                 //             ElevatedButton(
// //                                 //               onPressed: () {
// //                                 //                 Navigator.pop(context);
// //                                 //                 Navigator.pop(
// //                                 //                     context); // Navigate back to event list
// //                                 //               },
// //                                 //               child: Text(
// //                                 //                 'OK',
// //                                 //                 style: TextStyle(
// //                                 //                   fontSize: 16,
// //                                 //                   fontWeight: FontWeight.bold,
// //                                 //                   color: Colors.blue,
// //                                 //                 ),
// //                                 //               ),
// //                                 //             ),
// //                                 //             // ElevatedButton(
// //                                 //             //   onPressed: () {
// //                                 //             //     Navigator.push(
// //                                 //             //       context,
// //                                 //             //       MaterialPageRoute(
// //                                 //             //         builder: (context) =>
// //                                 //             //             TicketQr(
// //                                 //             //                 ticketId: response
// //                                 //             //                     .ticketId),
// //                                 //             //       ),
// //                                 //             //     );
// //                                 //             //   },
// //                                 //             //   child: Text(
// //                                 //             //     'View QR',
// //                                 //             //     style: TextStyle(
// //                                 //             //       fontSize: 16,
// //                                 //             //       fontWeight: FontWeight.bold,
// //                                 //             //       color: Colors.blue,
// //                                 //             //     ),
// //                                 //             //   ),
// //                                 //             // ),
// //                                 //           ],
// //                                 //         ),
// //                                 //       ],
// //                                 //     );
// //                                 //   },
// //                                 // );

// //                                 showAdaptiveDialog(
// //                                   context: context,
// //                                   builder: (context) {
// //                                     return AlertDialog(
// //                                       shape: RoundedRectangleBorder(
// //                                         borderRadius: BorderRadius.circular(16),
// //                                       ),
// //                                       backgroundColor: Colors.white,
// //                                       contentPadding: EdgeInsets.all(20),
// //                                       titlePadding: EdgeInsets.all(10),
// //                                       title: Text(
// //                                         'Registration Successful!',
// //                                         style: TextStyle(
// //                                           fontSize: 18,
// //                                           fontWeight: FontWeight.bold,
// //                                           color: Colors.green,
// //                                         ),
// //                                       ),
// //                                       content: Column(
// //                                         mainAxisSize: MainAxisSize.min,
// //                                         children: [
// //                                           Icon(
// //                                             Icons.check_circle_outline,
// //                                             size: 60,
// //                                             color: Colors.green,
// //                                           ),
// //                                           SizedBox(height: 16),
// //                                           Text(
// //                                             'Ticket ID: ${response.ticketId}',
// //                                             style: TextStyle(
// //                                               fontSize: 14,
// //                                               fontWeight: FontWeight.bold,
// //                                               color: Colors.blue,
// //                                             ),
// //                                           ),
// //                                           SizedBox(height: 8),
// //                                           Text(
// //                                             'Status: ${response.status.toUpperCase()}',
// //                                             style: TextStyle(
// //                                               fontSize: 14,
// //                                               fontWeight: FontWeight.bold,
// //                                               color:
// //                                                   response.status == 'pending'
// //                                                       ? Colors.orange
// //                                                       : Colors.green,
// //                                             ),
// //                                           ),
// //                                           SizedBox(height: 16),
// //                                           Text(
// //                                             response.status == 'pending'
// //                                                 ? 'Your registration is pending payment verification. You will receive the ticket once verified.'
// //                                                 : 'Your registration is confirmed! Check for the ticket.',
// //                                             textAlign: TextAlign.center,
// //                                             style: TextStyle(
// //                                               fontSize: 16,
// //                                               color: Colors.black,
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                       actions: [
// //                                         Row(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.spaceBetween,
// //                                           children: [
// //                                             ElevatedButton(
// //                                               onPressed: () {
// //                                                 Navigator.pop(
// //                                                     context); // Close dialog
// //                                                 Navigator.pop(
// //                                                     context); // Navigate back to event list
// //                                               },
// //                                               child: Text(
// //                                                 'OK',
// //                                                 style: TextStyle(
// //                                                   fontSize: 16,
// //                                                   fontWeight: FontWeight.bold,
// //                                                   color: Colors.blue,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                             ElevatedButton(
// //                                               onPressed: response.status ==
// //                                                       'approved'
// //                                                   ? () {
// //                                                       Navigator.push(
// //                                                         context,
// //                                                         MaterialPageRoute(
// //                                                           builder: (context) =>
// //                                                               TicketQr(
// //                                                                   ticketId: response
// //                                                                       .ticketId),
// //                                                         ),
// //                                                       );
// //                                                     }
// //                                                   : null, // Disable if not approved
// //                                               child: Text(
// //                                                 'View QR',
// //                                                 style: TextStyle(
// //                                                   fontSize: 16,
// //                                                   fontWeight: FontWeight.bold,
// //                                                   color: response.status ==
// //                                                           'approved'
// //                                                       ? Colors.blue
// //                                                       : Colors.grey,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ],
// //                                     );
// //                                   },
// //                                 );
// //                               } catch (e) {
// //                                 String errorMessage = 'Something went wrong';
// //                                 if (e.toString().contains('Exception:')) {
// //                                   errorMessage = e
// //                                       .toString()
// //                                       .replaceFirst('Exception: ', '');
// //                                 }

// //                                 showAdaptiveDialog(
// //                                   context: context,
// //                                   builder: (context) {
// //                                     return AlertDialog(
// //                                       shape: RoundedRectangleBorder(
// //                                         borderRadius: BorderRadius.circular(16),
// //                                       ),
// //                                       backgroundColor: Colors.white,
// //                                       contentPadding: EdgeInsets.all(20),
// //                                       titlePadding: EdgeInsets.all(10),
// //                                       title: Text(
// //                                         'Registration Failed',
// //                                         style: TextStyle(
// //                                           fontSize: 18,
// //                                           fontWeight: FontWeight.bold,
// //                                           color: Colors.red,
// //                                         ),
// //                                       ),
// //                                       content: Column(
// //                                         mainAxisSize: MainAxisSize.min,
// //                                         children: [
// //                                           Icon(
// //                                             Icons.error_outline,
// //                                             size: 60,
// //                                             color: Colors.red,
// //                                           ),
// //                                           SizedBox(height: 16),
// //                                           Text(
// //                                             errorMessage,
// //                                             textAlign: TextAlign.center,
// //                                             style: TextStyle(
// //                                               fontSize: 16,
// //                                               color: Colors.black,
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                       actions: [
// //                                         Center(
// //                                           child: ElevatedButton(
// //                                             onPressed: () {
// //                                               Navigator.pop(context);
// //                                             },
// //                                             child: Text(
// //                                               'OK',
// //                                               style: TextStyle(
// //                                                 fontSize: 16,
// //                                                 fontWeight: FontWeight.bold,
// //                                                 color: Colors.blue,
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     );
// //                                   },
// //                                 );
// //                               } finally {
// //                                 setState(() {
// //                                   _isLoading = false;
// //                                 });
// //                               }
// //                             } else {
// //                               final errorFields = [
// //                                 fullNameKey,
// //                                 emailKey,
// //                                 phoneKey,
// //                                 tierKey
// //                               ];
// //                               for (var key in errorFields) {
// //                                 if (key.currentState?.hasError ?? false) {
// //                                   final context = key.currentContext;
// //                                   if (context != null) {
// //                                     Scrollable.ensureVisible(
// //                                       context,
// //                                       duration: Duration(milliseconds: 300),
// //                                       curve: Curves.easeInOut,
// //                                     );
// //                                   }
// //                                   break;
// //                                 }
// //                               }
// //                             }
// //                           },
// //                     child: _isLoading
// //                         ? CircularProgressIndicator(color: Colors.white)
// //                         : Text(
// //                             'Proceed',
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                   ),
// //                   SizedBox(height: 20),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           if (_isLoading)
// //             Container(
// //               color: Colors.black.withAlpha(50),
// //               child: Center(
// //                 child: CircularProgressIndicator(),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget qrCode() {
// //     return SizedBox(
// //       width: double.infinity,
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(20),
// //         child: Image.asset(
// //           'assets/qrcode.png',
// //           fit: BoxFit.contain,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildImageUploadSection(
// //       BuildContext context, WidgetRef ref, XFile? selectedImage) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         RichText(
// //           text: TextSpan(
// //             text: 'Payment screenshot',
// //             style: const TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //               color: Color(0xFF2D5A5A),
// //             ),
// //             children: [
// //               const TextSpan(
// //                 text: ' *',
// //                 style: TextStyle(color: Colors.red),
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         GestureDetector(
// //           onTap: () => _showImageSourceDialog(context, ref),
// //           child: Container(
// //             width: double.infinity,
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(12),
// //               border: Border.all(color: Colors.grey[300]!),
// //             ),
// //             child: selectedImage != null
// //                 ? ClipRRect(
// //                     borderRadius: BorderRadius.circular(12),
// //                     child: Image.file(
// //                       File(selectedImage.path),
// //                       fit: BoxFit.cover,
// //                     ),
// //                   )
// //                 : SizedBox(
// //                     height: 200,
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       mainAxisSize: MainAxisSize.max,
// //                       children: [
// //                         Icon(
// //                           Icons.camera_alt_outlined,
// //                           size: 50,
// //                           color: Colors.grey[400],
// //                         ),
// //                         const SizedBox(height: 10),
// //                         Text(
// //                           'Tap to upload payment screenshot',
// //                           style: TextStyle(
// //                             color: Colors.black,
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //           ),
// //         ),
// //         SizedBox(height: 10),
// //       ],
// //     );
// //   }

// //   void _showImageSourceDialog(BuildContext context, WidgetRef ref) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('Select Image Source'),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               ListTile(
// //                 leading: const Icon(Icons.camera_alt),
// //                 title: const Text('Camera'),
// //                 onTap: () async {
// //                   Navigator.of(context).pop();
// //                   try {
// //                     await ref.read(imagePickerProvider.notifier).fromCamera();
// //                   } catch (e) {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('Camera error: $e')),
// //                     );
// //                   }
// //                 },
// //               ),
// //               ListTile(
// //                 leading: const Icon(Icons.photo_library),
// //                 title: const Text('Gallery'),
// //                 onTap: () async {
// //                   Navigator.of(context).pop();
// //                   try {
// //                     await ref.read(imagePickerProvider.notifier).fromGallery();
// //                   } catch (e) {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('Gallery error: $e')),
// //                     );
// //                   }
// //                 },
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget buildTextField({
// //     required String label,
// //     TextEditingController? controller,
// //     bool isRequired = true,
// //     TextInputType keyboardType = TextInputType.text,
// //     int maxLines = 1,
// //     String? hintText,
// //     Image? image,
// //     TextButton? button,
// //     required GlobalKey<FormFieldState> fieldKey,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         RichText(
// //           text: TextSpan(
// //             text: label,
// //             style: const TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //               color: Color(0xFF2D5A5A),
// //             ),
// //             children: isRequired
// //                 ? [
// //                     const TextSpan(
// //                       text: ' *',
// //                       style: TextStyle(color: Colors.red),
// //                     ),
// //                   ]
// //                 : [],
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         TextFormField(
// //           key: fieldKey,
// //           controller: controller,
// //           keyboardType: keyboardType,
// //           maxLines: maxLines,
// //           validator: isRequired
// //               ? (value) {
// //                   if (value == null || value.trim().isEmpty) {
// //                     return 'This field is required';
// //                   }
// //                   if (label == 'Email') {
// //                     return MyValidation.validateEmail(value);
// //                   }
// //                   if (label == 'Phone Number') {
// //                     return MyValidation.validateMobile(value);
// //                   }
// //                   return null;
// //                 }
// //               : null,
// //           decoration: InputDecoration(
// //             hintText: hintText,
// //             hintStyle: TextStyle(
// //               color: Colors.grey[400],
// //               fontSize: 14,
// //             ),
// //             filled: true,
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(12),
// //               borderSide: BorderSide.none,
// //             ),
// //             contentPadding: const EdgeInsets.symmetric(
// //               horizontal: 16,
// //               vertical: 12,
// //             ),
// //           ),
// //         ),
// //         SizedBox(height: 30),
// //       ],
// //     );
// //   }
// // }


// //ticketQR
// // import 'package:eventsolutions/provider/event/event_provider.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // // class TicketQr extends ConsumerWidget {
// // //   final String ticketId;

// // //   const TicketQr({super.key, required this.ticketId});

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final ticketAsync = ref.watch(ticketProvider(ticketId));

// // //     return Scaffold(
// // //       appBar: AppBar(title: Text('Ticket Details')),
// // //       body: ticketAsync.when(
// // //         data: (ticket) => Padding(
// // //           padding: const EdgeInsets.all(16.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text('Event: ${ticket.eventName}',
// // //                   style: TextStyle(fontSize: 18)),
// // //               Text('Name: ${ticket.name}'),
// // //               Text('Status: ${ticket.status}'),
// // //               Text('QR: ${ticket.qr ?? "No QR code"}'),
// // //               // You can list features too
// // //             ],
// // //           ),
// // //         ),
// // //         loading: () => Center(child: CircularProgressIndicator()),
// // //         error: (err, _) => Center(child: Text('Error: $err')),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:eventsolutions/provider/event/event_provider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:eventsolutions/services/event_services.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:eventsolutions/model/ticket_model.dart';

// // class TicketQr extends ConsumerWidget {
// //   final String? ticketId; // Optional parameter for direct navigation

// //   const TicketQr({super.key, this.ticketId});

// //   Future<String?> _getStoredTicketId() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString('lastTicketId');
// //   }

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final ticketService = ref.read(eventServiceProvider);

// //     return FutureBuilder<TicketData>(
// //       future: _getStoredTicketId().then((storedTicketId) async {
// //         final effectiveTicketId = ticketId ?? storedTicketId;
// //         if (effectiveTicketId == null) {
// //           throw Exception('No ticket ID available');
// //         }
// //         return await ticketService.fetchTicketDetails();
// //       }),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return Scaffold(body: Center(child: CircularProgressIndicator()));
// //         }

// //         if (snapshot.hasError) {
// //           return Scaffold(
// //             body: Center(child: Text('Error: ${snapshot.error}')),
// //           );
// //         }

// //         final ticketData = snapshot.data!;
// //         final baseUrl = 'http://182.93.94.210:8000';

// //         return Scaffold(
// //           appBar: AppBar(title: Text('Ticket Details')),
// //           body: Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Ticket ID: ${ticketData.ticketId}'),
// //                 Text('Event: ${ticketData.eventName}'),
// //                 Text('Status: ${ticketData.status.toUpperCase()}'),
// //                 SizedBox(height: 20),
// //                 if (ticketData.status == 'approved' && ticketData.qr != null)
// //                   Column(
// //                     children: [
// //                       Text('QR Code:',
// //                           style: TextStyle(fontWeight: FontWeight.bold)),
// //                       SizedBox(height: 10),
// //                       Image.network(
// //                         '$baseUrl${ticketData.qr}',
// //                         errorBuilder: (context, error, stackTrace) {
// //                           return Text('Failed to load QR code');
// //                         },
// //                       ),
// //                     ],
// //                   )
// //                 else if (ticketData.status == 'pending')
// //                   Text(
// //                     'Your ticket is pending verification. Please check back later.',
// //                     style: TextStyle(color: Colors.orange),
// //                   ),
// //                 Text('No QR code available.'),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }


// // class OngoingEventModel {
// //   final bool success;
// //   final String? error;
// //   final List<OngoingData> data;

// //   OngoingEventModel({required this.success, this.error, required this.data});

// //   factory OngoingEventModel.fromJson(Map<String, dynamic> json) {
// //     return OngoingEventModel(
// //       success: json['success'],
// //       error: json['error'],
// //       data: List<OngoingData>.from(
// //           json['data'].map((e) => OngoingData.fromJson(e))),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'success': success,
// //       'error': error,
// //       'data': data.map((e) => e.toJson()).toList(),
// //     };
// //   }
// // }

// // class OngoingData {
// //   final String? poster;
// //   final String title;
// //   final String description;
// //   final String startDate;
// //   final String endDate;
// //   final List<OngoingTicketTier> ticketTiers;
// //   final String eventId;

// //   OngoingData({
// //     this.poster,
// //     required this.eventId,
// //     required this.title,
// //     required this.description,
// //     required this.startDate,
// //     required this.endDate,
// //     required this.ticketTiers,
// //   });

// //   factory OngoingData.fromJson(Map<String, dynamic> json) {
// //     return OngoingData(
// //       title: json['title'],
// //       eventId: json['eventId'],
// //       poster: json['poster'],
// //       description: json['description'],
// //       startDate: json['startDateTime'],
// //       endDate: json['endDateTime'],
// //       ticketTiers: List<OngoingTicketTier>.from(
// //         json['ticketTiers'].map((e) => OngoingTicketTier.fromJson(e)),
// //       ),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'title': title,
// //       'poster': poster,
// //       'description': description,
// //       'startDateTime': startDate,
// //       'endDateTime': endDate,
// //       'ticketTiers': ticketTiers.map((e) => e.toJson()).toList(),
// //       'eventId': eventId,
// //     };
// //   }
// // }

// // class OngoingTicketTier {
// //   final String name;
// //   final double price;
// //   List<String> listofFeatures;

// //   OngoingTicketTier({
// //     required this.name,
// //     required this.price,
// //     required this.listofFeatures,
// //   });

// //   factory OngoingTicketTier.fromJson(Map<String, dynamic> json) {
// //     return OngoingTicketTier(
// //       name: json['name'],
// //       price: (json['price'] as num).toDouble(),
// //       listofFeatures: List<String>.from(json['listOfFeatures']),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'name': name,
// //       'price': price,
// //       'listOfFeatures': listofFeatures,
// //     };
// //   }
// // }


// // class UpcomingEventModel {
// //   final bool success;
// //   final String? error;
// //   final List<UpcomingData> data;

// //   UpcomingEventModel({required this.success, this.error, required this.data});

// //   factory UpcomingEventModel.fromJson(Map<String, dynamic> json) {
// //     return UpcomingEventModel(
// //       success: json['success'],
// //       error: json['error'],
// //       data: List<UpcomingData>.from(
// //           json['data'].map((e) => UpcomingData.fromJson(e))),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'success': success,
// //       'error': error,
// //       'data': data.map((e) => e.toJson()).toList(),
// //     };
// //   }
// // }

// // class UpcomingData {
// //   final String? poster;
// //   final String title;
// //   final String description;
// //   final String startDate;
// //   final String endDate;
// //   final List<UpcomingTicketTier> ticketTiers;
// //   final String eventId;

// //   UpcomingData({
// //     this.poster,
// //     required this.eventId,
// //     required this.title,
// //     required this.description,
// //     required this.startDate,
// //     required this.endDate,
// //     required this.ticketTiers,
// //   });

// //   factory UpcomingData.fromJson(Map<String, dynamic> json) {
// //     return UpcomingData(
// //       title: json['title'],
// //       eventId: json['eventId'],
// //       poster: json['poster'],
// //       description: json['description'],
// //       startDate: json['startDateTime'],
// //       endDate: json['endDateTime'],
// //       ticketTiers: List<UpcomingTicketTier>.from(
// //         json['ticketTiers'].map((e) => UpcomingTicketTier.fromJson(e)),
// //       ),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'title': title,
// //       'poster': poster,
// //       'description': description,
// //       'startDateTime': startDate,
// //       'endDateTime': endDate,
// //       'ticketTiers': ticketTiers.map((e) => e.toJson()).toList(),
// //       'eventId': eventId,
// //     };
// //   }
// // }

// // class UpcomingTicketTier {
// //   final String name;
// //   final double price;
// //   List<String> listofFeatures;

// //   UpcomingTicketTier({
// //     required this.name,
// //     required this.price,
// //     required this.listofFeatures,
// //   });

// //   factory UpcomingTicketTier.fromJson(Map<String, dynamic> json) {
// //     return UpcomingTicketTier(
// //       name: json['name'],
// //       price: (json['price'] as num).toDouble(),
// //       listofFeatures: List<String>.from(json['listOfFeatures']),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'name': name,
// //       'price': price,
// //       'listOfFeatures': listofFeatures,
// //     };
// //   }
// // }





// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // // class UpcomingEvents extends ConsumerWidget {
// // //   const UpcomingEvents({super.key});

// // //   String formatDateManually(DateTime dateTime) {
// // //     String day = dateTime.day.toString().padLeft(2, '0');

// // //     List<String> months = [
// // //       'Jan',
// // //       'Feb',
// // //       'Mar',
// // //       'Apr',
// // //       'May',
// // //       'Jun',
// // //       'Jul',
// // //       'Aug',
// // //       'Sep',
// // //       'Oct',
// // //       'Nov',
// // //       'Dec'
// // //     ];
// // //     String month = months[dateTime.month - 1];

// // //     // Get last two digits of year
// // //     String year = (dateTime.year % 100).toString().padLeft(2, '0');

// // //     return '$day $month, $year';
// // //   }

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     return Container(
// // //       color: const Color(0xffF4F4F4),
// // //       child: ListView(
// // //         padding: const EdgeInsets.symmetric(vertical: 12),
// // //         children: [
// // //           ongoingEvents(context, 'assets/user1.jpeg', 'Designers Meetup 2022',
// // //               '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// // //           ongoingEvents(context, 'assets/user2.png', 'Designers Meetup 2022',
// // //               '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// // //           ongoingEvents(context, 'assets/user3.jpeg', 'Designers Meetup 2022',
// // //               '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// // //           ongoingEvents(context, 'assets/image.png', 'Designers Meetup 2022',
// // //               '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// // //           ongoingEvents(context, 'assets/user4.jpg', 'Designers Meetup 2022',
// // //               '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// // //           ongoingEvents(context, 'assets/user5.jpg', 'Designers Meetup 2022',
// // //               '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget ongoingEvents(
// // //     BuildContext context,
// // //     String image,
// // //     String title,
// // //     String date,
// // //     String locationText,
// // //     String price,
// // //   ) {
// // //     return Card(
// // //       margin: const EdgeInsets.only(bottom: 25),
// // //       color: Colors.white,
// // //       elevation: 0,
// // //       shape: RoundedRectangleBorder(
// // //           borderRadius: BorderRadius.circular(20),
// // //           side: BorderSide(color: Colors.transparent)),
// // //       child: SizedBox(
// // //         height: 72,
// // //         child: Row(
// // //           children: [
// // //             ClipRRect(
// // //               borderRadius: BorderRadius.circular(15),
// // //               child: Image.asset(
// // //                 image,
// // //                 width: 72,
// // //                 height: 72,
// // //                 fit: BoxFit.cover,
// // //               ),
// // //             ),
// // //             Expanded(
// // //               child: Padding(
// // //                 padding:
// // //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     Text(
// // //                       title,
// // //                       style: const TextStyle(
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 15,
// // //                       ),
// // //                       maxLines: 1,
// // //                       overflow: TextOverflow.ellipsis,
// // //                     ),
// // //                     SizedBox(height: 4),
// // //                     Row(
// // //                       children: [
// // //                         Flexible(
// // //                           child: Text(
// // //                             date,
// // //                             style: TextStyle(
// // //                               fontSize: 10,
// // //                               color: Colors.grey.shade600,
// // //                             ),
// // //                             maxLines: 1,
// // //                             overflow: TextOverflow.ellipsis,
// // //                           ),
// // //                         ),
// // //                         const SizedBox(width: 5),
// // //                         Container(
// // //                           width: 5,
// // //                           height: 5,
// // //                           decoration: const BoxDecoration(
// // //                               shape: BoxShape.circle, color: Colors.orange),
// // //                         ),
// // //                         const SizedBox(width: 5),
// // //                         FittedBox(
// // //                           child: Text(
// // //                             locationText,
// // //                             style: TextStyle(
// // //                               fontSize: 13,
// // //                               color: Colors.grey.shade600,
// // //                             ),
// // //                             maxLines: 1,
// // //                             overflow: TextOverflow.ellipsis,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //             VerticalDivider(
// // //               indent: 10,
// // //               endIndent: 10,
// // //             ),
// // //             Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               crossAxisAlignment: CrossAxisAlignment.center,
// // //               children: [
// // //                 Text(
// // //                   price,
// // //                   style: const TextStyle(
// // //                     color: Colors.orange,
// // //                     fontSize: 14,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //                 TextButton(
// // //                   onPressed: () {},
// // //                   child: Text(
// // //                     'JOIN NOW',
// // //                     style: TextStyle(
// // //                       color: Colors.black,
// // //                       fontSize: 13,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                 )
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:eventsolutions/abstract/event_data.dart';
// // import 'package:eventsolutions/model/events/upcoming.dart';
// // import 'package:eventsolutions/provider/event/event_provider.dart';
// // import 'package:eventsolutions/view/entry_form.dart';
// // import 'package:eventsolutions/view/upcoming_entry_form.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class UpcomingEvents extends ConsumerWidget {
// //   const UpcomingEvents({super.key});

// //   String formatDateManually(DateTime dateTime) {
// //     String day = dateTime.day.toString().padLeft(2, '0');

// //     List<String> months = [
// //       'Jan',
// //       'Feb',
// //       'Mar',
// //       'Apr',
// //       'May',
// //       'Jun',
// //       'Jul',
// //       'Aug',
// //       'Sep',
// //       'Oct',
// //       'Nov',
// //       'Dec'
// //     ];
// //     String month = months[dateTime.month - 1];

// //     // Get last two digits of year
// //     String year = (dateTime.year % 100).toString().padLeft(2, '0');

// //     return '$day $month, $year';
// //   }

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final upcomingEvents = ref.watch(upcomingEventProvider);
// //     final baseUrlImage = 'http://182.93.94.210:8000';
// //     return Container(
// //         color: const Color(0xffF4F4F4),
// //         child: upcomingEvents.when(
// //           data: (upcomingevents) => ListView.builder(
// //             padding: const EdgeInsets.symmetric(vertical: 12),
// //             itemCount: upcomingevents.length,
// //             itemBuilder: (context, index) {
// //               final upcomingevent = upcomingevents[index];
// //               return ongoingEvents(
// //                   context,
// //                   '$baseUrlImage${upcomingevent.poster!}',
// //                   upcomingevent.title,
// //                   upcomingevent.startDate,
// //                   'Kathmandu Nepal',
// //                   upcomingevent.ticketTiers[0].price.toString(),
// //                   upcomingevent);
// //             },
// //           ),
// //           loading: () => const Center(child: CircularProgressIndicator()),
// //           error: (err, stack) => Center(child: Text('Error: $err')),
// //         )

// //         // child: ListView(
// //         //   padding: const EdgeInsets.symmetric(vertical: 12),
// //         //   children: [
// //         //     ongoingEvents(context, 'assets/user1.jpeg', 'Designers Meetup 2022',
// //         //         '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// //         //     ongoingEvents(context, 'assets/user2.png', 'Designers Meetup 2022',
// //         //         '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// //         //     ongoingEvents(context, 'assets/user3.jpeg', 'Designers Meetup 2022',
// //         //         '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// //         //     ongoingEvents(context, 'assets/image.png', 'Designers Meetup 2022',
// //         //         '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// //         //     ongoingEvents(context, 'assets/user4.jpg', 'Designers Meetup 2022',
// //         //         '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// //         //     ongoingEvents(context, 'assets/user5.jpg', 'Designers Meetup 2022',
// //         //         '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
// //         //   ],
// //         // ),
// //         );
// //   }

// //   Widget ongoingEvents(BuildContext context, String image, String title,
// //       String date, String locationText, String price, EventData eventData) {
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 25),
// //       color: Colors.white,
// //       elevation: 0,
// //       shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(20),
// //           side: BorderSide(color: Colors.transparent)),
// //       child: SizedBox(
// //         height: 72,
// //         child: Row(
// //           children: [
// //             ClipRRect(
// //               borderRadius: BorderRadius.circular(15),
// //               child: Image.network(
// //                 image,
// //                 width: 72,
// //                 height: 72,
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //             Expanded(
// //               child: Padding(
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       title,
// //                       style: const TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 15,
// //                       ),
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                     SizedBox(height: 4),
// //                     Row(
// //                       children: [
// //                         Flexible(
// //                           child: Text(
// //                             date,
// //                             style: TextStyle(
// //                               fontSize: 10,
// //                               color: Colors.grey.shade600,
// //                             ),
// //                             maxLines: 1,
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 5),
// //                         Container(
// //                           width: 5,
// //                           height: 5,
// //                           decoration: const BoxDecoration(
// //                               shape: BoxShape.circle, color: Colors.orange),
// //                         ),
// //                         const SizedBox(width: 5),
// //                         FittedBox(
// //                           child: Text(
// //                             locationText,
// //                             style: TextStyle(
// //                               fontSize: 13,
// //                               color: Colors.grey.shade600,
// //                             ),
// //                             maxLines: 1,
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             VerticalDivider(
// //               indent: 10,
// //               endIndent: 10,
// //             ),
// //             Column(
// //               mainAxisSize: MainAxisSize.min,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   price,
// //                   style: const TextStyle(
// //                     color: Colors.orange,
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.push(context,
// //                         MaterialPageRoute(builder: (context) {
// //                       return EntryForm(eventData: eventData);
// //                     }));
// //                   },
// //                   child: Text(
// //                     'JOIN NOW',
// //                     style: TextStyle(
// //                       color: Colors.black,
// //                       fontSize: 13,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

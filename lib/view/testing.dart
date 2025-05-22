import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eventsolutions/provider/event/eventProvider.dart';
import 'package:eventsolutions/view/entry_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TestingPage extends ConsumerWidget {
  const TestingPage({super.key});

  String formatDateManually(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '');

    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    String month = months[dateTime.month - 1];

    // Get last two digits of year
    String year = (dateTime.year % 100).toString().padLeft(2, '0');

    return '$day $month, $year';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final eventsAsyncValue = ref.watch(eventProvider);

    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.008,
        right: screenWidth * 0.03,
        left: screenWidth * 0.03,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: eventsAsyncValue
              .when(
                data: (events) {
                  if (events.isEmpty) {
                    return [
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No events available',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Check back later for upcoming events!',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ];
                  }
                  return events
                      .map((event) => eventCard(
                            context,
                            event.poster ??
                                'assets/default.png', // Fallback image
                            event.title,
                            event.startDate,
                            event.endDate,
                            event.ticketTiers.isNotEmpty
                                ? event.ticketTiers[0].price
                                : 0.0,
                          ))
                      .toList();
                },
                loading: () =>
                    [const Center(child: CircularProgressIndicator())],
                error: (error, stackTrace) {
                  final isUnauthorized = error.toString().contains('401');
                  return [
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Authentication Required',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No valid session. Please log in to view events.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ];
                },
              )
              .toList(),
        ),
      ),
    ));
  }

  Widget eventCard(
    BuildContext context,
    String image,
    String title,
    String startDate,
    String endDate,
    double price,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      // color: Colors.blueGrey,
      color: Colors.white,
      shadowColor: Colors.grey.withAlpha(10),
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
              width: 0, style: BorderStyle.solid, color: Colors.grey)),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                height: screenHeight * 0.2,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                SizedBox(
                  height: 6,
                ),
                FittedBox(
                  child: Text(
                    title,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                ),
                SizedBox(height: 12),
                // Date and Location row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Color(0xffF66B10)),
                        SizedBox(width: 4),
                        Text(
                          startDate != null
                              ? DateFormat('MMM dd, yyyy h:mm a')
                                  .format(DateTime.parse(startDate).toLocal())
                              : 'N/A',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Color(0xffF77018)),
                        SizedBox(width: 4),
                        Text(
                          'Kathmandu, Nepal', // Placeholder, as location is not in the model
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Price: Rs${price.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                    Spacer(),
                    // Join button
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => EntryForm(events: ,)));
                      },
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Color(0xff35353E),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 0),
                      ),
                      child: Text(
                        'JOIN NOW',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EventScreen extends ConsumerWidget {
  const EventScreen({super.key});

  String formatDateManually(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '');

    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    String month = months[dateTime.month - 1];

    // Get last two digits of year
    String year = (dateTime.year % 100).toString().padLeft(2, '0');

    return '$day $month, $year';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final event = ref.watch(eventProvider);

    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.008,
        right: screenWidth * 0.03,
        left: screenWidth * 0.03,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            children: event.when(
          data: (events) {
            if (events.isEmpty) {
              return [
                Center(
                  child: Text('No event found'),
                )
              ];
            }
            return events
                .map((event) => eventCard(
                      context,
                      event.poster ?? 'assets/default.png', // Fallback image
                      event.title,
                      event.startDate,
                      event.endDate,
                      event.ticketTiers.isNotEmpty
                          ? event.ticketTiers[0].price
                          : 0.0,
                    ))
                .toList();
          },
          loading: () => [const Center(child: CircularProgressIndicator())],
          error: (error, stackTrace) {
            return [
              Center(
                child: Text('Error:$error'),
              )
            ];
          },
        )),
      ),
    ));
  }

  Widget eventCard(
    BuildContext context,
    String image,
    String title,
    String startDate,
    String endDate,
    double price,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      // color: Colors.blueGrey,
      color: Colors.white,
      shadowColor: Colors.grey.withAlpha(10),
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
              width: 0, style: BorderStyle.solid, color: Colors.grey)),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                height: screenHeight * 0.2,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                SizedBox(
                  height: 6,
                ),
                FittedBox(
                  child: Text(
                    title,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                ),
                SizedBox(height: 12),
                // Date and Location row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Color(0xffF66B10)),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, yyyy h:mm a')
                              .format(DateTime.parse(startDate).toLocal()),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Color(0xffF77018)),
                        SizedBox(width: 4),
                        Text(
                          'Kathmandu, Nepal', // Placeholder, as location is not in the model
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Price: Rs${price.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                    Spacer(),
                    // Join button
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => EntryForm()));
                      },
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Color(0xff35353E),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 0),
                      ),
                      child: Text(
                        'JOIN NOW',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class ContactUsPage extends ConsumerWidget {
// //   const ContactUsPage({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final screenSize = MediaQuery.of(context).size;
// //     final screenWidth = screenSize.width;
// //     final screenHeight = screenSize.height;
// //     return Scaffold(
// //         body: Column(
// //       children: [
// //         Container(
// //           height: screenHeight * 0.25,
// //           width: double.infinity,
// //           decoration: BoxDecoration(
// //               image: DecorationImage(
// //                   fit: BoxFit.fitWidth,
// //                   image: AssetImage(
// //                     'assets/contact_us.jpg',
// //                   ))),
// //           child: Align(
// //             alignment: Alignment.center,
// //             child: Text(
// //               textAlign: TextAlign.center,
// //               'Contact Us for a complete solution to all events',
// //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
// //             ),
// //           ),
// //         ),
// //       ],
// //     ));
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ContactUsPage extends ConsumerWidget {
//   const ContactUsPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final screenSize = MediaQuery.of(context).size;
//     final screenHeight = screenSize.height;

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: screenHeight * 0.25,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage('assets/contact_us.jpg'),
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Container(color: Colors.transparent),
//                   Center(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 15),
//                       color: Colors.black26,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: const [
//                           Text(
//                             'Contact Us For A',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24,
//                             ),
//                           ),
//                           Text(
//                             'Complete Solution To All',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24,
//                             ),
//                           ),
//                           Text(
//                             'Events',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Contact information section
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Get In Touch',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Contact info cards
//                   _buildContactCard(
//                     icon: Icons.phone,
//                     title: 'Phone',
//                     subtitle: '+1 (555) 123-4567',
//                   ),
//                   _buildContactCard(
//                     icon: Icons.email,
//                     title: 'Email',
//                     subtitle: 'events@example.com',
//                   ),
//                   _buildContactCard(
//                     icon: Icons.location_on,
//                     title: 'Address',
//                     subtitle: '123 Event Street, Suite 456, New York, NY 10001',
//                   ),

//                   const SizedBox(height: 30),

//                   // Contact form
//                   const Text(
//                     'Send Us A Message',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 15),

//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'Name',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 15),

//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 15),

//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'Phone',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 15),

//                   TextFormField(
//                     maxLines: 4,
//                     decoration: const InputDecoration(
//                       labelText: 'Message',
//                       border: OutlineInputBorder(),
//                       alignLabelWithHint: true,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Handle form submission
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                       ),
//                       child: const Text(
//                         'SUBMIT',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContactCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 15),
//       elevation: 2,
//       child: ListTile(
//         leading: Icon(
//           icon,
//           size: 28,
//           color: Colors.blue,
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(subtitle),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class ContactUsPage extends StatefulWidget {
//   const ContactUsPage({Key? key}) : super(key: key);

//   @override
//   State<ContactUsPage> createState() => _ContactUsPageState();
// }

// class _ContactUsPageState extends State<ContactUsPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _messageController = TextEditingController();

//   String _selectedCountryCode = '+977';

//   final Map<String, String> _countryCodes = {
//     '+93': '🇦🇫 Afghanistan (+93)',
//     '+880': '🇧🇩 Bangladesh (+880)',
//     '+975': '🇧🇹 Bhutan (+975)',
//     '+91': '🇮🇳 India (+91)',
//     '+960': '🇲🇻 Maldives (+960)',
//     '+977': '🇳🇵 Nepal (+977)',
//     '+92': '🇵🇰 Pakistan (+92)',
//     '+94': '🇱🇰 Sri Lanka (+94)',
//   };

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // Handle form submission here
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Message sent successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );

//       // Clear form after submission
//       _fullNameController.clear();
//       _phoneController.clear();
//       _emailController.clear();
//       _messageController.clear();
//       setState(() {
//         _selectedCountryCode = '+1';
//       });
//     }
//   }

//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     bool isRequired = true,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     String? hintText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             text: label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF2D5A5A),
//             ),
//             children: isRequired
//                 ? [
//                     const TextSpan(
//                       text: ' *',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ]
//                 : [],
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           maxLines: maxLines,
// validator: isRequired
//     ? (value) {
//         if (value == null || value.trim().isEmpty) {
//           return 'This field is required';
//         }
//         if (keyboardType == TextInputType.emailAddress) {
//           final emailRegex =
//               RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//           if (!emailRegex.hasMatch(value)) {
//             return 'Please enter a valid email address';
//           }
//         }
//         if (keyboardType == TextInputType.phone) {
//           if (value.length < 7) {
//             return 'Please enter a valid phone number';
//           }
//         }
//         return null;
//       }
//     : null,
//           decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: TextStyle(
//               color: Colors.grey[400],
//               fontSize: 14,
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF5E6D3),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPhoneField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: const TextSpan(
//             text: 'Phone Number',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF2D5A5A),
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             // Country Code Dropdown
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF5E6D3),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: _selectedCountryCode,
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   items: _countryCodes.entries.map((entry) {
//                     return DropdownMenuItem<String>(
//                       value: entry.key,
//                       child: Text(
//                         entry.value,
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       setState(() {
//                         _selectedCountryCode = newValue;
//                       });
//                     }
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Phone Number Field
//             Expanded(
//               child: TextFormField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
// validator: (value) {
//   if (value == null || value.trim().isEmpty) {
//     return 'Phone number is required';
//   }
//   if (value.length < 7) {
//     return 'Please enter a valid phone number';
//   }
//   return null;
// },
//                 decoration: InputDecoration(
//                   hintText: 'Enter your phone number',
//                   hintStyle: TextStyle(
//                     color: Colors.grey[400],
//                     fontSize: 14,
//                   ),
//                   filled: true,
//                   fillColor: const Color(0xFFF5E6D3),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// backgroundColor: const Color(0xFF9BC5C5),
// appBar: AppBar(
//   backgroundColor: const Color(0xFF9BC5C5),
//   elevation: 0,
//   title: const Text(
//     'Contact Us',
//     style: TextStyle(
//       color: Color(0xFF2D5A5A),
//       fontWeight: FontWeight.bold,
//     ),
//   ),
//   centerTitle: true,
// ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Full Name Field
//               _buildTextField(
//                 label: 'Full Name',
//                 controller: _fullNameController,
//                 hintText: 'Enter your full name',
//               ),
//               const SizedBox(height: 20),

//               // Phone Number Field with Country Code
//               _buildPhoneField(),
//               const SizedBox(height: 20),

//               // Email Field
//               _buildTextField(
//                 label: 'Email',
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 hintText: 'Enter your email address',
//               ),
//               const SizedBox(height: 20),

//               // Message Field
//               _buildTextField(
//                 label: 'Message',
//                 controller: _messageController,
//                 maxLines: 5,
//                 hintText: 'Enter your message',
//               ),
//               const SizedBox(height: 32),

//               // Send Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _submitForm,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFFFB84D),
//                     foregroundColor: const Color(0xFF2D5A5A),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     'Send',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'dart:io';

// import 'package:eventsolutions/provider/image_provider.dart';
// import 'package:eventsolutions/provider/stall_provider.dart';
// import 'package:eventsolutions/validation/form_validation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';

// class StallDetails extends ConsumerStatefulWidget {
//   const StallDetails({super.key, required this.stallIds});
//   final List<String> stallIds;

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _StallDetailsState();
// }

// class _StallDetailsState extends ConsumerState<StallDetails> {
//   final _formKey = GlobalKey<FormState>();
//   final paymentProofKey = GlobalKey<FormFieldState>();
//   final stallIdKey = GlobalKey<FormFieldState>();
//   final businessNameKey = GlobalKey<FormFieldState>();
//   final businessPhoneKey = GlobalKey<FormFieldState>();
//   final businessEmailKey = GlobalKey<FormFieldState>();
//   final contactPersonNameKey = GlobalKey<FormFieldState>();
//   final contactPersonPhoneKey = GlobalKey<FormFieldState>();
//   final contactPersonEmailKey = GlobalKey<FormFieldState>();
//   final businessNameController = TextEditingController();
//   final businessPhoneController = TextEditingController();
//   final businessEmailController = TextEditingController();
//   final contactPersonNameController = TextEditingController();
//   final contactPersonPhoneController = TextEditingController();
//   final contactPersonEmailController = TextEditingController();
//   final paymentProofController = TextEditingController();
//   final stallIdController = TextEditingController();
//   final paidAmountKey = GlobalKey<FormFieldState>();
//   final paidAmountController = TextEditingController();

//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     final selectedImage = ref.watch(stallBookingImageProvider);
//     final stallById = ref.watch(stallByIdProvider(widget.stallIds.first));
//     final screenSize = MediaQuery.of(context).size;
//     final screenWidth = screenSize.width;
//     final screenHeight = screenSize.height;

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'Stall Details',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Color(0xff50d99b),
//       ),
//       body: stallById.when(
//         data: (stall) {
//           stallIdController.text = widget.stallIds.join(', ');
//           return SingleChildScrollView(
//             padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
//             child: Column(
//               children: [
//                 buildHeaderCard(stall),
//                 const SizedBox(height: 15),
//                 buildInfoCard(
//                   title: 'Stall Information',
//                   children: [
//                     infoRow('Name', stall.name),
//                     infoRow('Size', stall.size),
//                     infoRow('Size in SqFt', '${stall.sizeInSqFt}'),
//                     infoRow('Type', stall.stallTypeName),
//                     infoRow('Price per sqft',
//                         'Rs ${stall.price.toStringAsFixed(2)}'),
//                     infoRow(
//                       'Total Price with VAT',
//                       'Rs ${(stall.price * stall.sizeInSqFt + (13 / 100 * stall.price * stall.sizeInSqFt)).toStringAsFixed(2)}',
//                     ),
//                     infoRow(
//                       'Status',
//                       stall.status[0].toUpperCase() + stall.status.substring(1),
//                       valueStyle: TextStyle(
//                           color: stall.status == 'available'
//                               ? Colors.blue
//                               : Colors.red),
//                     ),
//                   ],
//                 ),
//                 buildInfoCard(
//                   title: 'Location & Event',
//                   children: [
//                     infoRow('Location', stall.location),
//                     infoRow('Event ID', stall.eventId,
//                         valueStyle: const TextStyle(fontSize: 10)),
//                   ],
//                 ),
//                 buildInfoCard(
//                   title: 'Amenities',
//                   children: stall.amenities.isNotEmpty
//                       ? stall.amenities.map((a) => bulletPoint(a)).toList()
//                       : [infoRow('Amenities', 'None')],
//                 ),
//                 Card(
//                   margin: EdgeInsets.zero,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     side: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                   color: Colors.grey.shade200,
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 20, left: 16, right: 16),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           buildTextField(
//                               label: 'Paying Amount',
//                               fieldKey: paidAmountKey,
//                               controller: paidAmountController,
//                               isRequired: true),
//                           buildTextField(
//                               label: 'Business Name',
//                               fieldKey: businessNameKey,
//                               controller: businessNameController,
//                               isRequired: true),
//                           buildTextField(
//                             label: 'Business Phone',
//                             fieldKey: businessPhoneKey,
//                             controller: businessPhoneController,
//                             isRequired: true,
//                             keyboardType: TextInputType.phone,
//                           ),
//                           buildTextField(
//                             label: 'Business Email',
//                             fieldKey: businessEmailKey,
//                             controller: businessEmailController,
//                             isRequired: true,
//                             keyboardType: TextInputType.emailAddress,
//                           ),
//                           buildTextField(
//                             label: 'Contact Person Name',
//                             fieldKey: contactPersonNameKey,
//                             controller: contactPersonNameController,
//                             isRequired: true,
//                           ),
//                           buildTextField(
//                             label: 'Contact Person Phone',
//                             fieldKey: contactPersonPhoneKey,
//                             controller: contactPersonPhoneController,
//                             isRequired: true,
//                             keyboardType: TextInputType.phone,
//                           ),
//                           buildTextField(
//                             label: 'Contact Person Email',
//                             fieldKey: contactPersonEmailKey,
//                             controller: contactPersonEmailController,
//                             isRequired: true,
//                             keyboardType: TextInputType.emailAddress,
//                           ),
//                           buildImageUploadSection(context, ref, selectedImage),
//                           buildTextField(
//                             label: 'Stall ID',
//                             fieldKey: stallIdKey,
//                             controller: stallIdController,
//                             isRequired: true,
//                             readOnly: true,
//                             enabled: false,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 50),
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           if (selectedImage == null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 backgroundColor: Colors.red,
//                                 content:
//                                     Text('Please upload a payment screenshot'),
//                               ),
//                             );
//                             return;
//                           }
//                           setState(() {
//                             _isLoading = true;
//                           });

//                           try {
//                             final bookingData = {
//                               'stallIds': widget.stallIds,
//                               'businessName': businessNameController.text,
//                               'businessPhone': businessPhoneController.text,
//                               'businessEmail': businessEmailController.text,
//                               'contactPersonName':
//                                   contactPersonNameController.text,
//                               'contactPersonPhone':
//                                   contactPersonPhoneController.text,
//                               'contactPersonEmail':
//                                   contactPersonEmailController.text,
//                               'paymentProof': File(selectedImage.path),
//                               'paidAmount': paidAmountController.text,
//                               'paymentMethod': 'bank'
//                             };

//                             final booking = await ref.read(
//                                 multipleStallBookingProvider(bookingData)
//                                     .future);
//                             paidAmountController.clear();
//                             businessNameController.clear();
//                             businessPhoneController.clear();
//                             businessEmailController.clear();
//                             contactPersonNameController.clear();
//                             contactPersonPhoneController.clear();
//                             contactPersonEmailController.clear();
//                             ref
//                                 .read(stallBookingImageProvider.notifier)
//                                 .clearImage();
//                             stallIdController.clear();

//                             await showAdaptiveDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return AlertDialog(
//                                     backgroundColor: Colors.white,
//                                     title: const Icon(Icons.check_circle,
//                                         color: Colors.green, size: 40),
//                                     content: const Text(
//                                       'Your stall has been confirmed!',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                         style: TextButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(15)),
//                                           foregroundColor: Colors.white,
//                                           backgroundColor:
//                                               const Color(0xFF2D5A5A),
//                                         ),
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                           Navigator.of(context).pop();
//                                         },
//                                         child: const Text('OK'),
//                                       ),
//                                     ],
//                                   );
//                                 });
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                   content: Text('Error booking stall: $e')),
//                             );
//                           } finally {
//                             setState(() {
//                               _isLoading = false;
//                             });
//                           }
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please fill all required fields.'),
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF2D5A5A),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: screenWidth * 0.3,
//                           vertical: screenHeight * 0.015,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       child: const Text(
//                         'Confirm Stall',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text('Error: $error')),
//       ),
//     );
//   }

//   void _showImageSourceDialog(BuildContext context, WidgetRef ref) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Image Source'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Camera'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   try {
//                     await ref
//                         .read(stallBookingImageProvider.notifier)
//                         .fromCamera();
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Camera error: $e')),
//                     );
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Gallery'),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   try {
//                     await ref
//                         .read(stallBookingImageProvider.notifier)
//                         .fromGallery();
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Gallery error: $e')),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget buildImageUploadSection(
//       BuildContext context, WidgetRef ref, XFile? selectedImage) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: const TextSpan(
//             text: 'Payment screenshot',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D5A5A),
//             ),
//             children: [
//               TextSpan(
//                 text: ' *',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         GestureDetector(
//           onTap: () => _showImageSourceDialog(context, ref),
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey[300]!),
//             ),
//             child: selectedImage != null
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.file(
//                       File(selectedImage.path),
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                 : const SizedBox(
//                     height: 200,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Icon(
//                           Icons.camera_alt_outlined,
//                           size: 50,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Tap to upload payment screenshot',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget buildHeaderCard(dynamic stall) {
//     return Container(
//       height: 150,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Color(0xffD5E8F2),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(top: 16),
//         child: Column(
//           children: [
//             Icon(Icons.store_mall_directory, size: 48, color: Colors.blueGrey),
//             const SizedBox(height: 10),
//             Text(
//               stall.stallTypeName,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1.1,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Stall ID: ${stall.stallId}',
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontFamily: 'monospace',
//                 color: Colors.black54,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildInfoCard({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             height: 40,
//             alignment: Alignment.center,
//             decoration: const BoxDecoration(
//               color: Color(0xffD5E8F2),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 5),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: children.isNotEmpty
//                   ? children
//                   : [
//                       const Text(
//                         'No information available',
//                         style: TextStyle(color: Colors.grey),
//                       )
//                     ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget infoRow(String label, String value, {TextStyle? valueStyle}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Expanded(
//               flex: 2,
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               )),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: valueStyle ?? const TextStyle(color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget bulletPoint(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         children: [
//           const Text('•  ', style: TextStyle(fontSize: 16)),
//           Expanded(
//             child: Text(text, style: const TextStyle(fontSize: 14)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildTextField({
//     required String label,
//     TextEditingController? controller,
//     bool isRequired = true,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     String? hintText,
//     Image? image,
//     TextButton? button,
//     required GlobalKey<FormFieldState> fieldKey,
//     bool readOnly = false,
//     bool enabled = true,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             text: label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
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
//           key: fieldKey,
//           controller: controller,
//           keyboardType: keyboardType,
//           maxLines: maxLines,
//           readOnly: readOnly,
//           enabled: enabled,
//           validator: isRequired
//               ? (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'This field is required';
//                   }
//                   if (label == 'Email') {
//                     return MyValidation.validateEmail(value);
//                   }
//                   return null;
//                 }
//               : null,
//           decoration: InputDecoration(
//             fillColor: Colors.white,
//             hintText: hintText,
//             hintStyle: const TextStyle(
//               color: Colors.grey,
//               fontSize: 14,
//             ),
//             filled: true,
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
//         const SizedBox(height: 30),
//       ],
//     );
//   }
// }

import 'dart:io';
import 'package:eventsolutions/provider/image_provider.dart';
import 'package:eventsolutions/provider/stall_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class StallDetails extends ConsumerStatefulWidget {
  const StallDetails({super.key, required this.stallIds});
  final List<String> stallIds;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StallDetailsState();
}

class _StallDetailsState extends ConsumerState<StallDetails> {
  final _formKey = GlobalKey<FormState>();
  final paymentProofKey = GlobalKey<FormFieldState>();
  final businessNameKey = GlobalKey<FormFieldState>();
  final businessPhoneKey = GlobalKey<FormFieldState>();
  final businessEmailKey = GlobalKey<FormFieldState>();
  final contactPersonNameKey = GlobalKey<FormFieldState>();
  final contactPersonPhoneKey = GlobalKey<FormFieldState>();
  final contactPersonEmailKey = GlobalKey<FormFieldState>();
  final paidAmountKey = GlobalKey<FormFieldState>();
  final businessNameController = TextEditingController();
  final businessPhoneController = TextEditingController();
  final businessEmailController = TextEditingController();
  final contactPersonNameController = TextEditingController();
  final contactPersonPhoneController = TextEditingController();
  final contactPersonEmailController = TextEditingController();
  final paidAmountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    businessNameController.dispose();
    businessPhoneController.dispose();
    businessEmailController.dispose();
    contactPersonNameController.dispose();
    contactPersonPhoneController.dispose();
    contactPersonEmailController.dispose();
    paidAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stallByIds =
        widget.stallIds.map((id) => ref.watch(stallByIdProvider(id))).toList();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    bool allLoaded = stallByIds.every((asyncValue) => asyncValue.hasValue);
    bool anyError = stallByIds.any((asyncValue) => asyncValue.hasError);

    if (anyError) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Stall Details (${widget.stallIds.length} Stalls)'),
          centerTitle: true,
          backgroundColor: const Color(0xff50d99b),
        ),
        body: Center(
          child: Text(
              'Error: ${stallByIds.firstWhere((element) => element.hasError).error}'),
        ),
      );
    }

    if (!allLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Stall Details (${widget.stallIds.length} Stalls)'),
          centerTitle: true,
          backgroundColor: const Color(0xff50d99b),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final stalls = stallByIds.map((asyncValue) => asyncValue.value!).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Stall Details (${widget.stallIds.length} Stalls)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff50d99b),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            ...stalls.asMap().entries.map((entry) {
              final index = entry.key;
              final stall = entry.value;
              return buildHeaderCard(stall, index + 1);
            }).toList(),
            const SizedBox(height: 15),
            buildInfoCard(
              title: 'Stall Information',
              children: [
                ...stalls.asMap().entries.expand((entry) {
                  final index = entry.key;
                  final stall = entry.value;
                  return [
                    infoRow('Stall ${index + 1} Name', stall.name),
                    infoRow('Size', stall.size),
                    infoRow('Size in SqFt', '${stall.sizeInSqFt}'),
                    infoRow('Type', stall.stallTypeName),
                    infoRow('Price per sqft',
                        'Rs ${stall.price.toStringAsFixed(2)}'),
                    infoRow(
                      'Total Price with VAT',
                      'Rs ${(stall.price * stall.sizeInSqFt * 1.13).toStringAsFixed(2)}',
                    ),
                    infoRow(
                      'Status',
                      stall.status[0].toUpperCase() + stall.status.substring(1),
                      valueStyle: TextStyle(
                          color: stall.status == 'available'
                              ? Colors.blue
                              : Colors.red),
                    ),
                    const SizedBox(height: 20),
                  ];
                }).toList(),
                infoRow(
                  'Total Price (All Stalls)',
                  'Rs ${stalls.fold<double>(0, (sum, stall) => sum + (stall.price * stall.sizeInSqFt * 1.13)).toStringAsFixed(2)}',
                  valueStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            buildInfoCard(
              title: 'Location & Event',
              children: [
                infoRow('Location', stalls.first.location),
                infoRow('Event ID', stalls.first.eventId,
                    valueStyle: const TextStyle(fontSize: 10)),
              ],
            ),
            buildInfoCard(
              title: 'Amenities',
              children: stalls
                  .expand((stall) => stall.amenities)
                  .toSet()
                  .map((a) => bulletPoint(a))
                  .toList(),
            ),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        label: 'Paying Amount',
                        fieldKey: paidAmountKey,
                        controller: paidAmountController,
                        isRequired: true,
                        keyboardType: TextInputType.number,
                      ),
                      buildTextField(
                        label: 'Business Name',
                        fieldKey: businessNameKey,
                        controller: businessNameController,
                        isRequired: true,
                      ),
                      buildTextField(
                        label: 'Business Phone',
                        fieldKey: businessPhoneKey,
                        controller: businessPhoneController,
                        isRequired: true,
                        keyboardType: TextInputType.phone,
                      ),
                      buildTextField(
                        label: 'Business Email',
                        fieldKey: businessEmailKey,
                        controller: businessEmailController,
                        isRequired: true,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      buildTextField(
                        label: 'Contact Person Name',
                        fieldKey: contactPersonNameKey,
                        controller: contactPersonNameController,
                        isRequired: true,
                      ),
                      buildTextField(
                        label: 'Contact Person Phone',
                        fieldKey: contactPersonPhoneKey,
                        controller: contactPersonPhoneController,
                        isRequired: true,
                        keyboardType: TextInputType.phone,
                      ),
                      buildTextField(
                        label: 'Contact Person Email',
                        fieldKey: contactPersonEmailKey,
                        controller: contactPersonEmailController,
                        isRequired: true,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      qrCode(),
                      buildImageUploadSection(context, ref),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final selectedImage =
                                ref.read(stallBookingImageProvider);
                            if (selectedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      'Please upload a payment screenshot'),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              final bookingData = {
                                'stallIds': widget.stallIds,
                                'businessName': businessNameController.text,
                                'businessPhone': businessPhoneController.text,
                                'businessEmail': businessEmailController.text,
                                'contactPersonName':
                                    contactPersonNameController.text,
                                'contactPersonPhone':
                                    contactPersonPhoneController.text,
                                'contactPersonEmail':
                                    contactPersonEmailController.text,
                                'paymentProof': File(selectedImage.path),
                                'paidAmount': paidAmountController.text,
                                'paymentMethod': 'bank',
                              };

                              final booking = await ref.read(
                                  multipleStallBookingProvider(bookingData)
                                      .future);
                              paidAmountController.clear();
                              businessNameController.clear();
                              businessPhoneController.clear();
                              businessEmailController.clear();
                              contactPersonNameController.clear();
                              contactPersonPhoneController.clear();
                              contactPersonEmailController.clear();
                              ref
                                  .read(stallBookingImageProvider.notifier)
                                  .clearImage();

                              await showAdaptiveDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Icon(Icons.check_circle,
                                        color: Colors.green, size: 40),
                                    content: Text(
                                      'Your ${widget.stallIds.length} stall(s) have been confirmed!',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              const Color(0xFF2D5A5A),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error booking stall: $e')),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please fill all required fields.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D5A5A),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.3,
                            vertical: screenHeight * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Confirm ${widget.stallIds.length} Stall(s)',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  try {
                    await ref
                        .read(stallBookingImageProvider.notifier)
                        .fromCamera();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Camera error: $e')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  try {
                    await ref
                        .read(stallBookingImageProvider.notifier)
                        .fromGallery();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gallery error: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget qrCode() {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/qrcode.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget buildImageUploadSection(BuildContext context, WidgetRef ref) {
    final selectedImage = ref.watch(stallBookingImageProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Payment screenshot',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5A5A),
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showImageSourceDialog(context, ref),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(selectedImage.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tap to upload payment screenshot',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildHeaderCard(dynamic stall, int stallNumber) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffD5E8F2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            const Icon(Icons.store_mall_directory,
                size: 48, color: Colors.blueGrey),
            const SizedBox(height: 10),
            Text(
              'Stall $stallNumber: ${stall.stallTypeName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Stall ID: ${stall.stallId}',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xffD5E8F2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children.isNotEmpty
                  ? children
                  : [
                      const Text(
                        'No information available',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: valueStyle ?? const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Text('•  ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required GlobalKey<FormFieldState> fieldKey,
    TextEditingController? controller,
    bool isRequired = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
    bool readOnly = false,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5A5A),
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          enabled: enabled,
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  if (label.contains('Email')) {
                    return MyValidation.validateEmail(value);
                  }
                  if (label.contains('Phone')) {
                    return MyValidation.validateMobile(value);
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

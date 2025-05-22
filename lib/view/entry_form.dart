import 'dart:io';
import 'package:eventsolutions/model/all_events_model.dart';
import 'package:eventsolutions/provider/image_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EntryForm extends ConsumerWidget {
  const EntryForm({super.key, required this.events});
  final Data events;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

    final fullNameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final baseUrlImage = 'http://182.93.94.210:8000';
    final selectedImage = ref.watch(imagePickerProvider); // This is now XFile?

    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(
          right: screenWidth * 0.05,
          left: screenWidth * 0.05,
          top: screenHeight * 0.05,
          bottom: screenHeight * 0.01),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              events.title,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: (events.poster != null && events.poster!.isNotEmpty)
                  ? Image.network(
                      '$baseUrlImage${events.poster}',
                      height: screenHeight * 0.2,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/event1.png');
                      },
                    )
                  : Image.asset(
                      'assets/event1.png',
                      height: screenHeight * 0.2,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                kDebugMode
                    ? events.description.replaceFirst(RegExp(r'[\n ].*$'), '')
                    : events.description,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price: ${events.ticketTiers[0].price.toString()}',
                  style: TextStyle(color: Colors.orange),
                ),
                Text('Location : Kathmandu')
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    buildTextField(
                        label: 'Full Name', controller: fullNameController),
                    buildTextField(label: 'Email', controller: emailController),
                    buildTextField(
                        label: 'Phone Number', controller: phoneController),
                  ],
                )),
            Text(
              'Please do payment in this QR code and send the payment screenshot below and wait till the payment is verified',
              softWrap: true,
            ),
            SizedBox(
              height: 10,
            ),
            qrCode(),
            SizedBox(
              height: 20,
            ),
            buildImageUploadSection(context, ref, selectedImage),
            ElevatedButton(onPressed: () {}, child: Text('Proceed'))
          ],
        ),
      ),
    ));
  }

  Widget qrCode() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Image.asset(
        'assets/event5.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget buildImageUploadSection(
      BuildContext context, WidgetRef ref, XFile? selectedImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Payment Screenshot',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5A5A),
            ),
            children: [
              const TextSpan(
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(selectedImage.path), // Convert XFile to File
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tap to upload payment screenshot',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 20),
      ],
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
                    await ref.read(imagePickerProvider.notifier).fromCamera();
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
                    await ref.read(imagePickerProvider.notifier).fromGallery();
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

  Widget buildTextField(
      {required String label,
      TextEditingController? controller,
      bool isRequired = true,
      TextInputType keyboardType = TextInputType.text,
      int maxLines = 1,
      String? hintText,
      Image? image,
      TextButton? button}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
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
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  if (keyboardType == TextInputType.emailAddress) {
                    MyValidation.validateEmail(value);
                  }

                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            filled: true,
            // fillColor: const Color(0xFFF5E6D3),
            fillColor: Colors.white,
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
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}

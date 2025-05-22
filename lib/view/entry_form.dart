import 'dart:io';
import 'package:eventsolutions/model/all_events_model.dart';
import 'package:eventsolutions/provider/image_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EntryForm extends ConsumerStatefulWidget {
  const EntryForm({super.key, required this.events});
  final Data events;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntryFormState();
}

class _EntryFormState extends ConsumerState<EntryForm> {
  final fullNameKey = GlobalKey<FormFieldState>();
  final emailKey = GlobalKey<FormFieldState>();
  final phoneKey = GlobalKey<FormFieldState>();

  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final baseUrlImage = 'http://182.93.94.210:8000';
    final selectedImage = ref.watch(imagePickerProvider); // This is now XFile?

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(
              right: screenWidth * 0.05,
              left: screenWidth * 0.05,
              top: screenHeight * 0.05,
              bottom: screenHeight * 0.01),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Text(
                  widget.events.title,
                  style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: (widget.events.poster != null &&
                          widget.events.poster!.isNotEmpty)
                      ? Image.network(
                          '$baseUrlImage${widget.events.poster}',
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
                Text(
                  // kDebugMode
                  //     ? widget.events.description
                  //         .replaceFirst(RegExp(r'[\n ].*'), '')
                  //     : widget.events.description,
                  widget.events.description,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      wordSpacing: 1),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price: ${widget.events.ticketTiers[0].price.toString()}',
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.w500),
                    ),
                    Text('Location : Kathmandu')
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.2, 0.7, 1],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildTextField(
                            fieldKey: fullNameKey,
                            label: 'Full Name',
                            controller: fullNameController),
                        buildTextField(
                            fieldKey: emailKey,
                            label: 'Email',
                            controller: emailController),
                        buildTextField(
                            fieldKey: phoneKey,
                            label: 'Phone Number',
                            hintText:
                                'Enter phone number with country code (e.g. +977)',
                            controller: phoneController),
                      ],
                    )),
                Text(
                  '''Please do payment in this QR code and send the payment screenshot below and wait till the payment is verified''',
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D5A5A),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                qrCode(),
                SizedBox(
                  height: 25,
                ),
                buildImageUploadSection(context, ref, selectedImage),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 2,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content:
                                  Text('Please upload a payment screenshot')));
                          return;
                        }
                        fullNameController.clear();
                        emailController.clear();
                        phoneController.clear();
                        ref.read(imagePickerProvider.notifier).clearImage();
                        showAdaptiveDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Rounded corners for the dialog
                              ),
                              backgroundColor: Colors
                                  .white, // Background color of the dialog
                              contentPadding: EdgeInsets.all(20),
                              titlePadding: EdgeInsets.all(10),
                              title: Text(
                                'Success',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .green, // Green color for the title for success
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 60,
                                    color: Colors
                                        .green, // Icon color to match the success theme
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '''Congratulations! Your form has been submitted successfully. You will receive the ticket in your registered email once the verification is done.''',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue, // Button color
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        final errorFields = [fullNameKey, emailKey, phoneKey];
                        for (var key in errorFields) {
                          if (key.currentState?.hasError ?? false) {
                            final context = key.currentContext;
                            if (context != null) {
                              Scrollable.ensureVisible(
                                context,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                            break;
                          }
                        }
                      }
                    },
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ));
  }

  Widget qrCode() {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/event5.png',
            fit: BoxFit.contain,
          ),
        ),
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
            width: double.infinity,
            // height: 200,
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
                : SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
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
                            // color: Colors.grey[600],
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        SizedBox(
          height: 10,
        )
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

  Widget buildTextField({
    required String label,
    TextEditingController? controller,
    bool isRequired = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
    Image? image,
    TextButton? button,
    required GlobalKey<FormFieldState> fieldKey,
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
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }

                  if (label == 'Email') {
                    return MyValidation.validateEmail(value);
                  }

                  if (label == 'Phone Number') {
                    return MyValidation.validateMobile(value);
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
            // fillColor: Colors.white,
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

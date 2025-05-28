// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:eventsolutions/model/abstract/event_data.dart';

import 'package:eventsolutions/provider/event_provider.dart';
import 'package:eventsolutions/provider/image_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:eventsolutions/view/ticket_qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryForm extends ConsumerStatefulWidget {
  const EntryForm({super.key, required this.eventData});
  // final OngoingData eventData;
  final EventData eventData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntryFormState();
}

class _EntryFormState extends ConsumerState<EntryForm> {
  final fullNameKey = GlobalKey<FormFieldState>();
  final emailKey = GlobalKey<FormFieldState>();
  final phoneKey = GlobalKey<FormFieldState>();
  final tierKey = GlobalKey<FormFieldState>();

  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  bool _isLoading = false;

  String _selectedCountryCode = '+977';

  final Map<String, String> _countryCodes = {
    '+93': '🇦🇫 Afghanistan (+93)',
    '+880': '🇧🇩 Bangladesh (+880)',
    '+975': '🇧🇹 Bhutan (+975)',
    '+86': '🇨🇳 China (+86)',
    '+91': '🇮🇳 India (+91)',
    '+960': '🇲🇻 Maldives (+960)',
    '+977': '🇳🇵 Nepal (+977)',
    '+92': '🇵🇰 Pakistan (+92)',
    '+94': '🇱🇰 Sri Lanka (+94)',
  };

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedTierProvider.notifier).state = null;
    });
  }

  Future<void> _saveTicketId(String ticketId) async {
    final prefs = await SharedPreferences.getInstance();
    final existingIds = prefs.getStringList('allTicketIds') ?? [];

    if (!existingIds.contains(ticketId)) {
      existingIds.add(ticketId);
      await prefs.setStringList('allTicketIds', existingIds);
    }

    // Also update lastTicketId if you still want to use it elsewhere
    await prefs.setString('lastTicketId', ticketId);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final baseUrlImage = 'http://182.93.94.210:8000';
    final selectedImage = ref.watch(imagePickerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow keyboard to adjust layout
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: screenWidth * 0.05,
              left: screenWidth * 0.05,
              top: screenHeight * 0.05,
              bottom: screenHeight * 0.01,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.eventData.title,
                      style: const TextStyle(
                        fontSize: 20,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: (widget.eventData.poster != null &&
                            widget.eventData.poster!.isNotEmpty)
                        ? Image.network(
                            '$baseUrlImage${widget.eventData.poster}',
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
                  const SizedBox(height: 10),
                  Text(
                    widget.eventData.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      wordSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final selectedTier = ref.watch(selectedTierProvider);

                          EventTicketTier? matchingTier;
                          if (selectedTier != null) {
                            try {
                              matchingTier = widget.eventData.ticketTiers
                                  .firstWhere(
                                      (tier) => tier.name == selectedTier);
                            } catch (e) {
                              matchingTier =
                                  widget.eventData.ticketTiers.isNotEmpty
                                      ? widget.eventData.ticketTiers[0]
                                      : null;
                            }
                          } else {
                            matchingTier =
                                widget.eventData.ticketTiers.isNotEmpty
                                    ? widget.eventData.ticketTiers[0]
                                    : null;
                          }

                          final price = matchingTier?.price.toString() ?? 'N/A';

                          return Text(
                            'Price: $price',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                      Text(widget.eventData.location),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
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
                  const SizedBox(height: 30),
                  Consumer(
                    builder: (context, ref, child) {
                      final tiers = widget.eventData.ticketTiers;
                      final currentSelectedTier =
                          ref.watch(selectedTierProvider);
                      final isValidTier =
                          tiers.any((tier) => tier.name == currentSelectedTier);
                      final selectedTier =
                          isValidTier ? currentSelectedTier : null;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: 'Ticket Tier',
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
                          DropdownButtonFormField<String>(
                            key: tierKey,
                            value: selectedTier,
                            hint: const Text('Select a ticket tier'),
                            isExpanded: true,
                            items: tiers.isEmpty
                                ? [
                                    const DropdownMenuItem(
                                      value: null,
                                      enabled: false,
                                      child: Text('No tiers available'),
                                    ),
                                  ]
                                : tiers.map((tier) {
                                    return DropdownMenuItem(
                                      value: tier.name,
                                      child: Text(tier.name),
                                    );
                                  }).toList(),
                            onChanged: tiers.isEmpty
                                ? null
                                : (value) {
                                    ref
                                        .read(selectedTierProvider.notifier)
                                        .state = value;
                                  },
                            validator: (value) {
                              if (value == null && tiers.isNotEmpty) {
                                return 'Please select a ticket tier';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
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
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Consumer(
                    builder: (context, ref, child) {
                      final selectedTier = ref.watch(selectedTierProvider);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Features:',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (selectedTier == null)
                            const Text(
                              'Select ticket tier to see the features',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else
                            ...() {
                              EventTicketTier? matchingTier;
                              try {
                                matchingTier = widget.eventData.ticketTiers
                                    .firstWhere(
                                        (tier) => tier.name == selectedTier);
                              } catch (e) {
                                matchingTier =
                                    widget.eventData.ticketTiers.isNotEmpty
                                        ? widget.eventData.ticketTiers[0]
                                        : null;
                              }

                              if (matchingTier == null) return <Widget>[];

                              return matchingTier.listofFeatures
                                  .cast<String>()
                                  .map((feature) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '• ',
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                feature.trim(),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList();
                            }(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  Card(
                    // color: Color(0xffFAFAFA),
                    // elevation: 6,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    // color: Colors.green.shade300,
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 20, bottom: 20, left: 16, right: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            buildTextField(
                              fieldKey: fullNameKey,
                              label: 'Full Name',
                              controller: fullNameController,
                            ),
                            buildTextField(
                              fieldKey: emailKey,
                              label: 'Email',
                              controller: emailController,
                            ),
                            _buildPhoneField()
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '''Please do payment in this QR code and send the payment screenshot below and wait till the payment is verified''',
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5A5A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  qrCode(),
                  const SizedBox(height: 25),
                  buildImageUploadSection(context, ref, selectedImage),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 2,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
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

                                // // Validate file type
                                // final fileExtension = selectedImage.path
                                //     .toLowerCase()
                                //     .split('.')
                                //     .last;
                                // if (!['png', 'jpg', 'jpeg']
                                //     .contains(fileExtension)) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(
                                //       backgroundColor: Colors.red,
                                //       content: Text(
                                //           'Payment screenshot must be a PNG or JPEG image'),
                                //     ),
                                //   );
                                //   return;
                                // }

                                final selectedTier =
                                    ref.read(selectedTierProvider);
                                if (selectedTier == null &&
                                    widget.eventData.ticketTiers.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content:
                                          Text('Please select a ticket tier'),
                                    ),
                                  );
                                  return;
                                }

                                if (widget.eventData.ticketTiers.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          'No ticket tiers available for this event'),
                                    ),
                                  );
                                  return;
                                }

                                // Step 2: Show loading state
                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  // Step 3: Prepare registration data
                                  final registrationData = {
                                    'email': emailController.text,
                                    'name': fullNameController.text,
                                    'number': phoneController.text,
                                    'tierName': selectedTier ??
                                        widget.eventData.ticketTiers[0].name,
                                    'paymentScreenshot':
                                        File(selectedImage.path),
                                    'eventId': widget.eventData.eventId,
                                  };

                                  // Step 4: Send registration request
                                  final response = await ref.read(
                                    registerEventProvider(registrationData)
                                        .future,
                                  );

                                  // Step 5: Save ticketId to Shared Preferences
                                  await _saveTicketId(response.ticketId);

                                  // Step 6: Clear form fields after successful registration
                                  fullNameController.clear();
                                  emailController.clear();
                                  phoneController.clear();
                                  ref
                                      .read(imagePickerProvider.notifier)
                                      .clearImage();
                                  ref
                                      .read(selectedTierProvider.notifier)
                                      .state = null;

                                  // Step 7: Show success dialog
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        backgroundColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        titlePadding: const EdgeInsets.all(10),
                                        title: const Text(
                                          'Registration Successful!',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.check_circle_outline,
                                              size: 60,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Ticket ID: ${response.ticketId}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Status: ${response.status.toUpperCase()}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    response.status == 'pending'
                                                        ? Colors.orange
                                                        : Colors.green,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              response.status == 'pending'
                                                  ? 'Your registration is pending payment verification. You will receive the ticket once verified.'
                                                  : 'Your registration is confirmed! Check for the ticket.',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Close dialog
                                                  Navigator.pop(
                                                      context); // Navigate back to event list
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: response.status ==
                                                        'approved'
                                                    ? () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    TicketQr(
                                                              ticketId: response
                                                                  .ticketId,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    : null, // Disable if not approved
                                                child: Text(
                                                  'View QR',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: response.status ==
                                                            'approved'
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } catch (e) {
                                  // Step 8: Handle errors with a failure dialog
                                  String errorMessage = 'Something went wrong';
                                  if (e.toString().contains('Exception:')) {
                                    errorMessage = e
                                        .toString()
                                        .replaceFirst('Exception: ', '');
                                  }

                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        backgroundColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        titlePadding: const EdgeInsets.all(10),
                                        title: const Text(
                                          'Registration Failed',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              size: 60,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              errorMessage,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
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
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } finally {
                                  // Step 9: Reset loading state
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } else {
                                // Scroll to the first error field
                                final errorFields = [
                                  fullNameKey,
                                  emailKey,
                                  phoneKey,
                                  tierKey
                                ];
                                for (var key in errorFields) {
                                  if (key.currentState?.hasError ?? false) {
                                    final context = key.currentContext;
                                    if (context != null) {
                                      Scrollable.ensureVisible(
                                        context,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                    break;
                                  }
                                }
                              }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Proceed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(50),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
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

  Widget buildImageUploadSection(
      BuildContext context, WidgetRef ref, XFile? selectedImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
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
        const SizedBox(height: 10),
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

  Widget _buildPhoneField() {
    final screenWidth = MediaQuery.of(context).size.width;
    final dropdownWidth = screenWidth * 0.35; // 35% of screen width

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D5A5A),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: dropdownWidth.clamp(100.0, 140.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCountryCode,
                    isExpanded: true,
                    items: _countryCodes.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(
                          entry.value,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCountryCode = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: MyValidation.validateMobile,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  filled: true,
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
            ),
          ],
        ),
      ],
    );
  }
}

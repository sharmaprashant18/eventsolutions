// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:eventsolutions/model/abstract/event_data.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:eventsolutions/provider/image_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:eventsolutions/view/ticket_qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class EntryForm extends ConsumerStatefulWidget {
  const EntryForm({super.key, required this.eventData});

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

    Future.microtask(() {
      if (mounted) {
        try {
          ref.read(selectedTierProvider.notifier).state = null;
          ref.read(entryFormImagePickerProvider.notifier).clearImage();
          log('Form state cleared successfully');
        } catch (e) {
          log('Error clearing form state: $e');
        }
      }
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

  Future<void> _downloadPdf(String pdfUrl, String fileName) async {
    try {
      // Check current permission status
      PermissionStatus status = await Permission.storage.status;

      // For Android 13+ (API 33+), we don't need storage permission for Downloads
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          // Android 13+ doesn't require storage permission for Downloads folder
          await _performDownload(pdfUrl, fileName);
          return;
        }
      }

      // Handle permission for older Android versions and iOS
      if (status.isDenied) {
        status = await Permission.storage.request();
      }

      if (status.isDenied) {
        _showPermissionDeniedDialog();
        return;
      }

      if (status.isPermanentlyDenied) {
        _showPermanentlyDeniedDialog();
        return;
      }

      if (status.isGranted) {
        await _performDownload(pdfUrl, fileName);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _performDownload(String pdfUrl, String fileName) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Downloading PDF...'),
            ],
          ),
        ),
      );

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final filePath = '${directory.path}/$fileName.pdf';

        Dio dio = Dio();
        await dio.download(pdfUrl, filePath);

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF downloaded successfully!'),
            backgroundColor: Color(0xff0a519d),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
            'Storage permission is required to download files. Please grant permission and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final status = await Permission.storage.request();
              if (status.isGranted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Permission granted! Please try downloading again.')),
                );
              }
            },
            child: Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  void _showPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
            'Storage permission is permanently denied. Please enable it in app settings to download files.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  EventTicketTier? _getSelectedTierData() {
    final selectedTierName = ref.read(selectedTierProvider);

    if (selectedTierName != null) {
      try {
        return widget.eventData.ticketTiers
            .firstWhere((tier) => tier.name == selectedTierName);
      } catch (e) {
        return widget.eventData.ticketTiers.isNotEmpty
            ? widget.eventData.ticketTiers[0]
            : null;
      }
    } else {
      return widget.eventData.ticketTiers.isNotEmpty
          ? widget.eventData.ticketTiers[0]
          : null;
    }
  }

  bool _shouldShowPaymentSection() {
    final selectedTierData = _getSelectedTierData();
    return widget.eventData.entryType == 'paid' &&
        selectedTierData != null &&
        selectedTierData.price != 0;
  }

  bool _isPaymentRequired() {
    return _shouldShowPaymentSection();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final baseUrlImage = 'http://182.93.94.210:8001';
    final selectedImage = ref.watch(entryFormImagePickerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                          color: Color(0xffe92429)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: (widget.eventData.poster != null &&
                            widget.eventData.poster!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: '$baseUrlImage${widget.eventData.poster}',
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorWidget: (context, error, stackTrace) {
                              return Icon(Icons.broken_image);
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
                              color: Color(0xffe92429),
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Color(0xffe92429)),
                          FittedBox(child: Text(widget.eventData.location)),
                        ],
                      ),
                    ],
                  ),
                  if (widget.eventData.proposal != null)
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Event Proposal',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.download),
                                                  onPressed: () {
                                                    _downloadPdf(
                                                        '$baseUrlImage${widget.eventData.proposal}',
                                                        '${widget.eventData.title}_proposal');
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Expanded(
                                          child: SfPdfViewer.network(
                                            interactionMode:
                                                PdfInteractionMode.pan,
                                            enableDoubleTapZooming: true,
                                            enableDocumentLinkAnnotation: true,
                                            enableHyperlinkNavigation: true,
                                            enableTextSelection: true,
                                            canShowScrollHead: true,
                                            '$baseUrlImage${widget.eventData.proposal}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            "View Proposal",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.wavy,
                                decorationColor: Colors.blue,
                                decorationThickness: 2,
                                color: const Color(0xff0a519d)),
                          ),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            _downloadPdf(
                                '$baseUrlImage${widget.eventData.proposal}',
                                '${widget.eventData.title}_proposal');
                          },
                          icon: const Icon(
                            Icons.download,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text("Download Proposal"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0a519d),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    )),
                  SizedBox(
                    height: 20,
                  ),
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
                              text: 'Ticket Category',
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
                            hint: const Text('Select a ticket category'),
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
                              color: Color(0xffe92429),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (selectedTier == null)
                            const Text(
                              'Select ticket category to see the features',
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
                                                color: Color(0xffe92429),
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
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
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
                  Consumer(
                    builder: (context, ref, child) {
                      // Watch for tier selection changes
                      ref.watch(selectedTierProvider);

                      final shouldShow = _shouldShowPaymentSection();

                      if (!shouldShow) {
                        return const SizedBox
                            .shrink(); // Hide payment section for free tiers
                      }

                      return Column(
                        children: [
                          Text(
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
                        ],
                      );
                    },
                  ),
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
                                // Check if payment screenshot is required for the selected tier
                                if (_isPaymentRequired() &&
                                    selectedImage == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          'Please upload a payment screenshot'),
                                    ),
                                  );
                                  return;
                                }

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

                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  final registrationData = {
                                    'email': emailController.text
                                        .trim()
                                        .toLowerCase(),
                                    'name': fullNameController.text.trim(),
                                    'number': phoneController.text.trim(),
                                    'tierName': selectedTier ??
                                        widget.eventData.ticketTiers[0].name,
                                    'paymentScreenshot': _isPaymentRequired() &&
                                            selectedImage != null
                                        ? File(selectedImage.path)
                                        : null, // Pass null for free tiers
                                    'eventId': widget.eventData.eventId,
                                  };

                                  final response = await ref.read(
                                    registerEventProvider(registrationData)
                                        .future,
                                  );

                                  // Save ticketId to Shared Preferences
                                  await _saveTicketId(response.ticketId);

                                  // Clear form fields
                                  fullNameController.clear();
                                  emailController.clear();
                                  phoneController.clear();
                                  ref
                                      .read(
                                          entryFormImagePickerProvider.notifier)
                                      .clearImage();
                                  ref
                                      .read(selectedTierProvider.notifier)
                                      .state = null;

                                  // Show success dialog
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
                                                style: const ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                            Color(0xff0a519d))),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
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
                                  // Handle errors with a failure dialog
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Consumer(
        builder: (context, ref, child) {
          final qr = ref.watch(qrProvider);
          final baseUrlImage = 'http://182.93.94.210:8001';

          return qr.when(
            data: (qr) {
              if (qr.isEmpty) {
                return const Text('No QR code found');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: qr.map((qrData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CachedNetworkImage(
                      imageUrl: '$baseUrlImage${qrData.image}',
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) {
                        return Icon(Icons.broken_image);
                      },
                    ),
                  );
                }).toList(),
              );
            },
            error: (error, stackTrace) {
              return const Text('Something went wrong');
            },
            loading: () => const CircularProgressIndicator(),
          );
        },
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
            text: 'Payment screenshot',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5A5A),
            ),
            children: _isPaymentRequired()
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [], // No asterisk for free tiers
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
                    await ref
                        .read(entryFormImagePickerProvider.notifier)
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
                        .read(entryFormImagePickerProvider.notifier)
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
                maxLength: 10,
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

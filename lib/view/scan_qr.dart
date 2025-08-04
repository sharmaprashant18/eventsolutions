import 'dart:developer';
import 'package:eventsolutions/view/scanned_data.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

class ScanQr extends ConsumerStatefulWidget {
  const ScanQr({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScanQrState();
}

class _ScanQrState extends ConsumerState<ScanQr> {
  MobileScannerController? controller;
  bool isFlashOn = false;
  bool frontCamera = false;
  bool _isDialogShowing = false;
  bool _isProcessing = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  void _initializeScanner() {
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      detectionTimeoutMs: 100,
      formats: [BarcodeFormat.all],
      returnImage: false,
    );
    log('Scanner initialized successfully');
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _handleQRScan(String ticketId) async {
    // Prevent multiple simultaneous scans
    if (_isProcessing || _isDialogShowing) {
      log('Already processing or dialog showing, ignoring scan');
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
      });

      log('Starting QR scan process for ticket: $ticketId');

      // Call the API directly to check entry status
      final eventService = ref.read(eventServiceProvider);

      try {
        // Try to get features directly
        final features =
            await eventService.getTicketFeaturesByTicketId(ticketId);
        log('Got features directly: ${features.length} features');

        // If we get here, entry is already allowed, go to features page
        await _navigateToFeatures(ticketId);
      } catch (apiError) {
        log('API Error: $apiError');

        if (apiError.toString().contains('Entry not allowed')) {
          log('Entry not allowed - first scan detected');
          await _showPrintingDialog(ticketId);
        } else if (apiError
            .toString()
            .contains('Entry true - printing ticket')) {
          log('Entry true - showing printing dialog');
          await _showPrintingDialog(ticketId);
        } else {
          // Some other API error
          throw apiError;
        }
      }
    } catch (e) {
      log('Error in _handleQRScan: $e');
      if (mounted) {
        await _showErrorDialog('Error processing QR code: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _showPrintingDialog(String ticketId) async {
    if (_isDialogShowing || !mounted) return;

    setState(() {
      _isDialogShowing = true;
    });

    await controller?.stop();

    log('Showing printing dialog for 3 seconds');

    // Show dialog without await - we want to control when it closes
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.print, color: Colors.green[600]),
            const SizedBox(width: 8),
            const Text('Entry Confirmed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your ticket is being printed...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );

    // Wait for 3 seconds then close dialog
    await Future.delayed(const Duration(seconds: 3));

    // Close dialog if still showing and mounted
    if (mounted && _isDialogShowing) {
      Navigator.of(context).pop();
      log('Dialog closed after 3 seconds');

      setState(() {
        _isDialogShowing = false;
      });
    }

    // Restart scanner
    if (mounted) {
      await controller?.start();

      // Small delay before navigation
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _navigateToFeatures(String ticketId) async {
    if (!mounted) return;

    log('Navigating to features page for ticket: $ticketId');

    // Use pushReplacement to avoid back stack issues
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScannedDataPage(ticketId: ticketId.toLowerCase()),
      ),
    );

    log('Navigation completed');
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isDialogShowing || _isProcessing || !mounted) {
      log('Scanner busy, ignoring detection');
      return;
    }

    log('QR code detected');

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      try {
        final scannedCode = barcodes.first.displayValue ?? 'No data';
        log("Scanned Code: $scannedCode");

        final parts = scannedCode.split('+');
        if (parts.length != 2) {
          throw Exception(
              'Invalid QR code format: Expected 2 parts, got ${parts.length}');
        }

        final createdByPart = parts[0].split(':');
        final ticketIdPart = parts[1].split(':');

        if (createdByPart.length != 2) {
          throw Exception('Invalid creator format: ${parts[0]}');
        }

        if (ticketIdPart.length != 2) {
          throw Exception('Invalid ticket ID format: ${parts[1]}');
        }

        final createdBy = createdByPart[1];
        final ticketId = ticketIdPart[1].toLowerCase();

        log('Parsed - Creator: $createdBy, TicketID: $ticketId');

        if (createdBy == 'EVENTSOLUTION' && ticketId.isNotEmpty) {
          _handleQRScan(ticketId);
        } else {
          _showErrorDialog(
              'This QR code is not valid for this app.\nCreator: $createdBy\nTicket ID: $ticketId');
        }
      } catch (e) {
        log('Error parsing QR code: $e');
        _showErrorDialog('Invalid QR code format: ${e.toString()}');
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    if (_isProcessing || !mounted) {
      log('Processing in progress, ignoring gallery selection');
      return;
    }

    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        final result = await controller?.analyzeImage(image.path);
        if (result != null && result.barcodes.isNotEmpty) {
          final code = result.barcodes.first.displayValue ?? 'No data';
          log('Gallery QR code: $code');

          try {
            final parts = code.split('+');
            if (parts.length != 2) {
              throw Exception('Invalid QR code format');
            }

            final createdByPart = parts[0].split(':');
            final ticketIdPart = parts[1].split(':');

            if (createdByPart.length != 2 || ticketIdPart.length != 2) {
              throw Exception('Invalid QR code structure');
            }

            final createdBy = createdByPart[1];
            final ticketId = ticketIdPart[1].toLowerCase();

            if (createdBy == 'EVENTSOLUTION' && ticketId.isNotEmpty) {
              await _handleQRScan(ticketId);
            } else {
              await _showErrorDialog('This QR code is not valid in this app');
            }
          } catch (e) {
            log('Error parsing gallery QR code: $e');
            await _showErrorDialog('This QR code is not valid in this app');
          }
        } else {
          await _showErrorDialog('No QR code found in the selected image');
        }
      }
    } catch (e) {
      log('Error picking image: $e');
      if (mounted) {
        await _showErrorDialog('Error selecting image from gallery');
      }
    }
  }

  Future<void> _showErrorDialog(String message) async {
    if (_isDialogShowing || !mounted) return;

    setState(() {
      _isDialogShowing = true;
    });

    await controller?.stop();

    log('Showing error dialog: $message');

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (mounted) {
      setState(() {
        _isDialogShowing = false;
      });

      await controller?.start();
    }
  }

  void _toggleFlash() {
    controller?.toggleTorch();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  void _switchCamera() {
    controller?.switchCamera();
    setState(() {
      frontCamera = !frontCamera;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle hardware back button
        if (_isProcessing || _isDialogShowing) {
          return false; // Prevent back navigation while processing
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Scanner'),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: _toggleFlash,
              icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
            ),
            IconButton(
              onPressed: _switchCamera,
              icon: Icon(
                  frontCamera ? Icons.flip_camera_android : Icons.photo_camera),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: controller,
                    onDetect: _onDetect,
                    errorBuilder: (context, error, child) {
                      log('Scanner error: $error');
                      return Center(child: Text('Scanner error: $error'));
                    },
                  ),
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isProcessing ? Colors.orange : Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (_isProcessing)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Processing QR Code...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _isProcessing
                        ? 'Processing... Please wait'
                        : 'Point camera at QR code or select from gallery',
                    style: TextStyle(
                      color: _isProcessing ? Colors.orange : Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _pickImageFromGallery,
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                        ),
                        label: const Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff0a519d),
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isProcessing
                            ? null
                            : () {
                                log('Manual scan button pressed');
                              },
                        icon: const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                        ),
                        label: const Text('Scan'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff0a519d),
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

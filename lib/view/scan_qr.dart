// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
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
  String? scannedCode;
  dynamic parsedJson;
  bool isScanning = false;
  bool isFlashOn = false;
  bool frontCamera = false;
  bool _isDialogShowing = false;
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
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isDialogShowing || isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      setState(() {
        isScanning = true;
        scannedCode = barcodes.first.displayValue ?? 'No data';
      });

      try {
        parsedJson = jsonDecode(scannedCode!);
        if (parsedJson is Map<String, dynamic> &&
            parsedJson['createdBy'] == 'Event Solution') {
        } else {
          _showErrorDialog('This QR code is not valid in this app');
          setState(() {
            scannedCode = null;
            parsedJson = null;
            isScanning = false;
          });
        }
      } catch (e) {
        log('Error parsing JSON: $e');

        _showErrorDialog('This QR code is not valid in this app');
        setState(() {
          scannedCode = null;
          parsedJson = null;
          isScanning = false;
        });
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final result = await controller?.analyzeImage(image.path);
        if (result != null && result.barcodes.isNotEmpty) {
          final code = result.barcodes.first.displayValue ?? 'No data';
          try {
            final parsed = jsonDecode(code);
            if (parsed is Map<String, dynamic> &&
                parsed['createdBy'] == 'Event Solution') {
              setState(() {
                scannedCode = code;
                parsedJson = parsed;
              });
            } else {
              _showErrorDialog('This QR code is not valid in this app');
            }
          } catch (e) {
            log('Error parsing JSON: $e');
            _showErrorDialog('This QR code is not valid in this app');
          }
        } else {
          _showErrorDialog('No QR code found in the selected image');
        }
      }
    } catch (e) {
      log('Error picking image: $e');
      _showErrorDialog('Error selecting image from gallery');
    }
  }

  void _showErrorDialog(String message) async {
    if (_isDialogShowing) return;

    _isDialogShowing = true;

    await controller?.stop();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    await controller?.start();
    setState(() {
      _isDialogShowing = false;
    });
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
    return Scaffold(
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
                ),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(10),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (scannedCode != null) ...[
                    const Text(
                      'Scanned Data:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: parsedJson != null &&
                              parsedJson is Map<String, dynamic>
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: parsedJson.entries.map<Widget>((entry) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    '${entry.key}: ${entry.value}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                            )
                          : Text(
                              scannedCode!,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    const SizedBox(height: 20),
                  ] else ...[
                    const Text(
                      'Point camera at QR code or select from gallery',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                        ),
                        label: const Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xff0a519d),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isScanning = false;
                            scannedCode = null;
                            parsedJson = null;
                          });
                        },
                        icon: const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                        ),
                        label: const Text('Scan'),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xff0a519d)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';
import 'package:eventsolutions/provider/image_provider.dart';
import 'package:eventsolutions/provider/stall_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PayAgain extends ConsumerStatefulWidget {
  const PayAgain(
      {super.key, required this.bookingId, required this.pendingAmount});
  final String bookingId;
  final double pendingAmount;

  @override
  ConsumerState<PayAgain> createState() => _PayAgainState();
}

class _PayAgainState extends ConsumerState<PayAgain> {
  final _formKey = GlobalKey<FormState>();
  final paidAmountKey = GlobalKey<FormFieldState>();
  final paidAmountController = TextEditingController();
  final String _paymentMethod = 'bank';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        try {
          ref.read(payAgainImageProvider.notifier).clearImage();
          log('Payment proof image cleared successfully');
        } catch (e) {
          log('Error clearing payment proof image: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    paidAmountController.dispose();
    super.dispose();
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
                    await ref.read(payAgainImageProvider.notifier).fromCamera();
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
                        .read(payAgainImageProvider.notifier)
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

  Future<void> _submitPayment() async {
    final selectedImage = ref.read(payAgainImageProvider);
    if (!_formKey.currentState!.validate() || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              'Please fill all required fields and upload a payment screenshot'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final paymentData = {
        'bookingId': widget.bookingId,
        'paidAmount': paidAmountController.text,
        'paymentMethod': _paymentMethod,
        'paymentProof': File(selectedImage.path),
      };

      final result = await ref.read(payAgainProvider(paymentData).future);
      paidAmountController.clear();
      ref.read(payAgainImageProvider.notifier).clearImage();

      await showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title:
                const Icon(Icons.check_circle, color: Colors.green, size: 40),
            content: Text(
              'Payment successful for booking ${result.bookingId}!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF2D5A5A),
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
        SnackBar(content: Text('Error processing payment: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Pay Again',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff50d99b),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            buildHeaderCard(),
            const SizedBox(height: 15),
            buildInfoCard(
              title: 'Booking Information',
              children: [
                infoRow('Booking ID', widget.bookingId,
                    valueStyle: const TextStyle(fontSize: 10)),
                infoRow(
                  'Pending Amount',
                  'Rs ${widget.pendingAmount.toStringAsFixed(2)}',
                  valueStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
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
                      buildPaymentAmountField(
                        label: 'Paying Amount',
                        fieldKey: paidAmountKey,
                        controller: paidAmountController,
                        totalPrice: widget.pendingAmount,
                      ),
                      qrCode(),
                      const SizedBox(height: 30),
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
                        onPressed: _submitPayment,
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
                        child: const Text(
                          'Submit Payment',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderCard() {
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
            const Icon(Icons.payment, size: 48, color: Colors.blueGrey),
            const SizedBox(height: 10),
            const Text(
              'Booking Payment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Booking ID: ${widget.bookingId}',
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

  Widget qrCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '''Please do payment in this QR code and send the payment screenshot below and wait till the payment is verified''',
          softWrap: true,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D5A5A),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/qrcode.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImageUploadSection(BuildContext context, WidgetRef ref) {
    final selectedImage = ref.watch(payAgainImageProvider);
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
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildPaymentAmountField({
    required String label,
    required GlobalKey<FormFieldState> fieldKey,
    required TextEditingController controller,
    required double totalPrice,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Paying Amount',
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Pending: Rs ${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.text = totalPrice.toStringAsFixed(2);
                      },
                      child: const Text('Pay Full'),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.text = (totalPrice / 2).toStringAsFixed(2);
                      },
                      child: const Text('Pay 50%'),
                    ),
                  ],
                ),
              ),
              TextFormField(
                key: fieldKey,
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  try {
                    final enteredAmount = double.parse(value);
                    if (enteredAmount <= 0) {
                      return 'Amount must be greater than zero';
                    }
                    if (enteredAmount > totalPrice) {
                      return 'Maximum: Rs ${totalPrice.toStringAsFixed(2)}';
                    }
                  } catch (e) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  prefixText: 'Rs ',
                  hintText: 'Enter amount to pay',
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    try {
                      final enteredAmount = double.parse(value);
                      if (enteredAmount > totalPrice) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Maximum amount: Rs ${totalPrice.toStringAsFixed(2)}'),
                            backgroundColor: Colors.orange,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    } catch (e) {
                      // Invalid number format
                    }
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

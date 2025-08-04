import 'package:eventsolutions/provider/stall_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HoldStallPage extends ConsumerStatefulWidget {
  const HoldStallPage({super.key, required this.stallIds});
  final List<String> stallIds;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HoldStallPageState();
}

class _HoldStallPageState extends ConsumerState<HoldStallPage> {
  String formatDateManually(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '0');
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
    String year = dateTime.year.toString();
    return '$day $month, $year';
  }

  final _formKey = GlobalKey<FormState>();
  final contactPersonNameKey = GlobalKey<FormFieldState>();
  final contactPersonPhoneKey = GlobalKey<FormFieldState>();
  final contactPersonEmailKey = GlobalKey<FormFieldState>();
  final contactPersonNameController = TextEditingController();
  final contactPersonPhoneController = TextEditingController();
  final contactPersonEmailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    contactPersonNameController.dispose();
    contactPersonPhoneController.dispose();
    contactPersonEmailController.dispose();
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
          title: Text('Hold Stall (${widget.stallIds.length} Stalls)'),
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
          title: Text('Hold Stall (${widget.stallIds.length} Stalls)'),
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
          'Hold Stall (${widget.stallIds.length} Stalls)',
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
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 16, right: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              final holdingData = {
                                'stallIds': widget.stallIds,
                                'contactPersonName':
                                    contactPersonNameController.text.trim(),
                                'contactPersonNumber':
                                    contactPersonPhoneController.text.trim(),
                                'contactPersonEmail':
                                    contactPersonEmailController.text.trim(),
                              };
                              final hold = await ref.read(
                                  multipleStallHoldProvider(holdingData)
                                      .future);
                              final holdExpiry = hold.holdExpiry ??
                                  DateTime.now().toIso8601String();

                              // Clear form
                              contactPersonNameController.clear();
                              contactPersonPhoneController.clear();
                              contactPersonEmailController.clear();

                              await showAdaptiveDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Icon(Icons.check_circle,
                                        color: Colors.blue, size: 40),
                                    content: Text(
                                      'Your ${widget.stallIds.length} stall(s) have been hold. Please complete payment by ${formatDateManually(DateTime.parse(holdExpiry))} to confirm booking, or the hold will be released!',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
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
                                    content:
                                        Text('Error holding stall(s): $e')),
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
                          'Hold ${widget.stallIds.length} Stall(s)',
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

  Widget infoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
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
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderCard(dynamic stall, int stallNumber) {
    return Container(
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
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
            FittedBox(
              child: Text(
                'Stall ID: ${stall.stallId}',
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'monospace',
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    TextEditingController? controller,
    bool isRequired = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
    required GlobalKey<FormFieldState> fieldKey,
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

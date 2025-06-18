// ignore_for_file: use_build_context_synchronously
import 'package:eventsolutions/provider/contact_us_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends ConsumerStatefulWidget {
  const ContactUsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends ConsumerState<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

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
    messageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'email': emailController.text.trim(),
        'name': fullNameController.text.trim(),
        'message': messageController.text.trim(),
        'phone': '$_selectedCountryCode${phoneController.text.trim()}',
      };

      try {
        final contactUsModel = await ref.read(contactusProvider(data).future);

        if (contactUsModel.success) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Thank You!'),
              content: const Text('Thank you for contacting us!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _formKey.currentState!.reset();
                    fullNameController.clear();
                    phoneController.clear();
                    emailController.clear();
                    messageController.clear();
                    setState(() {
                      _selectedCountryCode = '+977';
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(contactUsModel.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.06,
          bottom: screenHeight * 0.01,
        ),
        child: Column(
          children: [
            Text(
              'Contact Us',
              style: TextStyle(
                color: Color(0xFF2D5A5A),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            SingleChildScrollView(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Column(
                children: [
                  Card(
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
                            _buildTextField(
                              label: 'Full Name',
                              controller: fullNameController,
                              hintText: 'Enter your full name',
                            ),
                            const SizedBox(height: 20),
                            _buildPhoneField(),
                            const SizedBox(height: 20),
                            _buildTextField(
                              label: 'Email',
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Enter your email address',
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              label: 'Message',
                              controller: messageController,
                              maxLines: 5,
                              hintText: 'Enter your message',
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  // backgroundColor: Colors.black,
                                  backgroundColor: Color(0xff0a519d),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Send',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: Color(0xff0a519d),
                          ),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  "https://maps.app.goo.gl/Mm18oQMJmQBDj1H48"));
                            },
                            child: Text(
                              'Jwagal, Lalitpur, Nepal',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D5A5A)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Color(0xff0a519d),
                          ),
                          SizedBox(width: 8),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    launchUrl(
                                      Uri.parse("tel:+977-01-5260535"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                    debugPrint("Phone1 link tapped");
                                  },
                                  child: Text(
                                    '+977-01-5260535',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D5A5A)),
                                  )),
                              SizedBox(width: 4),
                              Text('/'),
                              SizedBox(width: 4),
                              InkWell(
                                onTap: () {
                                  launchUrl(
                                    Uri.parse("tel:01-5260103"),
                                    mode: LaunchMode.externalApplication,
                                  );
                                  debugPrint("Phone2 link tapped");
                                },
                                child: Text(
                                  '01-5260103',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D5A5A),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Color(0xff0a519d),
                          ),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              launchUrl(
                                mode: LaunchMode.externalApplication,
                                Uri.parse(
                                    "mailto:info@eventsolutionnepal.com.np?subject=Want to contact you&body=Hello, I would like to..."),
                              );
                              debugPrint("Email link tapped");
                            },
                            child: Text(
                              'info@eventsolutionnepal.com.np',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D5A5A),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isRequired = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
  }) {
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
                    return MyValidation.validateEmail(value);
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
                  // color: const Color(0xFFF5E6D3),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
            // Phone number input field expands to fill remaining space
            Expanded(
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
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
            ),
          ],
        ),
      ],
    );
  }
}

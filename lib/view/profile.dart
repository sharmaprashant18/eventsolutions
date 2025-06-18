// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:eventsolutions/model/user_update_model.dart';
import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
import 'package:eventsolutions/provider/image_provider.dart';
import 'package:eventsolutions/services/auth_services/auth_service.dart';
import 'package:eventsolutions/services/token_storage.dart';
import 'package:eventsolutions/view/change_password.dart';
import 'package:eventsolutions/view/loginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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
                    await ref
                        .read(profileImagePickerProvider.notifier)
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
                        .read(profileImagePickerProvider.notifier)
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

  void _toggleEdit(user) {
    setState(() {
      if (!_isEditing) {
        nameController.text = user.fullName ?? '';
        emailController.text = user.email ?? '';
        phoneController.text = user.phone ?? '';
        debugPrint('Setting controllers:');
        debugPrint('Name: ${user.fullName}');
        debugPrint('Email: ${user.email}');
        debugPrint('Phone: ${user.phone}');
      }
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = ref.read(userDetailsProvider).value;
      if (user == null) return;

      final newName = nameController.text.trim();
      final newEmail = emailController.text.trim();
      final newPhone = phoneController.text.trim();

      final nameChanged = newName != (user.fullName);
      final emailChanged = newEmail != (user.email);
      final phoneChanged = newPhone != (user.phone);

      if (!nameChanged && !emailChanged && !phoneChanged) {
        setState(() {
          _isEditing = false;
        });
        return;
      }

      final userUpdate = UserUpdateModel(
        name: newName,
        number: newPhone,
        email: newEmail,
      );

      final success = await ref
          .read(userUpdateStateProvider.notifier)
          .updateUser(userUpdate);

      if (success) {
        setState(() {
          _isEditing = false;
        });

        if (emailChanged) {
          await TokenStorage().getAccessToken();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email updated. Please log in again.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          if (kDebugMode) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully.'),
                backgroundColor: Color(0xff0a519d),
              ),
            );
          }
        }
      } else {
        final updateState = ref.read(userUpdateStateProvider);
        String errorMessage = 'Failed to update profile';

        updateState.when(
          data: (response) {
            if (response != null && !response.success) {
              errorMessage = response.message;
            }
          },
          error: (error, _) => errorMessage = error.toString(),
          loading: () {},
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = ref.watch(userDetailsProvider);
    final selectedImage = ref.watch(profileImagePickerProvider);
    final updateState = ref.watch(userUpdateStateProvider);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: screenHeight * 0.06,
            bottom: screenHeight * 0.01,
            right: screenWidth * 0.05,
            left: screenWidth * 0.05),
        child: userDetails.when(
          data: (user) => SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_isEditing) ...[
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                            });
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xff0a519d)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        updateState.when(
                          loading: () => const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          data: (_) => ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff0a519d),
                            ),
                            child: const Text('Save',
                                style: TextStyle(color: Colors.white)),
                          ),
                          error: (_, __) => ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff0a519d),
                            ),
                            child: const Text('Save',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ] else
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _toggleEdit(user),
                        ),
                    ],
                  ),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          child: selectedImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    File(selectedImage.path),
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  user.fullName.isNotEmpty
                                      ? user.fullName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                      fontSize: 70, color: Colors.black),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () =>
                                _showImageSourceDialog(context, ref),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          user.fullName.isNotEmpty ? user.fullName : 'User',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          user.email.isNotEmpty ? user.email : 'Email not set',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  const Text('Personal Information',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: screenHeight * 0.03),
                  if (_isEditing) ...[
                    _buildEditableField('Name', Icons.person_outline,
                        nameController, 'Please enter your name'),
                    _buildEditableField('Phone Number', Icons.phone_outlined,
                        phoneController, 'Please enter your phone number'),
                    _buildEditableField('Email Address', Icons.email_outlined,
                        emailController, 'Please enter your email',
                        isEmail: true),
                  ] else ...[
                    listTile('Name', Icons.person_outline, user.fullName),
                    listTile('Phone Number', Icons.phone_outlined, user.phone),
                    listTile('Email Address', Icons.email_outlined, user.email),
                  ],
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePassword()),
                      );
                    },
                    child: listTile('Change Password', Icons.lock_reset,
                        'Change your password'),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Center(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0a519d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        label: const Text('Logout',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm Logout"),
                                content: const Text(
                                    "Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      AuthService().logout();
                                      Navigator.of(context).pop();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.logout_outlined,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildEditableField(String title, IconData icon,
      TextEditingController controller, String validationMessage,
      {bool isEmail = false}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return validationMessage;
              }
              if (isEmail &&
                  !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Color(0xff0a519d), size: 19),
              labelText: title,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget listTile(String title, IconData icon, String subtitle) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Color(0xff0a519d),
                    size: 19,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 5),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:eventsolutions/view/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordKey = GlobalKey<FormFieldState>();
  final newPasswordKey = GlobalKey<FormFieldState>();
  final confirmPasswordKey = GlobalKey<FormFieldState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isResettingPassword = false;

  // Add password visibility states
  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  Future<void> passwordChange() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isResettingPassword = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.changePassword(
        oldPasswordController.text.trim(),
        newPasswordController.text.trim(),
        confirmPasswordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password Changed Successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(
              clearFields: true,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isResettingPassword = false);
      }
    }
  }

  String? validatePassword(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (fieldName == 'New Password') {
      return MyValidation.validatePassword(value);
    }

    if (fieldName == 'Confirm Password' &&
        value != newPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.06,
            bottom: screenHeight * 0.01,
            right: screenWidth * 0.03,
            left: screenWidth * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircleAvatar(
                  radius: screenWidth * 0.25,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    'assets/change_password.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Form(
                key: _formKey, // Make sure this matches the validation check
                child: Column(
                  children: [
                    buildTextField(
                      hintText: 'Old Password',
                      fieldKey: oldPasswordKey,
                      controller: oldPasswordController,
                      isObscure: !isOldPasswordVisible,
                      onVisibilityToggle: () {
                        setState(
                            () => isOldPasswordVisible = !isOldPasswordVisible);
                      },
                      validator: (value) =>
                          validatePassword(value, 'Old Password'),
                    ),
                    buildTextField(
                      hintText: 'New Password',
                      fieldKey: newPasswordKey,
                      controller: newPasswordController,
                      isObscure: !isNewPasswordVisible,
                      onVisibilityToggle: () {
                        setState(
                            () => isNewPasswordVisible = !isNewPasswordVisible);
                      },
                      validator: (value) =>
                          validatePassword(value, 'New Password'),
                    ),
                    buildTextField(
                      hintText: 'Confirm Password',
                      fieldKey: confirmPasswordKey,
                      controller: confirmPasswordController,
                      isObscure: !isConfirmPasswordVisible,
                      onVisibilityToggle: () {
                        setState(() => isConfirmPasswordVisible =
                            !isConfirmPasswordVisible);
                      },
                      validator: (value) =>
                          validatePassword(value, 'Confirm Password'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              Center(
                child: ElevatedButton(
                  onPressed: isResettingPassword ? null : passwordChange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(0, 50),
                  ),
                  child: isResettingPassword
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Confirm Change',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    bool isObscure = true,
    TextEditingController? controller,
    bool isRequired = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
    required GlobalKey<FormFieldState> fieldKey,
    VoidCallback? onVisibilityToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Card(
            elevation: 5,
            child: TextFormField(
              obscureText: isObscure,
              key: fieldKey,
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              validator: validator ??
                  (isRequired
                      ? (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        }
                      : null),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: onVisibilityToggle,
                  icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
                fillColor: Colors.white,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

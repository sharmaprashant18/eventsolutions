// ignore_for_file: use_build_context_synchronously
import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:eventsolutions/view/home_page.dart';
import 'package:eventsolutions/view/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isObscure = true;
  bool rememberMe = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setString('email', emailController.text.trim());
        await prefs.setString('password', passwordController.text.trim());
        await prefs.setBool('rememberMe', true);
      } else {
        await prefs.remove('email');
        await prefs.remove('password');
        await prefs.setBool('rememberMe', false);
      }
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.05,
                  right: screenWidth * 0.05,
                  left: screenWidth * 0.05),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                    height: screenHeight * 0.08,
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'Signup',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Text(
                          'Full Name',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: screenHeight * 0.009,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          controller: nameController,
                          validator: (value) =>
                              MyValidation.validateName(value),
                        ),
                        SizedBox(
                          height: screenHeight * 0.025,
                        ),
                        Text(
                          'Phone Number',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: screenHeight * 0.009,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          controller: phoneController,
                          validator: (value) =>
                              MyValidation.validateMobile(value),
                        ),
                        SizedBox(
                          height: screenHeight * 0.025,
                        ),
                        Text(
                          'Email',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: screenHeight * 0.009,
                        ),
                        TextFormField(
                          autofillHints:
                              rememberMe ? [AutofillHints.email] : null,
                          decoration: InputDecoration(
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          controller: emailController,
                          validator: (value) =>
                              MyValidation.validateEmail(value),
                        ),
                        SizedBox(
                          height: screenHeight * 0.025,
                        ),
                        Text(
                          'Password',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: screenHeight * 0.009,
                        ),
                        TextFormField(
                            autofillHints:
                                rememberMe ? [AutofillHints.password] : null,
                            obscureText: isObscure,
                            decoration: InputDecoration(
                                filled: false,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 10),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isObscure = !isObscure;
                                      });
                                    },
                                    icon: Icon(
                                      isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ))),
                            controller: passwordController,
                            validator: (value) {
                              return MyValidation.validatePassword(value);
                            }),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                            const Text(
                              'Remember me?',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      final authService =
                                          ref.read(authServiceProvider);

                                      // Step 1: Register the user
                                      debugPrint('Starting registration...');
                                      final registerResult =
                                          await authService.register(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                        nameController.text.trim(),
                                        phoneController.text.trim(),
                                      );

                                      debugPrint(
                                          'Registration successful: ${registerResult.message}');

                                      await saveCredentials();

                                      debugPrint(
                                          'Auto-logging in after registration...');
                                      await authService.login(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );

                                      debugPrint(
                                          'Auto-login successful, navigating to home...');

                                      if (mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage()),
                                        );
                                      }
                                    } catch (e) {
                                      debugPrint('Signup error: $e');
                                      if (mounted) {
                                        String errorMessage = e.toString();
                                        if (errorMessage
                                            .startsWith('Exception: ')) {
                                          errorMessage = errorMessage
                                              .replaceFirst('Exception: ', '');
                                        }

                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text('Registration Failed'),
                                            content: Text(errorMessage),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('OK'))
                                            ],
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey)),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey))
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.pinkAccent,
                                backgroundColor: Colors.green,
                                minimumSize: Size(0, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              onPressed: () {},
                              icon: Image.asset('assets/google.png',
                                  color: Colors.white,
                                  fit: BoxFit.contain,
                                  height: screenHeight * 0.02),
                              label: Text(
                                'Signup with Google',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        SizedBox(
                          height: screenHeight * 0.018,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already a user?',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ));
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                ),
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:eventsolutions/firebase_options.dart';
import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:eventsolutions/view/forgot_password.dart';
import 'package:eventsolutions/view/home_page.dart';
import 'package:eventsolutions/view/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.clearFields = false});
  final bool clearFields;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isObscure = true;
  bool rememberMe = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.clearFields) {
      emailController.clear();
      passwordController.clear();
    } else {
      _loadSavedCredentials();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Modified to use try-catch for error handling
  void _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('email');
      final savedPassword = prefs.getString('password');
      final remember = prefs.getBool('rememberMe') ?? false;

      if (remember && mounted) {
        setState(() {
          rememberMe = true;
          emailController.text = savedEmail ?? '';
          passwordController.text = savedPassword ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error loading saved credentials: $e');
    }
  }

  Future<void> _saveCredentials() async {
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

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });

        final authService = ref.read(authServiceProvider);

        await authService.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        // Only save credentials if login was successful
        await _saveCredentials();

        await Future.delayed(const Duration(milliseconds: 500));
        ref.refresh(userDetailsProvider);
        // Check if the widget is still mounted before navigating
        if (!mounted) return;
        // Navigate to HomePage after successful login
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Successful'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = e.toString();
          if (errorMessage.startsWith('Exception: ')) {
            errorMessage = errorMessage.replaceFirst('Exception: ', '');
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Failed: $errorMessage'),
              backgroundColor: Colors.red,
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
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
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
                    height: screenHeight * 0.08,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        const Text(
                          'Email',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: screenHeight * 0.009,
                        ),
                        TextFormField(
                          autofillHints:
                              rememberMe ? [AutofillHints.email] : null,
                          decoration: const InputDecoration(
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
                        const Text(
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
                              // activeColor: const Color(0xffED5684),
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
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: Colors.pinkAccent,
                            backgroundColor: Colors.green,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          onPressed: isLoading ? null : _handleLogin,
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
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: const ButtonStyle(
                                  overlayColor:
                                      WidgetStatePropertyAll(Colors.grey)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPassword()));
                              },
                              child: const Text(
                                'Forgot Password?',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Colors.grey)),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.grey)),
                              child: const Padding(
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(color: Colors.grey))
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Center(
                          child: Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Color(0xFF2D5A5A),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            //for normal user
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: screenWidth * 0.7,
                                height: screenHeight * 0.05,
                                child: TextButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : () async {
                                          try {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            // Initialize GoogleSignIn to always show account picker
                                            final GoogleSignIn googleSignIn =
                                                GoogleSignIn(
                                              clientId: DefaultFirebaseOptions
                                                  .currentPlatform.iosClientId,
                                              scopes: ['email', 'profile'],
                                              forceCodeForRefreshToken: true,
                                            );

                                            // Disconnect and sign out to force account selection
                                            await googleSignIn.disconnect();
                                            await googleSignIn.signOut();

                                            // Trigger Google Sign-In flow - this will now show account picker
                                            final GoogleSignInAccount?
                                                googleUser =
                                                await googleSignIn.signIn();

                                            if (googleUser == null) {
                                              // User cancelled the sign-in
                                              setState(() {
                                                isLoading = false;
                                              });
                                              return;
                                            }

                                            // Get user data
                                            final userEmail = googleUser.email;
                                            final userName =
                                                googleUser.displayName ?? '';
                                            final userId = googleUser.id;

                                            final googleSignInResult = await ref
                                                .read(googleSignInProvider({
                                              'email': userEmail,
                                              'fullName': userName,
                                              'uid': userId,
                                            }).future);

                                            // Save credentials if rememberMe is checked
                                            if (rememberMe) {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.setString(
                                                  'email', userEmail);
                                              await prefs.setBool(
                                                  'rememberMe', true);
                                            }

                                            // Refresh user details and navigate to HomePage
                                            ref.refresh(userDetailsProvider);
                                            if (mounted) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomePage()),
                                              );
                                            }
                                          } catch (e) {
                                            setState(() {
                                              isLoading = false;
                                            });

                                            if (mounted) {
                                              String errorMessage =
                                                  e.toString();
                                              if (errorMessage
                                                  .startsWith('Exception: ')) {
                                                errorMessage =
                                                    errorMessage.replaceFirst(
                                                        'Exception: ', '');
                                              }

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Google Sign-In failed: $errorMessage'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  icon: Image.asset(
                                    'assets/google.png',
                                    height: screenHeight * 0.02,
                                    width: screenWidth * 0.07,
                                  ),
                                  label: const Text(
                                    'As User',
                                    style: TextStyle(
                                      color: Color(0xFF2D5A5A),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            // For Organization Google Sign-In
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: screenWidth * 0.7,
                                height: screenHeight * 0.05,
                                child: TextButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : () async {
                                          try {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            // Initialize GoogleSignIn with forceCodeForRefreshToken to show account picker
                                            final GoogleSignIn googleSignIn =
                                                GoogleSignIn(
                                              clientId: DefaultFirebaseOptions
                                                  .currentPlatform.iosClientId,
                                              scopes: ['email', 'profile'],
                                              // Force account selection dialog
                                              forceCodeForRefreshToken: true,
                                            );

                                            // Sign out first to ensure account picker shows
                                            await googleSignIn.signOut();

                                            // Trigger Google Sign-In flow - this will now show account picker
                                            final GoogleSignInAccount?
                                                googleUser =
                                                await googleSignIn.signIn();

                                            if (googleUser == null) {
                                              // User cancelled the sign-in
                                              setState(() {
                                                isLoading = false;
                                              });
                                              return;
                                            }

                                            // Get user data
                                            final userEmail = googleUser.email;
                                            final userName =
                                                googleUser.displayName ?? '';
                                            final userId = googleUser.id;

                                            final googleSignInResult =
                                                await ref.read(
                                                    organizationGoogleSignInProvider({
                                              'email': userEmail,
                                              'fullName': userName,
                                              'uid': userId,
                                            }).future);

                                            // Save credentials if rememberMe is checked
                                            if (rememberMe) {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.setString(
                                                  'email', userEmail);
                                              await prefs.setBool(
                                                  'rememberMe', true);
                                            }

                                            // Refresh user details and navigate to HomePage
                                            ref.refresh(userDetailsProvider);
                                            if (mounted) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomePage()),
                                              );
                                            }
                                          } catch (e) {
                                            setState(() {
                                              isLoading = false;
                                            });

                                            if (mounted) {
                                              String errorMessage =
                                                  e.toString();
                                              if (errorMessage
                                                  .startsWith('Exception: ')) {
                                                errorMessage =
                                                    errorMessage.replaceFirst(
                                                        'Exception: ', '');
                                              }

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Google Sign-In failed: $errorMessage'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  icon: Image.asset(
                                    'assets/google.png',
                                    height: screenHeight * 0.02,
                                    width: screenWidth * 0.07,
                                  ),
                                  label: const Text(
                                    'As Organization',
                                    style: TextStyle(
                                      color: Color(0xFF2D5A5A),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.018,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Need an account?',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupPage(),
                                      ));
                                },
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                ),
                                child: const Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black),
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

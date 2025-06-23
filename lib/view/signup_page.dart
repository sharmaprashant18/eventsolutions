import 'package:eventsolutions/firebase_options.dart';
import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:eventsolutions/view/home_page.dart';
import 'package:eventsolutions/view/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserType { normal, organization }

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
  final TextEditingController otpController = TextEditingController();

  bool isObscure = true;
  bool rememberMe = false;
  bool isLoading = false;
  bool isOtpSent = false;
  bool isVerifyingOtp = false;
  bool isOtpVerified = false;
  UserType? selectedUserType = UserType.normal;

  final _formKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<bool> _shouldShowPhoneInput(String email, WidgetRef ref) async {
    try {
      final userDetailsAsync = await ref.refresh(userDetailsProvider.future);

      // Check if user has a phone number
      //  return userDetailsAsync.phone == null || userDetailsAsync.phone.isEmpty;
      return userDetailsAsync.phone.isEmpty;
    } catch (e) {
      // If there's an error fetching user details, show phone input as fallback
      debugPrint('Error checking user phone status: $e');
      return true;
    }
  }

  Future<void> saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setString('email', emailController.text.trim());
        await prefs.setString('password', passwordController.text.trim());
        await prefs.setBool('rememberMe', true);
        await prefs.setString('userType', selectedUserType.toString());
      } else {
        await prefs.remove('email');
        await prefs.remove('password');
        await prefs.remove('userType');
        await prefs.setBool('rememberMe', false);
      }
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
  }

  Future<void> sendOtpForSignup() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        isLoading = true;
      });

      final authService = ref.read(authServiceProvider);

      if (selectedUserType == UserType.normal) {
        await authService.register(
          nameController.text.trim(),
          phoneController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } else {
        await authService.organizationRegister(
          nameController.text.trim(),
          phoneController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      }

      setState(() {
        isOtpSent = true;
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent to your email. Please verify to continue.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.replaceFirst('Exception: ', '');
        }

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Registration Failed'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    }
  }

  Future<void> verifyOtpAndCompleteSignup() async {
    if (!_otpFormKey.currentState!.validate()) return;

    try {
      setState(() {
        isVerifyingOtp = true;
      });

      final authService = ref.read(authServiceProvider);

      await authService.verifyEmailCodeSignup(
        email: emailController.text.trim(),
        code: otpController.text.trim(),
      );

      setState(() {
        isOtpVerified = true;
        isVerifyingOtp = false;
      });

      await saveCredentials();

      debugPrint('Auto-logging in after email verification...');
      await authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      debugPrint('Auto-login successful, navigating to home...');
      ref.refresh(userDetailsProvider);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      setState(() {
        isVerifyingOtp = false;
      });

      if (mounted) {
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.replaceFirst('Exception: ', '');
        }

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Verification Failed'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    }
  }

  Widget buildSignupForm() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              'Signup',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: screenHeight * 0.04),
          const Text('User Type', style: TextStyle(fontSize: 15)),
          SizedBox(height: screenHeight * 0.009),
          DropdownButtonFormField<UserType>(
            value: selectedUserType,
            decoration: const InputDecoration(
              filled: false,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff0a519d))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
            ),
            items: const [
              DropdownMenuItem(
                value: UserType.normal,
                child: Text('Normal User'),
              ),
              DropdownMenuItem(
                value: UserType.organization,
                child: Text('Organization'),
              ),
            ],
            onChanged: isOtpSent
                ? null
                : (value) {
                    setState(() {
                      selectedUserType = value;
                    });
                  },
            validator: (value) =>
                value == null ? 'Please select a user type' : null,
          ),
          SizedBox(height: screenHeight * 0.025),
          const Text('Full Name', style: TextStyle(fontSize: 15)),
          SizedBox(height: screenHeight * 0.009),
          TextFormField(
            decoration: InputDecoration(
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff0a519d))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
            ),
            controller: nameController,
            // validator: (value) => MyValidation.validateName(value),
            enabled: !isOtpSent,
          ),
          SizedBox(height: screenHeight * 0.025),
          const Text('Phone Number', style: TextStyle(fontSize: 15)),
          SizedBox(height: screenHeight * 0.009),
          TextFormField(
            maxLength: 13,
            decoration: InputDecoration(
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff0a519d))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
            ),
            controller: phoneController,
            validator: (value) => MyValidation.validateMobile(value),
            enabled: !isOtpSent,
          ),
          SizedBox(height: screenHeight * 0.01),
          const Text('Email', style: TextStyle(fontSize: 15)),
          SizedBox(height: screenHeight * 0.009),
          TextFormField(
            autofillHints: rememberMe ? [AutofillHints.email] : null,
            decoration: InputDecoration(
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff0a519d))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
            ),
            controller: emailController,
            validator: (value) => MyValidation.validateEmail(value),
            enabled: !isOtpSent,
          ),
          SizedBox(height: screenHeight * 0.025),
          const Text('Password', style: TextStyle(fontSize: 15)),
          SizedBox(height: screenHeight * 0.009),
          TextFormField(
            autofillHints: rememberMe ? [AutofillHints.password] : null,
            obscureText: isObscure,
            decoration: InputDecoration(
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff0a519d))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              ),
            ),
            controller: passwordController,
            validator: (value) => MyValidation.validatePassword(value),
            enabled: !isOtpSent,
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: isOtpSent
                    ? null
                    : (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                activeColor: Color(0xff0a519d),
              ),
              const Text('Remember me?', style: TextStyle(fontSize: 15)),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          ElevatedButton(
            onPressed: (isLoading || isOtpSent) ? null : sendOtpForSignup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff0a519d),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    isOtpSent ? 'OTP SENT' : 'SEND OTP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildOtpVerificationForm() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Form(
      key: _otpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              'Verify Email',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Enter the 6-digit code sent to ${emailController.text}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: screenHeight * 0.04),
          const Text('Verification Code', style: TextStyle(fontSize: 15)),
          SizedBox(height: screenHeight * 0.009),
          TextFormField(
            controller: otpController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: const InputDecoration(
              filled: false,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hintText: 'Enter 6-digit code',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the verification code';
              }
              if (value.length != 6) {
                return 'Code must be 6 digits';
              }
              return null;
            },
          ),
          SizedBox(height: screenHeight * 0.03),
          ElevatedButton(
            onPressed: isVerifyingOtp ? null : verifyOtpAndCompleteSignup,
            style: ElevatedButton.styleFrom(
              // backgroundColor: Colors.green,
              backgroundColor: Color(0xff0a519d),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: isVerifyingOtp
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'VERIFY & COMPLETE SIGNUP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
          ),
          SizedBox(height: screenHeight * 0.02),
          TextButton(
            onPressed: isVerifyingOtp
                ? null
                : () {
                    setState(() {
                      isOtpSent = false;
                      otpController.clear();
                    });
                  },
            child: const Text(
              'Back to edit details',
              style: TextStyle(
                  color: Color(0xff0a519d),
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
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
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.05,
                right: screenWidth * 0.05,
                left: screenWidth * 0.05,
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                    height: screenHeight * 0.08,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  isOtpSent ? buildOtpVerificationForm() : buildSignupForm(),
                  if (!isOtpSent) ...[
                    SizedBox(height: screenHeight * 0.03),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.grey)),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              'OR',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Continue with Google',
                      style: TextStyle(
                        color: Color(0xFF2D5A5A),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
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
                              // onPressed: isLoading || isOtpSent
                              //     ? null
                              //     : () async {
                              //         try {
                              //           setState(() {
                              //             isLoading = true;
                              //           });

                              //           // Initialize GoogleSignIn to always show account picker
                              //           final GoogleSignIn googleSignIn =
                              //               GoogleSignIn(
                              //             clientId: DefaultFirebaseOptions
                              //                 .currentPlatform.iosClientId,
                              //             scopes: ['email', 'profile'],
                              //             forceCodeForRefreshToken: true,
                              //           );

                              //           // Disconnect and sign out to force account selection
                              //           // await googleSignIn.disconnect();
                              //           await googleSignIn.signOut();

                              //           // Trigger Google Sign-In flow - this will now show account picker
                              //           final GoogleSignInAccount? googleUser =
                              //               await googleSignIn.signIn();

                              //           if (googleUser == null) {
                              //             // User cancelled the sign-in
                              //             setState(() {
                              //               isLoading = false;
                              //             });
                              //             return;
                              //           }

                              //           // Get user data
                              //           final userEmail = googleUser.email;
                              //           final userName =
                              //               googleUser.displayName ?? '';
                              //           final userId = googleUser.id;

                              //           final googleSignInResult = await ref
                              //               .read(googleSignInProvider({
                              //             'email': userEmail,
                              //             'fullName': userName,
                              //             'uid': userId,
                              //           }).future);

                              //           // Save credentials if rememberMe is checked
                              //           if (rememberMe) {
                              //             final prefs = await SharedPreferences
                              //                 .getInstance();
                              //             await prefs.setString(
                              //                 'email', userEmail);
                              //             await prefs.setBool(
                              //                 'rememberMe', true);
                              //           }

                              //           // Refresh user details and navigate to HomePage
                              //           ref.refresh(userDetailsProvider);
                              //           if (mounted) {
                              //             Navigator.pushReplacement(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       const HomePage()),
                              //             );
                              //           }
                              //         } catch (e) {
                              //           setState(() {
                              //             isLoading = false;
                              //           });

                              //           if (mounted) {
                              //             String errorMessage = e.toString();
                              //             if (errorMessage
                              //                 .startsWith('Exception: ')) {
                              //               errorMessage =
                              //                   errorMessage.replaceFirst(
                              //                       'Exception: ', '');
                              //             }

                              //             ScaffoldMessenger.of(context)
                              //                 .showSnackBar(
                              //               SnackBar(
                              //                 content: Text(
                              //                     'Google Sign-In failed: $errorMessage'),
                              //                 backgroundColor: Colors.red,
                              //               ),
                              //             );
                              //           }
                              //         }
                              //       },

                              // For normal user Google Sign-In
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      try {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        final GoogleSignIn googleSignIn =
                                            GoogleSignIn(
                                          clientId: DefaultFirebaseOptions
                                              .currentPlatform.iosClientId,
                                          scopes: ['email', 'profile'],
                                          forceCodeForRefreshToken: true,
                                        );

                                        await googleSignIn.signOut();

                                        final GoogleSignInAccount? googleUser =
                                            await googleSignIn.signIn();

                                        if (googleUser == null) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          return;
                                        }

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

                                        if (rememberMe) {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString(
                                              'email', userEmail);
                                          await prefs.setBool(
                                              'rememberMe', true);
                                        }

                                        // Check if user needs to input phone number
                                        final needsPhoneInput =
                                            await _shouldShowPhoneInput(
                                                userEmail, ref);

                                        if (mounted) {
                                          if (needsPhoneInput) {
                                            // Navigate to phone input screen
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PhoneNumberInputScreen(
                                                  userEmail: userEmail,
                                                  userName: userName,
                                                ),
                                              ),
                                            );
                                          } else {
                                            // User already has phone number, go directly to HomePage
                                            ref.refresh(userDetailsProvider);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomePage()),
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });

                                        if (mounted) {
                                          String errorMessage = e.toString();
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
                              // onPressed: isLoading || isOtpSent
                              //     ? null
                              //     : () async {
                              //         try {
                              //           setState(() {
                              //             isLoading = true;
                              //           });

                              //           // Initialize GoogleSignIn with forceCodeForRefreshToken to show account picker
                              //           final GoogleSignIn googleSignIn =
                              //               GoogleSignIn(
                              //             clientId: DefaultFirebaseOptions
                              //                 .currentPlatform.iosClientId,
                              //             scopes: ['email', 'profile'],
                              //             // Force account selection dialog
                              //             forceCodeForRefreshToken: true,
                              //           );

                              //           // Sign out first to ensure account picker shows
                              //           await googleSignIn.signOut();

                              //           // Trigger Google Sign-In flow - this will now show account picker
                              //           final GoogleSignInAccount? googleUser =
                              //               await googleSignIn.signIn();

                              //           if (googleUser == null) {
                              //             // User cancelled the sign-in
                              //             setState(() {
                              //               isLoading = false;
                              //             });
                              //             return;
                              //           }

                              //           // Get user data
                              //           final userEmail = googleUser.email;
                              //           final userName =
                              //               googleUser.displayName ?? '';
                              //           final userId = googleUser.id;

                              //           final googleSignInResult = await ref.read(
                              //               organizationGoogleSignInProvider({
                              //             'email': userEmail,
                              //             'fullName': userName,
                              //             'uid': userId,
                              //           }).future);

                              //           // Save credentials if rememberMe is checked
                              //           if (rememberMe) {
                              //             final prefs = await SharedPreferences
                              //                 .getInstance();
                              //             await prefs.setString(
                              //                 'email', userEmail);
                              //             await prefs.setBool(
                              //                 'rememberMe', true);
                              //           }

                              //           // Refresh user details and navigate to HomePage
                              //           ref.refresh(userDetailsProvider);
                              //           if (mounted) {
                              //             Navigator.pushReplacement(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       const HomePage()),
                              //             );
                              //           }
                              //         } catch (e) {
                              //           setState(() {
                              //             isLoading = false;
                              //           });

                              //           if (mounted) {
                              //             String errorMessage = e.toString();
                              //             if (errorMessage
                              //                 .startsWith('Exception: ')) {
                              //               errorMessage =
                              //                   errorMessage.replaceFirst(
                              //                       'Exception: ', '');
                              //             }

                              //             ScaffoldMessenger.of(context)
                              //                 .showSnackBar(
                              //               SnackBar(
                              //                 content: Text(
                              //                     'Google Sign-In failed: $errorMessage'),
                              //                 backgroundColor: Colors.red,
                              //               ),
                              //             );
                              //           }
                              //         }
                              //       },
                              // For organization Google Sign-In
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      try {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        final GoogleSignIn googleSignIn =
                                            GoogleSignIn(
                                          clientId: DefaultFirebaseOptions
                                              .currentPlatform.iosClientId,
                                          scopes: ['email', 'profile'],
                                          forceCodeForRefreshToken: true,
                                        );

                                        await googleSignIn.signOut();

                                        final GoogleSignInAccount? googleUser =
                                            await googleSignIn.signIn();

                                        if (googleUser == null) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          return;
                                        }

                                        final userEmail = googleUser.email;
                                        final userName =
                                            googleUser.displayName ?? '';
                                        final userId = googleUser.id;

                                        final googleSignInResult = await ref.read(
                                            organizationGoogleSignInProvider({
                                          'email': userEmail,
                                          'fullName': userName,
                                          'uid': userId,
                                        }).future);

                                        if (rememberMe) {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString(
                                              'email', userEmail);
                                          await prefs.setBool(
                                              'rememberMe', true);
                                        }

                                        // Check if user needs to input phone number
                                        final needsPhoneInput =
                                            await _shouldShowPhoneInput(
                                                userEmail, ref);

                                        if (mounted) {
                                          if (needsPhoneInput) {
                                            // Navigate to phone input screen
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PhoneNumberInputScreen(
                                                  userEmail: userEmail,
                                                  userName: userName,
                                                ),
                                              ),
                                            );
                                          } else {
                                            // User already has phone number, go directly to HomePage
                                            ref.refresh(userDetailsProvider);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomePage()),
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });

                                        if (mounted) {
                                          String errorMessage = e.toString();
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
                    SizedBox(height: screenHeight * 0.018),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already a user?',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          ),
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

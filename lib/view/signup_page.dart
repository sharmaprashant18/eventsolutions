// // // // ignore_for_file: use_build_context_synchronously
// // // import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
// // // import 'package:eventsolutions/validation/form_validation.dart';
// // // import 'package:eventsolutions/view/home_page.dart';
// // // import 'package:eventsolutions/view/loginpage.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';

// // // class SignupPage extends ConsumerStatefulWidget {
// // //   const SignupPage({super.key});

// // //   @override
// // //   ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
// // // }

// // // class _SignupPageState extends ConsumerState<SignupPage> {
// // //   final TextEditingController nameController = TextEditingController();
// // //   final TextEditingController phoneController = TextEditingController();
// // //   final TextEditingController passwordController = TextEditingController();
// // //   final TextEditingController emailController = TextEditingController();
// // //   bool isObscure = true;
// // //   bool rememberMe = false;
// // //   bool isLoading = false;
// // //   bool isSendingOtp = false;
// // //   bool isResettingPassword = false;
// // //   bool isOtpSent = false;
// // //   final _formKey = GlobalKey<FormState>();
// // //   @override
// // //   void dispose() {
// // //     nameController.dispose();
// // //     phoneController.dispose();
// // //     passwordController.dispose();
// // //     emailController.dispose();
// // //     super.dispose();
// // //   }

// // //   Future<void> saveCredentials() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       if (rememberMe) {
// // //         await prefs.setString('email', emailController.text.trim());
// // //         await prefs.setString('password', passwordController.text.trim());
// // //         await prefs.setBool('rememberMe', true);
// // //       } else {
// // //         await prefs.remove('email');
// // //         await prefs.remove('password');
// // //         await prefs.setBool('rememberMe', false);
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error saving credentials: $e');
// // //     }
// // //   }

// // //   Future<void> sendOtp() async {
// // //     final email = emailController.text.trim();
// // //     if (MyValidation.validateEmail(email) != null) {
// // //       showDialog(
// // //         context: context,
// // //         builder: (_) => AlertDialog(
// // //           title: const Text('Invalid Email'),
// // //           content:
// // //               const Text('Please enter a valid email before requesting OTP.'),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context),
// // //               child: const Text('OK'),
// // //             ),
// // //           ],
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     try {
// // //       setState(() => isSendingOtp = true);
// // //       final authService = ref.read(authServiceProvider);
// // //       final result = await authService.forgotPassword(email);

// // //       if (!mounted) return;
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text(
// // //             'Verification Code is sent to your registered email',
// // //             style: TextStyle(fontSize: 12),
// // //           ),
// // //           backgroundColor: Colors.green,
// // //           behavior: SnackBarBehavior.floating,
// // //           margin: EdgeInsets.all(10),
// // //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// // //           duration: Duration(seconds: 2),
// // //         ),
// // //       );
// // //       setState(() => isOtpSent = true);
// // //     } catch (e) {
// // //       if (!mounted) return;

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text(e.toString()),
// // //           backgroundColor: Colors.red,
// // //           behavior: SnackBarBehavior.floating,
// // //           duration: Duration(seconds: 3),
// // //         ),
// // //       );
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() => isSendingOtp = false);
// // //       }
// // //     }
// // //   }

// // //   Future<void> resetPassword() async {
// // //     if (!_formKey.currentState!.validate()) return;

// // //     setState(() => isResettingPassword = true);

// // //     try {
// // //       final authService = ref.read(authServiceProvider);

// // //       await authService.verifyEmailCodeSignup(
// // //         email: emailController.text.trim(),
// // //         code: passwordController.text.trim(),
// // //       );

// // //       if (!mounted) return;
// // //       ScaffoldMessenger.of(context)
// // //           .showSnackBar(SnackBar(content: Text('Password Reset Successfully')));
// // //       await Future.delayed(Duration(seconds: 1));
// // //       if (mounted) {
// // //         Navigator.pushReplacement(
// // //             context,
// // //             MaterialPageRoute(
// // //               builder: (context) => LoginPage(
// // //                 clearFields: true,
// // //               ),
// // //             ));
// // //       }
// // //     } catch (e) {
// // //       if (!mounted) return;

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text(e.toString()),
// // //           backgroundColor: Colors.red,
// // //           behavior: SnackBarBehavior.floating,
// // //           duration: Duration(seconds: 3),
// // //         ),
// // //       );
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() => isResettingPassword = false);
// // //       }
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final screenSize = MediaQuery.of(context).size;
// // //     final screenWidth = screenSize.width;
// // //     final screenHeight = screenSize.height;

// // //     return Scaffold(
// // //       body: SingleChildScrollView(
// // //         scrollDirection: Axis.vertical,
// // //         child: Center(
// // //           child: ConstrainedBox(
// // //             constraints: BoxConstraints(maxWidth: 500),
// // //             child: Padding(
// // //               padding: EdgeInsets.only(
// // //                   top: screenHeight * 0.05,
// // //                   right: screenWidth * 0.05,
// // //                   left: screenWidth * 0.05),
// // //               child: Column(
// // //                 children: [
// // //                   Image.asset(
// // //                     'assets/logo.png',
// // //                     fit: BoxFit.cover,
// // //                     height: screenHeight * 0.08,
// // //                   ),
// // //                   SizedBox(
// // //                     height: screenHeight * 0.04,
// // //                   ),
// // //                   Form(
// // //                     key: _formKey,
// // //                     child: Column(
// // //                       mainAxisAlignment: MainAxisAlignment.center,
// // //                       crossAxisAlignment: CrossAxisAlignment.stretch,
// // //                       children: [
// // //                         Center(
// // //                           child: Text(
// // //                             'Signup',
// // //                             style: TextStyle(
// // //                                 fontSize: 30, fontWeight: FontWeight.bold),
// // //                           ),
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.04,
// // //                         ),
// // //                         Text(
// // //                           'Full Name',
// // //                           style: TextStyle(fontSize: 15),
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.009,
// // //                         ),
// // //                         TextFormField(
// // //                           decoration: InputDecoration(
// // //                             filled: false,
// // //                             contentPadding: EdgeInsets.symmetric(
// // //                                 vertical: 12, horizontal: 10),
// // //                             focusedBorder: OutlineInputBorder(
// // //                                 borderSide: BorderSide(color: Colors.green)),
// // //                             enabledBorder: OutlineInputBorder(
// // //                                 borderSide: BorderSide(color: Colors.grey)),
// // //                             border: OutlineInputBorder(
// // //                               borderSide: BorderSide(color: Colors.grey),
// // //                             ),
// // //                           ),
// // //                           controller: nameController,
// // //                           validator: (value) =>
// // //                               MyValidation.validateName(value),
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.025,
// // //                         ),
// // //                         Text(
// // //                           'Phone Number',
// // //                           style: TextStyle(fontSize: 15),
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.009,
// // //                         ),
// // //                         TextFormField(
// // //                           maxLength: 13,
// // //                           decoration: InputDecoration(
// // //                             filled: false,
// // //                             contentPadding: EdgeInsets.symmetric(
// // //                                 vertical: 12, horizontal: 10),
// // //                             focusedBorder: OutlineInputBorder(
// // //                                 borderSide: BorderSide(color: Colors.green)),
// // //                             enabledBorder: OutlineInputBorder(
// // //                                 borderSide: BorderSide(color: Colors.grey)),
// // //                             border: OutlineInputBorder(
// // //                               borderSide: BorderSide(color: Colors.grey),
// // //                             ),
// // //                           ),
// // //                           controller: phoneController,
// // //                           validator: (value) =>
// // //                               MyValidation.validateMobile(value),
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.01,
// // //                         ),
// // //                         Text(
// // //                           'Email',
// // //                           style: TextStyle(fontSize: 15),
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.009,
// // //                         ),
// // //                         TextFormField(
// // //                           autofillHints:
// // //                               rememberMe ? [AutofillHints.email] : null,
// // //                           decoration: InputDecoration(
// // //                             filled: false,
// // //                             contentPadding: EdgeInsets.symmetric(
// // //                                 vertical: 12, horizontal: 10),
// // //                             focusedBorder: OutlineInputBorder(
// // //                                 borderSide: BorderSide(color: Colors.green)),
// // //                             enabledBorder: OutlineInputBorder(
// // //                                 borderSide: BorderSide(color: Colors.grey)),
// // //                             border: OutlineInputBorder(
// // //                               borderSide: BorderSide(color: Colors.grey),
// // //                             ),
// // //                           ),
// // //                           controller: emailController,
// // //                           validator: (value) =>
// // //                               MyValidation.validateEmail(value),
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.025,
// // //                         ),
// // //                         Text(
// // //                           'Password',
// // //                           style: TextStyle(fontSize: 15),
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.009,
// // //                         ),
// // //                         TextFormField(
// // //                             autofillHints:
// // //                                 rememberMe ? [AutofillHints.password] : null,
// // //                             obscureText: isObscure,
// // //                             decoration: InputDecoration(
// // //                                 filled: false,
// // //                                 contentPadding: EdgeInsets.symmetric(
// // //                                     vertical: 12, horizontal: 10),
// // //                                 focusedBorder: OutlineInputBorder(
// // //                                     borderSide:
// // //                                         BorderSide(color: Colors.green)),
// // //                                 enabledBorder: OutlineInputBorder(
// // //                                     borderSide: BorderSide(color: Colors.grey)),
// // //                                 border: OutlineInputBorder(
// // //                                   borderSide: BorderSide(color: Colors.grey),
// // //                                 ),
// // //                                 suffixIcon: IconButton(
// // //                                     onPressed: () {
// // //                                       setState(() {
// // //                                         isObscure = !isObscure;
// // //                                       });
// // //                                     },
// // //                                     icon: Icon(
// // //                                       isObscure
// // //                                           ? Icons.visibility_off
// // //                                           : Icons.visibility,
// // //                                       color: Colors.grey,
// // //                                     ))),
// // //                             controller: passwordController,
// // //                             validator: (value) {
// // //                               return MyValidation.validatePassword(value);
// // //                             }),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.01,
// // //                         ),
// // //                         Row(
// // //                           children: [
// // //                             Checkbox(
// // //                               value: rememberMe,
// // //                               onChanged: (value) {
// // //                                 setState(() {
// // //                                   rememberMe = value!;
// // //                                 });
// // //                               },
// // //                               activeColor: Colors.green,
// // //                             ),
// // //                             const Text(
// // //                               'Remember me?',
// // //                               style: TextStyle(fontSize: 15),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.02,
// // //                         ),
// // //                         ElevatedButton(
// // //                           onPressed: isLoading
// // //                               ? null
// // //                               : () async {
// // //                                   if (_formKey.currentState!.validate()) {
// // //                                     try {
// // //                                       setState(() {
// // //                                         isLoading = true;
// // //                                       });

// // //                                       final authService =
// // //                                           ref.read(authServiceProvider);

// // //                                       // Step 1: Register the user
// // //                                       debugPrint('Starting registration...');
// // //                                       final registerResult =
// // //                                           await authService.register(
// // //                                         nameController.text.trim(),
// // //                                         phoneController.text.trim(),
// // //                                         emailController.text.trim(),
// // //                                         passwordController.text.trim(),
// // //                                       );

// // //                                       debugPrint(
// // //                                           'Registration successful: ${registerResult.message}');

// // //                                       await saveCredentials();

// // //                                       debugPrint(
// // //                                           'Auto-logging in after registration...');
// // //                                       await authService.login(
// // //                                         emailController.text.trim(),
// // //                                         passwordController.text.trim(),
// // //                                       );

// // //                                       debugPrint(
// // //                                           'Auto-login successful, navigating to home...');

// // //                                       ref.refresh(userDetailsProvider);

// // //                                       if (mounted) {
// // //                                         Navigator.pushReplacement(
// // //                                           context,
// // //                                           MaterialPageRoute(
// // //                                               builder: (context) => HomePage()),
// // //                                         );
// // //                                       }
// // //                                     } catch (e) {
// // //                                       debugPrint('Signup error: $e');
// // //                                       if (mounted) {
// // //                                         String errorMessage = e.toString();
// // //                                         if (errorMessage
// // //                                             .startsWith('Exception: ')) {
// // //                                           errorMessage = errorMessage
// // //                                               .replaceFirst('Exception: ', '');
// // //                                         }

// // //                                         showDialog(
// // //                                           context: context,
// // //                                           builder: (_) => AlertDialog(
// // //                                             title: Text('Registration Failed'),
// // //                                             content: Text(errorMessage),
// // //                                             actions: [
// // //                                               TextButton(
// // //                                                   onPressed: () =>
// // //                                                       Navigator.pop(context),
// // //                                                   child: Text('OK'))
// // //                                             ],
// // //                                           ),
// // //                                         );
// // //                                       }
// // //                                     } finally {
// // //                                       if (mounted) {
// // //                                         setState(() {
// // //                                           isLoading = false;
// // //                                         });
// // //                                       }
// // //                                     }
// // //                                   }
// // //                                 },
// // //                           style: ElevatedButton.styleFrom(
// // //                             backgroundColor: Colors.green,
// // //                             minimumSize: Size(double.infinity, 50),
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(12),
// // //                             ),
// // //                             elevation: 4,
// // //                           ),
// // //                           child: isLoading
// // //                               ? const SizedBox(
// // //                                   height: 20,
// // //                                   width: 20,
// // //                                   child: CircularProgressIndicator(
// // //                                     color: Colors.white,
// // //                                     strokeWidth: 2,
// // //                                   ),
// // //                                 )
// // //                               : const Text(
// // //                                   'SIGN UP',
// // //                                   style: TextStyle(
// // //                                     color: Colors.white,
// // //                                     fontWeight: FontWeight.bold,
// // //                                     letterSpacing: 1.2,
// // //                                   ),
// // //                                 ),
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.03,
// // //                         ),
// // //                         Row(
// // //                           children: [
// // //                             Expanded(child: Divider(color: Colors.grey)),
// // //                             Container(
// // //                               decoration: BoxDecoration(
// // //                                   shape: BoxShape.rectangle,
// // //                                   border: Border.all(color: Colors.grey)),
// // //                               child: Padding(
// // //                                 padding: EdgeInsets.all(2),
// // //                                 child: Text(
// // //                                   'OR',
// // //                                   style: TextStyle(
// // //                                       color: Colors.grey, fontSize: 13),
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             Expanded(child: Divider(color: Colors.grey))
// // //                           ],
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.02,
// // //                         ),
// // //                         // Align(
// // //                         //   alignment: Alignment.center,
// // //                         //   child: ElevatedButton.icon(
// // //                         //       style: ElevatedButton.styleFrom(
// // //                         //         // backgroundColor: Colors.pinkAccent,
// // //                         //         backgroundColor: Colors.green,
// // //                         //         minimumSize: Size(0, 50),
// // //                         //         shape: RoundedRectangleBorder(
// // //                         //           borderRadius: BorderRadius.circular(12),
// // //                         //         ),
// // //                         //         elevation: 4,
// // //                         //       ),
// // //                         //       onPressed: () {},
// // //                         //       icon: Image.asset('assets/google.png',
// // //                         //           color: Colors.white,
// // //                         //           fit: BoxFit.contain,
// // //                         //           height: screenHeight * 0.02),
// // //                         //       label: Text(
// // //                         //         'Signup with Google',
// // //                         //         style: TextStyle(color: Colors.white),
// // //                         //       )),
// // //                         // ),
// // //                         Align(
// // //                           alignment: Alignment.center,
// // //                           child: Container(
// // //                             decoration: BoxDecoration(
// // //                               color: Colors.white,
// // //                               borderRadius: BorderRadius.circular(20),
// // //                             ),
// // //                             width: screenWidth * 0.7,
// // //                             height: screenHeight * 0.05,
// // //                             child: TextButton.icon(
// // //                               onPressed: () {},
// // //                               icon: Image.asset(
// // //                                 'assets/google.png',
// // //                                 height: screenHeight * 0.02,
// // //                                 width: screenWidth * 0.07,
// // //                               ),
// // //                               label: Text(
// // //                                 'Continue with Google',
// // //                                 style: const TextStyle(
// // //                                   color: Color(0xFF2D5A5A),
// // //                                   fontSize: 17,
// // //                                   fontWeight: FontWeight.bold,
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                         SizedBox(
// // //                           height: screenHeight * 0.018,
// // //                         ),
// // //                         // Row(
// // //                         //   mainAxisAlignment: MainAxisAlignment.center,
// // //                         //   children: [
// // //                         //     Text(
// // //                         //       'Already a user?',
// // //                         //       style: TextStyle(
// // //                         //         fontSize: 18,
// // //                         //       ),
// // //                         //     ),
// // //                         //     TextButton(
// // //                         //         onPressed: () {
// // //                         //           Navigator.pushReplacement(
// // //                         //               context,
// // //                         //               MaterialPageRoute(
// // //                         //                 builder: (context) => LoginPage(),
// // //                         //               ));
// // //                         //         },
// // //                         //         style: TextButton.styleFrom(
// // //                         //           padding: EdgeInsets.symmetric(horizontal: 6),
// // //                         //         ),
// // //                         //         child: Text(
// // //                         //           'LOGIN',
// // //                         //           style: TextStyle(
// // //                         //             fontSize: 15,
// // //                         //             fontFamily: 'Montserrat',
// // //                         //             color: Colors.black,
// // //                         //             decoration: TextDecoration.underline,
// // //                         //           ),
// // //                         //         ))
// // //                         //   ],
// // //                         // ),
// // //                         Row(
// // //                           mainAxisAlignment: MainAxisAlignment.center,
// // //                           children: [
// // //                             const Text(
// // //                               'Already a user?',
// // //                               style:
// // //                                   TextStyle(color: Colors.black, fontSize: 16),
// // //                             ),
// // //                             TextButton(
// // //                                 onPressed: () {
// // //                                   Navigator.pushReplacement(
// // //                                       context,
// // //                                       MaterialPageRoute(
// // //                                         builder: (context) => const LoginPage(),
// // //                                       ));
// // //                                 },
// // //                                 style: TextButton.styleFrom(
// // //                                   padding:
// // //                                       const EdgeInsets.symmetric(horizontal: 6),
// // //                                 ),
// // //                                 child: const Text(
// // //                                   'LOGIN',
// // //                                   style: TextStyle(
// // //                                       decoration: TextDecoration.underline,
// // //                                       color: Colors.black),
// // //                                 ))
// // //                           ],
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // ignore_for_file: use_build_context_synchronously
// // import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
// // import 'package:eventsolutions/validation/form_validation.dart';
// // import 'package:eventsolutions/view/home_page.dart';
// // import 'package:eventsolutions/view/loginpage.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class SignupPage extends ConsumerStatefulWidget {
// //   const SignupPage({super.key});

// //   @override
// //   ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
// // }

// // class _SignupPageState extends ConsumerState<SignupPage> {
// //   final TextEditingController nameController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController otpController =
// //       TextEditingController(); // New OTP controller
// //   bool isObscure = true;
// //   bool rememberMe = false;
// //   bool isLoading = false;
// //   bool isSendingOtp = false;
// //   bool isVerifyingOtp = false;
// //   bool isOtpSent = false;
// //   final _formKey = GlobalKey<FormState>();
// //   final _otpFormKey = GlobalKey<FormState>(); // Key for OTP form

// //   @override
// //   void dispose() {
// //     nameController.dispose();
// //     phoneController.dispose();
// //     passwordController.dispose();
// //     emailController.dispose();
// //     otpController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> saveCredentials() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       if (rememberMe) {
// //         await prefs.setString('email', emailController.text.trim());
// //         await prefs.setString('password', passwordController.text.trim());
// //         await prefs.setBool('rememberMe', true);
// //       } else {
// //         await prefs.remove('email');
// //         await prefs.remove('password');
// //         await prefs.setBool('rememberMe', false);
// //       }
// //     } catch (e) {
// //       debugPrint('Error saving credentials: $e');
// //     }
// //   }

// //   Future<void> sendOtp() async {
// //     final email = emailController.text.trim();
// //     if (MyValidation.validateEmail(email) != null) {
// //       showDialog(
// //         context: context,
// //         builder: (_) => AlertDialog(
// //           title: const Text('Invalid Email'),
// //           content:
// //               const Text('Please enter a valid email before requesting OTP.'),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: const Text('OK'),
// //             ),
// //           ],
// //         ),
// //       );
// //       return;
// //     }

// //     try {
// //       setState(() => isSendingOtp = true);
// //       final authService = ref.read(authServiceProvider);
// //       final result = await authService.forgotPassword(email);

// //       if (!mounted) return;
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: const Text(
// //             'Verification Code sent to your email',
// //             style: TextStyle(fontSize: 12),
// //           ),
// //           backgroundColor: Colors.green,
// //           behavior: SnackBarBehavior.floating,
// //           margin: const EdgeInsets.all(10),
// //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //           duration: const Duration(seconds: 2),
// //         ),
// //       );
// //       setState(() => isOtpSent = true);
// //     } catch (e) {
// //       if (!mounted) return;

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(e.toString()),
// //           backgroundColor: Colors.red,
// //           behavior: SnackBarBehavior.floating,
// //           duration: const Duration(seconds: 3),
// //         ),
// //       );
// //     } finally {
// //       if (mounted) {
// //         setState(() => isSendingOtp = false);
// //       }
// //     }
// //   }

// //   Future<void> verifyOtpAndCompleteSignup() async {
// //     if (!_otpFormKey.currentState!.validate()) return;

// //     setState(() => isVerifyingOtp = true);

// //     try {
// //       final authService = ref.read(authServiceProvider);

// //       // Verify the OTP
// //       await authService.verifyEmailCodeSignup(
// //         email: emailController.text.trim(),
// //         code: otpController.text.trim(),
// //       );

// //       // After successful verification, proceed with login
// //       debugPrint('Auto-logging in after OTP verification...');
// //       await authService.login(
// //         emailController.text.trim(),
// //         passwordController.text.trim(),
// //       );

// //       debugPrint('Auto-login successful, navigating to home...');
// //       await saveCredentials();
// //       ref.refresh(userDetailsProvider);

// //       if (!mounted) return;
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (context) => const HomePage()),
// //       );
// //     } catch (e) {
// //       if (!mounted) return;

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(e.toString()),
// //           backgroundColor: Colors.red,
// //           behavior: SnackBarBehavior.floating,
// //           duration: const Duration(seconds: 3),
// //         ),
// //       );
// //     } finally {
// //       if (mounted) {
// //         setState(() => isVerifyingOtp = false);
// //       }
// //     }
// //   }

// //   void showOtpDialog() {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (_) => AlertDialog(
// //         title: const Text('Enter Verification Code'),
// //         content: Form(
// //           key: _otpFormKey,
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               TextFormField(
// //                 controller: otpController,
// //                 decoration: const InputDecoration(
// //                   labelText: 'OTP',
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter the OTP';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 10),
// //               TextButton(
// //                 onPressed: isSendingOtp
// //                     ? null
// //                     : () async {
// //                         await sendOtp(); // Resend OTP
// //                       },
// //                 child: const Text('Resend OTP'),
// //               ),
// //             ],
// //           ),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Cancel'),
// //           ),
// //           ElevatedButton(
// //             onPressed: isVerifyingOtp ? null : verifyOtpAndCompleteSignup,
// //             child: isVerifyingOtp
// //                 ? const SizedBox(
// //                     height: 20,
// //                     width: 20,
// //                     child: CircularProgressIndicator(strokeWidth: 2),
// //                   )
// //                 : const Text('Verify'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenSize = MediaQuery.of(context).size;
// //     final screenWidth = screenSize.width;
// //     final screenHeight = screenSize.height;

// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         scrollDirection: Axis.vertical,
// //         child: Center(
// //           child: ConstrainedBox(
// //             constraints: const BoxConstraints(maxWidth: 500),
// //             child: Padding(
// //               padding: EdgeInsets.only(
// //                 top: screenHeight * 0.05,
// //                 right: screenWidth * 0.05,
// //                 left: screenWidth * 0.05,
// //               ),
// //               child: Column(
// //                 children: [
// //                   Image.asset(
// //                     'assets/logo.png',
// //                     fit: BoxFit.cover,
// //                     height: screenHeight * 0.08,
// //                   ),
// //                   SizedBox(height: screenHeight * 0.04),
// //                   Form(
// //                     key: _formKey,
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       crossAxisAlignment: CrossAxisAlignment.stretch,
// //                       children: [
// //                         const Center(
// //                           child: Text(
// //                             'Signup',
// //                             style: TextStyle(
// //                               fontSize: 30,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                         SizedBox(height: screenHeight * 0.04),
// //                         const Text('Full Name', style: TextStyle(fontSize: 15)),
// //                         SizedBox(height: screenHeight * 0.009),
// //                         TextFormField(
// //                           decoration: const InputDecoration(
// //                             filled: false,
// //                             contentPadding: EdgeInsets.symmetric(
// //                                 vertical: 12, horizontal: 10),
// //                             focusedBorder: OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.green),
// //                             ),
// //                             enabledBorder: OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.grey),
// //                             ),
// //                             border: OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.grey),
// //                             ),
// //                           ),
// //                           controller: nameController,
// //                           validator: MyValidation.validateName,
// //                         ),
// //                         SizedBox(height: screenHeight * 0.025),
// //                         const Text('Phone Number',
// //                             style: TextStyle(fontSize: 15)),
// //                         SizedBox(height: screenHeight * 0.009),
// //                         TextFormField(
// //                           maxLength: 13,
// //                           decoration: const InputDecoration(
// //                             filled: false,
// //                             contentPadding: EdgeInsets.symmetric(
// //                                 vertical: 12, horizontal: 10),
// //                             focusedBorder: OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.green),
// //                             ),
// //                             enabledBorder: OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.grey),
// //                             ),
// //                             border: OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.grey),
// //                             ),
// //                           ),
// //                           controller: phoneController,
// //                           validator: MyValidation.validateMobile,
// //                         ),
// //                         SizedBox(height: screenHeight * 0.01),
// //                         const Text('Email', style: TextStyle(fontSize: 15)),
// //                         SizedBox(height: screenHeight * 0.009),
// //                         TextFormField(
// //                           autofillHints:
// //                               rememberMe ? [AutofillHints.email] : null,
// //                           decoration: const InputDecoration(
// //                             filled: false,
// //                             contentPadding: EdgeInsets.symmetric(
// //                                 vertical: 12, horizontal: 10),
// //                             focusedBorder: OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.green),
// //                             ),
// //                             enabledBorder: OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.grey),
// //                             ),
// //                             border: OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.grey),
// //                             ),
// //                           ),
// //                           controller: emailController,
// //                           validator: MyValidation.validateEmail,
// //                         ),
// //                         SizedBox(height: screenHeight * 0.025),
// //                         const Text('Password', style: TextStyle(fontSize: 15)),
// //                         SizedBox(height: screenHeight * 0.009),
// //                         TextFormField(
// //                           autofillHints:
// //                               rememberMe ? [AutofillHints.password] : null,
// //                           obscureText: isObscure,
// //                           decoration: InputDecoration(
// //                             filled: false,
// //                             contentPadding: const EdgeInsets.symmetric(
// //                                 vertical: 12, horizontal: 10),
// //                             focusedBorder: const OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.green),
// //                             ),
// //                             enabledBorder: const OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.grey),
// //                             ),
// //                             border: const OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.grey),
// //                             ),
// //                             suffixIcon: IconButton(
// //                               onPressed: () {
// //                                 setState(() {
// //                                   isObscure = !isObscure;
// //                                 });
// //                               },
// //                               icon: Icon(
// //                                 isObscure
// //                                     ? Icons.visibility_off
// //                                     : Icons.visibility,
// //                                 color: Colors.grey,
// //                               ),
// //                             ),
// //                           ),
// //                           controller: passwordController,
// //                           validator: MyValidation.validatePassword,
// //                         ),
// //                         SizedBox(height: screenHeight * 0.01),
// //                         Row(
// //                           children: [
// //                             Checkbox(
// //                               value: rememberMe,
// //                               onChanged: (value) {
// //                                 setState(() {
// //                                   rememberMe = value!;
// //                                 });
// //                               },
// //                               activeColor: Colors.green,
// //                             ),
// //                             const Text('Remember me?',
// //                                 style: TextStyle(fontSize: 15)),
// //                           ],
// //                         ),
// //                         SizedBox(height: screenHeight * 0.02),
// //                         ElevatedButton(
// //                           onPressed: isLoading
// //                               ? null
// //                               : () async {
// //                                   if (_formKey.currentState!.validate()) {
// //                                     try {
// //                                       setState(() {
// //                                         isLoading = true;
// //                                       });

// //                                       final authService =
// //                                           ref.read(authServiceProvider);

// //                                       // Step 1: Register the user
// //                                       debugPrint('Starting registration...');
// //                                       final registerResult =
// //                                           await authService.register(
// //                                         nameController.text.trim(),
// //                                         phoneController.text.trim(),
// //                                         emailController.text.trim(),
// //                                         passwordController.text.trim(),
// //                                       );

// //                                       debugPrint(
// //                                           'Registration successful: ${registerResult.message}');

// //                                       // Step 2: Send OTP
// //                                       await sendOtp();

// //                                       if (!mounted) return;

// //                                       // Step 3: Show OTP dialog
// //                                       showOtpDialog();
// //                                     } catch (e) {
// //                                       debugPrint('Signup error: $e');
// //                                       if (mounted) {
// //                                         String errorMessage = e.toString();
// //                                         if (errorMessage
// //                                             .startsWith('Exception: ')) {
// //                                           errorMessage = errorMessage
// //                                               .replaceFirst('Exception: ', '');
// //                                         }

// //                                         showDialog(
// //                                           context: context,
// //                                           builder: (_) => AlertDialog(
// //                                             title: const Text(
// //                                                 'Registration Failed'),
// //                                             content: Text(errorMessage),
// //                                             actions: [
// //                                               TextButton(
// //                                                 onPressed: () =>
// //                                                     Navigator.pop(context),
// //                                                 child: const Text('OK'),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         );
// //                                       }
// //                                     } finally {
// //                                       if (mounted) {
// //                                         setState(() {
// //                                           isLoading = false;
// //                                         });
// //                                       }
// //                                     }
// //                                   }
// //                                 },
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.green,
// //                             minimumSize: const Size(double.infinity, 50),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                             elevation: 4,
// //                           ),
// //                           child: isLoading
// //                               ? const SizedBox(
// //                                   height: 20,
// //                                   width: 20,
// //                                   child: CircularProgressIndicator(
// //                                     color: Colors.white,
// //                                     strokeWidth: 2,
// //                                   ),
// //                                 )
// //                               : const Text(
// //                                   'SIGN UP',
// //                                   style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontWeight: FontWeight.bold,
// //                                     letterSpacing: 1.2,
// //                                   ),
// //                                 ),
// //                         ),
// //                         SizedBox(height: screenHeight * 0.03),
// //                         Row(
// //                           children: [
// //                             const Expanded(child: Divider(color: Colors.grey)),
// //                             Container(
// //                               decoration: BoxDecoration(
// //                                 shape: BoxShape.rectangle,
// //                                 border: Border.all(color: Colors.grey),
// //                               ),
// //                               child: const Padding(
// //                                 padding: EdgeInsets.all(2),
// //                                 child: Text(
// //                                   'OR',
// //                                   style: TextStyle(
// //                                       color: Colors.grey, fontSize: 13),
// //                                 ),
// //                               ),
// //                             ),
// //                             const Expanded(child: Divider(color: Colors.grey)),
// //                           ],
// //                         ),
// //                         SizedBox(height: screenHeight * 0.02),
// //                         Align(
// //                           alignment: Alignment.center,
// //                           child: Container(
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: BorderRadius.circular(20),
// //                             ),
// //                             width: screenWidth * 0.7,
// //                             height: screenHeight * 0.05,
// //                             child: TextButton.icon(
// //                               onPressed: () {},
// //                               icon: Image.asset(
// //                                 'assets/google.png',
// //                                 height: screenHeight * 0.02,
// //                                 width: screenWidth * 0.07,
// //                               ),
// //                               label: const Text(
// //                                 'Continue with Google',
// //                                 style: TextStyle(
// //                                   color: Color(0xFF2D5A5A),
// //                                   fontSize: 17,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         SizedBox(height: screenHeight * 0.018),
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             const Text(
// //                               'Already a user?',
// //                               style:
// //                                   TextStyle(color: Colors.black, fontSize: 16),
// //                             ),
// //                             TextButton(
// //                               onPressed: () {
// //                                 Navigator.pushReplacement(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (context) => const LoginPage(),
// //                                   ),
// //                                 );
// //                               },
// //                               style: TextButton.styleFrom(
// //                                 padding:
// //                                     const EdgeInsets.symmetric(horizontal: 6),
// //                               ),
// //                               child: const Text(
// //                                 'LOGIN',
// //                                 style: TextStyle(
// //                                   decoration: TextDecoration.underline,
// //                                   color: Colors.black,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
// import 'package:eventsolutions/validation/form_validation.dart';
// import 'package:eventsolutions/view/home_page.dart';
// import 'package:eventsolutions/view/loginpage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SignupPage extends ConsumerStatefulWidget {
//   const SignupPage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
// }

// class _SignupPageState extends ConsumerState<SignupPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   bool isObscure = true;
//   bool rememberMe = false;
//   bool isLoading = false;
//   bool isSendingOtp = false;
//   bool isVerifyingOtp = false;
//   bool isOtpSent = false;
//   final _formKey = GlobalKey<FormState>();
//   final _otpFormKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     passwordController.dispose();
//     emailController.dispose();
//     otpController.dispose();
//     super.dispose();
//   }

//   Future<void> saveCredentials() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       if (rememberMe) {
//         await prefs.setString('email', emailController.text.trim());
//         await prefs.setString('password', passwordController.text.trim());
//         await prefs.setBool('rememberMe', true);
//       } else {
//         await prefs.remove('email');
//         await prefs.remove('password');
//         await prefs.setBool('rememberMe', false);
//       }
//     } catch (e) {
//       debugPrint('Error saving credentials: $e');
//     }
//   }

//   Future<void> sendOtp() async {
//     final email = emailController.text.trim();
//     if (MyValidation.validateEmail(email) != null) {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text('Invalid Email'),
//           content:
//               const Text('Please enter a valid email before requesting OTP.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     try {
//       setState(() => isSendingOtp = true);
//       final authService = ref.read(authServiceProvider);
//       final result = await authService.forgotPassword(email);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text(
//             'Verification Code sent to your email',
//             style: TextStyle(fontSize: 12),
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           margin: const EdgeInsets.all(10),
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//       setState(() => isOtpSent = true);
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => isSendingOtp = false);
//       }
//     }
//   }

//   Future<void> verifyOtpAndCompleteSignup() async {
//     if (!_otpFormKey.currentState!.validate()) return;

//     setState(() => isVerifyingOtp = true);

//     try {
//       final authService = ref.read(authServiceProvider);

//       // Verify the OTP, passing the email from emailController
//       await authService.verifyEmailCodeSignup(
//         email: emailController.text.trim(),
//         code: otpController.text.trim(),
//       );

//       // After successful verification, proceed with registration
//       debugPrint('Starting registration after OTP verification...');
//       await authService.register(
//         nameController.text.trim(),
//         phoneController.text.trim(),
//         emailController.text.trim(),
//         passwordController.text.trim(),
//       );

//       // Auto-login after successful registration
//       debugPrint('Auto-logging in after registration...');
//       await authService.login(
//         emailController.text.trim(),
//         passwordController.text.trim(),
//       );

//       debugPrint('Auto-login successful, navigating to home...');
//       await saveCredentials();
//       ref.refresh(userDetailsProvider);

//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//     } catch (e) {
//       if (!mounted) return;

//       String errorMessage = e.toString();
//       if (errorMessage.startsWith('Exception: ')) {
//         errorMessage = errorMessage.replaceFirst('Exception: ', '');
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => isVerifyingOtp = false);
//       }
//     }
//   }

//   void showOtpDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         title: const Text('Enter Verification Code'),
//         content: Form(
//           key: _otpFormKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: otpController,
//                 decoration: const InputDecoration(
//                   labelText: 'OTP',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the OTP';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 10),
//               TextButton(
//                 onPressed: isSendingOtp
//                     ? null
//                     : () async {
//                         await sendOtp();
//                       },
//                 child: const Text('Resend OTP'),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: isVerifyingOtp ? null : verifyOtpAndCompleteSignup,
//             child: isVerifyingOtp
//                 ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : const Text('Verify'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final screenWidth = screenSize.width;
//     final screenHeight = screenSize.height;

//     return Scaffold(
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 500),
//             child: Padding(
//               padding: EdgeInsets.only(
//                 top: screenHeight * 0.05,
//                 right: screenWidth * 0.05,
//                 left: screenWidth * 0.05,
//               ),
//               child: Column(
//                 children: [
//                   Image.asset(
//                     'assets/logo.png',
//                     fit: BoxFit.cover,
//                     height: screenHeight * 0.08,
//                   ),
//                   SizedBox(height: screenHeight * 0.04),
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         const Center(
//                           child: Text(
//                             'Signup',
//                             style: TextStyle(
//                               fontSize: 30,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: screenHeight * 0.04),
//                         const Text('Full Name', style: TextStyle(fontSize: 15)),
//                         SizedBox(height: screenHeight * 0.009),
//                         TextFormField(
//                           decoration: const InputDecoration(
//                             filled: false,
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 12, horizontal: 10),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.green),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                           ),
//                           controller: nameController,
//                           validator: MyValidation.validateName,
//                         ),
//                         SizedBox(height: screenHeight * 0.025),
//                         const Text('Phone Number',
//                             style: TextStyle(fontSize: 15)),
//                         SizedBox(height: screenHeight * 0.009),
//                         TextFormField(
//                           maxLength: 13,
//                           decoration: const InputDecoration(
//                             filled: false,
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 12, horizontal: 10),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.green),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                           ),
//                           controller: phoneController,
//                           validator: MyValidation.validateMobile,
//                         ),
//                         SizedBox(height: screenHeight * 0.01),
//                         const Text('Email', style: TextStyle(fontSize: 15)),
//                         SizedBox(height: screenHeight * 0.009),
//                         TextFormField(
//                           autofillHints:
//                               rememberMe ? [AutofillHints.email] : null,
//                           decoration: const InputDecoration(
//                             filled: false,
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 12, horizontal: 10),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.green),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                           ),
//                           controller: emailController,
//                           validator: MyValidation.validateEmail,
//                         ),
//                         SizedBox(height: screenHeight * 0.025),
//                         const Text('Password', style: TextStyle(fontSize: 15)),
//                         SizedBox(height: screenHeight * 0.009),
//                         TextFormField(
//                           autofillHints:
//                               rememberMe ? [AutofillHints.password] : null,
//                           obscureText: isObscure,
//                           decoration: InputDecoration(
//                             filled: false,
//                             contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 12, horizontal: 10),
//                             focusedBorder: const OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.green),
//                             ),
//                             enabledBorder: const OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             border: const OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             suffixIcon: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   isObscure = !isObscure;
//                                 });
//                               },
//                               icon: Icon(
//                                 isObscure
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                           controller: passwordController,
//                           validator: MyValidation.validatePassword,
//                         ),
//                         SizedBox(height: screenHeight * 0.01),
//                         Row(
//                           children: [
//                             Checkbox(
//                               value: rememberMe,
//                               onChanged: (value) {
//                                 setState(() {
//                                   rememberMe = value!;
//                                 });
//                               },
//                               activeColor: Colors.green,
//                             ),
//                             const Text('Remember me?',
//                                 style: TextStyle(fontSize: 15)),
//                           ],
//                         ),
//                         SizedBox(height: screenHeight * 0.02),
//                         ElevatedButton(
//                           onPressed: isLoading
//                               ? null
//                               : () async {
//                                   if (_formKey.currentState!.validate()) {
//                                     try {
//                                       setState(() {
//                                         isLoading = true;
//                                       });

//                                       final authService =
//                                           ref.read(authServiceProvider);

//                                       // Step 1: Send OTP
//                                       debugPrint('Sending OTP...');
//                                       await sendOtp();

//                                       if (!mounted) return;

//                                       // Step 2: Show OTP dialog
//                                       showOtpDialog();
//                                     } catch (e) {
//                                       debugPrint('Signup error: $e');
//                                       if (mounted) {
//                                         String errorMessage = e.toString();
//                                         if (errorMessage
//                                             .startsWith('Exception: ')) {
//                                           errorMessage = errorMessage
//                                               .replaceFirst('Exception: ', '');
//                                         }

//                                         showDialog(
//                                           context: context,
//                                           builder: (_) => AlertDialog(
//                                             title: const Text(
//                                                 'Registration Failed'),
//                                             content: Text(errorMessage),
//                                             actions: [
//                                               TextButton(
//                                                 onPressed: () =>
//                                                     Navigator.pop(context),
//                                                 child: const Text('OK'),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }
//                                     } finally {
//                                       if (mounted) {
//                                         setState(() {
//                                           isLoading = false;
//                                         });
//                                       }
//                                     }
//                                   }
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             minimumSize: const Size(double.infinity, 50),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             elevation: 4,
//                           ),
//                           child: isLoading
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                               : const Text(
//                                   'SIGN UP',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     letterSpacing: 1.2,
//                                   ),
//                                 ),
//                         ),
//                         SizedBox(height: screenHeight * 0.03),
//                         Row(
//                           children: [
//                             const Expanded(child: Divider(color: Colors.grey)),
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 border: Border.all(color: Colors.grey),
//                               ),
//                               child: const Padding(
//                                 padding: EdgeInsets.all(2),
//                                 child: Text(
//                                   'OR',
//                                   style: TextStyle(
//                                       color: Colors.grey, fontSize: 13),
//                                 ),
//                               ),
//                             ),
//                             const Expanded(child: Divider(color: Colors.grey)),
//                           ],
//                         ),
//                         SizedBox(height: screenHeight * 0.02),
//                         Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             width: screenWidth * 0.7,
//                             height: screenHeight * 0.05,
//                             child: TextButton.icon(
//                               onPressed: () {},
//                               icon: Image.asset(
//                                 'assets/google.png',
//                                 height: screenHeight * 0.02,
//                                 width: screenWidth * 0.07,
//                               ),
//                               label: const Text(
//                                 'Continue with Google',
//                                 style: TextStyle(
//                                   color: Color(0xFF2D5A5A),
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: screenHeight * 0.018),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               'Already a user?',
//                               style:
//                                   TextStyle(color: Colors.black, fontSize: 16),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const LoginPage(),
//                                   ),
//                                 );
//                               },
//                               style: TextButton.styleFrom(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 6),
//                               ),
//                               child: const Text(
//                                 'LOGIN',
//                                 style: TextStyle(
//                                   decoration: TextDecoration.underline,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously
import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:eventsolutions/view/home_page.dart';
import 'package:eventsolutions/view/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController otpController = TextEditingController();

  bool isObscure = true;
  bool rememberMe = false;
  bool isLoading = false;
  bool isOtpSent = false;
  bool isVerifyingOtp = false;
  bool isOtpVerified = false;

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

  Future<void> sendOtpForSignup() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        isLoading = true;
      });

      final authService = ref.read(authServiceProvider);

      await authService.register(
        nameController.text.trim(),
        phoneController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

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

      // Verify the OTP
      await authService.verifyEmailCodeSignup(
        email: emailController.text.trim(),
        code: otpController.text.trim(),
      );

      setState(() {
        isOtpVerified = true;
        isVerifyingOtp = false;
      });

      // Save credentials if remember me is checked
      await saveCredentials();

      // Auto-login after successful verification
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

          // Full Name Field
          const Text('Full Name', style: TextStyle(fontSize: 15)),
          SizedBox(height: screenHeight * 0.009),
          TextFormField(
            decoration: InputDecoration(
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
            ),
            controller: nameController,
            validator: (value) => MyValidation.validateName(value),
            enabled: !isOtpSent,
          ),
          SizedBox(height: screenHeight * 0.025),

          // Phone Number Field
          const Text('Phone Number', style: TextStyle(fontSize: 15)),
          SizedBox(height: screenHeight * 0.009),
          TextFormField(
            maxLength: 13,
            decoration: InputDecoration(
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
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

          // Email Field
          const Text('Email', style: TextStyle(fontSize: 15)),
          SizedBox(height: screenHeight * 0.009),
          TextFormField(
            autofillHints: rememberMe ? [AutofillHints.email] : null,
            decoration: InputDecoration(
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
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

          // Password Field
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
                  borderSide: BorderSide(color: Colors.green)),
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

          // Remember Me Checkbox
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
                activeColor: Colors.green,
              ),
              const Text('Remember me?', style: TextStyle(fontSize: 15)),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),

          // Send OTP Button
          ElevatedButton(
            onPressed: (isLoading || isOtpSent) ? null : sendOtpForSignup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
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

          // OTP Input Field
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

          // Verify OTP Button
          ElevatedButton(
            onPressed: isVerifyingOtp ? null : verifyOtpAndCompleteSignup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
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

          // Resend OTP Button
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
                  color: Colors.green, decoration: TextDecoration.underline),
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

                    // Google Sign-in Button
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
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/google.png',
                            height: screenHeight * 0.02,
                            width: screenWidth * 0.07,
                          ),
                          label: const Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Color(0xFF2D5A5A),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.018),

                    // Login Link
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

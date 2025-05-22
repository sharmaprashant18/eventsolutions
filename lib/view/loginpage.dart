// import 'package:eventsolutions/provider/auth_provider.dart';
// import 'package:eventsolutions/validation/form_validation.dart';
// import 'package:eventsolutions/view/forgot_password.dart';
// import 'package:eventsolutions/view/home_page.dart';
// import 'package:eventsolutions/view/signup_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LoginPage extends ConsumerStatefulWidget {
//   const LoginPage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
// }

// class _LoginPageState extends ConsumerState<LoginPage> {
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   bool isObscure = false;
//   bool rememberMe = false;
//   final _formKey = GlobalKey<FormState>();

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
//             constraints: BoxConstraints(
//               maxWidth: 500,
//             ),
//             child: Padding(
//               padding: EdgeInsets.only(
//                   top: screenHeight * 0.05,
//                   right: screenWidth * 0.05,
//                   left: screenWidth * 0.05),
//               child: Column(
//                 children: [
//                   Image.asset(
//                     'assets/logo.png',
//                     fit: BoxFit.cover,
//                     height: screenHeight * 0.08,
//                   ),
//                   SizedBox(
//                     height: screenHeight * 0.08,
//                   ),
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Center(
//                           child: Text(
//                             'Login',
//                             style: TextStyle(
//                                 fontSize: 30, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.04,
//                         ),
//                         Text(
//                           'Email',
//                           style: TextStyle(fontSize: 15),
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.009,
//                         ),
//                         TextFormField(
//                           autofillHints:
//                               rememberMe ? [AutofillHints.email] : null,
//                           decoration: InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 12, horizontal: 10),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey)),
//                             enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey)),
//                             disabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey)),
//                             border: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey)),
//                           ),
//                           controller: emailController,
//                           validator: (value) =>
//                               MyValidation.validateEmail(value),
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.025,
//                         ),
//                         Text(
//                           'Password',
//                           style: TextStyle(fontSize: 15),
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.009,
//                         ),
//                         TextFormField(
//                             autofillHints:
//                                 rememberMe ? [AutofillHints.password] : null,
//                             obscureText: isObscure,
//                             decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 10),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.grey)),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.grey)),
//                                 disabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.grey)),
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.grey)),
//                                 suffixIcon: IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         isObscure = !isObscure;
//                                       });
//                                     },
//                                     icon: Icon(
//                                       isObscure
//                                           ? Icons.visibility_off
//                                           : Icons.visibility,
//                                       color: Colors.grey,
//                                     ))),
//                             controller: passwordController,
//                             validator: (value) {
//                               return MyValidation.validatePassword(value);
//                             }),
//                         SizedBox(
//                           height: screenHeight * 0.01,
//                         ),
//                         Row(
//                           children: [
//                             Checkbox(
//                               value: rememberMe,
//                               onChanged: (value) {
//                                 setState(() {
//                                   rememberMe = value!;
//                                 });
//                               },
//                               activeColor: Color(0xffED5684),
//                             ),
//                             Text(
//                               'Remember me?',
//                               style: TextStyle(fontSize: 15),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.02,
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.pinkAccent,
//                             minimumSize: Size(double.infinity, 50),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             elevation: 4,
//                           ),
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               try {
//                                 final authService =
//                                     ref.read(authServiceProvider);
//                                 authService.login(
//                                   emailController.text.trim(),
//                                   passwordController.text.trim(),
//                                 );
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       'Logged in successfully',
//                                       style: TextStyle(fontSize: 12),
//                                     ),
//                                     backgroundColor: Colors.green,
//                                     behavior: SnackBarBehavior.floating,
//                                     margin: EdgeInsets.all(10),
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 5, vertical: 4),
//                                     duration: Duration(seconds: 1),
//                                   ),
//                                 );

//                                 Future.delayed(Duration(milliseconds: 500));

//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => HomePage()),
//                                 );
//                               } catch (e) {
//                                 String errorMessage = e.toString();

//                                 if (errorMessage.startsWith('Exception: ')) {
//                                   errorMessage = errorMessage.replaceFirst(
//                                       'Exception: ', '');
//                                 }

//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content:
//                                         Text('Login Failed: $errorMessage'),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                           child: Text(
//                             'LOGIN',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               style: ButtonStyle(
//                                   overlayColor:
//                                       WidgetStatePropertyAll(Colors.grey)),
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             ForgotPassword()));
//                               },
//                               child: Text(
//                                 'Forgot Password?',
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 13),
//                               ),
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.01,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(child: Divider(color: Colors.grey)),
//                             Container(
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.rectangle,
//                                   border: Border.all(color: Colors.grey)),
//                               child: Padding(
//                                 padding: EdgeInsets.all(2),
//                                 child: Text(
//                                   'OR',
//                                   style: TextStyle(
//                                       color: Colors.grey, fontSize: 13),
//                                 ),
//                               ),
//                             ),
//                             Expanded(child: Divider(color: Colors.grey))
//                           ],
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.02,
//                         ),
//                         Align(
//                           alignment: Alignment.center,
//                           child: ElevatedButton.icon(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.pinkAccent,
//                                 minimumSize: Size(0, 50),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 elevation: 4,
//                               ),
//                               onPressed: () {},
//                               icon: Image.asset(
//                                 'assets/google.png',
//                                 color: Colors.white,
//                                 fit: BoxFit.contain,
//                                 height: screenHeight * 0.02,
//                                 width: screenWidth * 0.07,
//                               ),
//                               label: Text(
//                                 'Signup with Google',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 15),
//                               )),
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.018,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Need an account?',
//                               style: TextStyle(color: Colors.black),
//                             ),
//                             TextButton(
//                                 onPressed: () {
//                                   Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => SignupPage(),
//                                       ));
//                                 },
//                                 style: TextButton.styleFrom(
//                                   padding: EdgeInsets.symmetric(horizontal: 6),
//                                 ),
//                                 child: Text(
//                                   'SIGN UP',
//                                   style: TextStyle(
//                                       decoration: TextDecoration.underline,
//                                       color: Colors.black),
//                                 ))
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

import 'dart:async';
import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
import 'package:eventsolutions/validation/form_validation.dart';
import 'package:eventsolutions/view/forgot_password.dart';
import 'package:eventsolutions/view/home_page.dart';
import 'package:eventsolutions/view/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

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

    _loadSavedCredentials();
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
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
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 10),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                disabledBorder: const OutlineInputBorder(
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
                              activeColor: const Color(0xffED5684),
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
                            backgroundColor: Colors.pinkAccent,
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
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/google.png',
                              color: Colors.white,
                              fit: BoxFit.contain,
                              height: screenHeight * 0.02,
                              width: screenWidth * 0.07,
                            ),
                            label: const Text(
                              'Login with Google',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
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
                                  Navigator.pushReplacement(
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

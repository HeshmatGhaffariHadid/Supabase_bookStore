import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../custom-widgets/text_form_field.dart';
import '../../supabase_config.dart';
import '../home_page.dart';
import 'SignUp_page.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/signIn';

  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailNode = FocusNode();
  final passwordNode = FocusNode();

  bool obSecureText = true;
  String errorMessage = '';
  bool loggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF5F5F5),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 30,
                  children: [
                    Text(
                      'Welcome Back 😊',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTextFormField(
                      node: emailNode,
                      controller: emailController,
                      label: 'Enter your email',
                      inputType: TextInputType.emailAddress,
                    ),
                    CustomTextFormField(
                      node: passwordNode,
                      controller: passwordController,
                      label: 'Enter your password',
                      hideText: obSecureText,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obSecureText = !obSecureText;
                          });
                        },
                        icon:
                            obSecureText
                                ? Icon(Icons.visibility_off_outlined)
                                : Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.indigo,
                                ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              loggingIn = true;
                            });

                            if (kDebugMode) {
                              print('🟡 user is signing in...');
                            }
                            await SupabaseConfig.client.auth.signInWithPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                            if (kDebugMode) {
                              print('🟢 user logged in successfully');
                            }
                            Navigator.pushReplacementNamed(
                              context,
                              HomePage.routName,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Welcome back')),
                            );
                          } catch (e) {
                            if (kDebugMode) {
                              print('🔴 Failed to sign-in, error: $e');
                            }
                            setState(() {
                              loggingIn = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Login failed, user not found!'),
                              ),
                            );
                          } finally {
                            setState(() {
                              loggingIn = false;
                            });
                            emailController.clear();
                            passwordController.clear();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                      ),
                      child:
                          loggingIn
                              ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                              : Text('Login', style: TextStyle(fontSize: 20)),
                    ),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Text('or', style: TextStyle(fontSize: 22)),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpPage.routeName);
                      },
                      child: Text(
                        'Create an Account',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

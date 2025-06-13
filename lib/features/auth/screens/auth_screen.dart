import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';

enum Auth { singin, singup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const String routeName = '/auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _singUpFormKey = GlobalKey<FormState>();
  final _singInFormKey = GlobalKey<FormState>();
  Auth _auth = Auth.singup;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameCotroller = TextEditingController();

  @override
  void dispose() {
    // reduce memory leaks
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameCotroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),

              ListTile(
                tileColor: _auth == Auth.singup? GlobalVariables.backgroundColor: GlobalVariables.greyBackgroundCOlor,
                title: const Text(
                  'Create Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth.singup,
                  groupValue: _auth,
                  onChanged: (Auth? val) {
                    setState(() {
                      _auth = val!;
                    });
                  },
                ),
              ),
              if (_auth == Auth.singup)
                Container(
                  padding: EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: _singUpFormKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _nameCotroller,
                          hintText: 'Name',
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email',
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                        ),
                        SizedBox(height: 10),
                        CustomButton(text: 'Sign Up', onTap: () {}),
                      ],
                    ),
                  ),
                ),
              ListTile(
                tileColor: _auth == Auth.singin? GlobalVariables.backgroundColor: GlobalVariables.greyBackgroundCOlor,
                title: const Text(
                  'Sign-In',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth.singin,
                  groupValue: _auth,
                  onChanged: (Auth? val) {
                    setState(() {
                      _auth = val!;
                    });
                  },
                ),
              ),
              if (_auth == Auth.singin)
                Container(
                  padding: EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: _singInFormKey,
                    child: Column(
                      children: [

                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email',
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                        ),
                        SizedBox(height: 10),
                        CustomButton(text: 'Sign In', onTap: () {}),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

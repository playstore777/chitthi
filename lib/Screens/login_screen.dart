import 'package:chitthi/Widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    // TODO: implement initState
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: RiveAnimation.asset(
                'assets/login_screen_character.riv',
                fit: BoxFit.fitHeight,
                stateMachines: const ['Login Machine'],
                onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(
                    artboard,
                    'Login Machine',
                  );
                  if (controller == null) return;

                  artboard.addController(controller as StateMachineController);
                  isChecking = controller?.findInput("isChecking");
                  numLook = controller?.findInput("numLook");
                  isHandsUp = controller?.findInput("isHandsUp");
                  trigSuccess = controller?.findInput("trigSuccess");
                  trigFail = controller?.findInput("trigFail");
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: emailController,
              focusNode: emailFocusNode,
              cursorColor: Colors.white,
              onChanged: (value) {
                numLook?.change(value.length.toDouble());
              },
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: passwordController,
              focusNode: passwordFocusNode,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              icon: const Icon(Icons.lock_open),
              label: const Text(
                'Sign In',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: signIn,
            ),
          ]),
        ));
  }

  Future signIn() async {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    var email = emailController.text.trim();
    var pass = passwordController.text.trim();

    showLoadingDialog(context);
    FirebaseAuth.instance.signOut();
    debugPrint('Current user: ${FirebaseAuth.instance.currentUser}');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    debugPrint('is mounted: $mounted');
    if (mounted) Navigator.pop(context);
    if (FirebaseAuth.instance.currentUser != null) {
      trigSuccess?.change(true);
    } else {
      trigFail?.change(true);
    }
  }
}

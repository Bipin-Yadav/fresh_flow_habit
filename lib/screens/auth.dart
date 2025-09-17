import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isSignIn = true;  // Toggle between Sign In and Sign Up
  bool isLoading = false;
  String errorMessage = "";

  void toggleForm() {
    setState(() {
      isSignIn = !isSignIn;
      errorMessage = "";
      _emailController.clear();
      _passwordController.clear();
      _fullNameController.clear();
      _phoneController.clear();
    });
  }

  Future<void> signIn() async {
    setState(() => isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(), password: _passwordController.text);
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Login failed";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> signUp() async {
    setState(() => isLoading = true);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(), password: _passwordController.text);

      // Optional: Save additional user info (Full name, phone) to Firestore here

      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Signup failed";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> signInAsGuest() async {
    setState(() => isLoading = true);

    try {
      await _auth.signInAnonymously();
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Guest login failed";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildForm() {
    if (isSignIn) {
      // Sign In Form
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(height: 12),
          const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              hintText: 'Enter your password',
            ),
          ),
          const SizedBox(height: 16),
          if (errorMessage.isNotEmpty)
            Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: isLoading ? null : signIn,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16C9E6),
                minimumSize: const Size(double.infinity, 50)),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Sign In'),
          ),
          TextButton(
            onPressed: toggleForm,
            child: const Text("Don't have an account? Sign Up"),
          ),
          const SizedBox(height: 12),
          Divider(),
          TextButton(
            onPressed: isLoading ? null : signInAsGuest,
            child: const Text('Continue as Guest'),
          ),
        ],
      );
    } else {
      // Sign Up Form
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              hintText: 'Enter your full name',
            ),
          ),
          const SizedBox(height: 12),
          const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(height: 12),
          const Text('Phone (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined),
              hintText: 'Enter your phone number',
            ),
          ),
          const SizedBox(height: 12),
          const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              hintText: 'Create a password',
            ),
          ),
          const SizedBox(height: 16),
          if (errorMessage.isNotEmpty)
            Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: isLoading ? null : signUp,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16C9E6),
                minimumSize: const Size(double.infinity, 50)),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Create Account'),
          ),
          TextButton(
            onPressed: toggleForm,
            child: const Text('Already have an account? Sign In'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F7FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF16C9E6),
                  radius: 30,
                  child: Image.asset('assets/splash_bg.png', width: 200, height: 200),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to HabitFlow',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Your journey to better habits starts here',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: buildForm(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Developed in partnership with',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const Text(
                  'True Heal Multispeciality Hospital',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  'Supporting patient wellness and health tracking',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

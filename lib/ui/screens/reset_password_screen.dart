import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project01/ui/screens/sign_in_screen.dart';
import 'package:project01/ui/utils/app_colors.dart';
import 'package:project01/ui/widgets/screen_background.dart';
import 'package:project01/data/models/network_response.dart';
import 'package:project01/data/services/network_caller.dart';
import 'package:project01/ui/widgets/snack_bar_message.dart';
import 'package:project01/data/utils/urls.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp; // Add OTP parameter

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp, // Make OTP required
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool _isRequestInProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82),
                Text(
                  'Set Password',
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Minimum number of password should be 8 letters',
                  style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildResetPasswordForm(),
                const SizedBox(height: 48),
                Center(
                  child: _buildHaveAccountSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Column(
      children: [
      TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(hintText: 'Password'),
      obscureText: true,
    ),
    const SizedBox(height: 8),
    TextFormField(
    controller: _confirmPasswordController,
    decoration: const InputDecoration(hintText: 'Confirm Password'),
    obscureText: true,
    ),
    const SizedBox(height: 24),
    _isRequestInProgress
    ? const CircularProgressIndicator()
        : ElevatedButton(
    onPressed: _onTapNextButton,
    child: const Icon(Icons.arrow_circle_right_outlined),
    ),
      ],
    );
  }

  Widget _buildHaveAccountSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.5),
        text: "Have account? ",
        children: [
          TextSpan(
              text: 'Sign In',
              style: const TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignIn),
        ],
      ),
    );
  }

  Future<void> _onTapNextButton() async {
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      showSnackBarMessage(context, "Please fill in both fields.", true);
      return;
    }

    if (password != confirmPassword) {
      showSnackBarMessage(context, "Passwords do not match.", true);
      return;
    }

    if (password.length < 8) {
      showSnackBarMessage(
          context, "Password must be at least 8 characters.", true);
      return;
    }

    _isRequestInProgress = true;
    setState(() {});

    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.recoverPassword,
        body: {
          "email": widget.email,
          "OTP": widget.otp, // Use received OTP
          "password": password,
        },
      );

      if (response.isSuccess) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
              (_) => false,
        );
      } else {
        showSnackBarMessage(context, response.errorMessage, true);
      }
    } catch (e) {
      showSnackBarMessage(context, 'An error occurred: $e', true);
    } finally {
      _isRequestInProgress = false;
      setState(() {});
    }
  }

  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (_) => false,
    );
  }
}
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project01/ui/screens/forgot_password_otp_screen.dart';
import 'package:project01/ui/utils/app_colors.dart';
import 'package:project01/ui/widgets/screen_background.dart';
import 'package:project01/data/models/network_response.dart';
import 'package:project01/data/services/network_caller.dart';
import 'package:project01/ui/widgets/snack_bar_message.dart';
import 'package:project01/data/utils/urls.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
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
                  'Your Email Address',
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'A 6 digits verification OTP will be sent to your email address',
                  style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildVerifyEmailForm(),
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

  Widget _buildVerifyEmailForm() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Email'),
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
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      showSnackBarMessage(context, "Please enter your email.", true);
      return;
    }

    _isRequestInProgress = true;
    setState(() {});

    final String apiUrl = Urls.forgetPasswordVerifyEmail(email);

    try {
      final NetworkResponse response =
      await NetworkCaller.getRequest(url: apiUrl);

      if (response.isSuccess) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordOtpScreen(email: email),
          ),
        );
      } else {
        showSnackBarMessage(
            context,
            response.errorMessage ?? 'Something went wrong. Please try again.',
            true);
      }
    } catch (e) {
      showSnackBarMessage(context, 'An error occurred: $e', true);
    } finally {
      _isRequestInProgress = false;
      setState(() {});
    }
  }

  void _onTapSignIn() {
    Navigator.pop(context);
  }
}
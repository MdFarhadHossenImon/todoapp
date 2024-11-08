import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:project01/ui/screens/reset_password_screen.dart';
import 'package:project01/ui/screens/sign_in_screen.dart';
import 'package:project01/ui/utils/app_colors.dart';
import 'package:project01/ui/widgets/screen_background.dart';
import 'package:project01/data/models/network_response.dart';
import 'package:project01/data/services/network_caller.dart';
import 'package:project01/ui/widgets/snack_bar_message.dart';
import 'package:project01/data/utils/urls.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpScreen({super.key, required this.email});

  @override
  _ForgotPasswordOtpScreenState createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
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
                  'Pin Verification',
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'A 6 digits verification OTP has been sent to your email address',
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
        PinCodeTextField(
          controller: _otpController,
          length: 6,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.white,
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          appContext: context,
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
            recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
          ),
        ],
      ),
    );
  }

  Future<void> _onTapNextButton() async {
    final String email = widget.email;
    final String otp = _otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      showSnackBarMessage(context, "Please enter a valid 6-digit OTP.", true);
      return;
    }

    setState(() {
      _isRequestInProgress = true;
    });

    try {
      String url = Urls.forgetPasswordOtpVerify(email, otp);

      final NetworkResponse response = await NetworkCaller.getRequest(url: url);

      if (response.isSuccess) {
        // Navigate to ResetPasswordScreen with email and OTP
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              email: email,
              otp: otp, // Pass OTP to ResetPasswordScreen
            ),
          ),
        );
      } else {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Something went wrong. Please try again.',
          true,
        );
      }
    } catch (e) {
      showSnackBarMessage(context, 'An error occurred: $e', true);
    } finally {
      setState(() {
        _isRequestInProgress = false;
      });
    }
  }

  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
    );
  }
}
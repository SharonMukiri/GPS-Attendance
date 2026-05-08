import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class OtpVerificationWidget extends StatefulWidget {
  final String email;
  final VoidCallback onVerified;
  final VoidCallback onBack;

  const OtpVerificationWidget({
    super.key,
    required this.email,
    required this.onVerified,
    required this.onBack,
  });

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production OTP state
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _hasError = false;
  String _errorText = '';
  int _resendCountdown = 30;
  Timer? _timer;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  // Mock OTP for demo
  static const _mockOtp = '123456';

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _resendCountdown = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendCountdown <= 1) {
        t.cancel();
      }
      if (mounted) setState(() => _resendCountdown--);
    });
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  String get _enteredOtp => _otpControllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length < 6) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // TODO: Replace with Supabase auth.verifyOtp() / Twilio verification check
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      if (_enteredOtp == _mockOtp) {
        setState(() => _isLoading = false);
        widget.onVerified();
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorText = 'Incorrect code. Please check your SMS and try again.';
        });
        _shakeController.forward(from: 0);
        for (final c in _otpControllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.message_rounded,
                  color: AppTheme.primary,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Verify Your Identity',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We sent a 6-digit code via SMS to the\nnumber linked to',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF78909C),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              widget.email,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            // OTP input boxes
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: child,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  return Padding(
                    padding: EdgeInsets.only(right: i < 5 ? 10 : 0),
                    child: _OtpBox(
                      controller: _otpControllers[i],
                      focusNode: _focusNodes[i],
                      hasError: _hasError,
                      onChanged: (val) {
                        if (val.isNotEmpty && i < 5) {
                          _focusNodes[i + 1].requestFocus();
                        } else if (val.isEmpty && i > 0) {
                          _focusNodes[i - 1].requestFocus();
                        }
                        if (_enteredOtp.length == 6) {
                          _verifyOtp();
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            if (_hasError) ...[
              const SizedBox(height: 12),
              Text(
                _errorText,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: (_isLoading || _enteredOtp.length < 6)
                    ? null
                    : _verifyOtp,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Verify Code',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code? ",
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: const Color(0xFF78909C),
                  ),
                ),
                _resendCountdown > 0
                    ? Text(
                        'Resend in ${_resendCountdown}s',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF78909C),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          // TODO: Trigger Twilio SMS resend via Supabase Edge Function
                          _startResendTimer();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Resend Code',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Back to Sign In'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF78909C),
              ),
            ),
            const SizedBox(height: 16),
            // Demo hint
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.infoContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.info,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demo OTP: 123456',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: GoogleFonts.manrope(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: hasError ? AppTheme.error : const Color(0xFF1A1A2E),
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: hasError
              ? AppTheme.errorContainer
              : AppTheme.surfaceVariantLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? AppTheme.error : AppTheme.outlineVariantLight,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? AppTheme.error : AppTheme.primary,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

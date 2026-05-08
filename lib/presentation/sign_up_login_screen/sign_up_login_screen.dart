import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import './widgets/demo_credentials_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/otp_verification_widget.dart';
import './widgets/signup_form_widget.dart';

class SignUpLoginScreen extends StatefulWidget {
  const SignUpLoginScreen({super.key});

  @override
  State<SignUpLoginScreen> createState() => _SignUpLoginScreenState();
}

class _SignUpLoginScreenState extends State<SignUpLoginScreen>
    with TickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production auth state
  late TabController _tabController;
  late AnimationController _logoAnimController;
  late AnimationController _formAnimController;
  late Animation<double> _logoScaleAnim;
  late Animation<double> _logoFadeAnim;
  late Animation<Offset> _formSlideAnim;
  late Animation<double> _formFadeAnim;

  bool _showOtpScreen = false;
  String _pendingEmail = '';
  String _pendingRole = 'student';
  bool _isLecturer = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _logoAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _formAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _logoScaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimController, curve: Curves.easeOutBack),
    );
    _logoFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimController, curve: Curves.easeOut),
    );
    _formSlideAnim =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _formAnimController,
            curve: Curves.easeOutCubic,
          ),
        );
    _formFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formAnimController, curve: Curves.easeOut),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      _logoAnimController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _formAnimController.forward();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _logoAnimController.dispose();
    _formAnimController.dispose();
    super.dispose();
  }

  void _onLoginSuccess(String email, String role) {
    // TODO: Integrate Twilio 2FA SMS trigger here via Supabase Edge Function
    setState(() {
      _pendingEmail = email;
      _pendingRole = role;
      _showOtpScreen = true;
    });
  }

  void _onOtpVerified() {
    // TODO: Set authenticated session in Supabase auth
    final isLecturer = _pendingRole == 'lecturer';
    setState(() {
      _isLecturer = isLecturer;
    });
    Fluttertoast.showToast(
      msg: 'Welcome back! Signed in successfully.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF1A1A2E),
      textColor: Colors.white,
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.homeScreen,
      (route) => false,
      arguments: {'isLecturer': isLecturer, 'email': _pendingEmail},
    );
  }

  void _onSignupSuccess(String email) {
    // TODO: Store user profile in Supabase database
    Fluttertoast.showToast(
      msg: 'Account created! Please sign in.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: Colors.white,
    );
    setState(() {
      _tabController.animateTo(0);
    });
  }

  void _onBackFromOtp() {
    setState(() {
      _showOtpScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: _showOtpScreen
              ? OtpVerificationWidget(
                  key: const ValueKey('otp'),
                  email: _pendingEmail,
                  onVerified: _onOtpVerified,
                  onBack: _onBackFromOtp,
                )
              : _buildAuthForms(isTablet),
        ),
      ),
    );
  }

  Widget _buildAuthForms(bool isTablet) {
    return SingleChildScrollView(
      key: const ValueKey('auth_forms'),
      physics: const ClampingScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 480 : double.infinity,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 0 : 24,
              vertical: 24,
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Logo section
                FadeTransition(
                  opacity: _logoFadeAnim,
                  child: ScaleTransition(
                    scale: _logoScaleAnim,
                    child: _buildLogoSection(),
                  ),
                ),
                const SizedBox(height: 32),
                // Form card
                SlideTransition(
                  position: _formSlideAnim,
                  child: FadeTransition(
                    opacity: _formFadeAnim,
                    child: _buildFormCard(),
                  ),
                ),
                const SizedBox(height: 16),
                // Demo credentials
                SlideTransition(
                  position: _formSlideAnim,
                  child: FadeTransition(
                    opacity: _formFadeAnim,
                    child: const DemoCredentialsWidget(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withAlpha(89),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'GeoAttend',
          style: GoogleFonts.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'GPS-Verified Attendance System',
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF78909C),
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tab bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF78909C),
              tabs: const [
                Tab(text: 'Sign In'),
                Tab(text: 'Sign Up'),
              ],
            ),
          ),
          SizedBox(
            height: 480,
            child: TabBarView(
              controller: _tabController,
              children: [
                LoginFormWidget(onLoginSuccess: _onLoginSuccess),
                SignupFormWidget(onSignupSuccess: _onSignupSuccess),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SignupFormWidget extends StatefulWidget {
  final Function(String email) onSignupSuccess;

  const SignupFormWidget({super.key, required this.onSignupSuccess});

  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  // TODO: Replace with Riverpod/Bloc for production state
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _isLecturerSignup = false;
  bool _agreedToTerms = false;
  String? _inviteCodeError;

  // Secure lecturer invite code — in production, validate server-side via Supabase RPC
  static const _validLecturerCode = 'LECT-2024-SECURE';

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please accept the Terms of Service to continue.',
            style: GoogleFonts.manrope(fontSize: 13),
          ),
        ),
      );
      return;
    }

    if (_isLecturerSignup &&
        _inviteCodeController.text.trim() != _validLecturerCode) {
      setState(() => _inviteCodeError = 'Invalid lecturer invite code');
      return;
    }

    setState(() {
      _isLoading = true;
      _inviteCodeError = null;
    });

    // TODO: Replace with Supabase auth.signUp() + insert into profiles table with role
    await Future.delayed(const Duration(milliseconds: 1400));

    if (mounted) {
      setState(() => _isLoading = false);
      widget.onSignupSuccess(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Role toggle — students can self-register; lecturers need invite code
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.infoContainer,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.info.withAlpha(77)),
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
                      'Students register freely. Lecturers require an invite code from your institution.',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.info,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Role selector
            Row(
              children: [
                Expanded(
                  child: _RoleChip(
                    label: 'Student',
                    iconName: 'school',
                    isSelected: !_isLecturerSignup,
                    onTap: () => setState(() => _isLecturerSignup = false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _RoleChip(
                    label: 'Lecturer',
                    iconName: 'menu_book',
                    isSelected: _isLecturerSignup,
                    onTap: () => setState(() => _isLecturerSignup = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Full name is required'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _studentIdController,
              textInputAction: TextInputAction.next,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: _isLecturerSignup ? 'Staff ID' : 'Student ID',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: 'badge',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'ID is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'Institutional Email',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: 'email',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'Password',
                helperText: 'Min. 8 characters with uppercase and number',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: CustomIconWidget(
                    iconName: _obscurePassword
                        ? 'visibility_off'
                        : 'visibility',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 8) return 'Minimum 8 characters';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              textInputAction: TextInputAction.next,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: CustomIconWidget(
                    iconName: _obscureConfirm ? 'visibility_off' : 'visibility',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Please confirm your password';
                }
                if (v != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            if (_isLecturerSignup) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _inviteCodeController,
                textInputAction: TextInputAction.done,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  labelText: 'Lecturer Invite Code',
                  helperText: 'Provided by your institution administrator',
                  errorText: _inviteCodeError,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomIconWidget(
                      iconName: 'key',
                      color: AppTheme.warning,
                      size: 20,
                    ),
                  ),
                  filled: true,
                  fillColor: AppTheme.warningContainer,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.warning.withAlpha(102),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.warning,
                      width: 2,
                    ),
                  ),
                ),
                validator: (v) {
                  if (_isLecturerSignup && (v == null || v.isEmpty)) {
                    return 'Invite code is required for lecturers';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: _agreedToTerms,
                    onChanged: (v) =>
                        setState(() => _agreedToTerms = v ?? false),
                    activeColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _isLoading ? null : _handleSignup,
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
                        'Create Account',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final String iconName;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.iconName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.outlineLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.white : const Color(0xFF78909C),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF4A5568),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

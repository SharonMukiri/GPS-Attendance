import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class DemoCredentialsWidget extends StatelessWidget {
  const DemoCredentialsWidget({super.key});

  static const _credentials = [
    {
      'role': 'Student',
      'email': 'amara.osei@geoattend.edu',
      'password': 'Student@2024',
      'icon': 'school',
      'color': AppTheme.secondary,
    },
    {
      'role': 'Lecturer',
      'email': 'dr.kwame.mensah@geoattend.edu',
      'password': 'Lecturer@2024',
      'icon': 'menu_book',
      'color': AppTheme.primary,
    },
  ];

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
      msg: '$label copied to clipboard',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF1A1A2E),
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariantLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.warningContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'key',
                    color: AppTheme.warning,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Demo Credentials',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warningContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Testing Only',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...List.generate(_credentials.length, (i) {
            final cred = _credentials[i];
            final color = cred['color'] as Color;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: color.withAlpha(31),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: cred['icon'] as String,
                              color: color,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            cred['role'] as String,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _CredentialRow(
                        label: 'Email',
                        value: cred['email'] as String,
                        onCopy: () => _copyToClipboard(
                          context,
                          cred['email'] as String,
                          'Email',
                        ),
                      ),
                      const SizedBox(height: 6),
                      _CredentialRow(
                        label: 'Password',
                        value: cred['password'] as String,
                        onCopy: () => _copyToClipboard(
                          context,
                          cred['password'] as String,
                          'Password',
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < _credentials.length - 1) const Divider(height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _CredentialRow({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF78909C),
              letterSpacing: 0.2,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A2E),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onCopy,
          child: Container(
            padding: const EdgeInsets.all(4),
            child: CustomIconWidget(
              iconName: 'copy',
              color: AppTheme.primary,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }
}

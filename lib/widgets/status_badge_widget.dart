import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum AttendanceStatus { present, absent, pending, excused, late }

enum SessionStatus { active, scheduled, closed, cancelled }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double fontSize;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.fontSize = 11,
  });

  factory StatusBadgeWidget.attendance(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return StatusBadgeWidget(
          label: 'Present',
          backgroundColor: AppTheme.successContainer,
          textColor: AppTheme.success,
          icon: Icons.check_circle_rounded,
        );
      case AttendanceStatus.absent:
        return StatusBadgeWidget(
          label: 'Absent',
          backgroundColor: AppTheme.errorContainer,
          textColor: AppTheme.error,
          icon: Icons.cancel_rounded,
        );
      case AttendanceStatus.pending:
        return StatusBadgeWidget(
          label: 'Pending',
          backgroundColor: AppTheme.warningContainer,
          textColor: AppTheme.warning,
          icon: Icons.schedule_rounded,
        );
      case AttendanceStatus.excused:
        return StatusBadgeWidget(
          label: 'Excused',
          backgroundColor: AppTheme.infoContainer,
          textColor: AppTheme.info,
          icon: Icons.info_rounded,
        );
      case AttendanceStatus.late:
        return StatusBadgeWidget(
          label: 'Late',
          backgroundColor: const Color(0xFFFFF3E0),
          textColor: const Color(0xFFE65100),
          icon: Icons.watch_later_rounded,
        );
    }
  }

  factory StatusBadgeWidget.session(SessionStatus status) {
    switch (status) {
      case SessionStatus.active:
        return StatusBadgeWidget(
          label: 'Active',
          backgroundColor: AppTheme.successContainer,
          textColor: AppTheme.success,
          icon: Icons.radio_button_checked,
        );
      case SessionStatus.scheduled:
        return StatusBadgeWidget(
          label: 'Scheduled',
          backgroundColor: AppTheme.infoContainer,
          textColor: AppTheme.info,
          icon: Icons.schedule_rounded,
        );
      case SessionStatus.closed:
        return StatusBadgeWidget(
          label: 'Closed',
          backgroundColor: const Color(0xFFF5F5F5),
          textColor: const Color(0xFF757575),
          icon: Icons.lock_rounded,
        );
      case SessionStatus.cancelled:
        return StatusBadgeWidget(
          label: 'Cancelled',
          backgroundColor: AppTheme.errorContainer,
          textColor: AppTheme.error,
          icon: Icons.cancel_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

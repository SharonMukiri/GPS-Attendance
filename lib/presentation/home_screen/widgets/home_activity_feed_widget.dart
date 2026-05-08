import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class HomeActivityFeedWidget extends StatelessWidget {
  const HomeActivityFeedWidget({super.key});

  static final List<Map<String, dynamic>> _activityMaps = [
    {
      'course': 'CS301',
      'action': 'Attendance marked',
      'detail': 'Data Structures & Algorithms',
      'time': '9:47 AM',
      'status': 'present',
      'iconName': 'check_circle',
    },
    {
      'course': 'MTH202',
      'action': 'Marked absent',
      'detail': 'Linear Algebra — missed sign-in window',
      'time': 'Yesterday',
      'status': 'absent',
      'iconName': 'cancel',
    },
    {
      'course': 'PHY101',
      'action': 'Attendance marked',
      'detail': 'Introduction to Physics',
      'time': 'Yesterday',
      'status': 'present',
      'iconName': 'check_circle',
    },
    {
      'course': 'ENG204',
      'action': 'Marked late',
      'detail': 'Engineering Mathematics',
      'time': '2 days ago',
      'status': 'late',
      'iconName': 'schedule',
    },
    {
      'course': 'STA305',
      'action': 'Attendance marked',
      'detail': 'Statistics & Probability',
      'time': '3 days ago',
      'status': 'present',
      'iconName': 'check_circle',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'present':
        return AppTheme.success;
      case 'absent':
        return AppTheme.error;
      case 'late':
        return const Color(0xFFE65100);
      default:
        return AppTheme.primary;
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'present':
        return AppTheme.successContainer;
      case 'absent':
        return AppTheme.errorContainer;
      case 'late':
        return const Color(0xFFFFF3E0);
      default:
        return AppTheme.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'refresh',
                      color: const Color(0xFF78909C),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Just now',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: const Color(0xFF78909C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...List.generate(_activityMaps.length, (i) {
            final a = _activityMaps[i];
            final color = _statusColor(a['status'] as String);
            final bg = _statusBg(a['status'] as String);
            return Column(
              children: [
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: 72,
                    color: AppTheme.outlineVariantLight,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: bg,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: a['iconName'] as String,
                            color: color,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    a['course'] as String,
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    a['action'] as String,
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              a['detail'] as String,
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: const Color(0xFF78909C),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        a['time'] as String,
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

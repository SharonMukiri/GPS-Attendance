import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/status_badge_widget.dart';

class AttendanceStudentLogWidget extends StatelessWidget {
  const AttendanceStudentLogWidget({super.key});

  static final List<Map<String, dynamic>> _logMaps = [
    {
      'course': 'CS301',
      'title': 'Data Structures & Algorithms',
      'date': 'Today, 10:47 AM',
      'status': 'present',
      'room': 'Room LT-4',
      'verified': true,
    },
    {
      'course': 'MTH202',
      'title': 'Linear Algebra',
      'date': 'Yesterday, 1:03 PM',
      'status': 'absent',
      'room': 'Room 201',
      'verified': false,
    },
    {
      'course': 'PHY101',
      'title': 'Introduction to Physics',
      'date': 'Yesterday, 3:15 PM',
      'status': 'present',
      'room': 'Lab 3',
      'verified': true,
    },
    {
      'course': 'ENG204',
      'title': 'Engineering Mathematics',
      'date': '2 days ago, 9:52 AM',
      'status': 'late',
      'room': 'Room B12',
      'verified': true,
    },
    {
      'course': 'STA305',
      'title': 'Statistics & Probability',
      'date': '3 days ago, 2:01 PM',
      'status': 'present',
      'room': 'Room 305',
      'verified': true,
    },
  ];

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
                  'Attendance Log',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'This week',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(_logMaps.length, (i) {
            final log = _logMaps[i];
            final statusStr = log['status'] as String;
            AttendanceStatus status;
            switch (statusStr) {
              case 'present':
                status = AttendanceStatus.present;
                break;
              case 'absent':
                status = AttendanceStatus.absent;
                break;
              case 'late':
                status = AttendanceStatus.late;
                break;
              default:
                status = AttendanceStatus.pending;
            }
            return Column(
              children: [
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
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
                          color: AppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            log['course'] as String,
                            style: GoogleFonts.manrope(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log['title'] as String,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  log['date'] as String,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: const Color(0xFF78909C),
                                  ),
                                ),
                                if (log['verified'] as bool) ...[
                                  const SizedBox(width: 6),
                                  CustomIconWidget(
                                    iconName: 'verified',
                                    color: AppTheme.primary,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'GPS',
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      StatusBadgeWidget.attendance(status),
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

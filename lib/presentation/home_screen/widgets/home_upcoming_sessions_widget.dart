import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/status_badge_widget.dart';

class HomeUpcomingSessionsWidget extends StatelessWidget {
  const HomeUpcomingSessionsWidget({super.key});

  static final List<Map<String, dynamic>> _sessionMaps = [
    {
      'course': 'CS301',
      'title': 'Data Structures & Algorithms',
      'room': 'Room LT-4, Block C',
      'time': '10:00 AM – 11:30 AM',
      'lecturer': 'Dr. K. Mensah',
      'status': 'active',
      'minutesUntil': 0,
    },
    {
      'course': 'MTH202',
      'title': 'Linear Algebra',
      'room': 'Room 201, Science Block',
      'time': '1:00 PM – 2:30 PM',
      'lecturer': 'Prof. A. Darko',
      'status': 'scheduled',
      'minutesUntil': 110,
    },
    {
      'course': 'PHY101',
      'title': 'Introduction to Physics',
      'room': 'Lab 3, Physics Dept',
      'time': '3:00 PM – 4:30 PM',
      'lecturer': 'Dr. E. Boateng',
      'status': 'scheduled',
      'minutesUntil': 230,
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
                  'Today\'s Schedule',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View all',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(_sessionMaps.length, (i) {
            final s = _sessionMaps[i];
            final isActive = s['status'] == 'active';
            return Column(
              children: [
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                    color: AppTheme.outlineVariantLight,
                  ),
                _SessionTile(data: s, isActive: isActive),
              ],
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isActive;

  const _SessionTile({required this.data, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: AppTheme.primary.withAlpha(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.primaryContainer
                    : AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  data['course'] as String,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isActive
                        ? AppTheme.primary
                        : const Color(0xFF78909C),
                  ),
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
                      Expanded(
                        child: Text(
                          data['title'] as String,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadgeWidget.session(
                        isActive
                            ? SessionStatus.active
                            : SessionStatus.scheduled,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: const Color(0xFF78909C),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data['time'] as String,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: const Color(0xFF78909C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'place',
                        color: const Color(0xFF78909C),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data['room'] as String,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: const Color(0xFF78909C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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

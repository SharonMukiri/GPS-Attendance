import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class HomeKpiCardsWidget extends StatelessWidget {
  final bool isLecturer;

  const HomeKpiCardsWidget({super.key, required this.isLecturer});

  @override
  Widget build(BuildContext context) {
    final cards = isLecturer ? _lecturerCards : _studentCards;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemCount: cards.length,
      itemBuilder: (context, i) => _KpiCard(data: cards[i]),
    );
  }

  static final _studentCards = [
    _KpiData(
      title: 'Attendance Rate',
      value: '78%',
      subtitle: '↓ Below 80% threshold',
      iconName: 'leaderboard',
      primaryColor: AppTheme.warning,
      bgColor: AppTheme.warningContainer,
      isAlert: true,
    ),
    _KpiData(
      title: 'This Week',
      value: '4/5',
      subtitle: 'Sessions attended',
      iconName: 'calendar_today',
      primaryColor: AppTheme.secondary,
      bgColor: AppTheme.successContainer,
      isAlert: false,
    ),
    _KpiData(
      title: 'Current Streak',
      value: '6 days',
      subtitle: '🔥 Keep it going!',
      iconName: 'local_fire_department',
      primaryColor: const Color(0xFFE65100),
      bgColor: const Color(0xFFFFF3E0),
      isAlert: false,
    ),
    _KpiData(
      title: 'Courses',
      value: '5',
      subtitle: '1 at-risk',
      iconName: 'menu_book',
      primaryColor: AppTheme.primary,
      bgColor: AppTheme.primaryContainer,
      isAlert: false,
    ),
  ];

  static final _lecturerCards = [
    _KpiData(
      title: 'Active Sessions',
      value: '2',
      subtitle: 'Live right now',
      iconName: 'play_circle',
      primaryColor: AppTheme.success,
      bgColor: AppTheme.successContainer,
      isAlert: false,
    ),
    _KpiData(
      title: 'Total Students',
      value: '187',
      subtitle: 'Across 4 courses',
      iconName: 'group',
      primaryColor: AppTheme.primary,
      bgColor: AppTheme.primaryContainer,
      isAlert: false,
    ),
    _KpiData(
      title: 'Avg Attendance',
      value: '71%',
      subtitle: '↓ Down from 76%',
      iconName: 'analytics',
      primaryColor: AppTheme.warning,
      bgColor: AppTheme.warningContainer,
      isAlert: true,
    ),
    _KpiData(
      title: 'Pending Reports',
      value: '3',
      subtitle: 'Needs generation',
      iconName: 'assignment',
      primaryColor: AppTheme.error,
      bgColor: AppTheme.errorContainer,
      isAlert: true,
    ),
  ];
}

class _KpiData {
  final String title;
  final String value;
  final String subtitle;
  final String iconName;
  final Color primaryColor;
  final Color bgColor;
  final bool isAlert;

  const _KpiData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconName,
    required this.primaryColor,
    required this.bgColor,
    required this.isAlert,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;

  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: data.isAlert
            ? Border.all(color: data.primaryColor.withAlpha(102), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: data.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomIconWidget(
                  iconName: data.iconName,
                  color: data.primaryColor,
                  size: 18,
                ),
              ),
              if (data.isAlert)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: data.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 1),
              Text(
                data.title,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF78909C),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.subtitle,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: data.isAlert
                      ? data.primaryColor
                      : const Color(0xFF9E9E9E),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

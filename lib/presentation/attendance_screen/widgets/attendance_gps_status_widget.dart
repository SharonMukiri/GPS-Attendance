import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class AttendanceGpsStatusWidget extends StatelessWidget {
  final bool isWithinGeofence;
  final bool gpsLoading;
  final double distanceMeters;
  final Animation<double> pulseAnimation;

  const AttendanceGpsStatusWidget({
    super.key,
    required this.isWithinGeofence,
    required this.gpsLoading,
    required this.distanceMeters,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (gpsLoading) {
      return Container(
        height: 160,
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.primary,
                strokeWidth: 3,
              ),
              SizedBox(height: 12),
              Text('Acquiring GPS signal...'),
            ],
          ),
        ),
      );
    }

    final isInside = isWithinGeofence;
    final primaryColor = isInside ? AppTheme.success : AppTheme.warning;
    final bgColor = isInside
        ? AppTheme.successContainer
        : AppTheme.warningContainer;
    final borderColor = isInside
        ? AppTheme.success.withAlpha(102)
        : AppTheme.warning.withAlpha(102);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Animated GPS pulse indicator
              AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.scale(
                        scale: isInside ? pulseAnimation.value : 1.0,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: primaryColor.withAlpha(38),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: isInside ? 'gps_fixed' : 'gps_not_fixed',
                            color: primaryColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isInside ? 'Inside Classroom' : 'Outside Classroom',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isInside
                          ? 'You are within the attendance zone'
                          : 'Move closer to enable attendance',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF78909C),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _GpsMetric(
                  label: 'Distance',
                  value: '${distanceMeters.toInt()}m',
                  iconName: 'my_location',
                  color: isInside ? AppTheme.success : AppTheme.warning,
                ),
                const SizedBox(width: 1),
                Container(
                  width: 1,
                  height: 32,
                  color: AppTheme.outlineVariantLight,
                ),
                const SizedBox(width: 1),
                _GpsMetric(
                  label: 'Geofence radius',
                  value: '50m',
                  iconName: 'place',
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 1),
                Container(
                  width: 1,
                  height: 32,
                  color: AppTheme.outlineVariantLight,
                ),
                const SizedBox(width: 1),
                _GpsMetric(
                  label: 'GPS accuracy',
                  value: isInside ? '±4m' : '±12m',
                  iconName: 'gps_fixed',
                  color: const Color(0xFF78909C),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GpsMetric extends StatelessWidget {
  final String label;
  final String value;
  final String iconName;
  final Color color;

  const _GpsMetric({
    required this.label,
    required this.value,
    required this.iconName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CustomIconWidget(iconName: iconName, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF78909C),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

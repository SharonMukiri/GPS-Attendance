import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class AttendanceSessionCardWidget extends StatefulWidget {
  final bool sessionActive;
  final bool attendanceMarked;

  const AttendanceSessionCardWidget({
    super.key,
    required this.sessionActive,
    required this.attendanceMarked,
  });

  @override
  State<AttendanceSessionCardWidget> createState() =>
      _AttendanceSessionCardWidgetState();
}

class _AttendanceSessionCardWidgetState
    extends State<AttendanceSessionCardWidget> {
  // TODO: Replace with real Supabase real-time session subscription
  late int _remainingMinutes;
  late int _totalMinutes;

  @override
  void initState() {
    super.initState();
    _remainingMinutes = 43;
    _totalMinutes = 90;
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1.0 - (_remainingMinutes / _totalMinutes);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.sessionActive
              ? [AppTheme.primary, const Color(0xFF1976D2)]
              : [const Color(0xFF757575), const Color(0xFF616161)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (widget.sessionActive ? AppTheme.primary : Colors.grey)
                .withAlpha(89),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'CS301',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (widget.sessionActive)
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF69F0AE),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF69F0AE),
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Data Structures & Algorithms',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.attendanceMarked)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF69F0AE).withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF69F0AE),
                    size: 28,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _SessionDetail(iconName: 'person', label: 'Dr. K. Mensah'),
              const SizedBox(width: 16),
              _SessionDetail(iconName: 'place', label: 'Room LT-4, Block C'),
            ],
          ),
          const SizedBox(height: 16),
          // Time remaining bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Session Progress',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withAlpha(204),
                    ),
                  ),
                  Text(
                    '$_remainingMinutes min remaining',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withAlpha(64),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF69F0AE),
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '10:00 AM',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      color: Colors.white.withAlpha(179),
                    ),
                  ),
                  Text(
                    '11:30 AM',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      color: Colors.white.withAlpha(179),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionDetail extends StatelessWidget {
  final String iconName;
  final String label;

  const _SessionDetail({required this.iconName, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: Colors.white.withAlpha(179),
          size: 13,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white.withAlpha(217),
          ),
        ),
      ],
    );
  }
}

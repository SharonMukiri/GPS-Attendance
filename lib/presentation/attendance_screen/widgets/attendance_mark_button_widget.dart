import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class AttendanceMarkButtonWidget extends StatefulWidget {
  final bool isWithinGeofence;
  final bool attendanceMarked;
  final bool sessionActive;
  final bool gpsLoading;
  final VoidCallback onMark;
  final Animation<double> pulseAnimation;

  const AttendanceMarkButtonWidget({
    super.key,
    required this.isWithinGeofence,
    required this.attendanceMarked,
    required this.sessionActive,
    required this.gpsLoading,
    required this.onMark,
    required this.pulseAnimation,
  });

  @override
  State<AttendanceMarkButtonWidget> createState() =>
      _AttendanceMarkButtonWidgetState();
}

class _AttendanceMarkButtonWidgetState extends State<AttendanceMarkButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  bool get _canMark =>
      widget.isWithinGeofence &&
      !widget.attendanceMarked &&
      widget.sessionActive &&
      !widget.gpsLoading;

  @override
  Widget build(BuildContext context) {
    if (widget.attendanceMarked) {
      return _buildMarkedState();
    }
    if (!widget.sessionActive) {
      return _buildInactiveState('No active session right now');
    }
    return _buildMarkButton();
  }

  Widget _buildMarkButton() {
    final canMark = _canMark;
    final buttonColor = canMark ? AppTheme.success : const Color(0xFFBDBDBD);
    final bgColor = canMark
        ? AppTheme.successContainer
        : const Color(0xFFF5F5F5);

    return GestureDetector(
      onTapDown: canMark ? (_) => _pressController.forward() : null,
      onTapUp: canMark
          ? (_) {
              _pressController.reverse();
              widget.onMark();
            }
          : null,
      onTapCancel: canMark ? () => _pressController.reverse() : null,
      child: AnimatedBuilder(
        animation: _pressScale,
        builder: (context, child) {
          return Transform.scale(scale: _pressScale.value, child: child);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: canMark
                  ? AppTheme.success.withAlpha(102)
                  : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
            boxShadow: canMark
                ? [
                    BoxShadow(
                      color: AppTheme.success.withAlpha(64),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: widget.pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: canMark ? widget.pulseAnimation.value : 1.0,
                    child: child,
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: buttonColor.withAlpha(38),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        shape: BoxShape.circle,
                        boxShadow: canMark
                            ? [
                                BoxShadow(
                                  color: buttonColor.withAlpha(102),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.how_to_reg_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                canMark ? 'Mark Attendance' : 'Cannot Mark Attendance',
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: canMark ? AppTheme.success : const Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                canMark
                    ? 'Tap to confirm your presence in CS301'
                    : widget.gpsLoading
                    ? 'Waiting for GPS signal...'
                    : 'You must be inside the classroom (within 50m)',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF78909C),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkedState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.successContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.success.withAlpha(102), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.success.withAlpha(38),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.success.withAlpha(38),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.check_circle_rounded,
                color: AppTheme.success,
                size: 44,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Attendance Confirmed!',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.success,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Marked present at 10:47 AM',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF78909C),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: AppTheme.success,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'GPS verified · CS301 · Today',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          const Icon(Icons.lock_rounded, color: Color(0xFFBDBDBD), size: 40),
          const SizedBox(height: 10),
          Text(
            message,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}

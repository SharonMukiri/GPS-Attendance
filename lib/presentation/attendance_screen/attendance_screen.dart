import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/attendance_gps_status_widget.dart';
import './widgets/attendance_lecturer_panel_widget.dart';
import './widgets/attendance_mark_button_widget.dart';
import './widgets/attendance_session_card_widget.dart';
import './widgets/attendance_student_log_widget.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with TickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production state management
  bool _isLecturer = false;
  String _userName = 'Amara Osei';
  bool _isWithinGeofence = false;
  bool _gpsLoading = true;
  bool _attendanceMarked = false;
  bool _sessionActive = true;
  double _distanceMeters = 245.0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // TODO: Replace with real geolocator location stream from Supabase
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _gpsLoading = false;
          _isWithinGeofence = false;
          _distanceMeters = 245.0;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO: Replace with Riverpod/Bloc to read auth state
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      setState(() {
        _isLecturer = args['isLecturer'] as bool? ?? false;
        _userName = args['userName'] as String? ?? 'Amara Osei';
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _simulateGeofenceEntry() {
    // TODO: Replace with real geolocator.getPositionStream() and geofence check
    setState(() {
      _isWithinGeofence = !_isWithinGeofence;
      _distanceMeters = _isWithinGeofence ? 18.0 : 245.0;
    });
  }

  void _markAttendance() {
    if (!_isWithinGeofence || _attendanceMarked) return;
    // TODO: Insert attendance record into Supabase attendance_logs table
    HapticFeedback.heavyImpact();
    setState(() => _attendanceMarked = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Attendance marked for CS301!',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black.withAlpha(20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isLecturer ? 'Session Management' : 'Mark Attendance',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            Text(
              'CS301 — Data Structures & Algorithms',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF78909C),
              ),
            ),
          ],
        ),
        actions: [
          if (!_isLecturer)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: _simulateGeofenceEntry,
                icon: CustomIconWidget(
                  iconName: 'gps_fixed',
                  color: AppTheme.primary,
                  size: 16,
                ),
                label: Text(
                  'Simulate GPS',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
      ),
    );
  }

  Widget _buildPhoneLayout() {
    if (_isLecturer) {
      return AttendanceLecturerPanelWidget(
        sessionActive: _sessionActive,
        onToggleSession: () => setState(() => _sessionActive = !_sessionActive),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AttendanceGpsStatusWidget(
            isWithinGeofence: _isWithinGeofence,
            gpsLoading: _gpsLoading,
            distanceMeters: _distanceMeters,
            pulseAnimation: _pulseAnimation,
          ),
          const SizedBox(height: 16),
          AttendanceSessionCardWidget(
            sessionActive: _sessionActive,
            attendanceMarked: _attendanceMarked,
          ),
          const SizedBox(height: 20),
          AttendanceMarkButtonWidget(
            isWithinGeofence: _isWithinGeofence,
            attendanceMarked: _attendanceMarked,
            sessionActive: _sessionActive,
            gpsLoading: _gpsLoading,
            onMark: _markAttendance,
            pulseAnimation: _pulseAnimation,
          ),
          const SizedBox(height: 24),
          const AttendanceStudentLogWidget(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    if (_isLecturer) {
      return AttendanceLecturerPanelWidget(
        sessionActive: _sessionActive,
        onToggleSession: () => setState(() => _sessionActive = !_sessionActive),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                AttendanceGpsStatusWidget(
                  isWithinGeofence: _isWithinGeofence,
                  gpsLoading: _gpsLoading,
                  distanceMeters: _distanceMeters,
                  pulseAnimation: _pulseAnimation,
                ),
                const SizedBox(height: 16),
                AttendanceSessionCardWidget(
                  sessionActive: _sessionActive,
                  attendanceMarked: _attendanceMarked,
                ),
                const SizedBox(height: 20),
                AttendanceMarkButtonWidget(
                  isWithinGeofence: _isWithinGeofence,
                  attendanceMarked: _attendanceMarked,
                  sessionActive: _sessionActive,
                  gpsLoading: _gpsLoading,
                  onMark: _markAttendance,
                  pulseAnimation: _pulseAnimation,
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const Expanded(flex: 5, child: AttendanceStudentLogWidget()),
        ],
      ),
    );
  }
}

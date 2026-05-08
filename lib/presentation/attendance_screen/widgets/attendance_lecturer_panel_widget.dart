import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/status_badge_widget.dart';

class AttendanceLecturerPanelWidget extends StatefulWidget {
  final bool sessionActive;
  final VoidCallback onToggleSession;

  const AttendanceLecturerPanelWidget({
    super.key,
    required this.sessionActive,
    required this.onToggleSession,
  });

  @override
  State<AttendanceLecturerPanelWidget> createState() =>
      _AttendanceLecturerPanelWidgetState();
}

class _AttendanceLecturerPanelWidgetState
    extends State<AttendanceLecturerPanelWidget> {
  // TODO: Replace with Supabase real-time subscription for live attendance updates
  static final List<Map<String, dynamic>> _studentMaps = [
    {
      'name': 'Amara Osei',
      'id': 'STU2021001',
      'status': 'present',
      'time': '10:03 AM',
      'avatarColor': 0xFF1565C0,
    },
    {
      'name': 'Kofi Asante',
      'id': 'STU2021002',
      'status': 'present',
      'time': '10:05 AM',
      'avatarColor': 0xFF00897B,
    },
    {
      'name': 'Fatima Al-Rashid',
      'id': 'STU2021003',
      'status': 'absent',
      'time': '—',
      'avatarColor': 0xFFC62828,
    },
    {
      'name': 'Yaw Boateng',
      'id': 'STU2021004',
      'status': 'present',
      'time': '10:07 AM',
      'avatarColor': 0xFF7B1FA2,
    },
    {
      'name': 'Abena Mensah',
      'id': 'STU2021005',
      'status': 'late',
      'time': '10:24 AM',
      'avatarColor': 0xFFE65100,
    },
    {
      'name': 'Kweku Darko',
      'id': 'STU2021006',
      'status': 'absent',
      'time': '—',
      'avatarColor': 0xFFC62828,
    },
    {
      'name': 'Nana Addo',
      'id': 'STU2021007',
      'status': 'present',
      'time': '10:02 AM',
      'avatarColor': 0xFF1565C0,
    },
    {
      'name': 'Akua Frimpong',
      'id': 'STU2021008',
      'status': 'present',
      'time': '10:09 AM',
      'avatarColor': 0xFF00897B,
    },
    {
      'name': 'Efua Sarpong',
      'id': 'STU2021009',
      'status': 'pending',
      'time': '—',
      'avatarColor': 0xFF78909C,
    },
    {
      'name': 'Kojo Antwi',
      'id': 'STU2021010',
      'status': 'present',
      'time': '10:11 AM',
      'avatarColor': 0xFF2E7D32,
    },
  ];

  String _filterStatus = 'all';

  int get _presentCount =>
      _studentMaps.where((s) => s['status'] == 'present').length;
  int get _absentCount =>
      _studentMaps.where((s) => s['status'] == 'absent').length;
  int get _lateCount => _studentMaps.where((s) => s['status'] == 'late').length;

  List<Map<String, dynamic>> get _filteredStudents {
    if (_filterStatus == 'all') return _studentMaps;
    return _studentMaps.where((s) => s['status'] == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return isTablet ? _buildTabletLayout() : _buildPhoneLayout();
  }

  Widget _buildPhoneLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSessionControl(),
          const SizedBox(height: 16),
          _buildLiveStats(),
          const SizedBox(height: 16),
          _buildFilterChips(),
          const SizedBox(height: 12),
          _buildStudentList(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                _buildSessionControl(),
                const SizedBox(height: 16),
                _buildLiveStats(),
                const SizedBox(height: 16),
                _buildAttendancePieChart(),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                _buildFilterChips(),
                const SizedBox(height: 12),
                _buildStudentList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionControl() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.sessionActive
              ? [AppTheme.primary, const Color(0xFF1976D2)]
              : [const Color(0xFF546E7A), const Color(0xFF455A64)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (widget.sessionActive ? AppTheme.primary : Colors.grey)
                .withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sessionActive ? 'Session Active' : 'Session Closed',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.sessionActive
                      ? 'CS301 · Students can mark attendance'
                      : 'CS301 · Attendance window closed',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: widget.onToggleSession,
            icon: Icon(
              widget.sessionActive
                  ? Icons.stop_circle_rounded
                  : Icons.play_circle_rounded,
              size: 18,
            ),
            label: Text(
              widget.sessionActive ? 'End Session' : 'Start Session',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: widget.sessionActive
                  ? AppTheme.error
                  : AppTheme.success,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveStats() {
    final total = _studentMaps.length;
    final attendanceRate = (_presentCount / total * 100).toStringAsFixed(0);

    return Row(
      children: [
        Expanded(
          child: _StatChip(
            value: '$_presentCount',
            label: 'Present',
            color: AppTheme.success,
            bgColor: AppTheme.successContainer,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            value: '$_absentCount',
            label: 'Absent',
            color: AppTheme.error,
            bgColor: AppTheme.errorContainer,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            value: '$_lateCount',
            label: 'Late',
            color: const Color(0xFFE65100),
            bgColor: const Color(0xFFFFF3E0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            value: '$attendanceRate%',
            label: 'Rate',
            color: AppTheme.primary,
            bgColor: AppTheme.primaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendancePieChart() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            'Attendance Breakdown',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: _presentCount.toDouble(),
                    color: AppTheme.success,
                    title: '$_presentCount',
                    titleStyle: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    radius: 55,
                  ),
                  PieChartSectionData(
                    value: _absentCount.toDouble(),
                    color: AppTheme.error,
                    title: '$_absentCount',
                    titleStyle: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    radius: 55,
                  ),
                  PieChartSectionData(
                    value: _lateCount.toDouble(),
                    color: const Color(0xFFE65100),
                    title: '$_lateCount',
                    titleStyle: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    radius: 55,
                  ),
                  PieChartSectionData(
                    value: _studentMaps
                        .where((s) => s['status'] == 'pending')
                        .length
                        .toDouble(),
                    color: const Color(0xFFBDBDBD),
                    title:
                        '${_studentMaps.where((s) => s['status'] == 'pending').length}',
                    titleStyle: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    radius: 55,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _LegendDot(color: AppTheme.success, label: 'Present'),
              _LegendDot(color: AppTheme.error, label: 'Absent'),
              _LegendDot(color: const Color(0xFFE65100), label: 'Late'),
              _LegendDot(color: const Color(0xFFBDBDBD), label: 'Pending'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['all', 'present', 'absent', 'late', 'pending'];
    final labels = {
      'all': 'All (${_studentMaps.length})',
      'present': 'Present ($_presentCount)',
      'absent': 'Absent ($_absentCount)',
      'late': 'Late ($_lateCount)',
      'pending': 'Pending',
    };
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final f = filters[i];
          final isSelected = _filterStatus == f;
          return GestureDetector(
            onTap: () => setState(() => _filterStatus = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.outlineLight,
                ),
              ),
              child: Text(
                labels[f] ?? f,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF4A5568),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentList() {
    final students = _filteredStudents;
    if (students.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'No students in this category',
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: const Color(0xFF78909C),
            ),
          ),
        ),
      );
    }
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
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Student Attendance',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Generate report via Supabase Edge Function
                  },
                  icon: CustomIconWidget(
                    iconName: 'download',
                    color: AppTheme.primary,
                    size: 14,
                  ),
                  label: Text(
                    'Export',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(students.length, (i) {
            final s = students[i];
            final statusStr = s['status'] as String;
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
                          color: Color(s['avatarColor'] as int).withAlpha(38),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (s['name'] as String)[0].toUpperCase(),
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(s['avatarColor'] as int),
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
                              s['name'] as String,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  s['id'] as String,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: const Color(0xFF78909C),
                                    fontFeatures: [
                                      const FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                                if ((s['time'] as String) != '—') ...[
                                  const SizedBox(width: 8),
                                  CustomIconWidget(
                                    iconName: 'schedule',
                                    color: const Color(0xFF9E9E9E),
                                    size: 11,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    s['time'] as String,
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      color: const Color(0xFF9E9E9E),
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

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color bgColor;

  const _StatChip({
    required this.value,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF78909C),
          ),
        ),
      ],
    );
  }
}

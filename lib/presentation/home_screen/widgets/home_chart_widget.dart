import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';

class HomeChartWidget extends StatefulWidget {
  final bool isLecturer;

  const HomeChartWidget({super.key, required this.isLecturer});

  @override
  State<HomeChartWidget> createState() => _HomeChartWidgetState();
}

class _HomeChartWidgetState extends State<HomeChartWidget>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production data
  late AnimationController _chartController;
  late Animation<double> _chartAnimation;
  int _touchedIndex = -1;

  // Student: attendance % per course
  static final List<Map<String, dynamic>> _studentBarData = [
    {'course': 'CS301', 'percent': 85.0, 'color': AppTheme.secondary},
    {'course': 'MTH202', 'percent': 72.0, 'color': AppTheme.warning},
    {'course': 'PHY101', 'percent': 91.0, 'color': AppTheme.success},
    {'course': 'ENG204', 'percent': 63.0, 'color': AppTheme.error},
    {'course': 'STA305', 'percent': 78.0, 'color': AppTheme.primary},
  ];

  // Lecturer: weekly class attendance trend (last 8 weeks)
  static final List<Map<String, dynamic>> _lecturerLineData = [
    {'week': 'W1', 'percent': 88.0},
    {'week': 'W2', 'percent': 82.0},
    {'week': 'W3', 'percent': 79.0},
    {'week': 'W4', 'percent': 85.0},
    {'week': 'W5', 'percent': 71.0},
    {'week': 'W6', 'percent': 68.0},
    {'week': 'W7', 'percent': 73.0},
    {'week': 'W8', 'percent': 71.0},
  ];

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartAnimation = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeOutCubic,
    );
    _chartController.forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isLecturer
                        ? 'Class Attendance Trend'
                        : 'Attendance by Course',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  Text(
                    widget.isLecturer
                        ? 'Last 8 weeks — CS301'
                        : 'Current semester',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF78909C),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.outlineVariantLight),
                ),
                child: Text(
                  widget.isLecturer ? 'Sem 1' : '2025–26',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: AnimatedBuilder(
              animation: _chartAnimation,
              builder: (context, child) {
                return widget.isLecturer ? _buildLineChart() : _buildBarChart();
              },
            ),
          ),
          if (!widget.isLecturer) ...[
            const SizedBox(height: 16),
            _buildCourseLegend(),
          ],
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        minY: 0,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: const Color(0xFF1A1A2E),
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final d = _studentBarData[groupIndex];
              return BarTooltipItem(
                '${d['course']}\n${rod.toY.toInt()}%',
                GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          touchCallback: (event, response) {
            setState(() {
              _touchedIndex = response?.spot?.touchedBarGroupIndex ?? -1;
            });
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= _studentBarData.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _studentBarData[i]['course'] as String,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF78909C),
                    ),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    color: const Color(0xFF78909C),
                  ),
                );
              },
              reservedSize: 36,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (_) => FlLine(
            color: AppTheme.outlineVariantLight,
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(_studentBarData.length, (i) {
          final d = _studentBarData[i];
          final isTouched = i == _touchedIndex;
          final pct = (d['percent'] as double) * _chartAnimation.value;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: pct,
                color: isTouched
                    ? (d['color'] as Color)
                    : (d['color'] as Color).withAlpha(191),
                width: isTouched ? 22 : 18,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 100,
                  color: AppTheme.backgroundLight,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLineChart() {
    final spots = List.generate(_lecturerLineData.length, (i) {
      final pct =
          (_lecturerLineData[i]['percent'] as double) * _chartAnimation.value;
      return FlSpot(i.toDouble(), pct);
    });

    return LineChart(
      LineChartData(
        minY: 50,
        maxY: 100,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: const Color(0xFF1A1A2E),
            tooltipRoundedRadius: 8,
            getTooltipItems: (spots) => spots.map((s) {
              final week = _lecturerLineData[s.x.toInt()]['week'];
              return LineTooltipItem(
                '$week: ${s.y.toInt()}%',
                GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= _lecturerLineData.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _lecturerLineData[i]['week'] as String,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF78909C),
                    ),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    color: const Color(0xFF78909C),
                  ),
                );
              },
              reservedSize: 36,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (_) => FlLine(
            color: AppTheme.outlineVariantLight,
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppTheme.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) {
                final isLow = spot.y < 75;
                return FlDotCirclePainter(
                  radius: 4,
                  color: isLow ? AppTheme.error : AppTheme.primary,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withAlpha(51),
                  AppTheme.primary.withAlpha(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: _studentBarData.map((d) {
        final pct = d['percent'] as double;
        final isLow = pct < 75;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: d['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${d['course']} ${pct.toInt()}%${isLow ? ' ⚠️' : ''}',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isLow ? AppTheme.warning : const Color(0xFF78909C),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
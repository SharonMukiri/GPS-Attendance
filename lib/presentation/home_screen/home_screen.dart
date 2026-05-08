import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/home_activity_feed_widget.dart';
import './widgets/home_chart_widget.dart';
import './widgets/home_kpi_cards_widget.dart';
import './widgets/home_lecturer_actions_widget.dart';
import './widgets/home_upcoming_sessions_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production state management
  int _currentNavIndex = 0;
  bool _isLecturer = false;
  String _userName = 'Amara Osei';
  String _userEmail = 'amara.osei@geoattend.edu';

  late AnimationController _entranceController;
  late List<Animation<double>> _sectionFades;
  late List<Animation<Offset>> _sectionSlides;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _sectionFades = List.generate(
      5,
      (i) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: Interval(
            i * 0.12,
            (i * 0.12 + 0.5).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );
    _sectionSlides = List.generate(
      5,
      (i) =>
          Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _entranceController,
              curve: Interval(
                i * 0.12,
                (i * 0.12 + 0.5).clamp(0.0, 1.0),
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
    );
    _entranceController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO: Replace with Riverpod/Bloc to read auth state
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final isLecturer = args['isLecturer'] as bool? ?? false;
      final email = args['email'] as String? ?? '';
      if (isLecturer != _isLecturer || email != _userEmail) {
        setState(() {
          _isLecturer = isLecturer;
          _userEmail = email.isNotEmpty ? email : _userEmail;
          _userName = isLecturer ? 'Dr. Kwame Mensah' : 'Amara Osei';
        });
      }
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;
    if (index == 1) {
      Navigator.pushNamed(
        context,
        AppRoutes.attendanceScreen,
        arguments: {'isLecturer': _isLecturer, 'userName': _userName},
      );
      return;
    }
    if (index == 2) {
      _showProfileBottomSheet();
      return;
    }
    setState(() => _currentNavIndex = index);
  }

  void _showProfileBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileBottomSheet(
        userName: _userName,
        email: _userEmail,
        isLecturer: _isLecturer,
        onLogout: () {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.signUpLoginScreen,
            (route) => false,
          );
        },
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
      body: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
      bottomNavigationBar: isTablet
          ? null
          : AppNavigation(
              currentIndex: _currentNavIndex,
              onDestinationSelected: _onNavTap,
              isLecturer: _isLecturer,
            ),
    );
  }

  Widget _buildPhoneLayout() {
    return SafeArea(
      child: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () async {
          // TODO: Refresh data from Supabase
          await Future.delayed(const Duration(milliseconds: 800));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _animatedSection(0, _buildGreetingRow()),
                    const SizedBox(height: 20),
                    _animatedSection(
                      1,
                      HomeKpiCardsWidget(isLecturer: _isLecturer),
                    ),
                    const SizedBox(height: 20),
                    _animatedSection(
                      2,
                      HomeChartWidget(isLecturer: _isLecturer),
                    ),
                    const SizedBox(height: 20),
                    if (_isLecturer)
                      _animatedSection(3, const HomeLecturerActionsWidget()),
                    if (!_isLecturer)
                      _animatedSection(3, const HomeUpcomingSessionsWidget()),
                    const SizedBox(height: 20),
                    _animatedSection(4, const HomeActivityFeedWidget()),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SafeArea(
      child: Row(
        children: [
          TabletNavigationRail(
            currentIndex: _currentNavIndex,
            onDestinationSelected: _onNavTap,
            isLecturer: _isLecturer,
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: RefreshIndicator(
              color: AppTheme.primary,
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 800));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(),
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildGreetingRow(),
                          const SizedBox(height: 20),
                          HomeKpiCardsWidget(isLecturer: _isLecturer),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: HomeChartWidget(isLecturer: _isLecturer),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 4,
                                child: _isLecturer
                                    ? const HomeLecturerActionsWidget()
                                    : const HomeUpcomingSessionsWidget(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const HomeActivityFeedWidget(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: AppTheme.backgroundLight,
      floating: true,
      snap: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: Colors.black.withAlpha(20),
      surfaceTintColor: AppTheme.backgroundLight,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'GeoAttend',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_rounded,
                color: Color(0xFF1A1A2E),
              ),
              onPressed: () {
                // TODO: Navigate to notifications screen
              },
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _showProfileBottomSheet,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primary.withAlpha(77),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : 'A',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingRow() {
    final now = DateTime.now();
    final dateStr =
        '${_dayName(now.weekday)}, ${now.day} ${_monthName(now.month)} ${now.year}';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_greeting, ${_userName.split(' ').first}! 👋',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateStr,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF78909C),
                ),
              ),
            ],
          ),
        ),
        if (_isLecturer)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'verified',
                  color: AppTheme.primary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Lecturer',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _animatedSection(int index, Widget child) {
    return FadeTransition(
      opacity: _sectionFades[index],
      child: SlideTransition(position: _sectionSlides[index], child: child),
    );
  }

  String _dayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(weekday - 1).clamp(0, 6)];
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(month - 1).clamp(0, 11)];
  }
}

class _ProfileBottomSheet extends StatelessWidget {
  final String userName;
  final String email;
  final bool isLecturer;
  final VoidCallback onLogout;

  const _ProfileBottomSheet({
    required this.userName,
    required this.email,
    required this.isLecturer,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outlineLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primary.withAlpha(77),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: const Color(0xFF78909C),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isLecturer
                      ? AppTheme.primaryContainer
                      : AppTheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isLecturer ? 'Lecturer' : 'Student',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isLecturer ? AppTheme.primary : AppTheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              _ProfileMenuItem(
                iconName: 'settings',
                label: 'Account Settings',
                onTap: () => Navigator.pop(context),
              ),
              _ProfileMenuItem(
                iconName: 'security',
                label: 'Security & 2FA',
                onTap: () => Navigator.pop(context),
              ),
              _ProfileMenuItem(
                iconName: 'notifications',
                label: 'Notification Preferences',
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _ProfileMenuItem(
                iconName: 'logout',
                label: 'Sign Out',
                color: AppTheme.error,
                onTap: onLogout,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String iconName;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.iconName,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? const Color(0xFF1A1A2E);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: AppTheme.primary.withAlpha(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: effectiveColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: effectiveColor,
                ),
              ),
            ),
            if (color == null)
              CustomIconWidget(
                iconName: 'chevron_right',
                color: const Color(0xFF78909C),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

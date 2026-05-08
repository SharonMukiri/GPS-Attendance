
import '../core/app_export.dart';

class AppNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isLecturer;

  const AppNavigation({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    this.isLecturer = false,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      animationDuration: const Duration(milliseconds: 350),
      destinations: [
        NavigationDestination(
          icon: CustomIconWidget(
            iconName: 'home_outlined',
            color: const Color(0xFF78909C),
            size: 24,
          ),
          selectedIcon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.primary,
            size: 24,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: CustomIconWidget(
            iconName: 'location_off',
            color: const Color(0xFF78909C),
            size: 24,
          ),
          selectedIcon: CustomIconWidget(
            iconName: 'location_on',
            color: AppTheme.primary,
            size: 24,
          ),
          label: isLecturer ? 'Sessions' : 'Attendance',
        ),
        NavigationDestination(
          icon: CustomIconWidget(
            iconName: 'person_outline',
            color: const Color(0xFF78909C),
            size: 24,
          ),
          selectedIcon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.primary,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}

class TabletNavigationRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isLecturer;

  const TabletNavigationRail({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    this.isLecturer = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      extended: MediaQuery.of(context).size.width >= 840,
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: AppTheme.primaryContainer,
      selectedIconTheme: const IconThemeData(color: AppTheme.primary),
      unselectedIconTheme: const IconThemeData(color: Color(0xFF78909C)),
      selectedLabelTextStyle: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.primary,
      ),
      unselectedLabelTextStyle: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF78909C),
      ),
      destinations: [
        NavigationRailDestination(
          icon: CustomIconWidget(
            iconName: 'home_outlined',
            color: const Color(0xFF78909C),
            size: 24,
          ),
          selectedIcon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.primary,
            size: 24,
          ),
          label: const Text('Home'),
        ),
        NavigationRailDestination(
          icon: CustomIconWidget(
            iconName: 'location_off',
            color: const Color(0xFF78909C),
            size: 24,
          ),
          selectedIcon: CustomIconWidget(
            iconName: 'location_on',
            color: AppTheme.primary,
            size: 24,
          ),
          label: Text(isLecturer ? 'Sessions' : 'Attendance'),
        ),
        NavigationRailDestination(
          icon: CustomIconWidget(
            iconName: 'person_outline',
            color: const Color(0xFF78909C),
            size: 24,
          ),
          selectedIcon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.primary,
            size: 24,
          ),
          label: const Text('Profile'),
        ),
      ],
    );
  }
}

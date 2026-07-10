import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../app/app_text_style.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/report/presentation/report_management_screens.dart';
import '../../features/user_management/presentation/user_management_screens.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/digital_signature/presentation/final_approval_module.dart';
import '../../features/dashboard/presentation/dashboard_analytics_screen.dart';
import '../../features/audit_logs/presentation/audit_logs_screen.dart';

class AdminLayout extends StatefulWidget {
  final Widget? child;
  final String activeRoute;

  const AdminLayout({
    super.key,
    this.child,
    required this.activeRoute,
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  late int _currentIndex;
  String _userViewMode = 'list';

  int _getRouteIndex(String route) {
    switch (route) {
      case '/dashboard':
        return 0;
      case '/reports':
        return 1;
      case '/approval':
        return 2;
      case '/users':
        return 3;
      case '/profile':
        return 4;
      case '/analytics':
        return 5;
      case '/audit':
        return 6;
      default:
        return 0;
    }
  }

  String _getIndexRoute(int index) {
    switch (index) {
      case 0:
        return '/dashboard';
      case 1:
        return '/reports';
      case 2:
        return '/approval';
      case 3:
        return '/users';
      case 4:
        return '/profile';
      case 5:
        return '/analytics';
      case 6:
        return '/audit';
      default:
        return '/dashboard';
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = _getRouteIndex(widget.activeRoute);
  }

  @override
  void didUpdateWidget(covariant AdminLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeRoute != widget.activeRoute) {
      setState(() {
        _currentIndex = _getRouteIndex(widget.activeRoute);
        _userViewMode = 'list';
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _userViewMode = 'list';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue, // Top banner color extends from Scaffold
      drawer: Drawer(
        backgroundColor: AppColors.cardBg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.blueCyanGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Admin', style: AppTextStyle.body17Semibold.copyWith(color: Colors.white)),
                        Text('john.admin@marinesurvey.com', style: AppTextStyle.body12Regular.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', 0),
                  _buildDrawerItem(Icons.people_outline, 'Users', 3),
                  _buildDrawerItem(Icons.description_outlined, 'Reports', 1),
                  _buildDrawerItem(Icons.verified_outlined, 'Final Approvals', 2),
                  _buildDrawerItem(Icons.analytics_outlined, 'Analytics', 5),
                  _buildDrawerItem(Icons.history, 'Audit logs', 6),
                  _buildDrawerItem(Icons.account_circle_outlined, 'Profile Settings', 4),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.pink),
              title: Text('Logout', style: AppTextStyle.body14Medium.copyWith(color: AppColors.pink)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Welcome Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Hi, John Admin',
                              style: AppTextStyle.body18Medium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text('👋', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Text(
                          'Welcome to Marine Survey',
                          style: AppTextStyle.body12Regular.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '8',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=80&q=80'),
                  ),
                ],
              ),
            ),
            // White Curved Content Area wrapping screen contents
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      const DashboardScreen(),
                      const ReportManagementScreen(),
                      const FinalApprovalScreen(),
                      UserManagementScreen(viewMode: _userViewMode),
                      const ProfileScreen(),
                      const DashboardAnalyticsScreen(),
                      const AuditLogsScreen(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomBarItem(Icons.home, 'Dashboard', _currentIndex == 0, () => _onTabTapped(0)),
            _buildBottomBarItem(Icons.description, 'Reports', _currentIndex == 1, () => _onTabTapped(1)),
            // Floating "+" Action Button (navigates to UserManagementScreen/3 and triggers 'add' mode)
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                  _userViewMode = 'add';
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.blueCyanGradient),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
            _buildBottomBarItem(Icons.draw, 'Sign', _currentIndex == 2, () => _onTabTapped(2)),
            _buildBottomBarItem(Icons.person, 'Profile', _currentIndex == 4, () => _onTabTapped(4)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    final isSelected = _currentIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary),
      title: Text(
        title,
        style: AppTextStyle.body14Medium.copyWith(
          color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primaryBlue.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Navigator.pop(context); // Close Drawer
        _onTabTapped(index);
      },
    );
  }
}

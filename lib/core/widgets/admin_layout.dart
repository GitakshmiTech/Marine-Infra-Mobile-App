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
import '../../features/report/presentation/prepared_by_report_screens.dart';
import '../../features/report/presentation/lashing_measurement_screen.dart';
import '../../features/report/presentation/odc_survey_screen.dart';
import '../../features/report/presentation/container_damage_screen.dart';
import '../../features/survey/presentation/survey_by_dashboard.dart';
import '../../features/survey/presentation/survey_by_reports_list.dart';
import '../../features/survey/presentation/surveyor_photo_gallery.dart';
import '../../features/survey/presentation/survey_notifications.dart';
import '../../features/verification/presentation/qc_dashboard.dart';
import '../../features/verification/presentation/qc_reports_list.dart';
import '../../features/verification/presentation/qc_photo_verification_gallery.dart';
import '../../features/verification/presentation/qc_notifications.dart';

class AdminLayout extends StatefulWidget {
  final Widget? child;
  final String activeRoute;
  final String initialRole;

  const AdminLayout({
    super.key,
    this.child,
    required this.activeRoute,
    this.initialRole = 'Company Admin',
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  late int _currentIndex;
  late String _userRole;
  String _userViewMode = 'list';
  String _lashingView = 'list';
  String _odcView = 'list';
  String _damageView = 'list';
  String _reportManagementView = 'list';

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

  @override
  void initState() {
    super.initState();
    _userRole = widget.initialRole;
    _currentIndex = _getRouteIndex(widget.activeRoute);
  }

  @override
  void didUpdateWidget(covariant AdminLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeRoute != widget.activeRoute) {
      setState(() {
        _currentIndex = _getRouteIndex(widget.activeRoute);
        _userViewMode = 'list';
        _lashingView = 'list';
        _odcView = 'list';
        _damageView = 'list';
        _reportManagementView = 'list';
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _userViewMode = 'list';
      _lashingView = 'list';
      _odcView = 'list';
      _damageView = 'list';
      _reportManagementView = 'list';
    });
  }

  String _getScreenTitle() {
    final isPreparedBy = _userRole == 'Prepared By';
    final isSurveyBy = _userRole == 'Survey By';
    final isCheckedBy = _userRole == 'Checked By';

    switch (_currentIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        if (isSurveyBy) return 'Assigned Reports';
        if (isPreparedBy) return 'Lashing & Measurement';
        return 'Reports';
      case 2:
        return 'Final Approvals';
      case 3:
        if (isPreparedBy) return 'Assignments';
        return 'Users';
      case 4:
        return 'Profile Settings';
      case 5:
        return 'Analytics';
      case 6:
        return 'Audit Logs';
      case 7:
        return 'ODC Survey';
      case 8:
        return 'Container Damage Survey';
      case 9:
        return 'Photo Gallery';
      case 10:
        return 'Digital Signature';
      case 11:
        return 'Notifications';
      case 12:
        return 'Report Verification';
      case 13:
        return 'Photo Verification';
      case 14:
        return 'QC Notifications';
      default:
        return 'Workspace';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPreparedBy = _userRole == 'Prepared By';
    final isSurveyBy = _userRole == 'Survey By';
    final isCheckedBy = _userRole == 'Checked By';

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
              padding: EdgeInsets.fromLTRB(10, MediaQuery.of(context).padding.top + 45, 10, 10),
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      isPreparedBy
                          ? Icons.edit_document
                          : isSurveyBy
                              ? Icons.directions_run_rounded
                              : isCheckedBy
                                  ? Icons.verified_user_rounded
                                  : Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPreparedBy
                              ? 'Sarah Preparer'
                              : isSurveyBy
                                  ? 'Field Surveyor'
                                  : isCheckedBy
                                      ? 'QC Reviewer Marc'
                                      : 'John Admin',
                          style: AppTextStyle.body17Semibold.copyWith(color: Colors.white),
                        ),
                        Text(
                          isPreparedBy
                              ? 'sarah.preparer@marinesurvey.com'
                              : isSurveyBy
                                  ? 'surveyor@marinesurvey.com'
                                  : isCheckedBy
                                      ? 'marc.reviewer@marinesurvey.com'
                                      : 'john.admin@marinesurvey.com',
                          style: AppTextStyle.body12Regular.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: isPreparedBy
                    ? [
                        _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', 0),
                        _buildDrawerItem(Icons.insert_drive_file_outlined, 'Lashing & Measurement', 1),
                        _buildDrawerItem(Icons.local_shipping_outlined, 'ODC Survey', 7),
                        _buildDrawerItem(Icons.dangerous_outlined, 'Container Damage Survey', 8),
                        _buildDrawerItem(Icons.assignment_outlined, 'Assignments', 3),
                        _buildDrawerItem(Icons.account_circle_outlined, 'Profile Settings', 4),
                      ]
                    : isSurveyBy
                        ? [
                            _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', 0),
                            _buildDrawerItem(Icons.assignment_turned_in_outlined, 'Assigned Reports', 1),
                            _buildDrawerItem(Icons.photo_library_outlined, 'Photo Gallery', 9),
                            _buildDrawerItem(Icons.draw_outlined, 'Digital Signature', 10),
                            _buildDrawerItem(Icons.notifications_none_rounded, 'Notifications', 11),
                            _buildDrawerItem(Icons.account_circle_outlined, 'Profile Settings', 4),
                          ]
                        : isCheckedBy
                            ? [
                                _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', 0),
                                _buildDrawerItem(Icons.playlist_add_check_rounded, 'Report Verification', 12),
                                _buildDrawerItem(Icons.image_search_rounded, 'Photo Verification', 13),
                                _buildDrawerItem(Icons.notifications_none_rounded, 'Notifications', 14),
                                _buildDrawerItem(Icons.account_circle_outlined, 'Profile Settings', 4),
                              ]
                            : [
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
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                children: [
                  _currentIndex == 0
                      ? Builder(
                          builder: (context) => GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: const Icon(Icons.menu, color: Colors.white, size: 28),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (_currentIndex == 1) {
                              if (isPreparedBy && _lashingView != 'list') {
                                setState(() => _lashingView = 'list');
                              } else if (!isPreparedBy && _reportManagementView != 'list') {
                                setState(() => _reportManagementView = 'list');
                              } else {
                                _onTabTapped(0);
                              }
                            } else if (_currentIndex == 7 && _odcView != 'list') {
                              setState(() => _odcView = 'list');
                            } else if (_currentIndex == 8 && _damageView != 'list') {
                              setState(() => _damageView = 'list');
                            } else {
                              _onTabTapped(0);
                            }
                          },
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                        ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _currentIndex == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    isPreparedBy
                                        ? 'Hi, Sarah Preparer'
                                        : isSurveyBy
                                            ? 'Hi, Field Surveyor'
                                            : isCheckedBy
                                                ? 'Hi, QC Reviewer Marc'
                                                : 'Hi, John Admin',
                                    style: AppTextStyle.body18Medium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text('👋', style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getScreenTitle(),
                                style: AppTextStyle.body18Medium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isSurveyBy) {
                        _onTabTapped(11);
                      } else if (isCheckedBy) {
                        _onTabTapped(14);
                      } else {
                        _onTabTapped(11);
                      }
                    },
                    child: Stack(
                      children: [
                        const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 32),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            padding: const EdgeInsets.all(5),
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
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => _onTabTapped(4),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=80&q=80'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                ),
                child: IndexedStack(
                  index: _currentIndex,
                    children: [
                      isSurveyBy
                          ? SurveyByDashboardScreen(
                              onViewReports: (tabIndex, {reportId}) {
                                setState(() {
                                  _currentIndex = 1;
                                });
                              },
                            )
                          : isCheckedBy
                              ? QCDashboardScreen(
                                  onViewReports: (tabIndex, {reportId}) {
                                    setState(() {
                                      _currentIndex = 12; // Navigate to QC verification list
                                    });
                                  },
                                )
                              : DashboardScreen(
                                  role: _userRole,
                                  onQuickActionNavigate: (tabIndex, view) {
                                    setState(() {
                                      _currentIndex = tabIndex;
                                      if (tabIndex == 1) {
                                        _lashingView = view;
                                      } else if (tabIndex == 7) {
                                        _odcView = view;
                                      } else if (tabIndex == 8) {
                                        _damageView = view;
                                      }
                                    });
                                  },
                                ),
                      isSurveyBy
                          ? const SurveyByAssignedReportsScreen()
                          : isPreparedBy
                              ? LashingMeasurementScreen(
                                  key: ValueKey(_lashingView),
                                  initialView: _lashingView,
                                )
                              : ReportManagementScreen(
                                  key: ValueKey(_reportManagementView),
                                  initialView: _reportManagementView,
                                  onViewChanged: (view) {
                                    setState(() {
                                      _reportManagementView = view;
                                    });
                                  },
                                ),
                      isPreparedBy
                          ? const _ReportTypeSelector()
                          : const FinalApprovalScreen(),
                      isPreparedBy
                          ? const PreparedByReportController(initialView: 'assign')
                          : UserManagementScreen(viewMode: _userViewMode),
                      ProfileScreen(userRole: _userRole),
                      const DashboardAnalyticsScreen(),
                      const AuditLogsScreen(),
                      OdcSurveyScreen(key: ValueKey(_odcView), initialView: _odcView),
                      ContainerDamageScreen(key: ValueKey(_damageView), initialView: _damageView),
                      const SurveyorPhotoGalleryScreen(), // 9
                      const SurveyByAssignedReportsScreen(initialTabIndex: 2), // 10
                      const SurveyNotificationsScreen(), // 11
                      const QCReportVerificationScreen(), // 12
                      const QCPhotoVerificationGalleryScreen(), // 13
                      const QCNotificationsScreen(), // 14
                    ],
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
        child: isSurveyBy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomBarItem(Icons.home, 'Dashboard', _currentIndex == 0, () => _onTabTapped(0)),
                  _buildBottomBarItem(Icons.assignment, 'Assigned', _currentIndex == 1 || _currentIndex == 10, () => _onTabTapped(1)),
                  _buildBottomBarItem(Icons.photo_library, 'Gallery', _currentIndex == 9, () => _onTabTapped(9)),
                  _buildBottomBarItem(Icons.notifications, 'Alerts', _currentIndex == 11, () => _onTabTapped(11)),
                  _buildBottomBarItem(Icons.person, 'Profile', _currentIndex == 4, () => _onTabTapped(4)),
                ],
              )
            : isCheckedBy
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBottomBarItem(Icons.home, 'Dashboard', _currentIndex == 0, () => _onTabTapped(0)),
                      _buildBottomBarItem(Icons.playlist_add_check_rounded, 'Verify', _currentIndex == 12, () => _onTabTapped(12)),
                      _buildBottomBarItem(Icons.image_search_rounded, 'Photos', _currentIndex == 13, () => _onTabTapped(13)),
                      _buildBottomBarItem(Icons.notifications, 'Alerts', _currentIndex == 14, () => _onTabTapped(14)),
                      _buildBottomBarItem(Icons.person, 'Profile', _currentIndex == 4, () => _onTabTapped(4)),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBottomBarItem(Icons.home, 'Dashboard', _currentIndex == 0, () => _onTabTapped(0)),
                      _buildBottomBarItem(Icons.description, 'Reports', _currentIndex == 1 || _currentIndex == 7 || _currentIndex == 8, () => _onTabTapped(1)),
                      // Floating "+" Action Button
                      GestureDetector(
                        onTap: () {
                          if (isPreparedBy) {
                            _showNewReportPicker(context);
                          } else {
                            setState(() {
                              _currentIndex = 3;
                              _userViewMode = 'add';
                            });
                          }
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
                      isPreparedBy
                          ? _buildBottomBarItem(Icons.assignment, 'Assign', _currentIndex == 3, () => _onTabTapped(3))
                          : _buildBottomBarItem(Icons.draw, 'Sign', _currentIndex == 2, () => _onTabTapped(2)),
                      _buildBottomBarItem(Icons.person, 'Profile', _currentIndex == 4, () => _onTabTapped(4)),
                    ],
                  ),
      ),
    );
  }

  void _showNewReportPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Create New Report', style: AppTextStyle.body18Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Select the report type to begin', style: AppTextStyle.body12Regular.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            _reportTypeCard(
              context,
              icon: Icons.link_rounded,
              title: 'Lashing & Measurement Survey',
              subtitle: 'Container lashing, securing & weight measurement',
              gradient: AppColors.blueCyanGradient,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1); // Goes to LashingMeasurementScreen
              },
            ),
            const SizedBox(height: 12),
            _reportTypeCard(
              context,
              icon: Icons.local_shipping_rounded,
              title: 'ODC Survey Report',
              subtitle: 'Over dimensional cargo inspection & routing',
              gradient: AppColors.emeraldCyanGradient,
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _odcView = 'create';
                  _currentIndex = 7;
                });
              },
            ),
            const SizedBox(height: 12),
            _reportTypeCard(
              context,
              icon: Icons.dangerous_rounded,
              title: 'Container Damage Survey',
              subtitle: 'Damage inspection, photo log & CSC status',
              gradient: AppColors.orangeYellowGradient,
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _damageView = 'create';
                  _currentIndex = 8;
                });
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _reportTypeCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: gradient.first.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
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

// ─────────────────────────────────────────────────────────────
//  Placeholder at IndexedStack index 2 for Prepared By role
//  User reaches report screens via the + FAB bottom sheet picker
// ─────────────────────────────────────────────────────────────
class _ReportTypeSelector extends StatelessWidget {
  const _ReportTypeSelector();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline_rounded, size: 56, color: AppColors.textMuted),
            SizedBox(height: 12),
            Text(
              'Tap the \u002B button below\nto create a new report.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

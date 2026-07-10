import 'package:flutter/material.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/dashboard/presentation/dashboard_analytics_screen.dart';
import '../features/user_management/presentation/user_management_screens.dart';
import '../features/report/presentation/report_management_screens.dart';
import '../features/digital_signature/presentation/final_approval_module.dart';
import '../features/audit_logs/presentation/audit_logs_screen.dart';
import '../core/widgets/admin_layout.dart';

import '../features/profile/presentation/profile_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const AdminLayout(
            activeRoute: '/dashboard',
            child: DashboardScreen(),
          ),
        );

      case '/users':
        return MaterialPageRoute(
          builder: (_) => const AdminLayout(
            activeRoute: '/users',
            child: UserManagementScreen(),
          ),
        );

      case '/reports':
        return MaterialPageRoute(
          builder: (_) => const AdminLayout(
            activeRoute: '/reports',
            child: ReportManagementScreen(),
          ),
        );

      case '/approval':
        return MaterialPageRoute(
          builder: (_) => const AdminLayout(
            activeRoute: '/approval',
            child: FinalApprovalScreen(),
          ),
        );

      case '/analytics':
        return MaterialPageRoute(
          builder: (_) => const AdminLayout(
            activeRoute: '/analytics',
            child: DashboardAnalyticsScreen(),
          ),
        );

      case '/audit':
        return MaterialPageRoute(
          builder: (_) => const AdminLayout(
            activeRoute: '/audit',
            child: AuditLogsScreen(),
          ),
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const AdminLayout(
            activeRoute: '/profile',
            child: ProfileScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
    }
  }
}

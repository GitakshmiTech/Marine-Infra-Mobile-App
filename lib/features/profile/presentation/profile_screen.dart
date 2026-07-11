import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';

class ProfileScreen extends StatelessWidget {
  final String userRole;
  const ProfileScreen({super.key, this.userRole = 'Company Admin'});

  @override
  Widget build(BuildContext context) {
    String name = 'John Smith';
    String email = 'john.smith@marinesurvey.com';
    String phone = '+91 98765 43210';
    String roleLabel = 'Company Admin';

    if (userRole == 'Prepared By') {
      name = 'Sarah Preparer';
      email = 'sarah.preparer@marinesurvey.com';
      phone = '+91 98765 00002';
      roleLabel = 'Prepared By';
    } else if (userRole == 'Survey By') {
      name = 'Field Surveyor John';
      email = 'surveyor@marinesurvey.com';
      phone = '+91 98765 00003';
      roleLabel = 'Surveyor Workspace';
    } else if (userRole == 'Checked By') {
      name = 'QC Reviewer Marc';
      email = 'marc.reviewer@marinesurvey.com';
      phone = '+91 98765 00004';
      roleLabel = 'Checked By (QC Review)';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Blue Profile Banner
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.blueCyanGradient,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Profile Photo
                  Stack(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: AppTextStyle.h4.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.green, size: 16),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    roleLabel,
                    style: AppTextStyle.body14Medium.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    email,
                    style: AppTextStyle.body12Regular.copyWith(color: Colors.white60),
                  ),
                  Text(
                    phone,
                    style: AppTextStyle.body12Regular.copyWith(color: Colors.white60),
                  ),
                ],
              ),
            ),

            // Info lists
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Personal Information'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsRow('Full Name', name, Icons.person_outline, Colors.blue),
                        const Divider(height: 1),
                        _buildSettingsRow('Email Address', email, Icons.mail_outline, Colors.blue),
                        const Divider(height: 1),
                        _buildSettingsRow('Phone Number', phone, Icons.phone_outlined, Colors.blue),
                        const Divider(height: 1),
                        _buildSettingsRow('Date of Birth', '15 May 1988', Icons.calendar_month_outlined, Colors.blue),
                        const Divider(height: 1),
                        _buildSettingsRow('Language', 'English', Icons.language_outlined, Colors.blue),
                        const Divider(height: 1),
                        _buildSettingsRow('Time Zone', '(GMT+05:30) Asia/Kolkata', Icons.schedule_outlined, Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Account Security Card
                  _buildSectionHeader('Account & Security'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildSecurityRow('Change Password', null, Icons.lock_outline, Colors.blue),
                        const Divider(height: 1),
                        _buildSecurityRow('Two-Factor Authentication', 'Enabled', Icons.verified_user_outlined, Colors.blue),
                        const Divider(height: 1),
                        _buildSecurityRow('Login Devices', null, Icons.phonelink_setup_rounded, Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Preferences
                  _buildSectionHeader('Preferences'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildSecurityRow('Notification Settings', null, Icons.notifications_none_outlined, Colors.blue),
                        const Divider(height: 1),
                        _buildSecurityRow('App Preferences', null, Icons.settings_outlined, Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      icon: const Icon(Icons.logout_rounded, color: AppColors.pink, size: 18),
                      label: const Text(
                        'Logout',
                        style: TextStyle(color: AppColors.pink, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: AppTextStyle.body14Medium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSettingsRow(String label, String value, IconData icon, Color color) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: AppColors.primaryBlue, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      trailing: Text(value, style: AppTextStyle.body13Semibold.copyWith(color: AppColors.textPrimary)),
    );
  }

  Widget _buildSecurityRow(String label, String? value, IconData icon, Color color) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: AppColors.primaryBlue, size: 20),
      title: Text(label, style: AppTextStyle.body13Semibold.copyWith(color: AppColors.textPrimary)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(value, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

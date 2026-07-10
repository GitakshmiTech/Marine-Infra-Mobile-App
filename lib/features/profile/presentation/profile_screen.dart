import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Blue Profile Banner (Profile Image, Name, Role, Contact)
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
                  // Circular Profile Photo with Camera Overlay
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
                        'John Smith',
                        style: AppTextStyle.h4.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.green, size: 16),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Company Admin',
                    style: AppTextStyle.body14Medium.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'john.smith@marinesurvey.com',
                    style: AppTextStyle.body12Regular.copyWith(color: Colors.white60),
                  ),
                  Text(
                    '+91 98765 43210',
                    style: AppTextStyle.body12Regular.copyWith(color: Colors.white60),
                  ),
                ],
              ),
            ),

            // 3. Info lists
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Info Card
                  _buildSectionHeader('Personal Information'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsRow('Full Name', 'John Smith', Icons.person_outline, Colors.blue),
                        const Divider(height: 1),
                        _buildSettingsRow('Email Address', 'john.smith@marinesurvey.com', Icons.mail_outline, Colors.blue),
                        const Divider(height: 1),
                        _buildSettingsRow('Phone Number', '+91 98765 43210', Icons.phone_outlined, Colors.blue),
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

                  // Account & Security Card
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



  Widget _buildSettingsRow(String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
        ],
      ),
    );
  }

  Widget _buildSecurityRow(String label, String? statusTag, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (statusTag != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                statusTag,
                style: const TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 6),
          ],
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
        ],
      ),
    );
  }
}

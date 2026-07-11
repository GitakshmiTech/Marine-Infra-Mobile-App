import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';

class UserManagementScreen extends StatefulWidget {
  final String viewMode;
  const UserManagementScreen({super.key, this.viewMode = 'list'});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _selectedStatus = 'All';
  late String _currentView;
  Map<String, dynamic>? _selectedUser;

  // Controllers for CRUD operations
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  String _selectedRole = 'Prepared By';

  // Mock User List Data
  final List<Map<String, dynamic>> _users = [
    {
      'id': 'EMP-001',
      'name': 'John Smith',
      'isYou': true,
      'email': 'john.smith@marinesurvey.com',
      'mobile': '+91 98765 43210',
      'role': 'Company Admin',
      'status': 'Active',
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=80&q=80',
    },
    {
      'id': 'EMP-008',
      'name': 'Sarah Johnson',
      'isYou': false,
      'email': 'sarah.johnson@marinesurvey.com',
      'mobile': '+91 91234 56789',
      'role': 'Prepared By',
      'status': 'Active',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=80&q=80',
    },
    {
      'id': 'EMP-014',
      'name': 'Michael Brown',
      'isYou': false,
      'email': 'michael.brown@marinesurvey.com',
      'mobile': '+91 99876 54321',
      'role': 'Survey By',
      'status': 'Active',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=80&q=80',
    },
    {
      'id': 'EMP-018',
      'name': 'Emily Davis',
      'isYou': false,
      'email': 'emily.davis@marinesurvey.com',
      'mobile': '+91 87654 32109',
      'role': 'Checked By',
      'status': 'Active',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=80&q=80',
    },
    {
      'id': 'EMP-022',
      'name': 'David Wilson',
      'isYou': false,
      'email': 'david.wilson@marinesurvey.com',
      'mobile': '+91 76543 21098',
      'role': 'Prepared By',
      'status': 'Inactive',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=80&q=80',
    },
    {
      'id': 'EMP-030',
      'name': 'Robert Lee',
      'isYou': false,
      'email': 'robert.lee@marinesurvey.com',
      'mobile': '+91 65432 10987',
      'role': 'Survey By',
      'status': 'Locked',
      'avatar': '',
      'initials': 'RL',
    },
    {
      'id': 'EMP-034',
      'name': 'Amanda Johnson',
      'isYou': false,
      'email': 'amanda.johnson@marinesurvey.com',
      'mobile': '+91 54321 09876',
      'role': 'Checked By',
      'status': 'Active',
      'avatar': '',
      'initials': 'AJ',
    },
    {
      'id': 'EMP-039',
      'name': 'Mark Thompson',
      'isYou': false,
      'email': 'mark.thompson@marinesurvey.com',
      'mobile': '+91 43210 98765',
      'role': 'Prepared By',
      'status': 'Active',
      'avatar': '',
      'initials': 'MT',
    }
  ];

  void _setView(String view, {Map<String, dynamic>? user}) {
    setState(() {
      _currentView = view;
      _selectedUser = user;
      if (view == 'edit' && user != null) {
        _nameController.text = user['name'];
        _emailController.text = user['email'];
        _mobileController.text = user['mobile'];
        _selectedRole = user['role'];
      } else if (view == 'add') {
        _nameController.clear();
        _emailController.clear();
        _mobileController.clear();
        _selectedRole = 'Prepared By';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currentView = widget.viewMode;
  }

  @override
  void didUpdateWidget(covariant UserManagementScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewMode != widget.viewMode) {
      _setView(widget.viewMode);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentView == 'add' || _currentView == 'edit') {
      return _buildUserFormView();
    }
    return _buildUserListView();
  }

  // --- USER LIST VIEW ---
  Widget _buildUserListView() {
    final filteredUsers = _users.where((user) {
      return _selectedStatus == 'All' || user['status'] == _selectedStatus;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _setView('add'),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // 1. Overview Scroller
          Container(
            height: 105,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildOverviewCard('Total Users', '${_users.length}', 'All users', _selectedStatus == 'All', () => setState(() => _selectedStatus = 'All'), Colors.blue),
                _buildOverviewCard('Active Users', '${_users.where((u) => u['status'] == 'Active').length}', 'Active', _selectedStatus == 'Active', () => setState(() => _selectedStatus = 'Active'), Colors.green),
                _buildOverviewCard('Inactive Users', '${_users.where((u) => u['status'] != 'Active').length}', 'Inactive', _selectedStatus == 'Inactive', () => setState(() => _selectedStatus = 'Inactive'), Colors.orange),
              ],
            ),
          ),

          // 2. User List cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                Color statusColor;
                switch (user['status']) {
                  case 'Active':
                    statusColor = Colors.green;
                    break;
                  case 'Inactive':
                    statusColor = Colors.grey;
                    break;
                  default:
                    statusColor = Colors.red;
                }

                Color roleColor;
                switch (user['role']) {
                  case 'Company Admin':
                    roleColor = Colors.blue;
                    break;
                  case 'Prepared By':
                    roleColor = Colors.purple;
                    break;
                  case 'Survey By':
                    roleColor = Colors.orange;
                    break;
                  default:
                    roleColor = Colors.teal;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Avatar + Details
                      Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: user['avatar'].isNotEmpty ? NetworkImage(user['avatar']) : null,
                                backgroundColor: user['avatar'].isEmpty ? roleColor.withOpacity(0.1) : Colors.transparent,
                                child: user['avatar'].isEmpty
                                    ? Text(user['initials'] ?? '', style: TextStyle(color: roleColor, fontWeight: FontWeight.bold))
                                    : null,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        user['name'],
                                        style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (user['isYou'] == true) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text('You', style: TextStyle(fontSize: 8, color: Colors.blue, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(user['email'], style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                Text(user['mobile'], style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      // Bottom Row: Status Badges & Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: roleColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: roleColor.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.verified_user_rounded, color: roleColor, size: 10),
                                    const SizedBox(width: 4),
                                    Text(
                                      user['role'],
                                      style: TextStyle(fontSize: 8, color: roleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  user['status'],
                                  style: TextStyle(fontSize: 8, color: statusColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _setView('edit', user: user),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.edit_outlined, color: AppColors.primaryBlue, size: 12),
                                      SizedBox(width: 4),
                                      Text('Edit', style: TextStyle(fontSize: 10, color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    user['status'] = user['status'] == 'Active' ? 'Inactive' : 'Active';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: (user['status'] == 'Active' ? Colors.red : Colors.green).withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        user['status'] == 'Active' ? Icons.block_flipped : Icons.check_circle_outline,
                                        color: user['status'] == 'Active' ? Colors.red : Colors.green,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        user['status'] == 'Active' ? 'Deactivate' : 'Activate',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: user['status'] == 'Active' ? Colors.red : Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String label, String value, String subText, bool isSelected, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 95,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.people_outline, color: color, size: 14),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 9, color: AppColors.textSecondary, overflow: TextOverflow.ellipsis),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      subText,
                      style: TextStyle(fontSize: 8, color: color, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- FORM VIEW ---
  Widget _buildUserFormView() {
    final isEdit = _currentView == 'edit';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Details' : 'Add New User'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _setView('list'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Personal & Official Details', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'Company Admin', child: Text('Company Admin')),
                    DropdownMenuItem(value: 'Prepared By', child: Text('Prepared By')),
                    DropdownMenuItem(value: 'Survey By', child: Text('Survey By')),
                    DropdownMenuItem(value: 'Checked By', child: Text('Checked By')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedRole = val;
                      });
                    }
                  },
                  decoration: const InputDecoration(labelText: 'System Access Role'),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _setView('list'),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (isEdit) {
                          final idx = _users.indexWhere((u) => u['id'] == _selectedUser!['id']);
                          if (idx != -1) {
                            setState(() {
                              _users[idx]['name'] = _nameController.text;
                              _users[idx]['email'] = _emailController.text;
                              _users[idx]['mobile'] = _mobileController.text;
                              _users[idx]['role'] = _selectedRole;
                            });
                          }
                        } else {
                          setState(() {
                            _users.add({
                              'id': 'EMP-0${_users.length + 1}',
                              'name': _nameController.text,
                              'isYou': false,
                              'email': _emailController.text,
                              'mobile': _mobileController.text,
                              'role': _selectedRole,
                              'status': 'Active',
                              'avatar': '',
                              'initials': _nameController.text.isNotEmpty
                                  ? _nameController.text.substring(0, min(2, _nameController.text.length)).toUpperCase()
                                  : 'US',
                            });
                          });
                        }
                        _setView('list');
                      },
                      child: Text(isEdit ? 'Save Changes' : 'Register User'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

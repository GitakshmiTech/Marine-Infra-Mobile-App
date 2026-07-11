import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'report_detail_screens.dart';

class ReportManagementScreen extends StatefulWidget {
  final String initialView;
  final ValueChanged<String>? onViewChanged;
  const ReportManagementScreen({super.key, this.initialView = 'list', this.onViewChanged});

  @override
  State<ReportManagementScreen> createState() => _ReportManagementScreenState();
}

class _ReportManagementScreenState extends State<ReportManagementScreen> {
  String _selectedStatus = 'All';
  String _selectedType = 'All Types';
  late String _currentView;
  Map<String, dynamic>? _selectedReport;

  @override
  void initState() {
    super.initState();
    _currentView = widget.initialView;
  }

  @override
  void didUpdateWidget(covariant ReportManagementScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialView != widget.initialView) {
      setState(() {
        _currentView = widget.initialView;
      });
    }
  }

  void _setView(String view, {Map<String, dynamic>? report}) {
    setState(() {
      _currentView = view;
      _selectedReport = report;
    });
    if (widget.onViewChanged != null) {
      widget.onViewChanged!(view);
    }
  }

  // Mock Report Data
  final List<Map<String, dynamic>> _reports = [
    {
      'id': 'MSR-2024-1250',
      'title': 'Lashing & Measurement Survey',
      'vessel': 'Oceanic Star',
      'client': 'Maersk Line',
      'date': '20 May 2024',
      'creator': 'John Smith',
      'status': 'Approved',
      'color': Colors.green,
      'type': 'Lashing & Measurement',
    },
    {
      'id': 'MSR-2024-1249',
      'title': 'ODC Survey',
      'vessel': 'Maersk Dubai',
      'client': 'Maersk Line',
      'date': '20 May 2024',
      'creator': 'John Smith',
      'status': 'Pending',
      'color': Colors.orange,
      'type': 'ODC Survey',
    },
    {
      'id': 'MSR-2024-1248',
      'title': 'Container Damage Survey',
      'vessel': 'MSC Glory',
      'client': 'MSC',
      'date': '19 May 2024',
      'creator': 'Michael Lee',
      'status': 'Under Review',
      'color': Colors.blue,
      'type': 'Container Damage',
    },
    {
      'id': 'MSR-2024-1247',
      'title': 'Lashing & Measurement Survey',
      'vessel': 'Evergreen',
      'client': 'Evergreen Line',
      'date': '19 May 2024',
      'creator': 'David Brown',
      'status': 'Returned',
      'color': Colors.red,
      'type': 'Lashing & Measurement',
    },
    {
      'id': 'MSR-2024-1246',
      'title': 'ODC Survey',
      'vessel': 'HMM Rotterdam',
      'client': 'HMM',
      'date': '18 May 2024',
      'creator': 'John Smith',
      'status': 'In Progress',
      'color': Colors.purple,
      'type': 'ODC Survey',
    },
    {
      'id': 'MSR-2024-1245',
      'title': 'Container Damage Survey',
      'vessel': 'APL China',
      'client': 'APL',
      'date': '18 May 2024',
      'creator': 'Michael Lee',
      'status': 'Draft',
      'color': Colors.grey,
      'type': 'Container Damage',
    }
  ];

  @override
  Widget build(BuildContext context) {
    if (_currentView == 'details' && _selectedReport != null) {
      final type = _selectedReport!['type'] ?? '';
      if (type == 'Lashing & Measurement') {
        return LashingReportDetailScreen(
          report: _selectedReport!,
          onBack: () => _setView('list'),
        );
      } else if (type == 'ODC Survey') {
        return OdcReportDetailScreen(
          report: _selectedReport!,
          onBack: () => _setView('list'),
        );
      } else {
        return ContainerDamageDetailScreen(
          report: _selectedReport!,
          onBack: () => _setView('list'),
        );
      }
    }

    // Filter logic
    final filteredReports = _reports.where((rep) {
      final matchesStatus = _selectedStatus == 'All' || rep['status'] == _selectedStatus;
      final matchesType = _selectedType == 'All Types' || rep['type'] == _selectedType;
      return matchesStatus && matchesType;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Horizontal Status Cards Scroller
          Container(
            height: 105,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildStatusCard('All Reports', '1,248', _selectedStatus == 'All', () => setState(() => _selectedStatus = 'All'), Colors.blue),
                _buildStatusCard('Pending', '312', _selectedStatus == 'Pending', () => setState(() => _selectedStatus = 'Pending'), Colors.orange),
                _buildStatusCard('In Progress', '152', _selectedStatus == 'In Progress', () => setState(() => _selectedStatus = 'In Progress'), Colors.purple),
                _buildStatusCard('Returned', '68', _selectedStatus == 'Returned', () => setState(() => _selectedStatus = 'Returned'), Colors.red),
                _buildStatusCard('Approved', '716', _selectedStatus == 'Approved', () => setState(() => _selectedStatus = 'Approved'), Colors.green),
              ],
            ),
          ),

          // 2. Tab chips scroller
          Container(
            height: 48,
            padding: const EdgeInsets.only(bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTypeChip('All Types'),
                _buildTypeChip('Lashing & Measurement'),
                _buildTypeChip('ODC Survey'),
                _buildTypeChip('Container Damage'),
              ],
            ),
          ),


          // 4. Reports List View
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                return GestureDetector(
                  onTap: () => _setView('details', report: report),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon Block
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: report['color'].withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.description_outlined, color: report['color'], size: 20),
                      ),
                      const SizedBox(width: 14),
                      // Details Area
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  report['id'],
                                  style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: report['color'].withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    report['status'],
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: report['color'],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              report['title'],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Row icons details (Vessel & Client)
                            Row(
                              children: [
                                const Icon(Icons.directions_boat_outlined, size: 12, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(report['vessel'], style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                const SizedBox(width: 12),
                                const Icon(Icons.person_outline, size: 12, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(report['client'], style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Date details
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  '${report['date']} • Created by ${report['creator']}',
                                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary, size: 18),
                    ],
                  ),
                ),
              );
            },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String label, String value, bool isSelected, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 90,
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
              child: Icon(Icons.insert_drive_file_outlined, color: color, size: 14),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 9, color: AppColors.textSecondary, overflow: TextOverflow.ellipsis),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label) {
    final isSelected = _selectedType == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.08) : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'qc_data_store.dart';
import 'qc_report_detail.dart';

class QCReportVerificationScreen extends StatefulWidget {
  final int initialTabIndex; // 0=All, 1=Pending, 2=UnderReview, 3=Returned, 4=Verified, 5=Submitted
  const QCReportVerificationScreen({super.key, this.initialTabIndex = 0});

  @override
  State<QCReportVerificationScreen> createState() => _QCReportVerificationScreenState();
}

class _QCReportVerificationScreenState extends State<QCReportVerificationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _priorityFilter = 'All';
  String _statusFilter = 'All';

  // Details active state
  Map<String, dynamic>? _activeReportDetail;

  @override
  void initState() {
    super.initState();
    _statusFilter = _getStatusFromIndex(widget.initialTabIndex);
  }

  @override
  void didUpdateWidget(covariant QCReportVerificationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex != widget.initialTabIndex) {
      setState(() {
        _statusFilter = _getStatusFromIndex(widget.initialTabIndex);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getStatusFromIndex(int index) {
    switch (index) {
      case 1:
        return 'Pending Verification';
      case 2:
        return 'Under Review';
      case 3:
        return 'Returned';
      case 4:
        return 'Verified';
      case 5:
        return 'Submitted';
      default:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_activeReportDetail != null) {
      return QCReportDetailScreen(
        report: _activeReportDetail!,
        onBack: () {
          setState(() {
            _activeReportDetail = null;
          });
        },
        onStatusChanged: () {
          setState(() {});
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Search & Filter header (12px horizontal padding)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search ID, Client, Vessel...',
                          prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                          isDense: true,
                          fillColor: AppColors.background,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Priority Filter Button
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list_rounded, color: AppColors.primaryBlue),
                      onSelected: (val) {
                        setState(() {
                          _priorityFilter = val;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'All', child: Text('All Priorities')),
                        const PopupMenuItem(value: 'High', child: Text('High Priority')),
                        const PopupMenuItem(value: 'Medium', child: Text('Medium Priority')),
                        const PopupMenuItem(value: 'Low', child: Text('Low Priority')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Horizontal Chips for Status Filtering
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _statusChip('All'),
                      _statusChip('Pending Verification', label: 'Pending'),
                      _statusChip('Under Review'),
                      _statusChip('Returned'),
                      _statusChip('Verified'),
                      _statusChip('Submitted', label: 'Admin Submitted'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main list content (12px horizontal padding)
          Expanded(
            child: _buildReportList(),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status, {String? label}) {
    final isSelected = _statusFilter == status;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label ?? status,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
        selected: isSelected,
        onSelected: (val) {
          if (val) {
            setState(() {
              _statusFilter = status;
            });
          }
        },
        selectedColor: AppColors.primaryBlue,
        backgroundColor: AppColors.background,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? AppColors.primaryBlue : AppColors.border),
        ),
      ),
    );
  }

  Widget _buildReportList() {
    final ds = QCDataStore.instance;

    final filtered = ds.reports.where((report) {
      // Status matching
      if (_statusFilter != 'All' && report['status'] != _statusFilter) {
        return false;
      }

      // Search Query
      final matchSearch = report['id'].toString().toLowerCase().contains(_searchQuery) ||
          report['client'].toString().toLowerCase().contains(_searchQuery) ||
          report['vessel'].toString().toLowerCase().contains(_searchQuery) ||
          (report['containerNo'] != null && report['containerNo'].toString().toLowerCase().contains(_searchQuery));

      if (!matchSearch) return false;

      // Priority Filter
      if (_priorityFilter != 'All' && report['priority'] != _priorityFilter) {
        return false;
      }

      return true;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.assignment_turned_in_outlined, size: 48, color: AppColors.textMuted),
            SizedBox(height: 12),
            Text('No reports found matching filters', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final rep = filtered[index];
        Color priorityColor = Colors.green;
        if (rep['priority'] == 'High') priorityColor = Colors.red;
        if (rep['priority'] == 'Medium') priorityColor = Colors.orange;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border)),
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rep['id'],
                      style: AppTextStyle.body14Semibold.copyWith(color: AppColors.primaryBlue),
                    ),
                    _statusBadge(rep['status']),
                  ],
                ),
                const SizedBox(height: 8),
                Text(rep['title'], style: AppTextStyle.body15Semibold.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                _infoRow(Icons.business, 'Client: ${rep['client']}'),
                _infoRow(Icons.directions_boat, 'Vessel: ${rep['vessel']}'),
                _infoRow(Icons.person_outline, 'Prepared By: ${rep['preparedBy']}'),
                _infoRow(Icons.person_pin_circle_outlined, 'Survey By: ${rep['surveyBy']}'),
                _infoRow(Icons.calendar_month, 'Submitted: ${rep['submittedDate']}'),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: priorityColor),
                        ),
                        const SizedBox(width: 6),
                        Text('${rep['priority']} Priority', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    Row(
                      children: [
                        if (rep['status'] == 'Pending Verification') ...[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                rep['status'] = 'Under Review';
                                rep['activities'].add({
                                  'time': 'Just now',
                                  'title': 'QC Review Started',
                                  'desc': 'QC Reviewer moved report to Under Review.'
                                });
                                _activeReportDetail = rep;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Start Review', style: TextStyle(fontSize: 12, color: Colors.white)),
                          ),
                        ] else ...[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _activeReportDetail = rep;
                              });
                            },
                            child: const Text('Open Review', style: TextStyle(color: AppColors.primaryBlue)),
                          ),
                        ],
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg = Colors.grey.shade100;
    Color fg = Colors.grey.shade700;

    switch (status) {
      case 'Pending Verification':
        bg = Colors.purple.shade50;
        fg = Colors.purple;
        break;
      case 'Under Review':
        bg = Colors.teal.shade50;
        fg = Colors.teal;
        break;
      case 'Returned':
        bg = Colors.red.shade50;
        fg = Colors.red;
        break;
      case 'Verified':
        bg = Colors.blue.shade50;
        fg = Colors.blue;
        break;
      case 'Submitted':
        bg = Colors.green.shade50;
        fg = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(
        status,
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

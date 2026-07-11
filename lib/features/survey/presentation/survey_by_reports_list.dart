import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'surveyor_data_store.dart';
import 'survey_by_report_detail.dart';

class SurveyByAssignedReportsScreen extends StatefulWidget {
  final int initialTabIndex; // 0=All, 1=New (Assigned), 2=Accepted, 3=In Progress, 4=Returned, 5=Completed
  const SurveyByAssignedReportsScreen({super.key, this.initialTabIndex = 0});

  @override
  State<SurveyByAssignedReportsScreen> createState() => _SurveyByAssignedReportsScreenState();
}

class _SurveyByAssignedReportsScreenState extends State<SurveyByAssignedReportsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _priorityFilter = 'All';
  String _statusFilter = 'All'; // Filters: All, Assigned, Accepted, In Progress, Returned, Completed

  // Details flow state
  Map<String, dynamic>? _activeReportDetail;

  @override
  void initState() {
    super.initState();
    _statusFilter = _getStatusFromIndex(widget.initialTabIndex);
  }

  @override
  void didUpdateWidget(covariant SurveyByAssignedReportsScreen oldWidget) {
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
        return 'Assigned';
      case 2:
        return 'Accepted';
      case 3:
        return 'In Progress';
      case 4:
        return 'Returned';
      case 5:
        return 'Completed';
      default:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_activeReportDetail != null) {
      return SurveyByReportDetailScreen(
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
          // Search & Filter header
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
                // Horizontal Chips for Status Filtering instead of Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _statusChip('All'),
                      _statusChip('Assigned', label: 'New'),
                      _statusChip('Accepted'),
                      _statusChip('In Progress'),
                      _statusChip('Returned'),
                      _statusChip('Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main list content
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
    final ds = SurveyorDataStore.instance;

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
            Text('No assignments found matching filters', style: TextStyle(color: AppColors.textSecondary)),
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
                _infoRow(Icons.location_on, 'Location: ${rep['location']}'),
                _infoRow(Icons.calendar_month, 'Due: ${rep['dueDate']}'),
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
                        if (rep['status'] == 'Assigned') ...[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                rep['status'] = 'Accepted';
                                rep['activities'].add({
                                  'time': 'Just now',
                                  'title': 'Accepted',
                                  'desc': 'Surveyor accepted the report.'
                                });
                              });
                              SurveyorDataStore.instance.addNotification('Report Accepted', 'You accepted report ${rep['id']}');
                            },
                            child: const Text('Accept', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ),
                        ] else if (rep['status'] == 'Accepted' || rep['status'] == 'Returned') ...[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                rep['status'] = 'In Progress';
                                rep['activities'].add({
                                  'time': 'Just now',
                                  'title': 'Survey Started',
                                  'desc': 'Surveyor started on-site field verification.'
                                });
                                _activeReportDetail = rep;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(rep['status'] == 'Returned' ? 'Modify' : 'Start Survey', style: const TextStyle(fontSize: 12, color: Colors.white)),
                          ),
                        ] else ...[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _activeReportDetail = rep;
                              });
                            },
                            child: const Text('View Details', style: TextStyle(color: AppColors.primaryBlue)),
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
      case 'Assigned':
        bg = Colors.purple.shade50;
        fg = Colors.purple;
        break;
      case 'Accepted':
        bg = Colors.teal.shade50;
        fg = Colors.teal;
        break;
      case 'In Progress':
        bg = Colors.amber.shade50;
        fg = Colors.amber.shade800;
        break;
      case 'Submitted':
        bg = Colors.blue.shade50;
        fg = Colors.blue;
        break;
      case 'Returned':
        bg = Colors.red.shade50;
        fg = Colors.red;
        break;
      case 'Completed':
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

import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';

import '../../../core/widgets/mock_media_picker.dart';

// --- MAIN PREPARED BY REPORT WIDGET CONTROLLER ---
class PreparedByReportController extends StatefulWidget {
  final String initialView;
  final String? defaultReportType;
  const PreparedByReportController({super.key, this.initialView = 'list', this.defaultReportType});

  @override
  State<PreparedByReportController> createState() => _PreparedByReportControllerState();
}

class _PreparedByReportControllerState extends State<PreparedByReportController> {
  late String _currentView;
  Map<String, dynamic>? _selectedReport;
  late String _selectedReportType;
  String _selectedStatus = 'All Reports';
  String _searchQuery = '';

  // Mock list of reports managed by Prepared By
  final List<Map<String, dynamic>> _reports = [
    {
      'id': 'MSR-2024-1250',
      'title': 'Lashing & Measurement Survey',
      'type': 'Lashing & Measurement',
      'vessel': 'Oceanic Star',
      'client': 'Maersk Line',
      'date': '20 May 2024',
      'creator': 'Sarah Johnson',
      'status': 'Draft',
      'color': Colors.orange,
      'priority': 'Medium',
      'branch': 'Mumbai Port',
      'voyage': 'V-204X',
      'port': 'JNP Terminal',
      'ref': 'REF-90921',
      'job': 'JOB-8812',
      'remarks': 'Lashing securing needs verification.',
      'instructions': 'Verify container lashing tension on bay 12.',
    },
    {
      'id': 'MSR-2024-1249',
      'title': 'ODC Survey',
      'type': 'ODC Survey',
      'vessel': 'Maersk Dubai',
      'client': 'Maersk Line',
      'date': '20 May 2024',
      'creator': 'Sarah Johnson',
      'status': 'Assigned to Survey By',
      'color': Colors.blue,
      'priority': 'High',
      'branch': 'Mumbai Port',
      'voyage': 'V-301D',
      'port': 'BP Terminal',
      'ref': 'REF-33291',
      'job': 'JOB-9022',
      'remarks': 'ODC dimensions exceed standard bays.',
      'instructions': 'Measure exact height clearance.',
    },
    {
      'id': 'MSR-2024-1247',
      'title': 'Container Damage Survey',
      'type': 'Container Damage',
      'vessel': 'Evergreen',
      'client': 'Evergreen Line',
      'date': '19 May 2024',
      'creator': 'Sarah Johnson',
      'status': 'Returned Reports',
      'color': Colors.red,
      'priority': 'High',
      'branch': 'Chennai Port',
      'voyage': 'V-992A',
      'port': 'Port Chennai',
      'ref': 'REF-2291',
      'job': 'JOB-1022',
      'remarks': 'Re-check corrosion marks on side wall.',
      'instructions': 'Please capture new photographs of the corner castings.',
    }
  ];

  List<String> _attachedDocuments = [];
  List<String> _attachedPhotos = [];

  // Form Fields
  final _clientController = TextEditingController();
  final _shippingController = TextEditingController();
  final _vesselController = TextEditingController();
  final _voyageController = TextEditingController();
  final _portController = TextEditingController();
  final _terminalController = TextEditingController();
  final _refController = TextEditingController();
  final _jobController = TextEditingController();
  final _remarksController = TextEditingController();
  final _instructionsController = TextEditingController();

  void _setView(String view, {Map<String, dynamic>? report}) {
    setState(() {
      _currentView = view;
      _selectedReport = report;

      if (view == 'edit' && report != null) {
        _selectedReportType = report['type'];
        _clientController.text = report['client'] ?? '';
        _vesselController.text = report['vessel'] ?? '';
        _voyageController.text = report['voyage'] ?? '';
        _portController.text = report['port'] ?? '';
        _refController.text = report['ref'] ?? '';
        _jobController.text = report['job'] ?? '';
        _remarksController.text = report['remarks'] ?? '';
        _instructionsController.text = report['instructions'] ?? '';
        _attachedDocuments = ['ref_drawing.pdf'];
        _attachedPhotos = ['pre_loading_ref.jpg'];
      } else if (view == 'create') {
        _selectedReportType = 'Lashing & Measurement';
        _clientController.clear();
        _vesselController.clear();
        _voyageController.clear();
        _portController.clear();
        _refController.clear();
        _jobController.clear();
        _remarksController.clear();
        _instructionsController.clear();
        _attachedDocuments = [];
        _attachedPhotos = [];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currentView = widget.initialView;
    _selectedReportType = widget.defaultReportType ?? 'Lashing & Measurement';
  }

  @override
  void didUpdateWidget(covariant PreparedByReportController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialView != widget.initialView) {
      setState(() {
        _currentView = widget.initialView;
      });
    }
  }

  @override
  void dispose() {
    _clientController.dispose();
    _shippingController.dispose();
    _vesselController.dispose();
    _voyageController.dispose();
    _portController.dispose();
    _terminalController.dispose();
    _refController.dispose();
    _jobController.dispose();
    _remarksController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentView) {
      case 'create':
      case 'edit':
        return _buildCreateOrEditForm();
      case 'assign':
        return _buildAssignmentView();
      case 'details':
        return _buildReportDetailsView();
      case 'list':
      default:
        return _buildReportListView();
    }
  }

  // --- REPORT LIST VIEW ---
  Widget _buildReportListView() {
    final filteredReports = _reports.where((rep) {
      // Type filter
      if (widget.defaultReportType != null && rep['type'] != widget.defaultReportType) {
        return false;
      }
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final idMatch = rep['id'].toString().toLowerCase().contains(query);
        final vesselMatch = rep['vessel'].toString().toLowerCase().contains(query);
        final clientMatch = rep['client'].toString().toLowerCase().contains(query);
        final titleMatch = rep['title'].toString().toLowerCase().contains(query);
        if (!idMatch && !vesselMatch && !clientMatch && !titleMatch) {
          return false;
        }
      }
      // Status filter
      if (_selectedStatus == 'All Reports') return true;
      if (_selectedStatus == 'Draft Reports' && rep['status'] == 'Draft') return true;
      if (_selectedStatus == 'Assigned to Survey By' && rep['status'] == 'Assigned to Survey By') return true;
      if (_selectedStatus == 'Assigned to Checked By' && rep['status'] == 'Assigned to Checked By') return true;
      if (_selectedStatus == 'Returned Reports' && rep['status'] == 'Returned Reports') return true;
      if (_selectedStatus == 'Approved Reports' && rep['status'] == 'Approved') return true;
      if (_selectedStatus == 'Rejected Reports' && rep['status'] == 'Rejected') return true;
      if (_selectedStatus == 'Archived Reports' && rep['status'] == 'Archived') return true;
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _setView('create'),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by ID, Vessel, Client...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),

          // Filter Chips Scroller
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('All Reports'),
                _buildFilterChip('Draft Reports'),
                _buildFilterChip('Assigned to Survey By'),
                _buildFilterChip('Assigned to Checked By'),
                _buildFilterChip('Returned Reports'),
                _buildFilterChip('Approved Reports'),
                _buildFilterChip('Rejected Reports'),
                _buildFilterChip('Archived Reports'),
              ],
            ),
          ),
          Expanded(
            child: filteredReports.isEmpty
                ? const Center(child: Text('No reports found matching this filter.'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final rep = filteredReports[index];
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(rep['id'], style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: rep['color'].withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    rep['status'],
                                    style: TextStyle(fontSize: 8, color: rep['color'], fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(rep['title'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                            const SizedBox(height: 8),
                            Text('Vessel: ${rep['vessel']} | Client: ${rep['client']}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            Text('Last Updated: ${rep['date']}', style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    _buildActionPill('Details', Icons.info_outline, Colors.blue, () => _setView('details', report: rep)),
                                    const SizedBox(width: 8),
                                    if (rep['status'] == 'Draft' || rep['status'] == 'Returned Reports') ...[
                                      _buildActionPill('Edit', Icons.edit_outlined, Colors.orange, () => _setView('edit', report: rep)),
                                      const SizedBox(width: 8),
                                      _buildActionPill('Assign', Icons.person_add_alt_1_rounded, Colors.purple, () => _setView('assign', report: rep)),
                                    ],
                                    const SizedBox(width: 8),
                                    _buildActionPill('Duplicate', Icons.copy_rounded, Colors.teal, () {
                                      setState(() {
                                        final newReport = Map<String, dynamic>.from(rep);
                                        newReport['id'] = 'MSR-2024-${1000 + Random().nextInt(1000)}';
                                        newReport['status'] = 'Draft';
                                        newReport['color'] = Colors.orange;
                                        newReport['date'] = '20 May 2024';
                                        _reports.add(newReport);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Report Duplicated as Draft successfully!')),
                                      );
                                    }),
                                  ],
                                ),
                                if (rep['status'] == 'Draft')
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppColors.pink, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _reports.remove(rep);
                                      });
                                    },
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

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedStatus == label;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: isSelected,
        selectedColor: AppColors.primaryBlue.withOpacity(0.08),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.white,
        side: BorderSide(color: isSelected ? AppColors.primaryBlue : AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (val) {
          setState(() {
            _selectedStatus = label;
          });
        },
      ),
    );
  }

  Widget _buildActionPill(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // --- REPORT FORM VIEW (Lashing, ODC, Container Damage) ---
  Widget _buildCreateOrEditForm() {
    final isEdit = _currentView == 'edit';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Report Selector Card
             if (widget.defaultReportType == null) ...[
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Report Template Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedReportType,
                      items: const [
                        DropdownMenuItem(value: 'Lashing & Measurement', child: Text('Lashing & Measurement Survey')),
                        DropdownMenuItem(value: 'ODC Survey', child: Text('ODC (Over Dimensional Cargo) Survey')),
                        DropdownMenuItem(value: 'Container Damage', child: Text('Container Damage Survey')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedReportType = val;
                          });
                        }
                      },
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Form Content Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Common Report Header', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: isEdit ? _selectedReport!['id'] : 'MSR-2024-${1000 + Random().nextInt(1000)}',
                    enabled: false,
                    decoration: const InputDecoration(labelText: 'Auto Generated Report Number'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _vesselController,
                    decoration: const InputDecoration(labelText: 'Vessel Name'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _clientController,
                    decoration: const InputDecoration(labelText: 'Client Name'),
                  ),
                  const SizedBox(height: 16),

                  Text('2. Office & Terminal Information', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _voyageController,
                    decoration: const InputDecoration(labelText: 'Voyage Number'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _portController,
                    decoration: const InputDecoration(labelText: 'Port / Terminal'),
                  ),
                  const SizedBox(height: 16),

                  Text('3. Cargo Details', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _refController,
                    decoration: const InputDecoration(labelText: 'Reference Number'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _jobController,
                    decoration: const InputDecoration(labelText: 'Job Number'),
                  ),
                  const SizedBox(height: 16),

                  Text('4. Attachments (Upload files & drawings)', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                        label: const Text('Add Document', style: TextStyle(fontSize: 11)),
                        onPressed: () async {
                          final file = await MockMediaPicker.showFilePicker(context, allowedExtensions: ['pdf', 'xlsx', 'docx']);
                          if (file != null) {
                            setState(() {
                              _attachedDocuments.add(file.name);
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt_outlined, size: 16),
                        label: const Text('Add Photo', style: TextStyle(fontSize: 11)),
                        onPressed: () async {
                          final file = await MockMediaPicker.showCamera(context);
                          if (file != null) {
                            setState(() {
                              _attachedPhotos.add(file.name);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (_attachedDocuments.isNotEmpty || _attachedPhotos.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        ..._attachedDocuments.map((doc) => Chip(
                              avatar: const Icon(Icons.picture_as_pdf_rounded, size: 14, color: Colors.red),
                              label: Text(doc, style: const TextStyle(fontSize: 11)),
                              onDeleted: () => setState(() => _attachedDocuments.remove(doc)),
                            )),
                        ..._attachedPhotos.map((pic) => Chip(
                              avatar: const Icon(Icons.image_rounded, size: 14, color: Colors.green),
                              label: Text(pic, style: const TextStyle(fontSize: 11)),
                              onDeleted: () => setState(() => _attachedPhotos.remove(pic)),
                            )),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),

                  Text('5. Remarks & Instructions', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _remarksController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Internal Remarks'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _instructionsController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Field Survey Instructions'),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _setView('list'),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        onPressed: () {
                          // Save Draft
                          setState(() {
                            if (isEdit) {
                              _selectedReport!['client'] = _clientController.text;
                              _selectedReport!['vessel'] = _vesselController.text;
                            } else {
                              _reports.add({
                                'id': 'MSR-2024-${1000 + Random().nextInt(1000)}',
                                'title': _selectedReportType,
                                'type': _selectedReportType,
                                'client': _clientController.text.isNotEmpty ? _clientController.text : 'Unknown Client',
                                'vessel': _vesselController.text.isNotEmpty ? _vesselController.text : 'Unknown Vessel',
                                'date': '20 May 2024',
                                'status': 'Draft',
                                'color': Colors.orange,
                              });
                            }
                          });
                          _setView('list');
                        },
                        child: const Text('Save Draft', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Save & Assign Workflow
                          setState(() {
                            Map<String, dynamic> targetRep;
                            if (isEdit) {
                              _selectedReport!['client'] = _clientController.text;
                              _selectedReport!['vessel'] = _vesselController.text;
                              targetRep = _selectedReport!;
                            } else {
                              targetRep = {
                                'id': 'MSR-2024-${1000 + Random().nextInt(1000)}',
                                'title': _selectedReportType,
                                'type': _selectedReportType,
                                'client': _clientController.text,
                                'vessel': _vesselController.text,
                                'date': '20 May 2024',
                                'status': 'Draft',
                                'color': Colors.orange,
                              };
                              _reports.add(targetRep);
                            }
                            _setView('assign', report: targetRep);
                          });
                        },
                        child: const Text('Assign Workflow'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ASSIGNMENT WORKFLOW VIEW ---
  Widget _buildAssignmentView() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Option 1: Assign to Survey By
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.directions_run_rounded, color: Colors.teal),
                      SizedBox(width: 8),
                      Text('Option 1: Assign to Survey By (Field Inspector)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Select this option if a physical cargo inspection is required at the terminal.', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: 'David Lightman (Surveyor)',
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                    items: const [
                      DropdownMenuItem(value: 'David Lightman (Surveyor)', child: Text('David Lightman (Surveyor)', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'Sarah Connor (Surveyor)', child: Text('Sarah Connor (Surveyor)', style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (val) {},
                    decoration: const InputDecoration(labelText: 'Select Surveyor User'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: 'Medium',
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                    items: const [
                      DropdownMenuItem(value: 'High', child: Text('High Priority', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'Medium', child: Text('Medium Priority', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'Low', child: Text('Low Priority', style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (val) {},
                    decoration: const InputDecoration(labelText: 'Assignment Priority'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      onPressed: () {
                        setState(() {
                          _selectedReport!['status'] = 'Assigned to Survey By';
                          _selectedReport!['color'] = Colors.teal;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Assigned to Survey By Successfully!')),
                        );
                        _setView('list');
                      },
                      child: const Text('Assign to Survey By', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Option 2: Direct Assign to Checked By
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.verified_user_rounded, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text('Option 2: Direct Assign to Checked By (QA)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Select this if office preparation is enough and no field inspection is required.', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: 'John Miller (Quality Auditor)',
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                    items: const [
                      DropdownMenuItem(value: 'John Miller (Quality Auditor)', child: Text('John Miller (Quality Auditor)', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'Alexander Marin (Auditor)', child: Text('Alexander Marin (Auditor)', style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (val) {},
                    decoration: const InputDecoration(labelText: 'Select Checked By Reviewer'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      onPressed: () {
                        setState(() {
                          _selectedReport!['status'] = 'Assigned to Checked By';
                          _selectedReport!['color'] = Colors.indigo;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Assigned Directly to Checked By Reviewer!')),
                        );
                        _setView('list');
                      },
                      child: const Text('Submit Direct to Checked By', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DETAILED REPORT PREVIEW SCREEN ---
  Widget _buildReportDetailsView() {
    final rep = _selectedReport ?? {};
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                isScrollable: true,
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primaryBlue,
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Report Form'),
                  Tab(text: 'Attachments'),
                  Tab(text: 'Timeline & History'),
                  Tab(text: 'Remarks'),
                  Tab(text: 'PDF & Signatures'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
          children: [
            // Tab 1: Overview
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRowDetail('Report Number', rep['id'] ?? ''),
                    _buildRowDetail('Report Type', rep['type'] ?? ''),
                    _buildRowDetail('Client Name', rep['client'] ?? ''),
                    _buildRowDetail('Vessel Name', rep['vessel'] ?? ''),
                    _buildRowDetail('Voyage Number', rep['voyage'] ?? 'V-102X'),
                    _buildRowDetail('Port Terminal', rep['port'] ?? 'JNP Terminal'),
                    _buildRowDetail('Job Reference', rep['ref'] ?? 'REF-992'),
                  ],
                ),
              ),
            ),
            // Tab 2: Report Form
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Form fields entered for: ${rep['type']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildRowDetail('Cargo Weight', '42.5 Metric Tons'),
                    _buildRowDetail('Lashing Points', '12 Points - Pass'),
                    _buildRowDetail('ODC Width Clearance', '3.8 Meters'),
                    _buildRowDetail('Securing Status', 'Verified & Tensioned'),
                  ],
                ),
              ),
            ),
            // Tab 3: Attachments
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAttachmentItem('Office Photo 1.jpg', 'Image File', Icons.image, Colors.blue),
                  _buildAttachmentItem('Cargo Drawing PDF.pdf', 'Technical Diagram', Icons.picture_as_pdf, Colors.red),
                  _buildAttachmentItem('Survey Authorization.doc', 'Verification Document', Icons.description, Colors.green),
                ],
              ),
            ),
            // Tab 4: Timeline
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTimelineNode('Report Created', 'Draft Saved', '20 May 2024, 10:00 AM', true),
                  _buildTimelineNode('Assigned to Survey By', 'Field Inspection Requested', '20 May 2024, 10:15 AM', rep['status'] != 'Draft'),
                  _buildTimelineNode('Submitted to Checked By', 'Audit Pending', '20 May 2024, 11:30 AM', rep['status'] == 'Assigned to Checked By'),
                ],
              ),
            ),
            // Tab 5: Remarks
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Prepared By Notes', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(rep['remarks'] ?? 'No custom remarks specified.', style: const TextStyle(fontSize: 12)),
                    const Divider(height: 24),
                    const Text('Survey Instructions', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(rep['instructions'] ?? 'No field survey instruction cards created.', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            // Tab 6: PDF & Signatures
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.picture_as_pdf_outlined, size: 48, color: Colors.red),
                        const SizedBox(height: 8),
                        const Text('Mock PDF Report Preview', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text('PDF Generated on final sign-off approval.', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Download Draft PDF'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Digital Signatures', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(Icons.check_circle_outline, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Sarah Johnson (Prepared By) - Signed', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.pending_outlined, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('John Miller (Checked By) - Pending', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
    );
  }

  Widget _buildRowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(String title, String type, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(type, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(String title, String desc, String time, bool active) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(active ? Icons.check_circle : Icons.radio_button_unchecked, color: active ? AppColors.primaryBlue : Colors.grey, size: 18),
            Container(width: 2, height: 40, color: active ? AppColors.primaryBlue : Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: active ? AppColors.textPrimary : Colors.grey)),
              Text(desc, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              Text(time, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
            ],
          ),
        ),
      ],
    );
  }
}

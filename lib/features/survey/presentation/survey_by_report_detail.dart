import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import '../../../core/widgets/custom_signature_pad.dart';
import '../../../core/widgets/mock_media_picker.dart';
import 'surveyor_data_store.dart';

class SurveyByReportDetailScreen extends StatefulWidget {
  final Map<String, dynamic> report;
  final VoidCallback onBack;
  final VoidCallback onStatusChanged;

  const SurveyByReportDetailScreen({
    super.key,
    required this.report,
    required this.onBack,
    required this.onStatusChanged,
  });

  @override
  State<SurveyByReportDetailScreen> createState() => _SurveyByReportDetailScreenState();
}

class _SurveyByReportDetailScreenState extends State<SurveyByReportDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  // Temporary Form States
  late TextEditingController _fieldObsController;
  late TextEditingController _lashingVerController;
  late TextEditingController _measVerController;
  late TextEditingController _remarksController;

  // Photo uploads state
  List<Map<String, dynamic>> _photos = [];
  String _selectedCategory = 'Cargo Close-up';
  final TextEditingController _photoCaptionController = TextEditingController();
  final TextEditingController _photoRemarksController = TextEditingController();

  // Document attachments state
  List<Map<String, String>> _documents = [];

  // Signature state
  List<Offset> _signaturePoints = [];
  bool _hasSignature = false;

  // Collapsible section expansion states
  bool _overviewExpanded = true;
  bool _formExpanded = true;
  bool _photosExpanded = true;
  bool _docsExpanded = false;
  bool _remarksExpanded = false;
  bool _sigExpanded = false;
  bool _timelineExpanded = false;

  @override
  void initState() {
    super.initState();
    final rep = widget.report;
    _fieldObsController = TextEditingController(text: rep['obsFieldObservations'] ?? rep['obsDamageVerification'] ?? rep['obsOdcVerification'] ?? '');
    _lashingVerController = TextEditingController(text: rep['obsLashingVerification'] ?? rep['obsDamageLocation'] ?? rep['obsCargoPositioning'] ?? '');
    _measVerController = TextEditingController(text: rep['obsMeasurementVerification'] ?? rep['obsDamageObservations'] ?? rep['obsSafetyObservations'] ?? '');
    _remarksController = TextEditingController(text: rep['obsRemarks'] ?? rep['obsConditionRemarks'] ?? rep['remarks'] ?? '');

    _photos = List<Map<String, dynamic>>.from(rep['photos'] ?? []);
    _documents = List<Map<String, String>>.from(rep['documents'] ?? []);
    _signaturePoints = List<Offset>.from(rep['signature'] ?? []);
    _hasSignature = (rep['signaturePath'] != null && rep['signaturePath'].toString().isNotEmpty) || _signaturePoints.isNotEmpty;
  }

  @override
  void dispose() {
    _fieldObsController.dispose();
    _lashingVerController.dispose();
    _measVerController.dispose();
    _remarksController.dispose();
    _photoCaptionController.dispose();
    _photoRemarksController.dispose();
    super.dispose();
  }

  void _saveDraft() {
    final rep = widget.report;
    setState(() {
      rep['obsFieldObservations'] = _fieldObsController.text;
      rep['obsLashingVerification'] = _lashingVerController.text;
      rep['obsMeasurementVerification'] = _measVerController.text;
      rep['obsRemarks'] = _remarksController.text;
      rep['photos'] = _photos;
      rep['documents'] = _documents;
      rep['signature'] = _signaturePoints;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft saved successfully!'), backgroundColor: Colors.teal),
    );
  }

  void _submitReport() {
    final rep = widget.report;

    if (_photos.isEmpty) {
      _showValidationError('At least one photo must be uploaded before submitting.');
      return;
    }
    if (_fieldObsController.text.trim().isEmpty) {
      _showValidationError('Please complete the mandatory Observation fields in the Survey Form.');
      return;
    }
    if (!_hasSignature) {
      _showValidationError('Digital signature must be applied before submission.');
      return;
    }

    setState(() {
      rep['obsFieldObservations'] = _fieldObsController.text;
      rep['obsLashingVerification'] = _lashingVerController.text;
      rep['obsMeasurementVerification'] = _measVerController.text;
      rep['obsRemarks'] = _remarksController.text;
      rep['photos'] = _photos;
      rep['documents'] = _documents;
      rep['signature'] = _signaturePoints;
      rep['status'] = 'Submitted';
      rep['activities'].add({
        'time': 'Just now',
        'title': 'Report Submitted',
        'desc': 'Surveyor submitted report. Locked for modifications.'
      });
    });

    SurveyorDataStore.instance.addNotification(
      'Report Submitted',
      'Report ${rep['id']} has been successfully sent to Checked By.'
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted to Checked By!'), backgroundColor: Colors.green),
    );
    widget.onStatusChanged();
    widget.onBack();
  }

  void _showValidationError(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Validation Alert'),
          ],
        ),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _addMockPhoto() {
    setState(() {
      _photos.add({
        'category': _selectedCategory,
        'caption': _photoCaptionController.text.isEmpty ? 'Field View' : _photoCaptionController.text,
        'remarks': _photoRemarksController.text,
        'metadata': '10 Jul 2026, 12:45 PM | GPS: 18.9502 N, 72.8258 E | Surveyor: surveyor | Android v13',
        'isMock': true,
      });
      _photoCaptionController.clear();
      _photoRemarksController.clear();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final rep = widget.report;
    final isLocked = rep['status'] == 'Submitted' || rep['status'] == 'Completed';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Inline Header Row replacing AppBar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryBlue, size: 20),
                    onPressed: widget.onBack,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rep['id'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Text(rep['title'], style: const TextStyle(fontSize: 9, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  if (!isLocked) ...[
                    TextButton(
                      onPressed: _saveDraft,
                      child: const Text('Save', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Submit', style: TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              // Returned Remarks Banner
              if (rep['status'] == 'Returned' && rep['returnRemarks'].toString().isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Returned Remarks:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 12)),
                            Text(rep['returnRemarks'], style: TextStyle(color: Colors.red.shade900, fontSize: 11)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 1. Overview Section
              _buildCollapsibleCard(
                title: 'Overview Details',
                icon: Icons.info_outline,
                color: Colors.blue,
                isExpanded: _overviewExpanded,
                onToggle: () => setState(() => _overviewExpanded = !_overviewExpanded),
                child: Column(
                  children: [
                    _buildOverviewItem('Client Name', rep['client']),
                    _buildOverviewItem('Vessel Name', rep['vessel']),
                    _buildOverviewItem('Shipping Line', rep['shippingLine']),
                    _buildOverviewItem('Location', rep['location']),
                    _buildOverviewItem('Assigned By', rep['assignedBy']),
                    _buildOverviewItem('Assigned Date', rep['date']),
                    _buildOverviewItem('Due Date', rep['dueDate']),
                    _buildOverviewItem('Instructions', rep['instructions']),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 2. Survey Form
              _buildCollapsibleCard(
                title: 'Survey Form Fields',
                icon: Icons.edit_note,
                color: Colors.purple,
                isExpanded: _formExpanded,
                onToggle: () => setState(() => _formExpanded = !_formExpanded),
                child: _buildSurveyFormFields(rep, isLocked),
              ),
              const SizedBox(height: 12),

              // 3. Photo Management
              _buildCollapsibleCard(
                title: 'Photo Uploads (${_photos.length})',
                icon: Icons.camera_alt_outlined,
                color: AppColors.emerald,
                isExpanded: _photosExpanded,
                onToggle: () => setState(() => _photosExpanded = !_photosExpanded),
                child: _buildPhotosSection(isLocked),
              ),
              const SizedBox(height: 12),

              // 4. Documents
              _buildCollapsibleCard(
                title: 'Supporting Documents (${_documents.length})',
                icon: Icons.upload_file,
                color: Colors.teal,
                isExpanded: _docsExpanded,
                onToggle: () => setState(() => _docsExpanded = !_docsExpanded),
                child: _buildDocumentsSection(isLocked),
              ),
              const SizedBox(height: 12),

              // 5. Remarks
              _buildCollapsibleCard(
                title: 'Remarks & Recommendations',
                icon: Icons.rate_review_outlined,
                color: Colors.amber.shade800,
                isExpanded: _remarksExpanded,
                onToggle: () => setState(() => _remarksExpanded = !_remarksExpanded),
                child: _buildRemarksSection(isLocked),
              ),
              const SizedBox(height: 12),

              // 6. Signature
              _buildCollapsibleCard(
                title: 'Digital Signature',
                icon: Icons.draw_outlined,
                color: Colors.indigo,
                isExpanded: _sigExpanded,
                onToggle: () => setState(() => _sigExpanded = !_sigExpanded),
                child: _buildSignatureSection(isLocked),
              ),
              const SizedBox(height: 12),

              // 7. Timeline / History
              _buildCollapsibleCard(
                title: 'Activity History',
                icon: Icons.history,
                color: Colors.grey.shade700,
                isExpanded: _timelineExpanded,
                onToggle: () => setState(() => _timelineExpanded = !_timelineExpanded),
                child: _buildTimelineSection(rep),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  //  COLLAPSIBLE CONTAINER WIDGET
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildCollapsibleCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withValues(alpha: 0.1),
                    child: Icon(icon, size: 16, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyle.body14Semibold.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ]
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  //  SECTION BUILDERS
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildOverviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
          Expanded(flex: 7, child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _buildSurveyFormFields(Map<String, dynamic> rep, bool isLocked) {
    String label1 = 'Inspection Observations';
    String label2 = 'Lashing Verification';
    String label3 = 'Measurement Details';

    if (rep['type'] == 'ODC Survey') {
      label1 = 'ODC Field Verification';
      label2 = 'Cargo Positioning';
      label3 = 'Safety Observations';
    } else if (rep['type'] == 'Container Damage') {
      label1 = 'Damage Verification';
      label2 = 'Damage Location';
      label3 = 'Damage Observations';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Complete the required fields for the on-site verification form.',
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _fieldObsController,
          enabled: !isLocked,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: label1,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _lashingVerController,
          enabled: !isLocked,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: label2,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _measVerController,
          enabled: !isLocked,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: label3,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _remarksController,
          enabled: !isLocked,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Additional Form Remarks',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosSection(bool isLocked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isLocked) ...[
          OutlinedButton.icon(
            onPressed: _showPhotoUploadSheet,
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Capture / Add Photo'),
          ),
          const SizedBox(height: 12),
        ],
        _photos.isEmpty
            ? const Center(child: Text('No photos uploaded yet.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final photo = _photos[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(Icons.image_outlined, size: 36, color: AppColors.primaryBlue),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(8)),
                                    child: Text(photo['category'], style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                if (!isLocked)
                                  Positioned(
                                    bottom: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _photos.removeAt(index);
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.red.withValues(alpha: 0.8),
                                        child: const Icon(Icons.delete, color: Colors.white, size: 12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(photo['caption'], style: AppTextStyle.body12Medium.copyWith(fontWeight: FontWeight.bold), maxLines: 1),
                              Text(photo['metadata'] ?? '', style: const TextStyle(fontSize: 7, color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  void _showPhotoUploadSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text('Capture & Upload Photo', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Photo Category'),
                items: const [
                  DropdownMenuItem(value: 'Front View', child: Text('Front View')),
                  DropdownMenuItem(value: 'Rear View', child: Text('Rear View')),
                  DropdownMenuItem(value: 'Left Side', child: Text('Left Side')),
                  DropdownMenuItem(value: 'Right Side', child: Text('Right Side')),
                  DropdownMenuItem(value: 'Top View', child: Text('Top View')),
                  DropdownMenuItem(value: 'Bottom View', child: Text('Bottom View')),
                  DropdownMenuItem(value: 'Cargo Close-up', child: Text('Cargo Close-up')),
                  DropdownMenuItem(value: 'Damage Close-up', child: Text('Damage Close-up')),
                  DropdownMenuItem(value: 'Overall View', child: Text('Overall View')),
                  DropdownMenuItem(value: 'Supporting Evidence', child: Text('Supporting Evidence')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _photoCaptionController,
                decoration: const InputDecoration(labelText: 'Photo Caption / Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _photoRemarksController,
                decoration: const InputDecoration(labelText: 'Observations / Remarks for this photo'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final file = await MockMediaPicker.showCamera(context);
                        if (file != null) {
                          setState(() {
                            _photos.add({
                              'category': _selectedCategory,
                              'caption': _photoCaptionController.text.isEmpty ? file.name : _photoCaptionController.text,
                              'remarks': _photoRemarksController.text,
                              'metadata': '10 Jul 2026, 12:45 PM | GPS: 18.9502 N, 72.8258 E | Surveyor: surveyor | Android v13',
                              'isMock': true,
                            });
                            _photoCaptionController.clear();
                            _photoRemarksController.clear();
                          });
                          Navigator.pop(context); // Close the BottomSheet picker modal
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text('Camera', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final file = await MockMediaPicker.showFilePicker(context, allowedExtensions: ['png', 'jpg']);
                        if (file != null) {
                          setState(() {
                            _photos.add({
                              'category': _selectedCategory,
                              'caption': _photoCaptionController.text.isEmpty ? file.name : _photoCaptionController.text,
                              'remarks': _photoRemarksController.text,
                              'metadata': '10 Jul 2026, 12:45 PM | GPS: 18.9502 N, 72.8258 E | Surveyor: surveyor | Android v13',
                              'isMock': true,
                            });
                            _photoCaptionController.clear();
                            _photoRemarksController.clear();
                          });
                          Navigator.pop(context); // Close the BottomSheet picker modal
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan),
                      icon: const Icon(Icons.photo_library, color: Colors.white),
                      label: const Text('Gallery', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsSection(bool isLocked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isLocked) ...[
          OutlinedButton.icon(
            onPressed: () async {
              final file = await MockMediaPicker.showFilePicker(context, allowedExtensions: ['pdf', 'xlsx', 'docx']);
              if (file != null) {
                setState(() {
                  _documents.add({'name': file.name, 'size': file.size});
                });
              }
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Supporting Document'),
          ),
          const SizedBox(height: 12),
        ],
        _documents.isEmpty
            ? const Center(child: Text('No supporting documents uploaded.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _documents.length,
                itemBuilder: (context, index) {
                  final doc = _documents[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                    child: ListTile(
                      leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text(doc['name'] ?? '', style: AppTextStyle.body13Semibold),
                      subtitle: Text(doc['size'] ?? '', style: const TextStyle(fontSize: 10)),
                      trailing: isLocked
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _documents.removeAt(index);
                                });
                              },
                            ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildRemarksSection(bool isLocked) {
    final rep = widget.report;
    final detailsController1 = TextEditingController(text: rep['remarks']);
    final detailsController2 = TextEditingController(text: rep['damageRemarks']);
    final detailsController3 = TextEditingController(text: rep['observations']);
    final detailsController4 = TextEditingController(text: rep['recommendations']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: detailsController1,
          enabled: !isLocked,
          maxLines: 2,
          onChanged: (val) => rep['remarks'] = val,
          decoration: const InputDecoration(labelText: 'General Remarks'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: detailsController2,
          enabled: !isLocked,
          maxLines: 2,
          onChanged: (val) => rep['damageRemarks'] = val,
          decoration: const InputDecoration(labelText: 'Damage Remarks'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: detailsController3,
          enabled: !isLocked,
          maxLines: 2,
          onChanged: (val) => rep['observations'] = val,
          decoration: const InputDecoration(labelText: 'Observation Notes'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: detailsController4,
          enabled: !isLocked,
          maxLines: 2,
          onChanged: (val) => rep['recommendations'] = val,
          decoration: const InputDecoration(labelText: 'Recommendations'),
        ),
      ],
    );
  }

  Widget _buildSignatureSection(bool isLocked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_hasSignature) ...[
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green, width: 2),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.verified, color: Colors.green, size: 36),
                SizedBox(height: 8),
                Text('Signature applied successfully', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (!isLocked)
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _signaturePoints.clear();
                  _hasSignature = false;
                });
              },
              child: const Text('Clear / Replace Signature'),
            ),
        ] else ...[
          CustomSignaturePad(
            onSignatureChanged: (pts) {
              if (pts.isNotEmpty) {
                setState(() {
                  _signaturePoints = pts;
                  _hasSignature = true;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _hasSignature = true;
                widget.report['signaturePath'] = 'mock_path_upload.png';
              });
            },
            icon: const Icon(Icons.file_upload),
            label: const Text('Upload Mock Signature Image'),
          )
        ]
      ],
    );
  }

  Widget _buildTimelineSection(Map<String, dynamic> rep) {
    final list = rep['activities'] as List<dynamic>? ?? [];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final act = list[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Icon(Icons.circle, color: AppColors.primaryBlue, size: 10),
                if (index != list.length - 1)
                  Container(width: 2, height: 36, color: AppColors.border),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(act['title'] ?? '', style: AppTextStyle.body13Semibold),
                  Text(act['desc'] ?? '', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  Text(act['time'] ?? '', style: const TextStyle(fontSize: 8, color: AppColors.textMuted)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

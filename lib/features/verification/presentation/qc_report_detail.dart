import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import '../../../core/widgets/custom_signature_pad.dart';
import 'qc_data_store.dart';

class QCReportDetailScreen extends StatefulWidget {
  final Map<String, dynamic> report;
  final VoidCallback onBack;
  final VoidCallback onStatusChanged;

  const QCReportDetailScreen({
    super.key,
    required this.report,
    required this.onBack,
    required this.onStatusChanged,
  });

  @override
  State<QCReportDetailScreen> createState() => _QCReportDetailScreenState();
}

class _QCReportDetailScreenState extends State<QCReportDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  // Global verification checklists
  late Map<String, bool> _verifiedSections;

  // Photo & Doc verification lists
  late List<Map<String, dynamic>> _photos;
  late List<Map<String, dynamic>> _documents;

  // Remarks Controllers
  late TextEditingController _generalRemarksController;
  late TextEditingController _qcNotesController;

  // Signature state
  List<Offset> _signaturePoints = [];
  bool _hasSignature = false;

  // Collapsible section expansion states
  bool _overviewExpanded = true;
  bool _formExpanded = true;
  bool _checklistExpanded = true;
  bool _photosExpanded = true;
  bool _docsExpanded = false;
  bool _remarksExpanded = false;
  bool _sigExpanded = false;
  bool _timelineExpanded = false;

  @override
  void initState() {
    super.initState();
    final rep = widget.report;
    _verifiedSections = Map<String, bool>.from(rep['verifiedSections'] ?? {});
    _photos = List<Map<String, dynamic>>.from(rep['photos'] ?? []);
    _documents = List<Map<String, dynamic>>.from(rep['documents'] ?? []);
    _generalRemarksController = TextEditingController(text: rep['generalRemarks'] ?? '');
    _qcNotesController = TextEditingController(text: rep['qcNotes'] ?? '');

    _signaturePoints = List<Offset>.from(rep['signature'] ?? []);
    _hasSignature = (rep['signaturePath'] != null && rep['signaturePath'].toString().isNotEmpty) || _signaturePoints.isNotEmpty;
  }

  @override
  void dispose() {
    _generalRemarksController.dispose();
    _qcNotesController.dispose();
    super.dispose();
  }

  void _saveReviewProgress() {
    final rep = widget.report;
    setState(() {
      rep['verifiedSections'] = _verifiedSections;
      rep['photos'] = _photos;
      rep['documents'] = _documents;
      rep['generalRemarks'] = _generalRemarksController.text;
      rep['qcNotes'] = _qcNotesController.text;
      rep['signature'] = _signaturePoints;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review progress saved!'), backgroundColor: Colors.teal),
    );
  }

  void _submitToCompanyAdmin() {
    // Check checklist verification
    final unverified = _verifiedSections.entries.where((e) => !e.value).map((e) => e.key).toList();
    if (unverified.isNotEmpty) {
      _showValidationAlert('Mandatory Checklist sections are unverified:\n${unverified.join(", ")}');
      return;
    }

    // Check photos
    final unverifiedPhotos = _photos.where((p) => !p['isVerified'] && !p['isRejected']).toList();
    if (unverifiedPhotos.isNotEmpty) {
      _showValidationAlert('You have ${unverifiedPhotos.length} photos with pending QC decisions.');
      return;
    }

    // Check signature
    if (!_hasSignature) {
      _showValidationAlert('Digital signature is required to authorize this QC verification.');
      return;
    }

    final rep = widget.report;
    setState(() {
      rep['verifiedSections'] = _verifiedSections;
      rep['photos'] = _photos;
      rep['documents'] = _documents;
      rep['generalRemarks'] = _generalRemarksController.text;
      rep['qcNotes'] = _qcNotesController.text;
      rep['signature'] = _signaturePoints;
      rep['status'] = 'Submitted';
      rep['activities'].add({
        'time': 'Just now',
        'title': 'QC Verified & Submitted',
        'desc': 'Verified by Checked By. Submitted to Company Admin for final approval.'
      });
    });

    QCDataStore.instance.addNotification(
      'QC Verification Complete',
      'Report ${rep['id']} successfully verified and forwarded to Company Admin.'
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Submitted successfully to Company Admin!'), backgroundColor: Colors.green),
    );
    widget.onStatusChanged();
    widget.onBack();
  }

  void _showValidationAlert(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('QC Verification Warning'),
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

  void _showReturnCorrectionDialog() {
    String returnTarget = 'Survey By';
    final correctionController = TextEditingController();
    String correctionPriority = 'High';

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
              Text('Return for Correction', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 16),
              const Text('Route correction request to:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: returnTarget,
                items: const [
                  DropdownMenuItem(value: 'Prepared By', child: Text('Prepared By (Office/Admin)')),
                  DropdownMenuItem(value: 'Survey By', child: Text('Survey By (Field/Photos)')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setSheetState(() {
                      returnTarget = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              const Text('Correction Priority:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: correctionPriority,
                items: const [
                  DropdownMenuItem(value: 'High', child: Text('High')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setSheetState(() {
                      correctionPriority = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              const Text('Correction Instructions:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: correctionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Describe details to modify, missing files, or photo issues...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (correctionController.text.trim().isEmpty) {
                          return;
                        }
                        Navigator.pop(context);
                        _performReturn(returnTarget, correctionController.text, correctionPriority);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Confirm Return', style: TextStyle(color: Colors.white)),
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

  void _performReturn(String target, String notes, String priority) {
    final rep = widget.report;
    setState(() {
      rep['status'] = 'Returned';
      rep['returnReason'] = notes;
      rep['returnTarget'] = target;
      rep['priority'] = priority;
      rep['activities'].add({
        'time': 'Just now',
        'title': 'Returned for Correction',
        'desc': 'Returned to $target. Notes: $notes'
      });
    });

    QCDataStore.instance.addNotification(
      'Report Returned',
      'Report ${rep['id']} has been returned to $target for correction.'
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report successfully returned to $target!'), backgroundColor: Colors.red),
    );
    widget.onStatusChanged();
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final rep = widget.report;
    final isLocked = rep['status'] == 'Submitted' || rep['status'] == 'Verified';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Inline Actions Row replacing AppBar
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
                      onPressed: _saveReviewProgress,
                      child: const Text('Save', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: _showReturnCorrectionDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Return QC', style: TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              // 1. Overview details
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
                    _buildOverviewItem('Prepared By', rep['preparedBy']),
                    _buildOverviewItem('Survey By', rep['surveyBy']),
                    _buildOverviewItem('DueDate', rep['dueDate']),
                    _buildOverviewItem('Instructions', rep['instructions']),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 2. Read-Only Field survey forms completed
              _buildCollapsibleCard(
                title: 'Survey Field Data Verification',
                icon: Icons.assignment_rounded,
                color: Colors.purple,
                isExpanded: _formExpanded,
                onToggle: () => setState(() => _formExpanded = !_formExpanded),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSurveyFieldDisplay('Client Details & Booking Info', 'SB: ${rep['billNo']} | Date: ${rep['billDate']} | Invoice: ${rep['invoiceNo']}'),
                    _buildSurveyFieldDisplay('Container & Weight Info', 'Container: ${rep['containerNo'] ?? "N/A"} | Weight: ${rep['cargoWeight']} T | Tare: ${rep['tareWeight']} T'),
                    _buildSurveyFieldDisplay('Field Observations', rep['obsFieldObservations'] ?? 'No observations entered.'),
                    _buildSurveyFieldDisplay('Lashing & Rigging Checks', rep['obsLashingVerification'] ?? 'No lashing check data.'),
                    _buildSurveyFieldDisplay('Measurements & Cargo Positioning', rep['obsMeasurementVerification'] ?? 'No measurements recorded.'),
                    _buildSurveyFieldDisplay('Additional Surveyor Remarks', rep['obsRemarks'] ?? 'No surveyor remarks.'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 3. Section verification checkboxes
              _buildCollapsibleCard(
                title: 'Section Verification Checklist',
                icon: Icons.fact_check_outlined,
                color: Colors.orange,
                isExpanded: _checklistExpanded,
                onToggle: () => setState(() => _checklistExpanded = !_checklistExpanded),
                child: _buildChecklistSection(isLocked),
              ),
              const SizedBox(height: 12),

              // 4. Photo Verification Gallery
              _buildCollapsibleCard(
                title: 'Photo logs verification (${_photos.length})',
                icon: Icons.camera_alt_outlined,
                color: AppColors.emerald,
                isExpanded: _photosExpanded,
                onToggle: () => setState(() => _photosExpanded = !_photosExpanded),
                child: _buildPhotosQCSection(isLocked),
              ),
              const SizedBox(height: 12),

              // 5. Document Verification
              _buildCollapsibleCard(
                title: 'Document & PDF attachments (${_documents.length})',
                icon: Icons.upload_file,
                color: Colors.teal,
                isExpanded: _docsExpanded,
                onToggle: () => setState(() => _docsExpanded = !_docsExpanded),
                child: _buildDocumentsQCSection(isLocked),
              ),
              const SizedBox(height: 12),

              // 6. Remarks
              _buildCollapsibleCard(
                title: 'QC Remarks & Internal Notes',
                icon: Icons.rate_review_outlined,
                color: Colors.amber.shade800,
                isExpanded: _remarksExpanded,
                onToggle: () => setState(() => _remarksExpanded = !_remarksExpanded),
                child: Column(
                  children: [
                    TextField(
                      controller: _generalRemarksController,
                      enabled: !isLocked,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'General QC Remarks',
                        hintText: 'Add remarks for Company Admin or Client...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _qcNotesController,
                      enabled: !isLocked,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Internal Verification Notes',
                        hintText: 'Add notes for correction loop, records...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 7. Signature Canvas
              _buildCollapsibleCard(
                title: 'QC Reviewer Signature',
                icon: Icons.draw_outlined,
                color: Colors.indigo,
                isExpanded: _sigExpanded,
                onToggle: () => setState(() => _sigExpanded = !_sigExpanded),
                child: _buildSignatureQCSection(isLocked),
              ),
              const SizedBox(height: 12),

              // 8. Activities History Timeline
              _buildCollapsibleCard(
                title: 'Verification Activity Timeline',
                icon: Icons.history,
                color: Colors.grey.shade700,
                isExpanded: _timelineExpanded,
                onToggle: () => setState(() => _timelineExpanded = !_timelineExpanded),
                child: _buildTimelineQCSection(rep),
              ),
              const SizedBox(height: 24),

              // Bottom submit row
              if (!isLocked) ...[
                ElevatedButton.icon(
                  onPressed: _submitToCompanyAdmin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  label: const Text('Forward to Company Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildSurveyFieldDisplay(String section, String data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(section, style: AppTextStyle.body12Medium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
            child: Text(data, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistSection(bool isLocked) {
    return Column(
      children: _verifiedSections.keys.map((key) {
        final verified = _verifiedSections[key] ?? false;
        return CheckboxListTile(
          value: verified,
          enabled: !isLocked,
          activeColor: AppColors.primaryBlue,
          title: Text(key, style: AppTextStyle.body13Semibold),
          subtitle: Text(verified ? 'QC Approved' : 'Review pending', style: TextStyle(fontSize: 10, color: verified ? Colors.green : AppColors.textSecondary)),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _verifiedSections[key] = val;
              });
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildPhotosQCSection(bool isLocked) {
    if (_photos.isEmpty) {
      return const Center(child: Text('No photos uploaded.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)));
    }

    return GridView.builder(
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
        final isApproved = photo['isVerified'] == true;
        final isRejected = photo['isRejected'] == true;

        return GestureDetector(
          onTap: () => _openPhotoInspectDialog(photo, index, isLocked),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isApproved
                    ? Colors.green
                    : isRejected
                        ? Colors.red
                        : AppColors.border,
              ),
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
                            decoration: BoxDecoration(
                              color: isApproved
                                  ? Colors.green
                                  : isRejected
                                      ? Colors.red
                                      : AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isApproved
                                  ? 'APPROVED'
                                  : isRejected
                                      ? 'REJECTED'
                                      : photo['category'],
                              style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
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
                      const SizedBox(height: 2),
                      Text(photo['metadata'] ?? '', style: const TextStyle(fontSize: 7, color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPhotoInspectDialog(Map<String, dynamic> photo, int index, bool isLocked) {
    final remarksController = TextEditingController(text: photo['qcRemarks'] ?? '');
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setPopupState) => AlertDialog(
          title: Text(photo['category']),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 64, color: AppColors.primaryBlue),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Caption: ${photo['caption']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text('Metadata: ${photo['metadata']}', style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                const SizedBox(height: 12),
                if (!isLocked) ...[
                  const Text('QC Remarks / Action Notes:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: remarksController,
                    maxLines: 2,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter photo remarks...'),
                  ),
                ] else ...[
                  Text('QC Remarks: ${photo['qcRemarks'] ?? "None"}', style: const TextStyle(fontSize: 11)),
                ]
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (!isLocked) ...[
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    photo['isVerified'] = false;
                    photo['isRejected'] = true;
                    photo['qcRemarks'] = remarksController.text;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                label: const Text('Reject Photo', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    photo['isVerified'] = true;
                    photo['isRejected'] = false;
                    photo['qcRemarks'] = remarksController.text;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                icon: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                label: const Text('Approve Photo', style: TextStyle(color: Colors.white)),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsQCSection(bool isLocked) {
    if (_documents.isEmpty) {
      return const Center(child: Text('No supporting documents attached.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)));
    }

    return Column(
      children: _documents.map((doc) {
        final isVerified = doc['isVerified'] == true;
        final isRejected = doc['isRejected'] == true;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
          child: ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
            title: Text(doc['name'] ?? '', style: AppTextStyle.body13Semibold),
            subtitle: Text(doc['size'] ?? '', style: const TextStyle(fontSize: 10)),
            trailing: isLocked
                ? _statusBadge(isVerified ? 'Approved' : isRejected ? 'Rejected' : 'Pending')
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check_circle, color: isVerified ? Colors.green : Colors.grey),
                        onPressed: () {
                          setState(() {
                            doc['isVerified'] = true;
                            doc['isRejected'] = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel, color: isRejected ? Colors.red : Colors.grey),
                        onPressed: () {
                          setState(() {
                            doc['isVerified'] = false;
                            doc['isRejected'] = true;
                          });
                        },
                      ),
                    ],
                  ),
          ),
        );
      }).toList(),
    );
  }

  Widget _statusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: text == 'Approved' ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: text == 'Approved' ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSignatureQCSection(bool isLocked) {
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
                Text('QC Authorized Signature applied', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
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
              child: const Text('Clear Signature'),
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
                widget.report['signaturePath'] = 'qc_signature.png';
              });
            },
            icon: const Icon(Icons.file_upload),
            label: const Text('Apply Saved QC Signature'),
          )
        ]
      ],
    );
  }

  Widget _buildTimelineQCSection(Map<String, dynamic> rep) {
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

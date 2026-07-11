import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'report_detail_screens.dart';
import '../../../core/widgets/mock_media_picker.dart';

// ─────────────────────────────────────────────
//  Container Damage Survey Screen
// ─────────────────────────────────────────────
class ContainerDamageScreen extends StatefulWidget {
  final String initialView;
  const ContainerDamageScreen({super.key, this.initialView = 'list'});

  @override
  State<ContainerDamageScreen> createState() => _ContainerDamageScreenState();
}

class _ContainerDamageScreenState extends State<ContainerDamageScreen> {
  late String _currentView;
  Map<String, dynamic>? _selectedReport;
  String _selectedStatus = 'All Reports';
  String _searchQuery = '';
  int _activeStep = 0;
  final _formKey = GlobalKey<FormState>();

  // ── Sample Reports ──────────────────────────
  final List<Map<String, dynamic>> _reports = [
    {
      // ── Identity
      'id': 'MSR-CDR-8812',
      'title': 'Container Damage Survey',
      'date': '19 May 2024',
      'status': 'Draft',
      'color': Colors.orange,
      // ── Step 1: Container Details
      'containerNo': 'EMCU 889922-1',
      'prefix': 'EMCU',
      'serialNo': '889922-1',
      'containerType': '40HC',
      // ── Step 1: Applicant & Inspection Details
      'applicant': 'Apex Cargo Agents',
      'bookingNo': 'BKG-77221',
      'leasingCompany': 'Triton Container Partners',
      'inspector': 'Rahul Sharma (Senior Inspector)',
      'location': 'JNPT Gate 3, Mumbai',
      'inspectDateTime': '19/05/2024',
      // ── Step 2: Damage Inspection
      'leftDamage': 'Dent 15cm x 10cm at mid-panel, surface rust visible.',
      'rightDamage': '',
      'frontDamage': 'Corner casting slightly bent, no structural failure.',
      'rearDamage': 'Door seal worn, minor paint chipping.',
      'roofDamage': '',
      'underDamage': 'Crossmember minor crack near right forklift pocket.',
      'interiorDamage': 'Plywood floor warped near front-left corner.',
      'cscDetails': 'CSC Plate: CSC-8912A | Next exam: Dec 2025',
      'containerStatus': 'Repairable — Class 2 Damage',
      'generalRemarks': 'Recommend repair before next voyage. Priority lane inspection required.',
      // ── Step 3: Photos
      'photoCount': 6,
      // ── Step 4: Assignment
      'surveyBy': 'Vikram Nair (Inspector)',
      'checkedBy': 'Priya Menon (Quality Lead)',
      'priority': 'High',
      'dueDate': '22/05/2024',
      'skipSurvey': false,
      'instructions': 'Please capture new photographs of the corner castings.',
      'remarks': 'Re-check corrosion marks on side wall.',
    },
    {
      // ── Identity
      'id': 'MSR-CDR-9012',
      'title': 'Container Damage Survey',
      'date': '21 May 2024',
      'status': 'Assigned to Survey By',
      'color': Colors.blue,
      // ── Step 1: Container Details
      'containerNo': 'MSCU 221100-3',
      'prefix': 'MSCU',
      'serialNo': '221100-3',
      'containerType': '20GP',
      // ── Step 1: Applicant & Inspection Details
      'applicant': 'Global Freight Co.',
      'bookingNo': 'BKG-88110',
      'leasingCompany': 'SeaCastle Container Leasing',
      'inspector': 'Anand Patel (Inspector)',
      'location': 'Chennai Port Terminal 2',
      'inspectDateTime': '21/05/2024',
      // ── Step 2: Damage Inspection
      'leftDamage': '',
      'rightDamage': 'Heavy dent at lower panel, 30cm x 20cm.',
      'frontDamage': '',
      'rearDamage': 'Door gasket completely failed, needs replacement.',
      'roofDamage': 'Hairline crack on roof corner — sealed with epoxy.',
      'underDamage': '',
      'interiorDamage': '',
      'cscDetails': 'CSC Plate: CSC-6621B | Next exam: Mar 2026',
      'containerStatus': 'Repair Required — Class 1 Damage',
      'generalRemarks': 'Cargo transfer recommended before repair.',
      // ── Step 3: Photos
      'photoCount': 4,
      // ── Step 4: Assignment
      'surveyBy': 'Vikram Nair (Inspector)',
      'checkedBy': '',
      'priority': 'Medium',
      'dueDate': '24/05/2024',
      'skipSurvey': false,
      'instructions': 'Photograph all four sides clearly.',
      'remarks': '',
    },
  ];

  // ── Step 1: Container Details (empty for new) ──
  final _containerNoCtrl    = TextEditingController();
  final _prefixCtrl         = TextEditingController();
  final _serialNoCtrl       = TextEditingController();
  String _containerType     = '40HC';

  // ── Step 1: Applicant & Inspection ──────────
  final _applicantCtrl      = TextEditingController();
  final _bookingNoCtrl      = TextEditingController();
  String? _leasingCompany;
  String? _inspectorName;
  String? _inspectionLocation;
  DateTime? _inspectDateTime;

  // ── Step 2: Damage Sections ─────────────────
  final _leftCtrl      = TextEditingController();
  final _rightCtrl     = TextEditingController();
  final _frontCtrl     = TextEditingController();
  final _rearCtrl      = TextEditingController();
  final _roofCtrl      = TextEditingController();
  final _underCtrl     = TextEditingController();
  final _interiorCtrl  = TextEditingController();
  final _cscCtrl       = TextEditingController();
  String _containerStatus = 'Excellent';
  final _generalRemarksCtrl = TextEditingController();

  // ── Step 3: Photos ───────────────────────────
  final List<Map<String, dynamic>> _photos = [];
  String _damageCategory = 'Side Panel';
  final _captionCtrl = TextEditingController();

  // ── Step 4: Assignment ───────────────────────
  bool _skipSurvey       = false;
  String? _surveyUser;
  String? _checkedUser;
  String _priority       = 'Medium';
  DateTime? _dueDate;
  final _instrCtrl       = TextEditingController();
  final _remarksCtrl     = TextEditingController();

  // ─────────────────────────────────────────────
  final _stepLabels = ['Particulars', 'Inspection', 'Photos', 'Assign'];
  final _stepIcons  = [Icons.description_outlined, Icons.content_paste_search, Icons.camera_alt_outlined, Icons.assignment_ind_outlined];

  void _setView(String view, {Map<String, dynamic>? report}) {
    setState(() {
      _currentView = view;
      _selectedReport = report;
      _activeStep = 0;
      if (view == 'edit' && report != null) _populateForEdit(report);
      if (view == 'create') _clearForm();
    });
  }

  void _clearForm() {
    _containerNoCtrl.clear(); _prefixCtrl.clear(); _serialNoCtrl.clear();
    _containerType = '40HC'; _applicantCtrl.clear(); _bookingNoCtrl.clear();
    _leasingCompany = null; _inspectorName = null; _inspectionLocation = null;
    _inspectDateTime = null; _leftCtrl.clear(); _rightCtrl.clear();
    _frontCtrl.clear(); _rearCtrl.clear(); _roofCtrl.clear();
    _underCtrl.clear(); _interiorCtrl.clear(); _cscCtrl.clear();
    _containerStatus = 'Excellent'; _generalRemarksCtrl.clear();
    _photos.clear(); _skipSurvey = false; _surveyUser = null;
    _checkedUser = null; _priority = 'Medium'; _dueDate = null;
    _instrCtrl.clear(); _remarksCtrl.clear();
  }

  void _populateForEdit(Map<String, dynamic> r) {
    _containerNoCtrl.text = r['containerNo'] ?? '';
    _applicantCtrl.text   = r['applicant'] ?? '';
    _containerType        = r['containerType'] ?? '40HC';
  }

  @override
  void initState() {
    super.initState();
    _currentView = widget.initialView;
  }

  @override
  void dispose() {
    for (var c in [_containerNoCtrl, _prefixCtrl, _serialNoCtrl, _applicantCtrl,
        _bookingNoCtrl, _leftCtrl, _rightCtrl, _frontCtrl, _rearCtrl, _roofCtrl,
        _underCtrl, _interiorCtrl, _cscCtrl, _generalRemarksCtrl, _captionCtrl,
        _instrCtrl, _remarksCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    switch (_currentView) {
      case 'create':
      case 'edit':
        return _buildWizard();
      case 'details':
        return _buildDetails();
      default:
        return _buildList();
    }
  }

  // ══════════════════════════════════════════════
  //   WIZARD SCAFFOLD
  // ══════════════════════════════════════════════
  Widget _buildWizard() {
    final isEdit = _currentView == 'edit';
    final rep = _selectedReport;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildStepBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: _buildStepContent(),
              ),
            ),
            _buildStickyActions(isEdit),
          ],
        ),
      ),
    );
  }

  // ── Step Progress Bar ──────────────────────
  Widget _buildStepBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(_stepLabels.length, (idx) {
          final isActive = _activeStep == idx;
          final isDone   = _activeStep > idx;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: isDone ? () => setState(() => _activeStep = idx) : null,
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? AppColors.primaryBlue
                                : isDone
                                    ? AppColors.emerald
                                    : AppColors.surface,
                            border: isActive ? Border.all(color: AppColors.primaryBlue, width: 2) : null,
                          ),
                          child: Center(
                            child: isDone
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                : Icon(_stepIcons[idx],
                                    size: 16,
                                    color: isActive ? Colors.white : AppColors.textMuted),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _stepLabels[idx],
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            color: isActive ? AppColors.primaryBlue : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (idx < _stepLabels.length - 1)
                  Container(
                    width: 20,
                    height: 2,
                    color: isDone ? AppColors.emerald : AppColors.border,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Sticky Bottom Buttons ─────────────────
  Widget _buildStickyActions(bool isEdit) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          if (_activeStep > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () => setState(() => _activeStep--),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48), side: const BorderSide(color: AppColors.border)),
                child: const Text('Back'),
              ),
            ),
          if (_activeStep > 0) const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () => _saveDraft(isEdit),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 48),
                foregroundColor: AppColors.orange,
                side: BorderSide(color: AppColors.orange.withValues(alpha: 0.4)),
              ),
              child: const Text('Save Draft'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => _handleNextOrSubmit(isEdit),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 48),
                backgroundColor: _activeStep == 3 ? AppColors.emerald : AppColors.primaryBlue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_activeStep == 3 ? 'Submit Report' : 'Next Step',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
                  Icon(_activeStep == 3 ? Icons.check_circle_outline_rounded : Icons.arrow_forward_rounded,
                      color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveDraft(bool isEdit) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: const [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('Draft saved successfully')]),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    _setView('list');
  }

  void _handleNextOrSubmit(bool isEdit) {
    if (_activeStep < 3) {
      setState(() => _activeStep++);
    } else {
      final newId = 'MSR-CDR-${1000 + Random().nextInt(9000)}';
      setState(() {
        if (!isEdit) {
          _reports.insert(0, {
            'id': newId,
            'title': 'Container Damage Survey',
            'applicant': _applicantCtrl.text.isEmpty ? 'Unknown Applicant' : _applicantCtrl.text,
            'containerNo': _containerNoCtrl.text.isEmpty ? 'N/A' : _containerNoCtrl.text,
            'containerType': _containerType,
            'status': _skipSurvey ? 'Assigned to Checked By' : 'Assigned to Survey By',
            'color': _skipSurvey ? AppColors.purple : AppColors.primaryBlue,
            'date': DateTime.now().toString().split(' ')[0],
          });
        } else if (_selectedReport != null) {
          _selectedReport!['applicant']     = _applicantCtrl.text;
          _selectedReport!['containerNo']   = _containerNoCtrl.text;
          _selectedReport!['containerType'] = _containerType;
          _selectedReport!['status']        = _skipSurvey ? 'Assigned to Checked By' : 'Assigned to Survey By';
          _selectedReport!['color']         = _skipSurvey ? AppColors.purple : AppColors.primaryBlue;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 8), Text('Report ${isEdit ? 'updated' : newId} submitted!')]),
          backgroundColor: AppColors.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      _setView('list');
    }
  }

  Widget _buildStepContent() {
    switch (_activeStep) {
      case 0: return _buildStep1();
      case 1: return _buildStep2();
      case 2: return _buildStep3();
      case 3: return _buildStep4();
      default: return const SizedBox();
    }
  }

  // ══════════════════════════════════════════════
  //   STEP 1 – PARTICULARS
  // ══════════════════════════════════════════════
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Container Details', Icons.directions_boat_rounded, AppColors.primaryBlue),
        const SizedBox(height: 12),
        _card(children: [
          _fieldRow(
            _buildField(_containerNoCtrl, 'Container Number', Icons.pin_outlined, required: true),
            null,
          ),
          Row(children: [
            Expanded(child: _buildField(_prefixCtrl, 'Prefix', Icons.format_quote_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildField(_serialNoCtrl, 'Serial No.', Icons.numbers_rounded, required: true)),
          ]),
          _buildDropdownField<String>(
            label: 'Container Type',
            icon: Icons.category_outlined,
            value: _containerType,
            items: ['20GP', '40GP', '40HC', '45HC', '20FR', '40FR', '20OT', '40OT'],
            onChanged: (v) => setState(() => _containerType = v!),
          ),
        ]),
        const SizedBox(height: 16),
        _sectionHeader('Applicant & Inspection Details', Icons.assignment_ind_rounded, AppColors.purple),
        const SizedBox(height: 12),
        _card(children: [
          _buildField(_applicantCtrl, 'Applicant Name', Icons.person_outline_rounded, required: true),
          _buildField(_bookingNoCtrl, 'Booking Number', Icons.bookmark_border_rounded, required: true),
          _buildSearchableDropdown(
            label: 'Leasing Company',
            icon: Icons.business_outlined,
            value: _leasingCompany,
            options: ['Triton Container', 'Texcontainer', 'Beacon Intermodal', 'SeaCastle', 'CAI International'],
            onChanged: (v) => setState(() => _leasingCompany = v),
          ),
          _buildSearchableDropdown(
            label: 'Inspector Name',
            icon: Icons.badge_outlined,
            value: _inspectorName,
            options: ['Sarah Johnson (QA)', 'John Miller (Inspector)', 'Priya Patel (QA)', 'David Chen (Inspector)'],
            onChanged: (v) => setState(() => _inspectorName = v),
          ),
          _buildSearchableDropdown(
            label: 'Inspection Location',
            icon: Icons.location_on_outlined,
            value: _inspectionLocation,
            options: ['Port of Chennai', 'Port of Mumbai', 'JNPT', 'Mundra Port', 'Hazira Port', 'Kandla Port'],
            onChanged: (v) => setState(() => _inspectionLocation = v),
            required: true,
          ),
          _buildDateTimePickerField(
            label: 'Inspection Date & Time',
            icon: Icons.event_rounded,
            value: _inspectDateTime,
            onChanged: (dt) => setState(() => _inspectDateTime = dt),
            required: true,
          ),
        ]),
      ],
    );
  }

  // ══════════════════════════════════════════════
  //   STEP 2 – INSPECTION / DAMAGE
  // ══════════════════════════════════════════════
  Widget _buildStep2() {
    final damageParts = [
      {'label': 'Left Side', 'ctrl': _leftCtrl, 'icon': Icons.arrow_back_rounded, 'color': Colors.blue},
      {'label': 'Right Side', 'ctrl': _rightCtrl, 'icon': Icons.arrow_forward_rounded, 'color': Colors.indigo},
      {'label': 'Front Panel', 'ctrl': _frontCtrl, 'icon': Icons.north_rounded, 'color': Colors.teal},
      {'label': 'Rear Panel', 'ctrl': _rearCtrl, 'icon': Icons.south_rounded, 'color': Colors.cyan},
      {'label': 'Roof / Top', 'ctrl': _roofCtrl, 'icon': Icons.roofing_rounded, 'color': Colors.orange},
      {'label': 'Under Structure', 'ctrl': _underCtrl, 'icon': Icons.horizontal_split_rounded, 'color': Colors.brown},
      {'label': 'Interior', 'ctrl': _interiorCtrl, 'icon': Icons.door_sliding_outlined, 'color': Colors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Damage Inspection', Icons.content_paste_search_outlined, AppColors.orange),
        const SizedBox(height: 6),
        Text('Tap each section to expand and enter damage notes.',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 12),
        ...damageParts.map((part) => _buildExpandableDamage(
          part['label'] as String,
          part['ctrl'] as TextEditingController,
          part['icon'] as IconData,
          part['color'] as Color,
        )),
        const SizedBox(height: 12),
        _sectionHeader('CSC & Container Status', Icons.verified_outlined, AppColors.emerald),
        const SizedBox(height: 12),
        _card(children: [
          _buildField(_cscCtrl, 'CSC Plate Details', Icons.fact_check_outlined, maxLines: 2, hint: 'e.g. Plate No. / CSC valid date...'),
          _buildDropdownField<String>(
            label: 'Container Status',
            icon: Icons.traffic_outlined,
            value: _containerStatus,
            items: ['Excellent', 'Good', 'Fair', 'Damaged', 'Repair Required', 'Out of Service'],
            onChanged: (v) => setState(() => _containerStatus = v!),
            required: true,
            itemColors: [Colors.green, Colors.teal, Colors.orange, Colors.red, Colors.deepOrange, Colors.grey],
          ),
          _buildField(_generalRemarksCtrl, 'General Remarks', Icons.notes_rounded, maxLines: 3, hint: 'Summarize overall container condition...'),
        ]),
      ],
    );
  }

  Widget _buildExpandableDamage(String label, TextEditingController ctrl, IconData icon, Color color) {
    final hasText = ctrl.text.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hasText ? color.withValues(alpha: 0.4) : AppColors.border),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 16),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(
          hasText ? ctrl.text : 'Tap to log damage details',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10, color: hasText ? AppColors.textSecondary : AppColors.textMuted, fontStyle: hasText ? FontStyle.normal : FontStyle.italic),
        ),
        trailing: hasText
            ? Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle))
            : const Icon(Icons.expand_more, size: 18),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        children: [
          TextFormField(
            controller: ctrl,
            maxLines: 4,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Describe $label condition in detail...',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════
  //   STEP 3 – PHOTOS
  // ══════════════════════════════════════════════
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Photo Documentation', Icons.camera_alt_rounded, AppColors.cyan),
        const SizedBox(height: 8),
        Text('Capture or select photos. Tap a photo to add caption.',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 16),

        // Camera / Gallery buttons
        Row(children: [
          Expanded(
            child: _bigActionButton(
              label: 'Open Camera',
              icon: Icons.camera_alt_rounded,
              color: AppColors.primaryBlue,
              onTap: () async {
                final file = await MockMediaPicker.showCamera(context);
                if (file != null) {
                  setState(() {
                    _photos.insert(0, {
                      'name': file.name,
                      'caption': '',
                      'category': _damageCategory,
                      'lat': 13.0827 + Random().nextDouble() * 0.001,
                      'lng': 80.2707 + Random().nextDouble() * 0.001,
                    });
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _bigActionButton(
              label: 'Choose Gallery',
              icon: Icons.photo_library_rounded,
              color: AppColors.purple,
              onTap: () async {
                final file = await MockMediaPicker.showFilePicker(context, allowedExtensions: ['png', 'jpg']);
                if (file != null) {
                  setState(() {
                    _photos.insert(0, {
                      'name': file.name,
                      'caption': '',
                      'category': _damageCategory,
                      'lat': 0.0,
                      'lng': 0.0,
                    });
                  });
                }
              },
            ),
          ),
        ]),
        const SizedBox(height: 16),

        // Category selector
        _card(children: [
          _buildDropdownField<String>(
            label: 'Default Photo Category',
            icon: Icons.label_outline_rounded,
            value: _damageCategory,
            items: ['Side Panel', 'Roof Panel', 'Front View', 'Rear View', 'Left Side', 'Right Side',
              'Door', 'Floor', 'Interior', 'Corner Post', 'Corner Casting', 'CSC Plate',
              'Container Number', 'Damage Close-up', 'Under Frame', 'Locking Rod', 'Other'],
            onChanged: (v) => setState(() => _damageCategory = v!),
          ),
        ]),
        const SizedBox(height: 16),

        // Photo grid
        if (_photos.isEmpty)
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.textMuted),
                const SizedBox(height: 8),
                Text('No photos yet — tap Camera or Gallery above', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.78,
            ),
            itemCount: _photos.length,
            itemBuilder: (ctx, i) {
              final p = _photos[i];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: Center(child: Icon(Icons.image_outlined, color: AppColors.textMuted, size: 36)),
                          ),
                          Positioned(
                            top: 6, right: 6,
                            child: Row(
                              children: [
                                _iconCircle(Icons.autorenew_rounded, Colors.orange, () {}),
                                const SizedBox(width: 4),
                                _iconCircle(Icons.delete_outline_rounded, Colors.red,
                                    () => setState(() => _photos.removeAt(i))),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 6, left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(p['category'], style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        onChanged: (v) => p['caption'] = v,
                        decoration: InputDecoration(
                          hintText: 'Add caption…',
                          hintStyle: const TextStyle(fontSize: 10),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
                        ),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _bigActionButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _iconCircle(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.85), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 12),
      ),
    );
  }

  // ══════════════════════════════════════════════
  //   STEP 4 – ASSIGNMENT (with report context)
  // ══════════════════════════════════════════════
  Widget _buildStep4() {
    // Build container info from what user entered in Step 1
    final containerNo   = _containerNoCtrl.text.isNotEmpty ? _containerNoCtrl.text : 'Not specified';
    final applicantName = _applicantCtrl.text.isNotEmpty  ? _applicantCtrl.text  : 'Not specified';
    final bookingNo     = _bookingNoCtrl.text.isNotEmpty   ? _bookingNoCtrl.text  : 'Not specified';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Report Context Banner ─────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.blueCyanGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.info_outline_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                const Text('Assigning This Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ]),
              const SizedBox(height: 10),
              _contextRow(Icons.pin_outlined, 'Container No.', containerNo),
              _contextRow(Icons.person_outline_rounded, 'Applicant', applicantName),
              _contextRow(Icons.bookmark_border_rounded, 'Booking No.', bookingNo),
              _contextRow(Icons.category_outlined, 'Type', _containerType),
              if (_inspectionLocation != null)
                _contextRow(Icons.location_on_outlined, 'Location', _inspectionLocation!),
              _contextRow(Icons.camera_alt_outlined, 'Photos', '${_photos.length} captured'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Assignment Options ────────────────────
        _sectionHeader('Workflow Assignment', Icons.assignment_ind_outlined, AppColors.primaryBlue),
        const SizedBox(height: 12),
        _card(children: [
          // Skip Survey Toggle with clear explanation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              color: _skipSurvey ? AppColors.emerald.withValues(alpha: 0.06) : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (_skipSurvey ? AppColors.emerald : AppColors.textMuted).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _skipSurvey ? Icons.fast_forward_rounded : Icons.search_rounded,
                    color: _skipSurvey ? AppColors.emerald : AppColors.textMuted,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _skipSurvey ? 'Direct to Checked By' : 'Assign Survey First',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: _skipSurvey ? AppColors.emerald : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _skipSurvey
                            ? 'No field survey — report goes directly to auditor'
                            : 'Field surveyor will inspect first, then auditor reviews',
                        style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _skipSurvey,
                  onChanged: (v) => setState(() => _skipSurvey = v),
                  activeThumbColor: AppColors.emerald,
                  activeTrackColor: AppColors.emerald.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Survey By / Checked By
          if (!_skipSurvey) ...[
            _buildSearchableDropdown(
              label: 'Assign Survey By (Surveyor)',
              icon: Icons.engineering_outlined,
              value: _surveyUser,
              options: ['David Lightman (Surveyor)', 'Sarah Connor (Surveyor)', 'Ravi Kumar (Surveyor)'],
              onChanged: (v) => setState(() => _surveyUser = v),
              required: true,
            ),
          ],
          _buildSearchableDropdown(
            label: 'Assign Checked By (Auditor)',
            icon: Icons.fact_check_outlined,
            value: _checkedUser,
            options: ['John Miller (Auditor)', 'Alexander Marin (Auditor)', 'Neha Shah (Auditor)'],
            onChanged: (v) => setState(() => _checkedUser = v),
          ),
        ]),

        const SizedBox(height: 16),
        _sectionHeader('Priority & Schedule', Icons.schedule_rounded, AppColors.orange),
        const SizedBox(height: 12),
        _card(children: [
          _buildDropdownField<String>(
            label: 'Priority',
            icon: Icons.flag_outlined,
            value: _priority,
            items: ['Low', 'Medium', 'High', 'Critical'],
            onChanged: (v) => setState(() => _priority = v!),
            itemColors: [Colors.grey, Colors.orange, Colors.red, Colors.red.shade900],
          ),
          _buildDateTimePickerField(
            label: 'Due Date',
            icon: Icons.calendar_today_outlined,
            value: _dueDate,
            onChanged: (dt) => setState(() => _dueDate = dt),
          ),
          _buildField(_instrCtrl, 'Internal Instructions', Icons.sticky_note_2_outlined, maxLines: 3, hint: 'Notes for the assigned surveyor or auditor...'),
          _buildField(_remarksCtrl, 'Remarks', Icons.notes_rounded, maxLines: 2),
        ]),
      ],
    );
  }

  Widget _contextRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 13),
          const SizedBox(width: 6),
          Text('$label: ', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Flexible(child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════
  //   REPORT LIST
  // ══════════════════════════════════════════════
  Widget _buildList() {
    final statusOptions = ['All Reports', 'Draft', 'Assigned to Survey By', 'Assigned to Checked By'];
    final filtered = _reports.where((r) {
      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          r['id'].toString().toLowerCase().contains(q) ||
          r['applicant'].toString().toLowerCase().contains(q) ||
          r['containerNo'].toString().toLowerCase().contains(q);
      final matchStatus = _selectedStatus == 'All Reports' || r['status'] == _selectedStatus;
      return matchSearch && matchStatus;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _setView('create'),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search by ID, applicant or container…',
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.border)),
              ),
            ),
          ),
          // Status filter chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: statusOptions.map((s) {
                final isSelected = _selectedStatus == s;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(s, style: TextStyle(fontSize: 10, color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary)),
                    selected: isSelected,
                    selectedColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: isSelected ? AppColors.primaryBlue : AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (_) => setState(() => _selectedStatus = s),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.find_in_page_outlined, size: 52, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      Text('No reports found', style: TextStyle(color: AppColors.textMuted)),
                    ]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) => _buildReportCard(filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> rep) {
    final color = rep['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(rep['id'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
              _statusBadge(rep['status'], color),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.directions_boat_outlined, size: 13, color: AppColors.primaryBlue),
              const SizedBox(width: 4),
              Text(rep['containerNo'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryBlue)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6)),
                child: Text(rep['containerType'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              Icon(Icons.person_outline, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(rep['applicant'], style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const Spacer(),
              Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(rep['date'], style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ]),
            const Divider(height: 20),
            Row(children: [
              _actionPill('Details', Icons.visibility_outlined, AppColors.primaryBlue, () => _setView('details', report: rep)),
              const SizedBox(width: 8),
              if (rep['status'] == 'Draft')
                _actionPill('Edit', Icons.edit_outlined, AppColors.orange, () => _setView('edit', report: rep)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _actionPill(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════════
  //   REPORT DETAILS
  // ══════════════════════════════════════════════
  Widget _buildDetails() {
    // Pass the stored report map directly — all fields are now stored in the report
    final rep = _selectedReport ?? {};
    return ContainerDamageDetailScreen(
      report: rep,
      onBack: () => _setView('list'),
      onEdit: rep['status'] == 'Draft' ? () => _setView('edit', report: rep) : null,
    );
  }

  // ══════════════════════════════════════════════
  //   SHARED HELPER WIDGETS
  // ══════════════════════════════════════════════
  Widget _sectionHeader(String title, IconData icon, Color color) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 16),
      ),
      const SizedBox(width: 8),
      Text(title, style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    ]);
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.expand((w) => [w, const SizedBox(height: 12)]).toList()
          ..removeLast(),
      ),
    );
  }

  Widget _fieldRow(Widget left, Widget? right) {
    if (right == null) return left;
    return Row(children: [Expanded(child: left), const SizedBox(width: 12), Expanded(child: right)]);
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
    String? hint,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        labelStyle: const TextStyle(fontSize: 12),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.02),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: maxLines > 1 ? 12 : 12),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    bool required = false,
    List<Color>? itemColors,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      dropdownColor: Colors.white,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
      items: items.asMap().entries.map((e) {
        final color = itemColors != null ? itemColors[e.key % itemColors.length] : AppColors.textPrimary;
        return DropdownMenuItem<T>(
          value: e.value,
          child: Row(children: [
            if (itemColors != null) ...[
              Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
            ],
            Text(e.value.toString(), style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12)),
          ]),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        labelStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.02),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildSearchableDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
    bool required = false,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Colors.white,
      isExpanded: true,
      hint: Text('Select $label', style: const TextStyle(fontSize: 12)),
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
      items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 12)))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        labelStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.02),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildDateTimePickerField({
    required String label,
    required IconData icon,
    required DateTime? value,
    required void Function(DateTime) onChanged,
    bool required = false,
  }) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: value ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2035));
        if (d != null) onChanged(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value != null ? '${value.day}/${value.month}/${value.year}' : (required ? '$label *' : label),
              style: TextStyle(
                fontSize: 13,
                color: value != null ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
        ]),
      ),
    );
  }
}

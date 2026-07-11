import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'report_detail_screens.dart';

class OdcSurveyScreen extends StatefulWidget {
  final String initialView;
  const OdcSurveyScreen({super.key, this.initialView = 'list'});

  @override
  State<OdcSurveyScreen> createState() => _OdcSurveyScreenState();
}

class _OdcSurveyScreenState extends State<OdcSurveyScreen> {
  late String _currentView;
  Map<String, dynamic>? _selectedReport;
  String _selectedStatus = 'All Reports';
  String _searchQuery = '';

  // Wizard Step Control
  int _activeStep = 0;

  // Mock list of reports
  final List<Map<String, dynamic>> _reports = [
    {
      // ── Identity
      'id': 'MSR-ODC-7701',
      'title': 'ODC Survey Report',
      'type': 'ODC Survey',
      'date': '20 May 2024',
      'status': 'Draft',
      'color': Colors.orange,
      // ── Step 1: Container Details
      'containerNo': 'MSKU-998811-0',
      'containerSize': '40FT',
      'containerType': 'FR',
      'tareWeight': 4.5,
      'mgw': 45.0,
      'cscPlate': 'CSC-9091A',
      'acep': 'ACEP-US-991',
      // ── Step 1: Cargo Particulars
      'party': 'Vanguard Logistics',
      'exporter': 'Export-Link India',
      'consignee': 'Global Importers EU',
      'shippingLine': 'Maersk Line',
      'billNo': 'SB-8822910',
      'billDate': '15 May 2024',
      'invoiceNo': 'INV-7711',
      'invoiceDate': '14 May 2024',
      'location': 'JNPT Terminals',
      'description': 'Industrial Boiler Assembly',
      'loadingPort': 'JNPT Port',
      'dischargePort': 'Rotterdam Port',
      // ── Step 2: ODC Observations
      'overLenRear': 12.0,
      'overLenRearCm': 30.48,
      'overHeight': 24.0,
      'overHeightCm': 60.96,
      // ── Step 3: Cargo Dimensions
      'cargoLength': 12.2,
      'cargoWidth': 2.6,
      'cargoHeight': 3.4,
      'cargoGross': 34.5,
      // ── Step 4: Lashing Materials
      'material1': 'Nylon Lashing Belt — 50mm — 10 nos',
      'material2': 'Wire Rope Lashing — 12mm — 8 nos',
      // ── Step 5: Photos
      'photoCount': 2,
      // ── Step 6: Assignment
      'surveyBy': 'David Lightman (Surveyor)',
      'checkedBy': 'John Miller (Auditor)',
      'priority': 'High',
      'dueDate': '25 May 2024',
      'skipSurvey': false,
      'instructions': 'Measure exact clearance heights at the gantry gates.',
      'assignRemarks': 'Required extra careful clearance scan.',
    },
  ];

  // Step 1 Controllers
  final _containerNoController = TextEditingController(text: 'MSKU-998811-0');
  String _containerSize = '40FT';
  String _containerType = 'FR';
  final _tareWeightController = TextEditingController(text: '4.5');
  final _mgwController = TextEditingController(text: '45.0');
  final _cscPlateController = TextEditingController(text: 'CSC-9091A');
  final _acepController = TextEditingController(text: 'ACEP-US-991');
  DateTime _mfgDate = DateTime.now().subtract(const Duration(days: 365 * 2));

  final _partyController = TextEditingController(text: 'Vanguard Logistics');
  final _exporterController = TextEditingController(text: 'Export-Link India');
  final _consigneeController = TextEditingController(text: 'Global Importers EU');
  String _shippingLine = 'Maersk Line';
  final _billNoController = TextEditingController(text: 'SB-8822910');
  DateTime _billDate = DateTime.now();
  final _invoiceNoController = TextEditingController(text: 'INV-7711');
  DateTime _invoiceDate = DateTime.now();
  String _location = 'JNPT Terminals';
  final _descController = TextEditingController(text: 'Industrial Boiler Assembly');
  final _grossWeightController = TextEditingController(text: '34.5');
  final _billQtyController = TextEditingController(text: '1');
  String _loadingPort = 'JNPT Port';
  String _dischargePort = 'Rotterdam Port';

  // Step 2 Observations Details (ObservationModel list)
  final List<Map<String, dynamic>> _observations = [
    {'dimension': 'Cargo Over Length Rear', 'inch': 12.0, 'feet': 1.0, 'centimeter': 30.48},
    {'dimension': 'Cargo Over Height', 'inch': 24.0, 'feet': 2.0, 'centimeter': 60.96},
  ];

  // Step 3 Cargo Dimensions
  final _cargoLengthController = TextEditingController(text: '12.2');
  final _cargoWidthController = TextEditingController(text: '2.6');
  final _cargoHeightController = TextEditingController(text: '3.4');
  final _cargoGrossController = TextEditingController(text: '34.5');

  // Step 4 Lashing Materials
  final List<Map<String, dynamic>> _lashingMaterials = [
    {'materialName': 'Nylon Lashing Belt', 'mm': 50, 'swl': '5.0 Tons', 'loop': 4, 'cross': 2, 'foreAft': 4, 'total': 10},
    {'materialName': 'Wire Rope Lashing', 'mm': 12, 'swl': '8.2 Tons', 'loop': 2, 'cross': 4, 'foreAft': 2, 'total': 8},
  ];

  // Step 5 Photos
  final List<Map<String, dynamic>> _uploadedPhotos = [
    {
      'name': 'odc_front.jpg',
      'caption': 'Front ODC width profile',
      'category': 'ODC Front',
      'lat': 18.9515,
      'lng': 72.8217,
      'time': '11:15 AM'
    }
  ];
  String _photoCategory = 'ODC Front';
  final _photoCaptionController = TextEditingController();

  // Step 6 Assignment
  String _assignSurveyUser = 'David Lightman (Surveyor)';
  bool _skipSurvey = false;
  String _assignCheckedUser = 'John Miller (Auditor)';
  String _priority = 'Medium';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 2));
  final _remarksController = TextEditingController(text: 'Required extra careful clearance scan.');
  final _instructionsController = TextEditingController(text: 'Measure exact clearance heights at the gantry gates.');

  void _setView(String view, {Map<String, dynamic>? report}) {
    setState(() {
      _currentView = view;
      _selectedReport = report;
      _activeStep = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentView = widget.initialView;
  }

  @override
  void dispose() {
    _containerNoController.dispose();
    _tareWeightController.dispose();
    _mgwController.dispose();
    _cscPlateController.dispose();
    _acepController.dispose();
    _partyController.dispose();
    _exporterController.dispose();
    _consigneeController.dispose();
    _billNoController.dispose();
    _invoiceNoController.dispose();
    _descController.dispose();
    _grossWeightController.dispose();
    _billQtyController.dispose();
    _cargoLengthController.dispose();
    _cargoWidthController.dispose();
    _cargoHeightController.dispose();
    _cargoGrossController.dispose();
    _photoCaptionController.dispose();
    _remarksController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentView) {
      case 'create':
      case 'edit':
        return _buildWizardForm();
      case 'details':
        return _buildDetails();
      case 'list':
      default:
        return _buildList();
    }
  }

  Widget _buildWizardForm() {
    final isEdit = _currentView == 'edit';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Step progress indicator bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(6, (idx) {
                  final isActive = _activeStep == idx;
                  final isDone = _activeStep > idx;
                  return Row(
                    children: [
                      if (idx > 0)
                        Container(
                          width: 20,
                          height: 2,
                          color: isDone ? AppColors.primaryBlue : Colors.grey.shade300,
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: isActive
                                  ? AppColors.primaryBlue
                                  : (isDone ? Colors.green : Colors.grey.shade300),
                              child: isDone
                                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                                  : Text('${idx + 1}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: isActive || isDone ? Colors.white : Colors.black87,
                                          fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ['Header', 'Observe', 'Dimension', 'Lashing', 'Photos', 'Assign'][idx],
                              style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                  color: isActive ? AppColors.primaryBlue : AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Wizard content scroll container
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(16),
                child: _buildStepContent(),
              ),
            ),
          ),

          // Wizard Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_activeStep > 0)
                  OutlinedButton(onPressed: () => setState(() => _activeStep--), child: const Text('Back'))
                else
                  OutlinedButton(onPressed: () => _setView('list'), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (_activeStep < 5) {
                      setState(() => _activeStep++);
                    } else {
                      // Final Finish Action
                      setState(() {
                        if (isEdit) {
                          _selectedReport!['client'] = _partyController.text;
                        } else {
                          _reports.add({
                            'id': 'MSR-ODC-${1000 + Random().nextInt(1000)}',
                            'title': 'ODC Survey Report',
                            'type': 'ODC Survey',
                            'vessel': 'Maersk Dubai',
                            'client': _partyController.text,
                            'date': '20 May 2024',
                            'status': _skipSurvey ? 'Assigned to Checked By' : 'Assigned to Survey By',
                            'color': _skipSurvey ? Colors.indigo : Colors.blue,
                            'party': _partyController.text,
                          });
                        }
                      });
                      _setView('list');
                    }
                  },
                  child: Text(_activeStep == 5 ? 'Finish & Save' : 'Next Step'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_activeStep) {
      case 0:
        return _buildStep1Particulars();
      case 1:
        return _buildStep2Observations();
      case 2:
        return _buildStep3Dimensions();
      case 3:
        return _buildStep4Lashing();
      case 4:
        return _buildStep5Photos();
      case 5:
      default:
        return _buildStep6Assignment();
    }
  }

  // --- STEP 1: PARTICULARS ---
  Widget _buildStep1Particulars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 1 – Particulars', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        Text('Section 1 – Container Details', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _containerNoController, decoration: const InputDecoration(labelText: 'Container Number*')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _containerSize,
                dropdownColor: Colors.white,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                items: const [
                  DropdownMenuItem(value: '20FT', child: Text('20FT', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: '40FT', child: Text('40FT', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: '45FT', child: Text('45FT', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: '48FT', child: Text('48FT', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: '53FT', child: Text('53FT', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) => setState(() => _containerSize = val!),
                decoration: InputDecoration(
                  labelText: 'Container Size*',
                  labelStyle: const TextStyle(fontSize: 12),
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.02),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _containerType,
                dropdownColor: Colors.white,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                items: const [
                  DropdownMenuItem(value: 'HC', child: Text('HC', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'GP', child: Text('GP', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'FR', child: Text('FR (Flat Rack)', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'OT', child: Text('OT (Open Top)', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'RF', child: Text('RF', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'TK', child: Text('TK', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) => setState(() => _containerType = val!),
                decoration: InputDecoration(
                  labelText: 'Container Type*',
                  labelStyle: const TextStyle(fontSize: 12),
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.02),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(controller: _tareWeightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Tare Weight (Double)')),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _mgwController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'MGW (Double)')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(controller: _cscPlateController, decoration: const InputDecoration(labelText: 'CSC Plate Details')),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(controller: _acepController, decoration: const InputDecoration(labelText: 'ACEP Number')),
        const Divider(height: 24),
        Text('Section 2 – Cargo Particulars', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 12),
        TextFormField(controller: _partyController, decoration: const InputDecoration(labelText: 'Party Name*')),
        const SizedBox(height: 12),
        TextFormField(controller: _exporterController, decoration: const InputDecoration(labelText: 'Exporter Name')),
        const SizedBox(height: 12),
        TextFormField(controller: _consigneeController, decoration: const InputDecoration(labelText: 'Consignee Name')),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _shippingLine,
                dropdownColor: Colors.white,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                items: const [
                  DropdownMenuItem(value: 'Maersk Line', child: Text('Maersk Line', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'MSC', child: Text('MSC', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'CMA CGM', child: Text('CMA CGM', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) => setState(() => _shippingLine = val!),
                decoration: InputDecoration(
                  labelText: 'Shipping Line',
                  labelStyle: const TextStyle(fontSize: 12),
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.02),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(controller: _billNoController, decoration: const InputDecoration(labelText: 'Shipping Bill Number*')),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(controller: _descController, maxLines: 2, decoration: const InputDecoration(labelText: 'Description of Cargo*')),
      ],
    );
  }

  // --- STEP 2: OBSERVATIONS ---
  Widget _buildStep2Observations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 2 – Observation Details', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _observations.length,
          itemBuilder: (context, index) {
            final obs = _observations[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(obs['dimension'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Inches: ${obs['inch']} in'),
                  Text('Feet: ${obs['feet']} ft'),
                  Text('Centimeters: ${obs['centimeter']} cm'),
                ],
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _observations.add({'dimension': 'Cargo Over Width Left', 'inch': 10.0, 'feet': 0.83, 'centimeter': 25.4});
            });
          },
          child: const Text('Add Observation'),
        ),
      ],
    );
  }

  // --- STEP 3: CARGO DIMENSIONS ---
  Widget _buildStep3Dimensions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 3 – Cargo Dimensions', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        TextFormField(controller: _cargoLengthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Length (Double)*')),
        const SizedBox(height: 12),
        TextFormField(controller: _cargoWidthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Width (Double)*')),
        const SizedBox(height: 12),
        TextFormField(controller: _cargoHeightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Height (Double)*')),
        const SizedBox(height: 12),
        TextFormField(controller: _cargoGrossController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gross Weight (Double)*')),
      ],
    );
  }

  // --- STEP 4: LASHING MATERIALS ---
  Widget _buildStep4Lashing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 4 – Lashing Materials', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _lashingMaterials.length,
          itemBuilder: (context, index) {
            final mat = _lashingMaterials[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ExpansionTile(
                title: Text(mat['materialName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('Diameter: ${mat['mm']} mm | SWL: ${mat['swl']}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildMatValueRow('Loop count', mat['loop'].toString()),
                        _buildMatValueRow('Cross count', mat['cross'].toString()),
                        _buildMatValueRow('Fore/Aft count', mat['foreAft'].toString()),
                        _buildMatValueRow('Total count', mat['total'].toString()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _lashingMaterials.add({'materialName': 'Ratchet Machine', 'mm': 0, 'swl': '4.2 Tons', 'loop': 6, 'cross': 4, 'foreAft': 4, 'total': 14});
            });
          },
          child: const Text('Add Material Entry'),
        ),
      ],
    );
  }

  Widget _buildMatValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- STEP 5: PHOTO UPLOAD ---
  Widget _buildStep5Photos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 5 – Photo Upload', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _uploadedPhotos.length,
          itemBuilder: (context, index) {
            final photo = _uploadedPhotos[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Row(
                children: [
                  const Icon(Icons.photo_library_outlined, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(photo['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Category: ${photo['category']} | Caption: ${photo['caption']}', style: const TextStyle(fontSize: 10)),
                        Text('Geolocation: (${photo['lat']}, ${photo['lng']})', style: const TextStyle(fontSize: 9)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(height: 24),
        DropdownButtonFormField<String>(
          value: _photoCategory,
          dropdownColor: Colors.white,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
          items: const [
            DropdownMenuItem(value: 'ODC Front', child: Text('ODC Front', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'ODC Rear', child: Text('ODC Rear', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'Lashing', child: Text('Lashing', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'Seal', child: Text('Seal', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'Other', child: Text('Other', style: TextStyle(fontSize: 12))),
          ],
          onChanged: (val) => setState(() => _photoCategory = val!),
          decoration: InputDecoration(
            labelText: 'Photo Category',
            labelStyle: const TextStyle(fontSize: 12),
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.02),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(controller: _photoCaptionController, decoration: const InputDecoration(labelText: 'Photo Caption')),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (_photoCaptionController.text.isNotEmpty) {
              setState(() {
                _uploadedPhotos.add({
                  'name': 'odc_ins_capture.jpg',
                  'caption': _photoCaptionController.text,
                  'category': _photoCategory,
                  'lat': 18.9517,
                  'lng': 72.8219,
                  'time': '11:25 AM'
                });
                _photoCaptionController.clear();
              });
            }
          },
          child: const Text('Capture photo & save metadata'),
        ),
      ],
    );
  }

  // --- STEP 6: ASSIGNMENT ---
  Widget _buildStep6Assignment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 6 – Assignment', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Skip Survey (Direct Submit to Checked By)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          value: _skipSurvey,
          onChanged: (val) => setState(() => _skipSurvey = val),
        ),
        const SizedBox(height: 12),
        if (!_skipSurvey)
          DropdownButtonFormField<String>(
            value: _assignSurveyUser,
            dropdownColor: Colors.white,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
            items: const [
              DropdownMenuItem(value: 'David Lightman (Surveyor)', child: Text('David Lightman (Surveyor)', style: TextStyle(fontSize: 12))),
              DropdownMenuItem(value: 'Sarah Connor (Surveyor)', child: Text('Sarah Connor (Surveyor)', style: TextStyle(fontSize: 12))),
            ],
            onChanged: (val) => setState(() => _assignSurveyUser = val!),
            decoration: InputDecoration(
              labelText: 'Assign Survey User*',
              labelStyle: const TextStyle(fontSize: 12),
              filled: true,
              fillColor: Colors.grey.withValues(alpha: 0.02),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          )
        else
          DropdownButtonFormField<String>(
            value: _assignCheckedUser,
            dropdownColor: Colors.white,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
            items: const [
              DropdownMenuItem(value: 'John Miller (Auditor)', child: Text('John Miller (Auditor)', style: TextStyle(fontSize: 12))),
              DropdownMenuItem(value: 'Alexander Marin (Auditor)', child: Text('Alexander Marin (Auditor)', style: TextStyle(fontSize: 12))),
            ],
            onChanged: (val) => setState(() => _assignCheckedUser = val!),
            decoration: InputDecoration(
              labelText: 'Assign Checked By*',
              labelStyle: const TextStyle(fontSize: 12),
              filled: true,
              fillColor: Colors.grey.withValues(alpha: 0.02),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _priority,
          dropdownColor: Colors.white,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
          items: const [
            DropdownMenuItem(value: 'Low', child: Text('Low', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'Medium', child: Text('Medium', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'High', child: Text('High', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'Critical', child: Text('Critical', style: TextStyle(fontSize: 12))),
          ],
          onChanged: (val) => setState(() => _priority = val!),
          decoration: InputDecoration(
            labelText: 'Priority*',
            labelStyle: const TextStyle(fontSize: 12),
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.02),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(controller: _remarksController, maxLines: 2, decoration: const InputDecoration(labelText: 'Remarks')),
        const SizedBox(height: 12),
        TextFormField(controller: _instructionsController, maxLines: 2, decoration: const InputDecoration(labelText: 'Internal Instructions')),
      ],
    );
  }

  // --- LIST & DETAILS ---
  Widget _buildList() {
    final filtered = _reports.where((rep) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!rep['id'].toString().toLowerCase().contains(query) &&
            !rep['client'].toString().toLowerCase().contains(query)) {
          return false;
        }
      }
      if (_selectedStatus == 'All Reports') return true;
      return rep['status'] == _selectedStatus;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _setView('create'),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search ODC Survey Reports...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
          ),
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('All Reports'),
                _buildFilterChip('Draft'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final rep = filtered[index];
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
                            child: Text(rep['status'], style: TextStyle(fontSize: 8, color: rep['color'], fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(rep['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                      const SizedBox(height: 4),
                      Text('Party: ${rep['party']} | Container Size: ${rep['containerSize']}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildActionPill('Details', Icons.info_outline, Colors.blue, () => _setView('details', report: rep)),
                              const SizedBox(width: 8),
                              if (rep['status'] == 'Draft')
                                _buildActionPill('Edit', Icons.edit_outlined, Colors.orange, () => _setView('edit', report: rep)),
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

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedStatus == label;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: isSelected,
        selectedColor: AppColors.primaryBlue.withOpacity(0.08),
        labelStyle: TextStyle(color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
        backgroundColor: Colors.white,
        side: BorderSide(color: isSelected ? AppColors.primaryBlue : AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (val) => setState(() => _selectedStatus = label),
      ),
    );
  }

  Widget _buildActionPill(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
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

  Widget _buildDetails() {
    // Pass the stored report map directly — all fields are now stored in the report
    final rep = _selectedReport ?? {};
    return OdcReportDetailScreen(
      report: rep,
      onBack: () => _setView('list'),
      onEdit: rep['status'] == 'Draft' ? () => _setView('edit', report: rep) : null,
    );
  }

  Widget _buildRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

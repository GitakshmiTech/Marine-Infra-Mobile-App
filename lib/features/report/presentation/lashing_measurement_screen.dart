import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'report_detail_screens.dart';
import '../../../core/widgets/mock_media_picker.dart';

class LashingMeasurementScreen extends StatefulWidget {
  final String initialView;
  const LashingMeasurementScreen({super.key, this.initialView = 'list'});

  @override
  State<LashingMeasurementScreen> createState() => _LashingMeasurementScreenState();
}

class _LashingMeasurementScreenState extends State<LashingMeasurementScreen> {
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
      'id': 'MSR-LMS-9011',
      'title': 'Lashing & Measurement Survey',
      'type': 'Lashing & Measurement',
      'date': '20 May 2024',
      'status': 'Draft',
      'color': Colors.orange,
      // ── Step 1: Shipping Bill & Cargo Particulars
      'party': 'Elite Shipping Agency',
      'exporter': 'Global Cargo Corp',
      'consignee': 'Importers Unlimited',
      'shippingLine': 'Maersk Line',
      'billNo': 'SB-992011',
      'billDate': '12 May 2024',
      'invoiceNo': 'INV-2041',
      'invoiceDate': '10 May 2024',
      'location': 'Mumbai Port JNP Terminal',
      'description': 'Machinery parts loaded on flat racks',
      'grossWeight': 42.5,
      'quantity': 14,
      'discharge': 'Rotterdam Port',
      'remarks': 'Required special extra tension lashing belts.',
      // ── Step 2: Container Inspection
      'containerNo': 'MSKU-882910-1',
      'containerSize': '40FT',
      'stuffPkg': 45,
      'cargoWeight': 38.2,
      'tareWeight': 4.3,
      'totalWeight': 42.5,
      'payload': 34.0,
      'acep': 'USA-ACEP-992',
      'csc': 'CSC-89912',
      'condition': 'Excellent',
      'inspRemarks': 'Structural integrity fully sound.',
      // ── Step 3: Dimensions
      'rearLength': '12.0',
      'frontLength': '15.0',
      'rightWidth': '8.0',
      'leftWidth': '8.0',
      'height': '22.0',
      // ── Step 4: Lashing Materials
      'hooks': '12',
      'belts': '24',
      'chains': '8',
      'wireRope': '16',
      'ratchet': '20',
      'blocks': '30',
      'dunnage': '12',
      'shackles': '40',
      'turnbuckles': 'Heavy shackle locks',
      'hclamps': 'Tension checked using pneumatic wrench.',
      // ── Step 5: Photos
      'photoCount': 3,
      'photoCategories': 'Front View, Side Lashing, Top Securing',
      // ── Step 6: Assignment
      'surveyBy': 'David Lightman (Surveyor)',
      'checkedBy': 'John Miller (Auditor)',
      'priority': 'High',
      'dueDate': '25 May 2024',
      'skipSurvey': false,
      'instructions': 'Verify container lashing tension on bay 12.',
      'assignRemarks': 'Report to be reviewed before port clearance.',
    },
  ];

  // Step 1 Controllers
  final _partyController = TextEditingController(text: 'Elite Shipping Agency');
  final _exporterController = TextEditingController(text: 'Global Cargo Corp');
  final _consigneeController = TextEditingController(text: 'Importers Unlimited');
  String _shippingLine = 'Maersk Line';
  final _billNoController = TextEditingController(text: 'SB-992011');
  DateTime _billDate = DateTime.now();
  final _invoiceNoController = TextEditingController(text: 'INV-2041');
  DateTime _invoiceDate = DateTime.now();
  String _location = 'JNP Terminal';
  final _descController = TextEditingController(text: 'Machinery parts loaded on flat racks');
  final _weightController = TextEditingController(text: '42.5');
  final _qtyController = TextEditingController(text: '14');
  String _dischargePort = 'Rotterdam Port';
  final _remarksController = TextEditingController(text: 'Needs extra turnbuckle check.');

  // Step 2 Controllers
  final _containerNoController = TextEditingController(text: 'MSKU-882910-1');
  String _containerSize = '40FT';
  final _stuffPkgController = TextEditingController(text: '45');
  final _cargoWeightController = TextEditingController(text: '38.2');
  final _tareWeightController = TextEditingController(text: '4.3');
  final _totalWeightController = TextEditingController(text: '42.5');
  final _payloadController = TextEditingController(text: '34.0');
  final _acepController = TextEditingController(text: 'USA-ACEP-992');
  final _cscController = TextEditingController(text: 'CSC-89912');
  DateTime _mfgDate = DateTime.now().subtract(const Duration(days: 365 * 3));
  String _containerCondition = 'Excellent';
  final _inspRemarksController = TextEditingController(text: 'Structural integrity fully sound.');

  // Step 3 Dimensions & Dynamic Matrix
  final _rearLengthController = TextEditingController(text: '12.0');
  final _frontLengthController = TextEditingController(text: '15.0');
  final _rightWidthController = TextEditingController(text: '8.0');
  final _leftWidthController = TextEditingController(text: '8.0');
  final _heightController = TextEditingController(text: '22.0');

  final List<Map<String, dynamic>> _dimensionMatrix = [
    {'dimension': 'Over Length Rear', 'value': 20.0, 'unit': 'cm'},
    {'dimension': 'Over Height', 'value': 45.0, 'unit': 'cm'},
  ];

  // Step 4 Lashing
  final _hooksController = TextEditingController(text: '12');
  final _beltsController = TextEditingController(text: '24');
  final _chainsController = TextEditingController(text: '8');
  final _wireRopeController = TextEditingController(text: '16');
  final _ratchetController = TextEditingController(text: '20');
  final _blocksController = TextEditingController(text: '30');
  final _dunnageController = TextEditingController(text: '12');
  final _protectorsController = TextEditingController(text: '40');
  final _otherMaterialController = TextEditingController(text: 'Heavy shackle locks');
  final _lashingRemarksController = TextEditingController(text: 'Tension checked using pneumatic wrench.');

  // Step 5 Photos
  final List<Map<String, dynamic>> _uploadedPhotos = [
    {
      'name': 'front_rack.jpg',
      'url': 'front_rack_mock_url',
      'caption': 'Front view cargo lash securing',
      'category': 'Front View',
      'lat': 18.9512,
      'lng': 72.8214,
      'time': '10:15 AM',
      'size': '2.4 MB'
    },
    {
      'name': 'side_lashing.jpg',
      'url': 'side_lashing_mock_url',
      'caption': 'Right side turnbuckles',
      'category': 'Right Side',
      'lat': 18.9514,
      'lng': 72.8216,
      'time': '10:20 AM',
      'size': '1.8 MB'
    }
  ];
  String _selectedPhotoCategory = 'Front View';
  final _photoCaptionController = TextEditingController();

  // Step 6 Assignment
  String _assignSurveyUser = 'David Lightman (Surveyor)';
  bool _skipSurvey = false;
  String _assignCheckedUser = 'John Miller (Auditor)';
  String _reportPriority = 'Medium';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 2));
  final _instructionsController = TextEditingController(text: 'Verify tension on the bottom corner castings.');

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
    _partyController.dispose();
    _exporterController.dispose();
    _consigneeController.dispose();
    _billNoController.dispose();
    _invoiceNoController.dispose();
    _descController.dispose();
    _weightController.dispose();
    _qtyController.dispose();
    _remarksController.dispose();
    _containerNoController.dispose();
    _stuffPkgController.dispose();
    _cargoWeightController.dispose();
    _tareWeightController.dispose();
    _totalWeightController.dispose();
    _payloadController.dispose();
    _acepController.dispose();
    _cscController.dispose();
    _inspRemarksController.dispose();
    _rearLengthController.dispose();
    _frontLengthController.dispose();
    _rightWidthController.dispose();
    _leftWidthController.dispose();
    _heightController.dispose();
    _hooksController.dispose();
    _beltsController.dispose();
    _chainsController.dispose();
    _wireRopeController.dispose();
    _ratchetController.dispose();
    _blocksController.dispose();
    _dunnageController.dispose();
    _protectorsController.dispose();
    _otherMaterialController.dispose();
    _lashingRemarksController.dispose();
    _photoCaptionController.dispose();
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

  // --- WIZARD FORM BUILDER ---
  Widget _buildWizardForm() {
    final isEdit = _currentView == 'edit';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Visual Step Indicator
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
                              ['Header', 'Inspect', 'Dimension', 'Lashing', 'Photos', 'Assign'][idx],
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

          // Main Wizard Body
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

          // Next/Prev Buttons
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_activeStep > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => _activeStep--),
                    child: const Text('Back'),
                  )
                else
                  OutlinedButton(
                    onPressed: () => _setView('list'),
                    child: const Text('Cancel'),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_activeStep < 5) {
                      setState(() => _activeStep++);
                    } else {
                      // Submit Wizard Flow
                      setState(() {
                        if (isEdit) {
                          _selectedReport!['client'] = _partyController.text;
                        } else {
                          _reports.add({
                            'id': 'MSR-LMS-${1000 + Random().nextInt(1000)}',
                            'title': 'Lashing & Measurement Survey',
                            'type': 'Lashing & Measurement',
                            'vessel': 'Oceanic Star',
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
        return _buildStep1Header();
      case 1:
        return _buildStep2Inspection();
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

  // --- STEP 1: SHIPPING BILL PARTICULARS ---
  Widget _buildStep1Header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 1 – Shipping Bill / Particulars', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        TextFormField(controller: _partyController, decoration: const InputDecoration(labelText: 'Party*')),
        const SizedBox(height: 20),
        TextFormField(controller: _exporterController, decoration: const InputDecoration(labelText: 'Exporter*')),
        const SizedBox(height: 20),
        TextFormField(controller: _consigneeController, decoration: const InputDecoration(labelText: 'Consignee*')),
        const SizedBox(height: 20),
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
                decoration: const InputDecoration(
                  labelText: 'Shipping Line*',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _billNoController,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Shipping Bill Number*',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final dt = await showDatePicker(context: context, initialDate: _billDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
                  if (dt != null) setState(() => _billDate = dt);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Shipping Bill Date',
                      hintText: '${_billDate.toLocal().toString().split(' ')[0]}',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(controller: _invoiceNoController, decoration: const InputDecoration(labelText: 'Invoice Number*')),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Gross Weight (Double)*')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(controller: _qtyController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Shipping Quantity (Int)*')),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(controller: _remarksController, maxLines: 2, decoration: const InputDecoration(labelText: 'Remarks')),
      ],
    );
  }

  // --- STEP 2: CONTAINER INSPECTION ---
  Widget _buildStep2Inspection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 2 – Inspection Report', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _containerNoController, decoration: const InputDecoration(labelText: 'Container Number*')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _containerSize,
                dropdownColor: Colors.white,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                items: const [
                  DropdownMenuItem(value: '20FT', child: Text('20FT', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: '40FT', child: Text('40FT', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: '45FT', child: Text('45FT', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) => setState(() => _containerSize = val!),
                decoration: const InputDecoration(
                  labelText: 'Container Size*',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _stuffPkgController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stuff Packages (Int)*')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(controller: _cargoWeightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Cargo Gross Weight*')),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _tareWeightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Container Tare Weight*')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(controller: _totalWeightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Weight*')),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _payloadController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Payload Capacity*')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _containerCondition,
                dropdownColor: Colors.white,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                items: const [
                  DropdownMenuItem(value: 'Excellent', child: Text('Excellent', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'Good', child: Text('Good', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'Damaged', child: Text('Damaged', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) => setState(() => _containerCondition = val!),
                decoration: const InputDecoration(
                  labelText: 'Container Condition*',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _acepController, decoration: const InputDecoration(labelText: 'Container ACEP')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(controller: _cscController, decoration: const InputDecoration(labelText: 'Container CSC Number')),
            ),
          ],
        ),
      ],
    );
  }

  // --- STEP 3: OVER DIMENSIONS ---
  Widget _buildStep3Dimensions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 3 – Over Dimension', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _rearLengthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Over Length Rear (Double)')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(controller: _frontLengthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Over Length Front (Double)')),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(controller: _heightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Over Height (Double)')),
        const SizedBox(height: 16),
        Text('Dimension Matrix (Dynamic List)', style: AppTextStyle.body12Regular.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _dimensionMatrix.length,
          itemBuilder: (context, index) {
            final row = _dimensionMatrix[index];
            final val = row['value'] as double;
            // Unit Conversions
            double mm = val * 10;
            double inches = val / 2.54;
            double meters = val / 100;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(row['dimension'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.pink, size: 18),
                        onPressed: () => setState(() => _dimensionMatrix.removeAt(index)),
                      ),
                    ],
                  ),
                  Text('Input Value: ${row['value']} ${row['unit']}'),
                  const SizedBox(height: 4),
                  Text('Auto Calculated Conversions:', style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                  Text('Millimeters: ${mm.toStringAsFixed(1)} mm | Inches: ${inches.toStringAsFixed(1)} in | Meters: ${meters.toStringAsFixed(2)} m', style: const TextStyle(fontSize: 9)),
                ],
              ),
            );
          },
        ),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _dimensionMatrix.add({'dimension': 'Over Width Right', 'value': 15.0, 'unit': 'cm'});
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Measurement'),
        ),
      ],
    );
  }

  // --- STEP 4: LASHING DETAILS ---
  Widget _buildStep4Lashing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 4 – Lashing Details', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _hooksController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Hooks (Int)')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(controller: _beltsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Nylon Belts (Int)')),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _chainsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Chains (Int)')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(controller: _ratchetController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Ratchet (Int)')),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(controller: _blocksController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Wooden Blocks (Int)')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(controller: _dunnageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Dunnage (Int)')),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(controller: _otherMaterialController, maxLines: 2, decoration: const InputDecoration(labelText: 'Other Lashing Material')),
      ],
    );
  }

  // --- STEP 5: PHOTO UPLOADS WITH METADATA ---
  Widget _buildStep5Photos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 5 – Photo Upload with Metadata', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
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
                  const Icon(Icons.image, color: Colors.blue, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(photo['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Category: ${photo['category']} | Caption: ${photo['caption']}', style: const TextStyle(fontSize: 10)),
                        Text('Geolocation: (${photo['lat']}, ${photo['lng']}) | Uploaded By: Sarah Johnson', style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.pink),
                    onPressed: () => setState(() => _uploadedPhotos.removeAt(index)),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(height: 24),
        DropdownButtonFormField<String>(
          value: _selectedPhotoCategory,
          dropdownColor: Colors.white,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
          items: const [
            DropdownMenuItem(value: 'Front View', child: Text('Front View', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'Rear View', child: Text('Rear View', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'Cargo', child: Text('Cargo', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'Lashing', child: Text('Lashing', style: TextStyle(fontSize: 12))),
          ],
          onChanged: (val) => setState(() => _selectedPhotoCategory = val!),
          decoration: const InputDecoration(
            labelText: 'Photo Category',
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(controller: _photoCaptionController, decoration: const InputDecoration(labelText: 'Photo Caption')),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            if (_photoCaptionController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a caption first!'), behavior: SnackBarBehavior.floating),
              );
              return;
            }
            final file = await MockMediaPicker.showCamera(context);
            if (file != null) {
              setState(() {
                _uploadedPhotos.add({
                  'name': file.name,
                  'url': 'mock_url',
                  'caption': _photoCaptionController.text,
                  'category': _selectedPhotoCategory,
                  'lat': 18.9515,
                  'lng': 72.8217,
                  'time': '10:30 AM',
                  'size': file.size
                });
                _photoCaptionController.clear();
              });
            }
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Capture & Upload Photo'),
        ),
      ],
    );
  }

  // --- STEP 6: WORKFLOW ASSIGNMENT ---
  Widget _buildStep6Assignment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 6 – Assignment', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Skip Survey (Submit Directly to Checked By)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
            decoration: const InputDecoration(
              labelText: 'Assign To Survey By*',
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
            decoration: const InputDecoration(
              labelText: 'Assign Directly Checked By*',
            ),
          ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _reportPriority,
          dropdownColor: Colors.white,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
          items: const [
            DropdownMenuItem(value: 'Low', child: Text('Low', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'Medium', child: Text('Medium', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'High', child: Text('High', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'Critical', child: Text('Critical', style: TextStyle(fontSize: 12))),
          ],
          onChanged: (val) => setState(() => _reportPriority = val!),
          decoration: const InputDecoration(
            labelText: 'Priority*',
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _instructionsController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Internal Instructions'),
        ),
      ],
    );
  }

  // --- LIST VIEW & DETAILS ---
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
      if (_selectedStatus == 'Draft Reports' && rep['status'] == 'Draft') return true;
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
                hintText: 'Search Lashing & Measurement Reports...',
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
                _buildFilterChip('Draft Reports'),
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
                      Text('Party: ${rep['party']} | Exporter: ${rep['exporter']}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
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
    return LashingReportDetailScreen(
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

import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import '../../../core/widgets/custom_signature_pad.dart';

class FinalApprovalScreen extends StatefulWidget {
  const FinalApprovalScreen({super.key});

  @override
  State<FinalApprovalScreen> createState() => _FinalApprovalScreenState();
}

class _FinalApprovalScreenState extends State<FinalApprovalScreen> {
  String _currentView = 'pending_list';
  Map<String, dynamic>? _selectedReport;
  int _currentStep = 0;
  bool _isSignatureVerified = false;

  final List<Map<String, dynamic>> _pendingApprovals = [
    {
      'id': 'REP-9902',
      'vessel': 'MV Ocean Titan',
      'client': 'Cargill Marine Corp',
      'date': '2026-07-09',
      'priority': 'High',
      'surveyor': 'David Lightman'
    },
    {
      'id': 'REP-9915',
      'vessel': 'Sealand Voyager',
      'client': 'Maersk Shipping',
      'date': '2026-07-10',
      'priority': 'Medium',
      'surveyor': 'John Doe'
    }
  ];

  void _startVerification(Map<String, dynamic> report) {
    setState(() {
      _selectedReport = report;
      _currentView = 'verify';
      _currentStep = 0;
      _isSignatureVerified = false;
    });
  }

  void _finishApproval(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report ${action == 'approve' ? 'Approved & Signed' : action == 'return' ? 'Returned' : 'Rejected'}!'),
        backgroundColor: action == 'approve' ? AppColors.emerald : action == 'return' ? AppColors.orange : AppColors.pink,
      ),
    );
    setState(() {
      _currentView = 'pending_list';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentView == 'verify') {
      return _buildVerificationWorkflow();
    }
    return _buildPendingList();
  }

  Widget _buildPendingList() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Awaiting Final Admin Sign-off', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pendingApprovals.length,
              itemBuilder: (context, index) {
                final rep = _pendingApprovals[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 10, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(rep['id'], style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: rep['priority'] == 'High' ? AppColors.pink.withOpacity(0.1) : AppColors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${rep['priority']} Priority',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: rep['priority'] == 'High' ? AppColors.pink : AppColors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('Vessel: ${rep['vessel']}', style: AppTextStyle.body14Regular),
                        Text('Client: ${rep['client']}', style: AppTextStyle.body14Regular),
                        Text('Surveyor: ${rep['surveyor']} | Submitted: ${rep['date']}', style: AppTextStyle.body12Regular),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: AppColors.blueCyanGradient),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () => _startVerification(rep),
                            icon: const Icon(Icons.verified_rounded, size: 18, color: Colors.white),
                            label: const Text('Verify & Sign', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationWorkflow() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Step Progress Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              color: AppColors.cardBg,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepHeader(0, 'Details'),
                const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textSecondary),
                _buildStepHeader(1, 'Checklist'),
                const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textSecondary),
                _buildStepHeader(2, 'Media'),
                const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textSecondary),
                _buildStepHeader(3, 'Sign'),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildActiveStepContent(),
            ),
          ),
          // Navigation Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.cardBg,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.surface, foregroundColor: AppColors.textPrimary, side: const BorderSide(color: AppColors.border)),
                      child: const Text('Back'),
                    ),
                    if (_currentStep < 3)
                      ElevatedButton(
                        onPressed: () => setState(() => _currentStep++),
                        child: const Text('Next Step'),
                      ),
                  ],
                ),
                if (_currentStep == 3) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _finishApproval('return'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
                          child: const Text('Return', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _finishApproval('reject'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
                          child: const Text('Reject', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: _isSignatureVerified ? const LinearGradient(colors: AppColors.blueCyanGradient) : null,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isSignatureVerified ? Colors.transparent : Colors.grey.shade300,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: _isSignatureVerified ? () => _finishApproval('approve') : null,
                            child: const Text('Approve', style: TextStyle(fontSize: 12, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(int index, String title) {
    final isActive = _currentStep == index;
    final isDone = _currentStep > index;
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: isActive ? AppColors.primaryBlue : isDone ? AppColors.emerald : AppColors.border,
          child: isDone
              ? const Icon(Icons.check, size: 10, color: Colors.white)
              : Text('${index + 1}', style: TextStyle(fontSize: 8, color: isActive ? Colors.white : AppColors.textSecondary)),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? AppColors.primaryBlue : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildDetailsStep();
      case 1:
        return _buildChecklistStep();
      case 2:
        return _buildMediaStep();
      case 3:
      default:
        return _buildSignatureStep();
    }
  }

  Widget _buildDetailsStep() {
    final report = _selectedReport ?? {};
    return Container(
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
            Text('Mandatory Fields', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildVerifyRow('Client Name', report['client'] ?? 'Unknown', true),
            _buildVerifyRow('Vessel Name', report['vessel'] ?? 'Unknown', true),
            _buildVerifyRow('Surveyor Name', report['surveyor'] ?? 'Unknown', true),
            _buildVerifyRow('Survey Date', report['date'] ?? 'Unknown', true),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistStep() {
    return Container(
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
            Text('Operational Checklist', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildVerifyRow('Hull integrity', 'Pass', true),
            _buildVerifyRow('Generator output test', 'Pass', true),
            _buildVerifyRow('Emergency pumps speed', 'Pass', true),
            _buildVerifyRow('Anchor windlass systems', 'Fail', false),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaStep() {
    return Container(
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
            Text('Photos & Documentation', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildVerifyRow('Corrosion Photo', 'Attached', true),
            _buildVerifyRow('Propeller Scan', 'Attached', true),
            _buildVerifyRow('Engine Registry PDF', 'Uploaded', true),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
                Text('Apply Digital Signature', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Draw signature below to sign off & lock final PDF report.', style: AppTextStyle.body12Regular),
                const SizedBox(height: 12),
                CustomSignaturePad(
                  onSignatureChanged: (points) {
                    if (points.isNotEmpty && !points.first.isInfinite) {
                      setState(() {
                        _isSignatureVerified = true;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyRow(String label, String value, bool isOk) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(isOk ? Icons.check_circle_rounded : Icons.warning_amber_rounded, color: isOk ? AppColors.emerald : AppColors.orange, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: AppTextStyle.body14Regular)),
          Text(value, style: AppTextStyle.body14Regular.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

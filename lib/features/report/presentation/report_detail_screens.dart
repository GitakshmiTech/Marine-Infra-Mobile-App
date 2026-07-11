import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';

// ═══════════════════════════════════════════════════════════════
//  LASHING & MEASUREMENT SURVEY — FULL DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════
class LashingReportDetailScreen extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback onBack;
  final VoidCallback? onEdit;

  const LashingReportDetailScreen({
    super.key,
    required this.report,
    required this.onBack,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final rep = report;
    final color = rep['color'] as Color? ?? AppColors.primaryBlue;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // extra bottom padding for floating buttons
            child: Column(
              children: [
                // Top Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.blueCyanGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.link_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 6),
                        Text(rep['id'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const Spacer(),
                        _statusPill(rep['status'] ?? '', color),
                      ]),
                      const SizedBox(height: 8),
                      Text(rep['title'] ?? 'Lashing & Measurement Survey',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text('Survey Date: ${rep['date'] ?? ''}',
                          style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Section 1: Shipping Bill Particulars
                _section(
                  title: 'Shipping Bill & Cargo Particulars',
                  icon: Icons.receipt_long_rounded,
                  color: AppColors.primaryBlue,
                  children: [
                    _row('Party', rep['party']),
                    _row('Exporter', rep['exporter']),
                    _row('Consignee', rep['consignee']),
                    _row('Shipping Line', rep['shippingLine']),
                    _row('Shipping Bill No.', rep['billNo']),
                    _row('Shipping Bill Date', rep['billDate']),
                    _row('Invoice No.', rep['invoiceNo']),
                    _row('Invoice Date', rep['invoiceDate']),
                    _row('Survey Location', rep['location']),
                    _row('Cargo Description', rep['description']),
                    _row('Total Gross Weight', rep['grossWeight'] != null ? '${rep['grossWeight']} MT' : null),
                    _row('Shipping Quantity', rep['quantity']?.toString()),
                    _row('Port of Discharge', rep['discharge']),
                    _row('Remarks', rep['remarks']),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 2: Container Inspection
                _section(
                  title: 'Container Inspection',
                  icon: Icons.directions_boat_rounded,
                  color: AppColors.cyan,
                  children: [
                    _row('Container No.', rep['containerNo']),
                    _row('Container Size', rep['containerSize']),
                    _row('Stuff Packages', rep['stuffPkg']?.toString()),
                    _row('Cargo Gross Weight', rep['cargoWeight'] != null ? '${rep['cargoWeight']} MT' : null),
                    _row('Container Tare Weight', rep['tareWeight'] != null ? '${rep['tareWeight']} MT' : null),
                    _row('Total Weight', rep['totalWeight'] != null ? '${rep['totalWeight']} MT' : null),
                    _row('Payload Capacity', rep['payload'] != null ? '${rep['payload']} MT' : null),
                    _row('ACEP Number', rep['acep']),
                    _row('CSC Plate No.', rep['csc']),
                    _row('Container Condition', rep['condition']),
                    _row('Inspection Remarks', rep['inspRemarks']),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 3: Dimensions
                _section(
                  title: 'Cargo Dimensions & Over-Limit Matrix',
                  icon: Icons.straighten_rounded,
                  color: AppColors.purple,
                  children: [
                    _row('Rear Length (cm)', rep['rearLength']?.toString()),
                    _row('Front Length (cm)', rep['frontLength']?.toString()),
                    _row('Right Width (cm)', rep['rightWidth']?.toString()),
                    _row('Left Width (cm)', rep['leftWidth']?.toString()),
                    _row('Height (cm)', rep['height']?.toString()),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 4: Lashing Materials
                _section(
                  title: 'Lashing Materials Used',
                  icon: Icons.link_rounded,
                  color: AppColors.orange,
                  children: [
                    _row('Lashing Hooks', rep['hooks']?.toString()),
                    _row('Lashing Belts', rep['belts']?.toString()),
                    _row('Chains', rep['chains']?.toString()),
                    _row('Wire Ropes', rep['wireRope']?.toString()),
                    _row('Ratchets', rep['ratchet']?.toString()),
                    _row('Blocks / Wedges', rep['blocks']?.toString()),
                    _row('Dunnage', rep['dunnage']?.toString()),
                    _row('Shackles', rep['shackles']?.toString()),
                    _row('Turnbuckles', rep['turnbuckles']?.toString()),
                    _row('H-Clamps', rep['hclamps']?.toString()),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 5: Photos
                _section(
                  title: 'Photo Log',
                  icon: Icons.camera_alt_rounded,
                  color: AppColors.emerald,
                  children: [
                    _row('Total Photos', rep['photoCount']?.toString() ?? '1'),
                    _row('Photo Categories', rep['photoCategories'] ?? 'Front View, Lashing'),
                    _row('Geo-Tagged', 'Yes'),
                    const SizedBox(height: 12),
                    _buildPhotoGrid(context, rep['photos'], AppColors.emerald),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 6: Assignment & Workflow
                _section(
                  title: 'Assignment & Workflow',
                  icon: Icons.assignment_ind_rounded,
                  color: AppColors.pink,
                  children: [
                    _row('Assigned Survey By', rep['surveyBy'] ?? 'Not Assigned'),
                    _row('Assigned Checked By', rep['checkedBy'] ?? 'Not Assigned'),
                    _row('Priority', rep['priority'] ?? 'Medium'),
                    _row('Due Date', rep['dueDate'] ?? '—'),
                    _row('Skip Survey', rep['skipSurvey'] == true ? 'Yes — Direct to Checked By' : 'No'),
                    _row('Instructions', rep['instructions']),
                    _row('Assignment Remarks', rep['assignRemarks']),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: rep['status'] == 'Draft' && onEdit != null
          ? FloatingActionButton(
              heroTag: 'lashing_edit_btn',
              onPressed: onEdit,
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.edit_rounded, color: Colors.white),
            )
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ODC SURVEY — FULL DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════
class OdcReportDetailScreen extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback onBack;
  final VoidCallback? onEdit;

  const OdcReportDetailScreen({
    super.key,
    required this.report,
    required this.onBack,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final rep = report;
    final color = rep['color'] as Color? ?? AppColors.emerald;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // extra bottom padding for floating buttons
            child: Column(
              children: [
                // Top Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.emeraldCyanGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.local_shipping_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 6),
                        Text(rep['id'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const Spacer(),
                        _statusPill(rep['status'] ?? '', color),
                      ]),
                      const SizedBox(height: 8),
                      const Text('ODC Survey Report',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text('Survey Date: ${rep['date'] ?? ''}',
                          style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Section 1: Container Details
                _section(
                  title: 'Container Details',
                  icon: Icons.directions_boat_rounded,
                  color: AppColors.primaryBlue,
                  children: [
                    _row('Container No.', rep['containerNo']),
                    _row('Container Size', rep['containerSize']),
                    _row('Container Type', rep['containerType']),
                    _row('Tare Weight', rep['tareWeight'] != null ? '${rep['tareWeight']} MT' : null),
                    _row('MGW', rep['mgw'] != null ? '${rep['mgw']} MT' : null),
                    _row('CSC Plate No.', rep['cscPlate']),
                    _row('ACEP Number', rep['acep']),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 2: Cargo Particulars
                _section(
                  title: 'Cargo Particulars',
                  icon: Icons.inventory_2_rounded,
                  color: AppColors.cyan,
                  children: [
                    _row('Party Name', rep['party']),
                    _row('Exporter', rep['exporter']),
                    _row('Consignee', rep['consignee']),
                    _row('Shipping Line', rep['shippingLine']),
                    _row('Shipping Bill No.', rep['billNo']),
                    _row('Shipping Bill Date', rep['billDate']),
                    _row('Invoice No.', rep['invoiceNo']),
                    _row('Survey Location', rep['location']),
                    _row('Cargo Description', rep['description']),
                    _row('Loading Port', rep['loadingPort']),
                    _row('Discharge Port', rep['dischargePort']),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 3: Observations / ODC Measurements
                _section(
                  title: 'ODC Observations & Measurements',
                  icon: Icons.straighten_rounded,
                  color: AppColors.purple,
                  children: [
                    _row('Cargo Length', rep['cargoLength'] != null ? '${rep['cargoLength']} m' : null),
                    _row('Cargo Width', rep['cargoWidth'] != null ? '${rep['cargoWidth']} m' : null),
                    _row('Cargo Height', rep['cargoHeight'] != null ? '${rep['cargoHeight']} m' : null),
                    _row('Gross Weight', rep['cargoGross'] != null ? '${rep['cargoGross']} MT' : null),
                    _row('Over Length (Rear)', '${rep['overLenRear'] ?? 12} inches / ${rep['overLenRearCm'] ?? 30.48} cm'),
                    _row('Over Height', '${rep['overHeight'] ?? 24} inches / ${rep['overHeightCm'] ?? 60.96} cm'),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 4: Lashing Materials
                _section(
                  title: 'Lashing Materials Used',
                  icon: Icons.link_rounded,
                  color: AppColors.orange,
                  children: [
                    _row('Material 1', rep['material1'] ?? 'Nylon Lashing Belt — 50mm — 10 nos'),
                    _row('Material 2', rep['material2'] ?? 'Wire Rope Lashing — 12mm — 8 nos'),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 5: Photos
                _section(
                  title: 'Photo Log',
                  icon: Icons.camera_alt_rounded,
                  color: AppColors.emerald,
                  children: [
                    _row('Total Photos', rep['photoCount']?.toString() ?? '1'),
                    _row('Geo-Tagged', 'Yes'),
                    const SizedBox(height: 12),
                    _buildPhotoGrid(context, rep['photos'], AppColors.emerald),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 6: Assignment
                _section(
                  title: 'Assignment & Workflow',
                  icon: Icons.assignment_ind_rounded,
                  color: AppColors.pink,
                  children: [
                    _row('Assigned Survey By', rep['surveyBy'] ?? 'Not Assigned'),
                    _row('Assigned Checked By', rep['checkedBy'] ?? 'Not Assigned'),
                    _row('Priority', rep['priority'] ?? 'Medium'),
                    _row('Due Date', rep['dueDate'] ?? '—'),
                    _row('Skip Survey', rep['skipSurvey'] == true ? 'Yes' : 'No'),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: rep['status'] == 'Draft' && onEdit != null
          ? FloatingActionButton(
              heroTag: 'odc_edit_btn',
              onPressed: onEdit,
              backgroundColor: AppColors.emerald,
              child: const Icon(Icons.edit_rounded, color: Colors.white),
            )
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  CONTAINER DAMAGE SURVEY — FULL DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════
class ContainerDamageDetailScreen extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback onBack;
  final VoidCallback? onEdit;

  const ContainerDamageDetailScreen({
    super.key,
    required this.report,
    required this.onBack,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final rep = report;
    final color = rep['color'] as Color? ?? AppColors.orange;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // extra bottom padding for floating buttons
            child: Column(
              children: [
                // Top Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.orangeYellowGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.dangerous_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 6),
                        Text(rep['id'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const Spacer(),
                        _statusPill(rep['status'] ?? '', color),
                      ]),
                      const SizedBox(height: 8),
                      const Text('Container Damage Survey',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text('Survey Date: ${rep['date'] ?? ''}',
                          style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Section 1: Container Details
                _section(
                  title: 'Container Details',
                  icon: Icons.directions_boat_rounded,
                  color: AppColors.primaryBlue,
                  children: [
                    _row('Container No.', rep['containerNo']),
                    _row('Container Prefix', rep['prefix']),
                    _row('Serial Number', rep['serialNo']),
                    _row('Container Type', rep['containerType']),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 2: Applicant & Inspection
                _section(
                  title: 'Applicant & Inspection Details',
                  icon: Icons.assignment_ind_rounded,
                  color: AppColors.purple,
                  children: [
                    _row('Applicant Name', rep['applicant']),
                    _row('Booking Number', rep['bookingNo']),
                    _row('Leasing Company', rep['leasingCompany']),
                    _row('Inspector Name', rep['inspector']),
                    _row('Inspection Location', rep['location']),
                    _row('Inspection Date & Time', rep['inspectDateTime']),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 3: Damage Inspection
                _section(
                  title: 'Damage Inspection Details',
                  icon: Icons.content_paste_search_outlined,
                  color: AppColors.orange,
                  children: [
                    _damageRow('Left Side', rep['leftDamage']),
                    _damageRow('Right Side', rep['rightDamage']),
                    _damageRow('Front Panel', rep['frontDamage']),
                    _damageRow('Rear Panel', rep['rearDamage']),
                    _damageRow('Roof / Top', rep['roofDamage']),
                    _damageRow('Under Structure', rep['underDamage']),
                    _damageRow('Interior', rep['interiorDamage']),
                    _row('CSC Particulars', rep['cscDetails']),
                    _row('Container Status', rep['containerStatus']),
                    _row('General Remarks', rep['generalRemarks']),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 4: Photos
                _section(
                  title: 'Photo Log',
                  icon: Icons.camera_alt_rounded,
                  color: AppColors.cyan,
                  children: [
                    _row('Total Photos', rep['photoCount']?.toString() ?? '1'),
                    _row('Geo-Tagged', 'Yes'),
                    const SizedBox(height: 12),
                    _buildPhotoGrid(context, rep['photos'], AppColors.cyan),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 5: Assignment
                _section(
                  title: 'Assignment & Workflow',
                  icon: Icons.assignment_outlined,
                  color: AppColors.pink,
                  children: [
                    _row('Assigned Survey By', rep['surveyBy'] ?? 'Not Assigned'),
                    _row('Assigned Checked By', rep['checkedBy'] ?? 'Not Assigned'),
                    _row('Priority', rep['priority'] ?? 'Medium'),
                    _row('Due Date', rep['dueDate'] ?? '—'),
                    _row('Skip Survey', rep['skipSurvey'] == true ? 'Yes — Direct to Checked By' : 'No'),
                    _row('Internal Instructions', rep['instructions']),
                    _row('Remarks', rep['remarks']),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: (rep['status'] == 'Draft') && onEdit != null
          ? FloatingActionButton(
              heroTag: 'damage_edit_btn',
              onPressed: onEdit,
              backgroundColor: AppColors.orange,
              child: const Icon(Icons.edit_rounded, color: Colors.white),
            )
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════

Widget _statusPill(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
    ),
    child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
  );
}

Widget _section({
  required String title,
  required IconData icon,
  required Color color,
  required List<Widget> children,
}) {
  // Filter out null rows
  final visible = children.whereType<Widget>().toList();
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 10),
            Text(title, style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ]),
        ),
        // Rows
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: visible),
        ),
      ],
    ),
  );
}

Widget _row(String label, String? value) {
  if (value == null || value.isEmpty) return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ),
        Expanded(
          flex: 6,
          child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ),
      ],
    ),
  );
}

// Special damage row: shows "No damage" in muted style if empty, otherwise uses orange
Widget _damageRow(String label, String? value) {
  final hasValue = value != null && value.isNotEmpty;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasValue ? AppColors.orange : AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            hasValue ? (value as String) : 'No damage recorded',
            style: TextStyle(
              fontSize: 12,
              fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
              color: hasValue ? AppColors.textPrimary : AppColors.textMuted,
              fontStyle: hasValue ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ),
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
//  PHOTO THUMBNAIL & PREVIEW UTILITIES
// ═══════════════════════════════════════════════════════════════

final List<String> _mockPhotoUrls = [
  'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=600&q=80',
  'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=600&q=80',
  'https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=600&q=80',
  'https://images.unsplash.com/photo-1506015391300-4802dc74de2e?auto=format&fit=crop&w=600&q=80',
  'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=600&q=80',
];

Widget _buildPhotoGrid(BuildContext context, List<dynamic>? photos, Color themeColor) {
  final photoList = (photos != null && photos.isNotEmpty)
      ? photos
      : List.generate(3, (index) => {
          'category': index == 0 ? 'Front View' : index == 1 ? 'Lashing Details' : 'Top Securing',
          'caption': 'Survey Photo ${index + 1}',
          'metadata': '10 Jul 2026, 11:3${index} AM | GPS: 18.9502 N, 72.8258 E | Device: CAT S62 Pro',
        });

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Tap on any photo to preview', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontStyle: FontStyle.italic)),
      const SizedBox(height: 8),
      SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: photoList.length,
          itemBuilder: (context, index) {
            final photo = photoList[index];
            final url = _mockPhotoUrls[index % _mockPhotoUrls.length];
            return GestureDetector(
              onTap: () => _showPhotoPreview(context, photo, url),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  image: DecorationImage(
                    image: NetworkImage(url),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
                    ),
                    child: Text(
                      photo['category'] ?? 'Photo',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

void _showPhotoPreview(BuildContext context, dynamic photo, String url) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  photo['caption'] ?? 'Survey Photo',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Category: ${photo['category'] ?? "General"}',
                  style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600, fontSize: 12),
                ),
                if (photo['metadata'] != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      photo['metadata'],
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

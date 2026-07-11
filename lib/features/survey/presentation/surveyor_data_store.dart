import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  MOCK DATA STORE FOR SURVEYOR PANEL STATE
// ─────────────────────────────────────────────────────────────────────────────
class SurveyorDataStore {
  static final SurveyorDataStore instance = SurveyorDataStore._internal();
  SurveyorDataStore._internal();

  final List<Map<String, dynamic>> reports = [
    {
      'id': 'MSR-2026-8001',
      'title': 'Lashing & Measurement Survey',
      'type': 'Lashing & Measurement',
      'vessel': 'Pacific Voyager',
      'client': 'APL Logistics',
      'date': '10 Jul 2026',
      'dueDate': '11 Jul 2026',
      'priority': 'High',
      'status': 'Assigned', // Statuses: Assigned, Accepted, In Progress, Submitted, Returned, Completed
      'assignedBy': 'Sarah Preparer',
      'location': 'Port of Mumbai - Berth 14',
      'instructions': 'Verify container lashing tension on bay 4 & 5. Ensure wire ropes have no slack.',
      'exporter': 'India Iron Ltd',
      'consignee': 'Global Trade Corp',
      'shippingLine': 'Maersk Line',
      'billNo': 'SB-992019',
      'billDate': '08 Jul 2026',
      'invoiceNo': 'INV-4820A',
      'invoiceDate': '08 Jul 2026',
      'description': 'Industrial Steel Coils & Cable Reels',
      'grossWeight': 24.5,
      'quantity': 12,
      'discharge': 'Rotterdam',
      'containerNo': 'MSKU-882910-2',
      'containerSize': '40ft OT',
      'stuffPkg': 12,
      'cargoWeight': 22.1,
      'tareWeight': 2.4,
      'totalWeight': 24.5,
      'payload': 30.4,
      'acep': 'ACEP-IN-98',
      'csc': 'CSC-893011',
      'condition': 'Good',
      // Field observations
      'obsFieldObservations': '',
      'obsLashingVerification': '',
      'obsMeasurementVerification': '',
      'obsRemarks': '',
      // Photos
      'photos': <Map<String, dynamic>>[],
      // Docs
      'documents': <Map<String, String>>[
        {'name': 'Cargo_Manifest.pdf', 'size': '1.2 MB'},
        {'name': 'Prepared_Instructions.pdf', 'size': '450 KB'}
      ],
      'remarks': '',
      'damageRemarks': '',
      'observations': '',
      'recommendations': '',
      'internalComments': '',
      'signature': <Offset>[],
      'signaturePath': '',
      'returnRemarks': '',
      'activities': [
        {'time': '10 Jul 2026, 09:00 AM', 'title': 'Assignment Created', 'desc': 'Assigned to Surveyor by Sarah Preparer'}
      ]
    },
    {
      'id': 'MSR-2026-8002',
      'title': 'ODC Survey Report',
      'type': 'ODC Survey',
      'vessel': 'Atlantic Crest',
      'client': 'Cosco Shipping',
      'date': '10 Jul 2026',
      'dueDate': '12 Jul 2026',
      'priority': 'Medium',
      'status': 'Accepted',
      'assignedBy': 'Sarah Preparer',
      'location': 'Port of Chennai - Terminal 2',
      'instructions': 'Conduct ODC check for over-width cargo. Confirm cargo positioning.',
      'exporter': 'BHEL India',
      'consignee': 'Jebel Ali Power Stn',
      'shippingLine': 'Cosco',
      'billNo': 'SB-281903',
      'billDate': '09 Jul 2026',
      'invoiceNo': 'INV-1102B',
      'invoiceDate': '09 Jul 2026',
      'description': 'Transformer Assembly & Accessories',
      'grossWeight': 45.2,
      'quantity': 1,
      'discharge': 'Jebel Ali',
      'obsOdcVerification': 'Pre-scan shows 10cm over-width on starboard side.',
      'obsCargoPositioning': 'Secured on flat rack.',
      'obsSafetyObservations': 'Sufficient clearance from container cell guides.',
      'obsRemarks': 'Ready for lashing certification.',
      'photos': <Map<String, dynamic>>[],
      'documents': <Map<String, String>>[],
      'remarks': '',
      'damageRemarks': '',
      'observations': '',
      'recommendations': '',
      'internalComments': '',
      'signature': <Offset>[],
      'signaturePath': '',
      'returnRemarks': '',
      'activities': [
        {'time': '10 Jul 2026, 08:30 AM', 'title': 'Assignment Created', 'desc': 'Assigned to Surveyor'},
        {'time': '10 Jul 2026, 11:15 AM', 'title': 'Assignment Accepted', 'desc': 'Surveyor accepted this report'}
      ]
    },
    {
      'id': 'MSR-2026-8003',
      'title': 'Container Damage Survey',
      'type': 'Container Damage',
      'vessel': 'Ever Star',
      'client': 'Evergreen Line',
      'date': '09 Jul 2026',
      'dueDate': '10 Jul 2026',
      'priority': 'High',
      'status': 'Returned',
      'assignedBy': 'Checked By - Marc',
      'location': 'JNPT Terminal 1',
      'instructions': 'Verify corner casting damage and dent on left side panel.',
      'exporter': 'General Metal Corp',
      'consignee': 'Euro Logistics Ltd',
      'shippingLine': 'Evergreen',
      'billNo': 'SB-8829102',
      'billDate': '07 Jul 2026',
      'invoiceNo': 'INV-8820B',
      'invoiceDate': '07 Jul 2026',
      'description': 'Scrap Metal Containers',
      'grossWeight': 28.0,
      'quantity': 5,
      'discharge': 'Hamburg',
      'obsDamageVerification': 'Left wall dent is 25cm in length, 5cm depth.',
      'obsDamageLocation': 'Left panel, bay 3, row A.',
      'obsDamageObservations': 'Corrosion visible, wall integrity compromised.',
      'obsConditionRemarks': 'Needs patching before loading on vessel.',
      'photos': <Map<String, dynamic>>[
        {
          'category': 'Damage Close-up',
          'caption': 'Dent on Left Panel',
          'remarks': 'Rusting visible on the dent border.',
          'metadata': '10 Jul 2026 | GPS: 18.9500, 72.8200 | Surveyor: John | Android 13',
          'isMock': true
        }
      ],
      'documents': <Map<String, String>>[],
      'remarks': 'Dent verified.',
      'damageRemarks': 'Requires immediate welding attention.',
      'observations': 'Water leakage risk from top-left corner castings.',
      'recommendations': 'Reject for immediate sea voyage until repaired.',
      'internalComments': 'Checked by rejected this originally due to insufficient photo clarity.',
      'signature': <Offset>[],
      'signaturePath': '',
      'returnRemarks': 'Please upload a closer photo of the corner castings showing the seal.',
      'activities': [
        {'time': '09 Jul 2026, 04:00 PM', 'title': 'Report Submitted', 'desc': 'Surveyor submitted report for review'},
        {'time': '10 Jul 2026, 02:00 PM', 'title': 'Report Returned', 'desc': 'Returned by Checked By. Reason: Please upload closer photo of corner castings.'}
      ]
    },
    {
      'id': 'MSR-2026-8004',
      'title': 'Lashing & Measurement Survey',
      'type': 'Lashing & Measurement',
      'vessel': 'CMA CGM Hydra',
      'client': 'CMA CGM',
      'date': '08 Jul 2026',
      'dueDate': '09 Jul 2026',
      'priority': 'Medium',
      'status': 'Completed',
      'assignedBy': 'Sarah Preparer',
      'location': 'Port of Mumbai - Berth 18',
      'instructions': 'Verify double-turnbuckle security on flat racks.',
      'exporter': 'Tata Motors',
      'consignee': 'Apex Auto Dubai',
      'shippingLine': 'CMA CGM',
      'billNo': 'SB-1102941',
      'billDate': '06 Jul 2026',
      'invoiceNo': 'INV-9022C',
      'invoiceDate': '06 Jul 2026',
      'description': 'Commercial Vehicle Chassis',
      'grossWeight': 32.8,
      'quantity': 4,
      'discharge': 'Jebel Ali',
      'obsFieldObservations': 'All turnbuckles secured and safety pins installed.',
      'obsLashingVerification': 'Tension tests passed on all 8 lashing ropes.',
      'obsMeasurementVerification': 'Dimensions match flatrack specification.',
      'obsRemarks': 'Cargo is safe for transit.',
      'photos': <Map<String, dynamic>>[],
      'documents': <Map<String, String>>[],
      'remarks': 'Verified on-site.',
      'signaturePath': 'mock_signature_file.png',
      'activities': [
        {'time': '08 Jul 2026, 10:00 AM', 'title': 'Report Assigned', 'desc': 'Assigned by Sarah'},
        {'time': '08 Jul 2026, 02:00 PM', 'title': 'Report Submitted', 'desc': 'Submitted by Surveyor'},
        {'time': '09 Jul 2026, 11:00 AM', 'title': 'Report Approved', 'desc': 'Final approval by Checked By Marc'}
      ]
    }
  ];

  final List<Map<String, String>> notifications = [
    {
      'title': 'New Report Assigned',
      'time': '10 mins ago',
      'desc': 'Lashing & Measurement Survey (MSR-2026-8001) has been assigned to you by Sarah Preparer.',
      'isNew': 'true',
    },
    {
      'title': 'Report Returned',
      'time': '2 hours ago',
      'desc': 'Container Damage Survey (MSR-2026-8003) has been returned by Checked By Marc. Reason: Add closer casting photo.',
      'isNew': 'true',
    },
    {
      'title': 'Report Approved',
      'time': '1 day ago',
      'desc': 'Your survey for CMA CGM Hydra (MSR-2026-8004) has been accepted and finalized.',
      'isNew': 'false',
    }
  ];

  void addNotification(String title, String desc) {
    notifications.insert(0, {
      'title': title,
      'time': 'Just now',
      'desc': desc,
      'isNew': 'true',
    });
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/app_provider.dart';
import '../../providers/loan_provider.dart';
import '../../widgets/primary_button.dart';

/// Screen 7: Demo KYC Upload
///
/// PURPOSE:
/// Demonstrates the digital KYC & document origination workflow
/// without collecting, transmitting, or storing real identity documents.
///
/// FEATURES:
/// - Heading: "Document Verification"
/// - Subtitle: "Demonstration Only — Do Not Upload Real Documents"
/// - Prominent label: "Demo KYC — Not Verified"
/// - 4 Document Cards:
///     1. Aadhaar Front
///     2. Aadhaar Back
///     3. PAN Card
///     4. Bank Statement PDF
/// - Separate Selfie Demonstration Card with simulated avatar
/// - Status for each card: "Not Added" vs "Demo Sample Added"
/// - Synthetic sample previews without activating camera or permissions
/// - "Add All Demo Samples" 1-tap tester button
/// - Continue button opening Sample Key Fact Statement (KFS) screen
class KycUploadScreen extends StatefulWidget {
  const KycUploadScreen({super.key});

  @override
  State<KycUploadScreen> createState() => _KycUploadScreenState();
}

class _KycUploadScreenState extends State<KycUploadScreen> {
  // Local synthetic document model
  late Map<String, _DemoDocInfo> _docs;
  bool _selfieAdded = false;

  @override
  void initState() {
    super.initState();
    _docs = {
      'aadhaar_front': _DemoDocInfo(
        title: 'Aadhaar Card (Front)',
        subtitle: 'Synthetic sample with name & photo',
        icon: Icons.badge_outlined,
        fileName: 'demo_aadhaar_front.jpg',
        fileSize: '240 KB',
        isAdded: false,
      ),
      'aadhaar_back': _DemoDocInfo(
        title: 'Aadhaar Card (Back)',
        subtitle: 'Synthetic sample with address',
        icon: Icons.contact_mail_outlined,
        fileName: 'demo_aadhaar_back.jpg',
        fileSize: '215 KB',
        isAdded: false,
      ),
      'pan_card': _DemoDocInfo(
        title: 'PAN Card',
        subtitle: 'Synthetic sample with demo number',
        icon: Icons.credit_card_rounded,
        fileName: 'demo_pancard.jpg',
        fileSize: '190 KB',
        isAdded: false,
      ),
      'bank_statement': _DemoDocInfo(
        title: 'Bank Statement PDF',
        subtitle: 'Synthetic 3-month statement',
        icon: Icons.picture_as_pdf_outlined,
        fileName: 'demo_bank_statement.pdf',
        fileSize: '1.2 MB',
        isPdf: true,
        isAdded: false,
      ),
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loanProvider = context.read<LoanProvider>();
    _docs['aadhaar_front']!.isAdded = loanProvider.aadhaarFrontAdded;
    _docs['aadhaar_back']!.isAdded = loanProvider.aadhaarBackAdded;
    _docs['pan_card']!.isAdded = loanProvider.panCardAdded;
    _docs['bank_statement']!.isAdded = loanProvider.bankStatementAdded;
    _selfieAdded = loanProvider.selfieAdded;
  }

  void _toggleDoc(String key) {
    setState(() {
      final doc = _docs[key]!;
      doc.isAdded = !doc.isAdded;
      context.read<LoanProvider>().setDocumentAdded(key, doc.isAdded);
    });
  }

  void _toggleSelfie() {
    setState(() {
      _selfieAdded = !_selfieAdded;
      context.read<LoanProvider>().setDocumentAdded('selfie', _selfieAdded);
    });
  }

  void _addAllSamples() {
    setState(() {
      for (final doc in _docs.values) {
        doc.isAdded = true;
      }
      _selfieAdded = true;
    });
    context.read<LoanProvider>().addAllKycDemoSamples();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All synthetic demo KYC samples added.'),
        backgroundColor: AppTheme.secondary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSyntheticPreview(String key, _DemoDocInfo doc) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Icon(doc.icon, color: AppTheme.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  doc.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Synthetic Document Preview Box
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            doc.isPdf
                                ? Icons.picture_as_pdf_rounded
                                : Icons.image_rounded,
                            size: 48,
                            color: AppTheme.secondary.withValues(alpha: 0.6),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            doc.fileName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                          Text(
                            doc.fileSize,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Demo Watermark Banner
                    Positioned.fill(
                      child: Center(
                        child: Transform.rotate(
                          angle: -0.25,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.warning.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'DEMO SAMPLE — NOT VERIFIED',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Synthetic notice
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Synthetic placeholder image generated for demo presentation. No personal identity data is stored.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _toggleDoc(key);
              },
              child: const Text(
                'Remove Sample',
                style: TextStyle(color: AppTheme.error),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _onContinue() {
    final loanProvider = context.read<LoanProvider>();
    loanProvider.setCurrentStep(3); // Step 3 -> Proceeding to KFS (Step 4)

    // Navigate to Sample Key Fact Statement Screen
    Navigator.of(context).pushNamed(AppRoutes.keyFactStatement);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isHindi = appProvider.isHindi;

    final int addedCount = _docs.values.where((d) => d.isAdded).length +
        (_selfieAdded ? 1 : 0);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: Column(
          children: [
            Text(
              isHindi ? 'दस्तावेज़ सत्यापन (डेमो)' : 'Document Verification',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              isHindi ? 'चरण 3 / 4 • डेमो केवाईसी' : 'Step 3 of 4 • Demo KYC',
              style: const TextStyle(
                color: AppTheme.secondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 0.75, // Step 3 of 4 = 75%
            backgroundColor: Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
            minHeight: 3,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ─── 1. Mandatory Privacy Banner & Demo Tag ─────────
                    _buildPrivacyBanner(isHindi),

                    const SizedBox(height: 20),

                    // ─── 2. Header & Subtitle ───────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isHindi ? 'दस्तावेज़ सत्यापन' : 'Document Verification',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.2,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isHindi
                                    ? 'केवल प्रदर्शन उद्देश्य — वास्तविक दस्तावेज़ अपलोड न करें'
                                    : 'Demonstration Only — Do Not Upload Real Documents',
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 1-Tap "Add All Samples"
                        InkWell(
                          onTap: _addAllSamples,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.secondary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.playlist_add_check_rounded,
                                    size: 16, color: AppTheme.secondary),
                                SizedBox(width: 4),
                                Text(
                                  'Add All Demo',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Status counter badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            addedCount == 5
                                ? Icons.check_circle_rounded
                                : Icons.info_outline_rounded,
                            size: 16,
                            color: addedCount == 5 ? AppTheme.success : AppTheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Demo Samples Added: $addedCount of 5',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Required label: Demo KYC — Not Verified
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Demo KYC — Not Verified',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ─── 3. Section: Four Document Cards ─────────────────
                    _buildSectionTitle(
                      title: isHindi ? 'आवश्यक दस्तावेज़ (डेमो)' : 'Required Documents (Demo Samples)',
                      icon: Icons.folder_copy_outlined,
                    ),
                    const SizedBox(height: 12),

                    // 4 Document Cards
                    ..._docs.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildDocCard(entry.key, entry.value),
                      );
                    }),

                    const SizedBox(height: 16),

                    // ─── 4. Separate Selfie Demonstration Card ───────────
                    _buildSectionTitle(
                      title: isHindi ? 'लाइव सेल्फी सत्यापन (डेमो)' : 'Selfie Demonstration Card',
                      icon: Icons.face_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildSelfieCard(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ─── Fixed Bottom Bar with Continue Button ───────────────────
            _buildBottomBar(isHindi, addedCount),
          ],
        ),
      ),
    );
  }

  /// 1. Top Privacy Notice Banner with strict disclaimer & Demo KYC label
  Widget _buildPrivacyBanner(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.privacy_tip_outlined, color: Color(0xFFD97706), size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Demo KYC — Not Verified',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF92400E),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE68A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'NO REAL DATA',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF78350F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Privacy Notice verbatim
          Text(
            isHindi
                ? 'यह एक प्रदर्शन है। कृपया वास्तविक पहचान दस्तावेज़ या बैंक विवरण अपलोड न करें।'
                : 'This is a demonstration. Please do not upload real identity documents or bank statements.',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFB45309),
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.secondary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }

  /// 2. Interactive Document Card
  Widget _buildDocCard(String key, _DemoDocInfo doc) {
    final isAdded = doc.isAdded;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAdded ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
          width: isAdded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Icon Box
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isAdded
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isAdded ? Icons.check_circle_rounded : doc.icon,
                  color: isAdded ? AppTheme.success : AppTheme.secondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doc.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Badge: Not Added vs Demo Sample Added
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: isAdded
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isAdded
                        ? const Color(0xFFBBF7D0)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  isAdded ? 'Demo Sample Added' : 'Not Added',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isAdded ? const Color(0xFF15803D) : AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Action row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isAdded) ...[
                // File info chip
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.attach_file_rounded, size: 14, color: AppTheme.secondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${doc.fileName} (${doc.fileSize})',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => _showSyntheticPreview(key, doc),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Preview', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _toggleDoc(key),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.close_rounded, size: 16, color: AppTheme.textHint),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const Expanded(
                  child: Text(
                    'Simulated placeholder document',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: AppTheme.textHint),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _toggleDoc(key),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Add Demo Sample',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// 3. Separate Selfie Demonstration Card
  Widget _buildSelfieCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selfieAdded ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
          width: _selfieAdded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Selfie Verification (Mock)',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _selfieAdded
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selfieAdded
                        ? const Color(0xFFBBF7D0)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  _selfieAdded ? 'Demo Sample Added' : 'Not Added',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _selfieAdded
                        ? const Color(0xFF15803D)
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Center Mock Preview Box
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                // Synthetic Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: _selfieAdded
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFE2E8F0),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selfieAdded
                              ? AppTheme.success
                              : const Color(0xFFCBD5E1),
                          width: 2.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _selfieAdded ? Icons.person_rounded : Icons.face_rounded,
                          size: 44,
                          color: _selfieAdded
                              ? AppTheme.success
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    if (_selfieAdded)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _selfieAdded
                      ? 'Synthetic Selfie Captured (Demo)'
                      : 'Mock Selfie Liveness Check',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'No camera or gallery permissions requested or activated.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Action button to simulate selfie
          OutlinedButton.icon(
            onPressed: _toggleSelfie,
            icon: Icon(
              _selfieAdded ? Icons.refresh_rounded : Icons.camera_front_rounded,
              size: 18,
            ),
            label: Text(
              _selfieAdded
                  ? 'Re-simulate Selfie'
                  : 'Simulate Demo Selfie Capture',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  _selfieAdded ? AppTheme.textPrimary : AppTheme.secondary,
              side: BorderSide(
                color: _selfieAdded
                    ? const Color(0xFFCBD5E1)
                    : AppTheme.secondary,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Fixed Bottom Action Bar with Continue button
  Widget _buildBottomBar(bool isHindi, int addedCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: PrimaryButton(
          text: isHindi
              ? 'केएफएस विवरण देखें (Continue)'
              : 'Continue to Key Fact Statement',
          backgroundColor: AppTheme.accent,
          icon: Icons.arrow_forward_rounded,
          onPressed: _onContinue,
        ),
      ),
    );
  }
}

class _DemoDocInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  final String fileName;
  final String fileSize;
  final bool isPdf;
  bool isAdded;

  _DemoDocInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.fileName,
    required this.fileSize,
    this.isPdf = false,
    this.isAdded = false,
  });
}

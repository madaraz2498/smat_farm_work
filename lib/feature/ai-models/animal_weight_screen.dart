import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ANIMAL WEIGHT ESTIMATION SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

enum AnimalWeightStatus { idle, loading, result, error }

class AnimalWeightResult {
  final double weightKg;
  final String animalType;
  final double confidence;
  const AnimalWeightResult({
    required this.weightKg,
    required this.animalType,
    required this.confidence,
  });
}

class AnimalWeightController extends ChangeNotifier {
  AnimalWeightStatus  _status = AnimalWeightStatus.idle;
  String?             _imagePath;
  AnimalWeightResult? _result;
  String?             _errorMessage;

  AnimalWeightStatus  get status       => _status;
  String?             get imagePath    => _imagePath;
  AnimalWeightResult? get result       => _result;
  String?             get errorMessage => _errorMessage;

  Future<void> estimateWeight(String path) async {
    _imagePath    = path;
    _status       = AnimalWeightStatus.loading;
    _result       = null;
    _errorMessage = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      _result = const AnimalWeightResult(
        weightKg:   369.0,
        animalType: 'Pig',
        confidence: 0.92,
      );
      _status = AnimalWeightStatus.result;
    } catch (_) {
      _errorMessage = 'Estimation failed. Please try again.';
      _status       = AnimalWeightStatus.error;
    }
    notifyListeners();
  }

  void reset() {
    _status       = AnimalWeightStatus.idle;
    _imagePath    = null;
    _result       = null;
    _errorMessage = null;
    notifyListeners();
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class AnimalWeightScreen extends StatefulWidget {
  const AnimalWeightScreen({super.key});
  @override
  State<AnimalWeightScreen> createState() => _AnimalWeightScreenState();
}

class _AnimalWeightScreenState extends State<AnimalWeightScreen> {
  final _ctrl = AnimalWeightController();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _pickImage() => _ctrl.estimateWeight('mock_path');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title:   'Animal Weight Estimation (Computer Vision)',
        svgPath: 'assets/images/icons/animal_icon.svg',
      ),
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => _Body(ctrl: _ctrl, onPick: _pickImage),
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  final AnimalWeightController ctrl;
  final VoidCallback onPick;
  const _Body({required this.ctrl, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PageHeading(
                title:    'Animal Weight Estimation',
                subtitle: 'Upload an animal image to estimate weight using AI-powered computer vision',
              ),
              const SizedBox(height: 20),
              _ImageCard(
                imagePath: ctrl.imagePath,
                isLoading: ctrl.status == AnimalWeightStatus.loading,
                onPick:    onPick,
              ),
              const SizedBox(height: 20),
              if (ctrl.status == AnimalWeightStatus.result &&
                  ctrl.result != null) ...[
                _ResultCard(result: ctrl.result!),
                const SizedBox(height: 20),
              ],
              if (ctrl.status == AnimalWeightStatus.error &&
                  ctrl.errorMessage != null)
                _ErrorBanner(ctrl.errorMessage!),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Page heading ─────────────────────────────────────────────────────────────

class _PageHeading extends StatelessWidget {
  final String title, subtitle;
  const _PageHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: tt.bodySmall?.copyWith(color: AppColors.textSubtle)),
      ],
    );
  }
}

// ─── Image card ───────────────────────────────────────────────────────────────

class _ImageCard extends StatelessWidget {
  final String?      imagePath;
  final bool         isLoading;
  final VoidCallback onPick;
  const _ImageCard({
    required this.imagePath,
    required this.isLoading,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color:        AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            ),
            child: const Icon(Icons.visibility_outlined,
                color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            child: isLoading
                ? _loadingBox()
                : imagePath != null
                ? Image.asset(imagePath!,
                width: double.infinity, height: 190,
                fit:   BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder())
                : _placeholder(),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _OutlineBtn(label: 'Choose Image', onTap: onPick)),
            const SizedBox(width: 12),
            Expanded(
              child: _SolidBtn(
                label:   'Estimate Weight',
                onTap:   onPick,
                enabled: true,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _loadingBox() => Container(
    width: double.infinity, height: 190,
    color: AppColors.background,
    child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary)),
  );

  Widget _placeholder() => Container(
    width: double.infinity, height: 190,
    color: AppColors.background,
    child: const Icon(Icons.pets_rounded,
        color: AppColors.textDisabled, size: 52),
  );
}

// ─── Result card ──────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final AnimalWeightResult result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Estimation Result',
              style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 16),
          Container(
            width:   double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:        AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              border:       Border.all(color: AppColors.primary.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimated Weight',
                    style: tt.bodySmall?.copyWith(color: AppColors.primary)),
                const SizedBox(height: 4),
                Text('${result.weightKg.toStringAsFixed(0)} kg',
                    style: tt.headlineMedium?.copyWith(
                      color:      AppColors.primary,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Animal Type', value: result.animalType),
          const SizedBox(height: 12),
          _ConfidenceRow(confidence: result.confidence),
        ],
      ),
    );
  }
}

// ─── Info row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        border:       Border.all(color: AppColors.cardBorder),
      ),
      child: RichText(
        text: TextSpan(
          style: tt.bodyMedium?.copyWith(color: AppColors.textDark),
          children: [
            TextSpan(
                text:  '$label: ',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

// ─── Confidence row ────────────────────────────────────────────────────────────

class _ConfidenceRow extends StatelessWidget {
  final double confidence;
  const _ConfidenceRow({required this.confidence});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        border:       Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: tt.bodyMedium?.copyWith(color: AppColors.textDark),
              children: [
                const TextSpan(
                    text:  'Confidence Score: ',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: '${(confidence * 100).toStringAsFixed(0)}%'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value:           confidence,
              minHeight:       8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor:      const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared buttons ───────────────────────────────────────────────────────────

class _OutlineBtn extends StatelessWidget {
  final String     label;
  final VoidCallback onTap;
  const _OutlineBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding:         const EdgeInsets.symmetric(vertical: 14),
        side:            const BorderSide(color: AppColors.primary),
        shape:           RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)),
        backgroundColor: AppColors.primarySurface,
      ),
      child: Text(label,
          style: const TextStyle(
              color: AppColors.primary, fontWeight: FontWeight.w600)),
    );
  }
}

class _SolidBtn extends StatelessWidget {
  final String     label;
  final VoidCallback onTap;
  final bool       enabled;
  const _SolidBtn(
      {required this.label, required this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        padding:                 const EdgeInsets.symmetric(vertical: 14),
        backgroundColor:         AppColors.primary,
        foregroundColor:         Colors.white,
        disabledBackgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)),
        elevation: 0,
      ),
      child: Text(label,
          style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Error banner ─────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:        const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        border:       Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(children: [
        const Icon(Icons.error_outline, size: 16, color: AppColors.error),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.error)),
        ),
      ]),
    );
  }
}
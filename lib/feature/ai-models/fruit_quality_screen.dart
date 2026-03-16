import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

enum FruitQualityStatus { idle, loading, result, error }

class FruitResult {
  final String grade, gradeLabel, ripeness, defects;
  const FruitResult({required this.grade, required this.gradeLabel, required this.ripeness, required this.defects});
}

class FruitQualityController extends ChangeNotifier {
  FruitQualityStatus _status = FruitQualityStatus.idle;
  String?            _imagePath;
  FruitResult?       _result;
  String?            _errorMessage;

  FruitQualityStatus get status       => _status;
  String?            get imagePath    => _imagePath;
  FruitResult?       get result       => _result;
  String?            get errorMessage => _errorMessage;

  Future<void> analyze(String path) async {
    _imagePath = path; _status = FruitQualityStatus.loading;
    _result = null; _errorMessage = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      _result = const FruitResult(
        grade: 'A', gradeLabel: 'Premium quality - Ready for market',
        ripeness: 'Ripe', defects: 'Minor surface blemishes',
      );
      _status = FruitQualityStatus.result;
    } catch (_) {
      _errorMessage = 'Analysis failed. Please try again.';
      _status       = FruitQualityStatus.error;
    }
    notifyListeners();
  }

  void reset() {
    _status = FruitQualityStatus.idle; _imagePath = null;
    _result = null; _errorMessage = null;
    notifyListeners();
  }
}

class FruitQualityScreen extends StatefulWidget {
  const FruitQualityScreen({super.key});
  @override
  State<FruitQualityScreen> createState() => _FruitQualityScreenState();
}

class _FruitQualityScreenState extends State<FruitQualityScreen> {
  final _ctrl = FruitQualityController();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  void _pickImage() => _ctrl.analyze('mock_path');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
       body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => _Body(ctrl: _ctrl, onPick: _pickImage),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final FruitQualityController ctrl;
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
              const _PageHeading(
                title:    'Fruit Quality Analysis',
                subtitle: 'Upload fruit image for computer vision-based quality grading',
              ),
              const SizedBox(height: 20),
              _ImageCard(
                imagePath: ctrl.imagePath,
                isLoading: ctrl.status == FruitQualityStatus.loading,
                onPick:    onPick,
                analyzeLabel: 'Analyze Fruit',
              ),
              const SizedBox(height: 20),
              if (ctrl.status == FruitQualityStatus.result && ctrl.result != null) ...[
                _AnalysisResultCard(result: ctrl.result!),
                const SizedBox(height: 20),
              ],
              if (ctrl.status == FruitQualityStatus.error && ctrl.errorMessage != null)
                _ErrorBanner(ctrl.errorMessage!),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageHeading extends StatelessWidget {
  final String title, subtitle;
  const _PageHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
      const SizedBox(height: 4),
      Text(subtitle, style: tt.bodySmall?.copyWith(color: AppColors.textSubtle)),
    ]);
  }
}

class _ImageCard extends StatelessWidget {
  final String?      imagePath;
  final bool         isLoading;
  final VoidCallback onPick;
  final String       analyzeLabel;
  const _ImageCard({required this.imagePath, required this.isLoading, required this.onPick, required this.analyzeLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color:        AppColors.primarySurface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
          ),
          child: const Icon(Icons.apple_outlined, color: AppColors.primary, size: 28),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
          child: isLoading
              ? Container(width: double.infinity, height: 190, color: AppColors.background,
              child: const Center(child: CircularProgressIndicator(color: AppColors.primary)))
              : imagePath != null
              ? Image.asset(imagePath!, width: double.infinity, height: 190, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder())
              : _placeholder(),
        ),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onPick,
              style: OutlinedButton.styleFrom(
                padding:         const EdgeInsets.symmetric(vertical: 14),
                side:            const BorderSide(color: AppColors.primary),
                shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                backgroundColor: AppColors.primarySurface,
              ),
              child: const Text('Choose Image',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onPick,
              style: ElevatedButton.styleFrom(
                padding:         const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                elevation: 0,
              ),
              child: Text(analyzeLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _placeholder() => Container(
    width: double.infinity, height: 190, color: AppColors.background,
    child: const Icon(Icons.image_outlined, color: AppColors.textDisabled, size: 52),
  );
}

class _AnalysisResultCard extends StatelessWidget {
  final FruitResult result;
  const _AnalysisResultCard({required this.result});

  Color get _gradeColor {
    switch (result.grade) {
      case 'A': return AppColors.primary;
      case 'B': return AppColors.warning;
      default:  return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final color = _gradeColor;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Analysis Results',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:        color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            border:       Border.all(color: color.withOpacity(0.25)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Quality Grade', style: tt.bodySmall?.copyWith(color: AppColors.textSubtle)),
            const SizedBox(height: 4),
            Text('Grade ${result.grade}',
                style: tt.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(result.gradeLabel, style: tt.bodySmall?.copyWith(color: AppColors.textSubtle)),
          ]),
        ),
        const SizedBox(height: 12),
        _InfoRow(label: 'Ripeness Level',  value: result.ripeness),
        const SizedBox(height: 12),
        _InfoRow(label: 'Defect Detection', value: result.defects),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
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
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

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
        Expanded(child: Text(message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error))),
      ]),
    );
  }
}
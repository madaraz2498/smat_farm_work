import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

enum PlantScanStatus { idle, loading, result, error }

class PlantDiseaseResult {
  final String status;
  final bool   isHealthy;
  final double confidence;
  const PlantDiseaseResult({required this.status, required this.isHealthy, required this.confidence});
}

class PlantDiseaseController extends ChangeNotifier {
  PlantScanStatus     _status = PlantScanStatus.idle;
  String?             _imagePath;
  PlantDiseaseResult? _result;
  String?             _errorMessage;

  PlantScanStatus     get status       => _status;
  String?             get imagePath    => _imagePath;
  PlantDiseaseResult? get result       => _result;
  String?             get errorMessage => _errorMessage;

  Future<void> analyzeImage(String path) async {
    _imagePath = path; _status = PlantScanStatus.loading;
    _result = null; _errorMessage = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      _result = const PlantDiseaseResult(status: 'Healthy Plant', isHealthy: true, confidence: 0.95);
      _status = PlantScanStatus.result;
    } catch (_) {
      _errorMessage = 'Analysis failed. Please try again.';
      _status       = PlantScanStatus.error;
    }
    notifyListeners();
  }

  void reset() {
    _status = PlantScanStatus.idle; _imagePath = null;
    _result = null; _errorMessage = null;
    notifyListeners();
  }
}

class PlantDiseaseScreen extends StatefulWidget {
  const PlantDiseaseScreen({super.key});
  @override
  State<PlantDiseaseScreen> createState() => _PlantDiseaseScreenState();
}

class _PlantDiseaseScreenState extends State<PlantDiseaseScreen> {
  final _ctrl = PlantDiseaseController();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  void _pickImage() => _ctrl.analyzeImage('mock_path');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Plant Disease Detection (CNN)', svgPath: 'assets/images/icons/plant_icon.svg',
      ),
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => _Body(ctrl: _ctrl, onPick: _pickImage),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final PlantDiseaseController ctrl;
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
                title:    'Plant Disease Detection',
                subtitle: 'Upload a plant leaf image for AI-powered disease diagnosis using CNN',
              ),
              const SizedBox(height: 20),
              _ImageCard(
                imagePath: ctrl.imagePath,
                isLoading: ctrl.status == PlantScanStatus.loading,
                onPick:    onPick,
                iconData:  Icons.eco_outlined,
                analyzeLabel: 'Analyze Image',
              ),
              const SizedBox(height: 20),
              if (ctrl.status == PlantScanStatus.result && ctrl.result != null) ...[
                _AnalysisResultCard(result: ctrl.result!),
                const SizedBox(height: 20),
              ],
              if (ctrl.status == PlantScanStatus.error && ctrl.errorMessage != null)
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
  final IconData     iconData;
  final String       analyzeLabel;
  const _ImageCard({required this.imagePath, required this.isLoading, required this.onPick, required this.iconData, required this.analyzeLabel});

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
          child: Icon(iconData, color: AppColors.primary, size: 28),
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
  final PlantDiseaseResult result;
  const _AnalysisResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final tt       = Theme.of(context).textTheme;
    final color    = result.isHealthy ? AppColors.primary : AppColors.error;
    final bgCol    = result.isHealthy ? AppColors.primarySurface : const Color(0xFFFEF2F2);
    final borderCol = result.isHealthy ? AppColors.primary.withOpacity(0.25) : AppColors.error.withOpacity(0.3);

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
        Text('Analysis Result',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color:        bgCol,
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            border:       Border.all(color: borderCol),
          ),
          child: Row(children: [
            Icon(result.isHealthy ? Icons.check_circle_outline : Icons.warning_amber_outlined,
                color: color, size: 20),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                style: tt.bodyMedium,
                children: [
                  TextSpan(text: 'Status: ',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  TextSpan(text: result.status,
                      style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color:        AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            border:       Border.all(color: AppColors.cardBorder),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RichText(
              text: TextSpan(
                style: tt.bodyMedium?.copyWith(color: AppColors.textDark),
                children: [
                  const TextSpan(text: 'Confidence: ', style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: '${(result.confidence * 100).toStringAsFixed(0)}%'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: LinearProgressIndicator(
                value:           result.confidence,
                minHeight:       8,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor:      AlwaysStoppedAnimation(color),
              ),
            ),
          ]),
        ),
      ]),
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
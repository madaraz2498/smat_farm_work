import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

enum SoilAnalysisStatus { idle, loading, result, error }

class SoilResult {
  final String soilType, fertilityLevel;
  const SoilResult({required this.soilType, required this.fertilityLevel});
}

class SoilAnalysisController extends ChangeNotifier {
  SoilAnalysisStatus _status = SoilAnalysisStatus.idle;
  SoilResult?        _result;
  String?            _errorMessage;

  final phCtrl         = TextEditingController();
  final moistureCtrl   = TextEditingController();
  final nitrogenCtrl   = TextEditingController();
  final phosphorusCtrl = TextEditingController();
  final potassiumCtrl  = TextEditingController();

  SoilAnalysisStatus get status       => _status;
  SoilResult?        get result       => _result;
  String?            get errorMessage => _errorMessage;

  bool validate() => phCtrl.text.isNotEmpty;

  Future<void> analyze() async {
    if (!validate()) {
      _errorMessage = 'Please enter at least the pH value.';
      notifyListeners(); return;
    }
    _status = SoilAnalysisStatus.loading; _result = null; _errorMessage = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      _result = const SoilResult(soilType: 'Sandy', fertilityLevel: 'Low');
      _status = SoilAnalysisStatus.result;
    } catch (_) {
      _errorMessage = 'Analysis failed. Please try again.';
      _status       = SoilAnalysisStatus.error;
    }
    notifyListeners();
  }

  void reset() {
    _status = SoilAnalysisStatus.idle; _result = null; _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final c in [phCtrl, moistureCtrl, nitrogenCtrl, phosphorusCtrl, potassiumCtrl]) c.dispose();
    super.dispose();
  }
}

class SoilAnalysisScreen extends StatefulWidget {
  const SoilAnalysisScreen({super.key});
  @override
  State<SoilAnalysisScreen> createState() => _SoilAnalysisScreenState();
}

class _SoilAnalysisScreenState extends State<SoilAnalysisScreen> {
  final _ctrl = SoilAnalysisController();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FeatureAppBar(
        title: 'Soil Type Analysis', svgPath: 'assets/images/icons/soil_icon.svg',
      ),
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => _Body(ctrl: _ctrl),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final SoilAnalysisController ctrl;
  const _Body({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Soil Type Analysis',
                  style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text('Analyze soil properties using AI by entering the soil data below',
                  style: tt.bodySmall?.copyWith(color: AppColors.textSubtle)),
              const SizedBox(height: 20),
              _FormCard(ctrl: ctrl),
              const SizedBox(height: 20),
              if (ctrl.status == SoilAnalysisStatus.result && ctrl.result != null)
                _ResultRow(result: ctrl.result!),
              if (ctrl.status == SoilAnalysisStatus.error && ctrl.errorMessage != null) ...[
                const SizedBox(height: 8),
                _ErrorBanner(ctrl.errorMessage!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final SoilAnalysisController ctrl;
  const _FormCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
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
        Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color:        AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            ),
            child: const Icon(Icons.straighten_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Text('Manual Soil Properties Input',
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
        ]),
        const SizedBox(height: 20),

        const _FieldLabel('Soil pH'),        const SizedBox(height: 8),
        _TextField(controller: ctrl.phCtrl,         hint: '6.5'), const SizedBox(height: 16),
        const _FieldLabel('Moisture Level (%)'),     const SizedBox(height: 8),
        _TextField(controller: ctrl.moistureCtrl,   hint: '48'),  const SizedBox(height: 16),
        const _FieldLabel('Nitrogen (N)'),           const SizedBox(height: 8),
        _TextField(controller: ctrl.nitrogenCtrl,   hint: '20'),  const SizedBox(height: 16),
        const _FieldLabel('Phosphorus (P)'),         const SizedBox(height: 8),
        _TextField(controller: ctrl.phosphorusCtrl, hint: '30'),  const SizedBox(height: 16),
        const _FieldLabel('Potassium (K)'),          const SizedBox(height: 8),
        _TextField(controller: ctrl.potassiumCtrl,  hint: '25'),  const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: ctrl.status == SoilAnalysisStatus.loading ? null : ctrl.analyze,
            style: ElevatedButton.styleFrom(
              padding:         const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              elevation: 0,
            ),
            child: ctrl.status == SoilAnalysisStatus.loading
                ? const SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Analyze Soil Properties',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ),
        ),
      ]),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final SoilResult result;
  const _ResultRow({required this.result});

  Color get _fertilityColor {
    switch (result.fertilityLevel) {
      case 'High':     return AppColors.primary;
      case 'Moderate': return AppColors.warning;
      default:         return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt             = Theme.of(context).textTheme;
    final fertilityColor = _fertilityColor;

    Widget card({required String label, required Widget content}) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color:        AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: const Icon(Icons.straighten_outlined, color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: 8),
          Text(label, style: tt.bodySmall?.copyWith(color: AppColors.textSubtle)),
        ]),
        const SizedBox(height: 12),
        content,
      ]),
    );

    return Row(children: [
      Expanded(child: card(
        label: 'Soil Type',
        content: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:        AppColors.primarySurface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            border:       Border.all(color: AppColors.primary.withOpacity(0.25)),
          ),
          child: Center(child: Text(result.soilType,
              style: tt.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600))),
        ),
      )),
      const SizedBox(width: 12),
      Expanded(child: card(
        label: 'Fertility Level',
        content: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:        fertilityColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            border:       Border.all(color: fertilityColor.withOpacity(0.3)),
          ),
          child: Center(child: Text(result.fertilityLevel,
              style: tt.titleSmall?.copyWith(color: fertilityColor, fontWeight: FontWeight.w600))),
        ),
      )),
    ]);
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textDark));
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String                hint;
  const _TextField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textDisabled),
        filled: true, fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border:        OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMid), borderSide: const BorderSide(color: AppColors.cardBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMid), borderSide: const BorderSide(color: AppColors.cardBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMid), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
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
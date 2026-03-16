import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

enum CropRecommendationStatus { idle, loading, result, error }

class CropResult {
  final String crop, yieldLevel, explanation;

  const CropResult(
      {required this.crop,
      required this.yieldLevel,
      required this.explanation});
}

class CropRecommendationController extends ChangeNotifier {
  CropRecommendationStatus _status = CropRecommendationStatus.idle;
  CropResult? _result;
  String? _errorMessage;
  String _selectedSoilType = 'Sandy';

  final temperatureCtrl = TextEditingController();
  final humidityCtrl = TextEditingController();
  final rainfallCtrl = TextEditingController();

  static const List<String> soilTypes = [
    'Sandy',
    'Loamy',
    'Clay',
    'Silt',
    'Peaty',
    'Saline'
  ];

  CropRecommendationStatus get status => _status;

  CropResult? get result => _result;

  String? get errorMessage => _errorMessage;

  String get selectedSoilType => _selectedSoilType;

  void setSoilType(String t) {
    _selectedSoilType = t;
    notifyListeners();
  }

  bool validate() =>
      temperatureCtrl.text.isNotEmpty &&
      humidityCtrl.text.isNotEmpty &&
      rainfallCtrl.text.isNotEmpty;

  Future<void> recommend() async {
    _status = CropRecommendationStatus.loading;
    _result = null;
    _errorMessage = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      final temp = temperatureCtrl.text,
          humidity = humidityCtrl.text,
          rainfall = rainfallCtrl.text;
      _result = CropResult(
        crop: 'Cotton',
        yieldLevel: 'Medium',
        explanation: 'Based on the provided climate and soil conditions '
            '(Temperature: ${temp}°C, Humidity: $humidity%, '
            'Rainfall: ${rainfall}mm), Cotton is recommended with '
            'an expected medium yield potential.',
      );
      _status = CropRecommendationStatus.result;
    } catch (_) {
      _errorMessage = 'Failed to get recommendation. Please try again.';
      _status = CropRecommendationStatus.error;
    }
    notifyListeners();
  }

  void reset() {
    _status = CropRecommendationStatus.idle;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    temperatureCtrl.dispose();
    humidityCtrl.dispose();
    rainfallCtrl.dispose();
    super.dispose();
  }
}

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  final _ctrl = CropRecommendationController();
  String? _validationError;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_ctrl.validate()) {
      setState(() => _validationError =
          'Please fill in Temperature, Humidity, and Rainfall.');
      return;
    }
    setState(() => _validationError = null);
    _ctrl.recommend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => _Body(
          ctrl: _ctrl,
          onSubmit: _submit,
          validationError: _validationError,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final CropRecommendationController ctrl;
  final VoidCallback onSubmit;
  final String? validationError;

  const _Body(
      {required this.ctrl, required this.onSubmit, this.validationError});

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
              _FormCard(
                  ctrl: ctrl,
                  onSubmit: onSubmit,
                  validationError: validationError),
              const SizedBox(height: 20),
              if (ctrl.status == CropRecommendationStatus.result &&
                  ctrl.result != null)
                _ResultCard(result: ctrl.result!),
              if (ctrl.status == CropRecommendationStatus.error &&
                  ctrl.errorMessage != null) ...[
                const SizedBox(height: 20),
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
  final CropRecommendationController ctrl;
  final VoidCallback onSubmit;
  final String? validationError;

  const _FormCard(
      {required this.ctrl, required this.onSubmit, this.validationError});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              ),
              child: const Icon(Icons.eco_outlined,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Text('Environmental Parameters',
                style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.textDark)),
          ]),
          const SizedBox(height: 20),
          const _FieldLabel('Temperature (°C)'),
          const SizedBox(height: 8),
          _TextField(
              controller: ctrl.temperatureCtrl,
              hint: '25',
              type: TextInputType.number),
          const SizedBox(height: 16),
          const _FieldLabel('Humidity (%)'),
          const SizedBox(height: 8),
          _TextField(
              controller: ctrl.humidityCtrl,
              hint: '65',
              type: TextInputType.number),
          const SizedBox(height: 16),
          const _FieldLabel('Rainfall (mm)'),
          const SizedBox(height: 8),
          _TextField(
              controller: ctrl.rainfallCtrl,
              hint: '120',
              type: TextInputType.number),
          const SizedBox(height: 16),
          const _FieldLabel('Soil Type'),
          const SizedBox(height: 8),
          _SoilDropdown(ctrl: ctrl),
          const SizedBox(height: 20),
          if (validationError != null) ...[
            _ErrorBanner(validationError!),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ctrl.status == CropRecommendationStatus.loading
                  ? null
                  : onSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                elevation: 0,
              ),
              child: ctrl.status == CropRecommendationStatus.loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Recommend Crop',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoilDropdown extends StatelessWidget {
  final CropRecommendationController ctrl;

  const _SoilDropdown({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: ctrl.selectedSoilType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSubtle),
          style: const TextStyle(fontSize: 14, color: AppColors.textDark),
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          items: CropRecommendationController.soilTypes
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) {
            if (v != null) ctrl.setSoilType(v);
          },
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final CropResult result;

  const _ResultCard({required this.result});

  Color get _yieldColor {
    switch (result.yieldLevel) {
      case 'High':
        return AppColors.primary;
      case 'Medium':
        return AppColors.warning;
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recommendation Result',
              style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              border: Border.all(color: AppColors.primary.withOpacity(0.25)),
            ),
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: const Icon(Icons.eco_outlined,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Recommended Crop',
                    style: tt.bodySmall?.copyWith(color: AppColors.primary)),
                const SizedBox(height: 2),
                Text(result.crop,
                    style: tt.titleMedium?.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700)),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: RichText(
              text: TextSpan(
                style: tt.bodyMedium?.copyWith(color: AppColors.textDark),
                children: [
                  const TextSpan(
                      text: 'Expected Yield Level: ',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(
                      text: result.yieldLevel,
                      style: TextStyle(
                          color: _yieldColor, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Text(result.explanation,
                style: tt.bodySmall
                    ?.copyWith(color: AppColors.textSubtle, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: AppColors.textDark));
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType type;

  const _TextField(
      {required this.controller, required this.hint, required this.type});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textDisabled),
        filled: true,
        fillColor: AppColors.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            borderSide: const BorderSide(color: AppColors.cardBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            borderSide: const BorderSide(color: AppColors.cardBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
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
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(children: [
        const Icon(Icons.error_outline, size: 16, color: AppColors.error),
        const SizedBox(width: 8),
        Expanded(
            child: Text(message,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.error))),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../widgets/onboarding/welcome_step.dart';
import '../widgets/onboarding/settings_step.dart';
import '../widgets/onboarding/account_step.dart';
import '../widgets/onboarding/categories_step.dart';
import '../widgets/onboarding/completion_step.dart';
import '../../data/repositories/app_settings_repository_impl.dart';

/// OnboardingScreen - Multi-step welcome tour for first-time users
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  late PageController _pageController;

  // Form data to persist across steps
  String? _accountName;
  bool _accountIsDebit = true;
  bool _accountIsCredit = false;
  double _accountBalance = 0.0;
  double _accountCreditLimit = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentStep,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    try {
      // Update the hasCompletedOnboarding flag
      final appSettingsRepository = AppSettingsRepositoryImpl();
      await appSettingsRepository.updateHasCompletedOnboarding(true);

      // The MaterialApp will automatically rebuild and show MainScreen
      // because the appSettingsStreamProvider will emit the updated settings
      // No need to navigate - the reactive system will handle it
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao finalizar onboarding: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _goToNextStep() {
    if (_currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pular Onboarding?'),
        content: const Text(
          'Você pode configurar essas informações mais tarde nas configurações do app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _completeOnboarding();
            },
            child: const Text('Pular'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentStep = index;
            });
          },
          children: [
            // Step 0: Welcome
            WelcomeStep(
              onContinue: _goToNextStep,
              onSkip: _skipOnboarding,
            ),

            // Step 1: Settings (Salary, Reserve, Percentage)
            SettingsStep(
              onContinue: _goToNextStep,
              onBack: _goToPreviousStep,
            ),

            // Step 2: Account Creation
            AccountStep(
              onContinue: _goToNextStep,
              onBack: _goToPreviousStep,
              onAccountDataChanged: (name, isDebit, isCredit, balance, creditLimit) {
                setState(() {
                  _accountName = name;
                  _accountIsDebit = isDebit;
                  _accountIsCredit = isCredit;
                  _accountBalance = balance;
                  _accountCreditLimit = creditLimit;
                });
              },
            ),

            // Step 3: Categories Review
            CategoriesStep(
              onContinue: _goToNextStep,
              onBack: _goToPreviousStep,
            ),

            // Step 4: Completion
            CompletionStep(
              onComplete: _completeOnboarding,
              onBack: _goToPreviousStep,
            ),
          ],
        ),
      ),
      // Progress indicator
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        color: AppColors.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm / 2,
                  ),
                  width: _currentStep == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentStep == index
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Passo ${_currentStep + 1} de 5',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

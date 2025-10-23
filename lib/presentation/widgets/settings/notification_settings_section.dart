import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/parsers/notification_parser_registry.dart';

/// Settings section for configuring notification capture features
///
/// Allows users to enable/disable automatic transaction capture from bank notifications
/// and shows which banks are currently supported.
class NotificationSettingsSection extends StatefulWidget {
  const NotificationSettingsSection({super.key});

  @override
  State<NotificationSettingsSection> createState() =>
      _NotificationSettingsSectionState();
}

class _NotificationSettingsSectionState
    extends State<NotificationSettingsSection> {
  bool _isAutoCaptureEnabled = false;
  bool _hasPermission = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final hasPermission = await NotificationService.hasPermission();
    if (mounted) {
      setState(() {
        _hasPermission = hasPermission;
        _isLoading = false;
      });
    }
  }

  Future<void> _openPermissionSettings() async {
    await NotificationService.openPermissionSettings();
    // Recheck permission after user returns from settings
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      _checkNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final registry = NotificationParserRegistry();
    final supportedBanks = registry.supportedBanks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'Captura Automática de Transações',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Description
        Text(
          'Detecte automaticamente compras aprovadas de suas contas bancárias e adicione-as ao app rapidamente.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Toggle for auto-capture
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SwitchListTile(
            value: _isAutoCaptureEnabled,
            onChanged: (value) {
              setState(() {
                _isAutoCaptureEnabled = value;
              });

              if (value && !_hasPermission) {
                // Prompt user to grant permission
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'É necessário conceder permissão para acessar notificações.',
                    ),
                    action: SnackBarAction(
                      label: 'Configurar',
                      onPressed: _openPermissionSettings,
                    ),
                  ),
                );
              }
            },
            title: const Text('Ativar captura automática'),
            subtitle: Text(
              _isLoading
                  ? 'Verificando permissão...'
                  : _hasPermission
                      ? 'Permissão concedida'
                      : 'Permissão necessária',
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.md),
          ),
        ),

        if (!_hasPermission && _isAutoCaptureEnabled) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.warningWithOpacity,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColors.warning),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.warning),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Permissão Necessária',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Para usar captura automática, conceda acesso às notificações.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.warning,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openPermissionSettings,
              icon: const Icon(Icons.security),
              label: const Text('Abrir Configurações'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],

        const SizedBox(height: AppSpacing.lg),

        // Supported banks section
        if (supportedBanks.isNotEmpty) ...[
          Text(
            'Bancos Suportados (${supportedBanks.length})',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColors.border),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: supportedBanks.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColors.border,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final bankName = supportedBanks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          bankName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Novos bancos serão adicionados em futuras atualizações.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ] else
          Text(
            'Nenhum banco suportado no momento. Novos bancos estarão disponíveis em breve.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/repository_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Toggle button for marking invoices as paid/unpaid
///
/// **F17-T2 Implementation**: Invoice Payment Toggle
///
/// Shows "Pagar Fatura" when unpaid, "Desmarcar como Pago" when paid.
/// Displays confirmation dialogs before changing payment status.
class InvoicePaymentButton extends ConsumerWidget {
  final int? invoiceId;
  final bool isPaid;
  final VoidCallback? onPaymentStatusChanged;

  const InvoicePaymentButton({
    super.key,
    required this.invoiceId,
    required this.isPaid,
    this.onPaymentStatusChanged,
  });

  Future<void> _handlePaymentToggle(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (invoiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fatura não encontrada'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          isPaid
              ? 'Desmarcar Fatura como Paga?'
              : 'Confirmar Pagamento da Fatura?',
        ),
        content: Text(
          isPaid
              ? 'Tem certeza que deseja desmarcar esta fatura como paga?'
              : 'Tem certeza que deseja marcar esta fatura como paga?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isPaid ? AppColors.warning : AppColors.success,
            ),
            child: Text(isPaid ? 'Desmarcar' : 'Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final invoiceRepo = ref.read(invoiceRepositoryProvider);

      if (isPaid) {
        await invoiceRepo.unmarkPaid(invoiceId!);
      } else {
        await invoiceRepo.markAsPaid(invoiceId!);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPaid
                  ? 'Fatura desmarcada como paga'
                  : 'Fatura marcada como paga',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }

      // Call callback if provided
      onPaymentStatusChanged?.call();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar status: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If no invoice exists, show disabled button
    if (invoiceId == null) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.receipt_outlined),
          label: const Text('Sem Fatura'),
          onPressed: null, // disabled
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            disabledBackgroundColor: AppColors.surfaceVariant,
            disabledForegroundColor: AppColors.textSecondary,
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: isPaid
          ? OutlinedButton.icon(
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Desmarcar como Pago'),
              onPressed: () => _handlePaymentToggle(context, ref),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                side: const BorderSide(
                  color: AppColors.warning,
                  width: 2,
                ),
                foregroundColor: AppColors.warning,
              ),
            )
          : OutlinedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Pagar Fatura'),
              onPressed: () => _handlePaymentToggle(context, ref),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                side: const BorderSide(
                  color: AppColors.success,
                  width: 2,
                ),
                foregroundColor: AppColors.success,
              ),
            ),
    );
  }
}

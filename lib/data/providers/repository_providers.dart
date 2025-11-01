import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/i_account_repository.dart';
import '../../domain/repositories/i_app_settings_repository.dart';
import '../../domain/repositories/i_category_repository.dart';
import '../../domain/repositories/i_recurring_expense_repository.dart';
import '../../domain/repositories/i_transaction_repository.dart';
import '../../domain/repositories/i_backup_repository.dart';
import '../../domain/repositories/i_invoice_repository.dart';
import '../repositories/account_repository_impl.dart';
import '../repositories/app_settings_repository_impl.dart';
import '../repositories/category_repository_impl.dart';
import '../repositories/recurring_expense_repository_impl.dart';
import '../repositories/transaction_repository_impl.dart';
import '../repositories/invoice_repository_impl.dart';
import '../repositories/backup_repository_impl.dart';

/// Provider for TransactionRepository
/// Provides access to transaction CRUD operations and queries
final transactionRepositoryProvider = Provider<ITransactionRepository>((ref) {
  return TransactionRepositoryImpl();
});

/// Provider for AccountRepository
/// Provides access to account CRUD operations and balance management
final accountRepositoryProvider = Provider<IAccountRepository>((ref) {
  return AccountRepositoryImpl();
});

/// Provider for RecurringExpenseRepository
/// Provides access to recurring expense CRUD operations and queries
final recurringExpenseRepositoryProvider =
    Provider<IRecurringExpenseRepository>((ref) {
  return RecurringExpenseRepositoryImpl();
});

/// Provider for CategoryRepository
/// Provides access to category CRUD operations and seeding
final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  return CategoryRepositoryImpl();
});

/// Provider for AppSettingsRepository
/// Provides access to app-wide settings management
final appSettingsRepositoryProvider = Provider<IAppSettingsRepository>((ref) {
  return AppSettingsRepositoryImpl();
});

/// Provider for BackupRepository
/// Provides access to backup and restore operations
final backupRepositoryProvider = Provider<IBackupRepository>((ref) {
  return BackupRepositoryImpl();
});

/// Provider for InvoiceRepository
/// Provides access to invoice CRUD operations and billing cycle management
final invoiceRepositoryProvider = Provider<IInvoiceRepository>((ref) {
  return InvoiceRepositoryImpl();
});

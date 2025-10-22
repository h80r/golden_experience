import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/repositories/i_backup_repository.dart';
import '../datasources/local_database.dart';
import '../database/transactions_table.dart';
import '../database/accounts_table.dart';
import '../database/categories_table.dart';
import '../database/recurring_expenses_table.dart';
import '../database/app_settings_table.dart';

/// Implementation of IBackupRepository using Drift database
class BackupRepositoryImpl implements IBackupRepository {
  final LocalDatabase _db = LocalDatabase.instance;

  @override
  Future<String> exportToJson() async {
    try {
      // Fetch all data from all tables
      final transactions = await _db.select(_db.transactions).get();
      final accounts = await _db.select(_db.accounts).get();
      final categories = await _db.select(_db.categories).get();
      final recurringExpenses = await _db.select(_db.recurringExpenses).get();
      final appSettings = await _db.select(_db.appSettings).get();

      // Convert all data to JSON-serializable format
      final backupData = {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'tables': {
          'transactions': transactions.map((t) => t.toJson()).toList(),
          'accounts': accounts.map((a) => a.toJson()).toList(),
          'categories': categories.map((c) => c.toJson()).toList(),
          'recurringExpenses':
              recurringExpenses.map((r) => r.toJson()).toList(),
          'appSettings': appSettings.map((s) => s.toJson()).toList(),
        },
      };

      // Convert to pretty JSON string
      return const JsonEncoder.withIndent('  ').convert(backupData);
    } catch (e) {
      throw Exception('Erro ao exportar dados: $e');
    }
  }

  @override
  Future<void> importFromJson(String jsonData) async {
    try {
      // Parse JSON
      final parsed = jsonDecode(jsonData) as Map<String, dynamic>;

      // Validate version compatibility
      final version = parsed['version'] ?? '1.0';
      if (version != '1.0') {
        throw Exception('Versão de backup não suportada: $version');
      }

      final tables = parsed['tables'] as Map<String, dynamic>;

      // Clear all tables to avoid conflicts
      await _db.delete(_db.transactions).go();
      await _db.delete(_db.recurringExpenses).go();
      await _db.delete(_db.accounts).go();
      await _db.delete(_db.categories).go();
      await _db.delete(_db.appSettings).go();

      // Import categories first (referenced by other tables)
      if (tables['categories'] != null) {
        final categories = tables['categories'] as List;
        for (final categoryJson in categories) {
          final categoryData = categoryJson as Map<String, dynamic>;
          final companion = CategoryModelCompanion(
            id: Value(categoryData['id'] as int),
            name: Value(categoryData['name'] as String),
          );
          await _db.into(_db.categories).insert(companion);
        }
      }

      // Import accounts (referenced by transactions and recurring expenses)
      if (tables['accounts'] != null) {
        final accounts = tables['accounts'] as List;
        for (final accountJson in accounts) {
          final accountData = accountJson as Map<String, dynamic>;

          // Handle both old (single-type) and new (dual-type) format
          bool isDebit, isCredit;
          double balance, creditLimit, creditUsed = 0.0;

          if (accountData.containsKey('type')) {
            // Old format: single type (enum string)
            final accountTypeStr = accountData['type'] as String;
            isDebit = accountTypeStr == 'debit';
            isCredit = accountTypeStr == 'credit';
            balance = (accountData['initialBalance'] as num?)?.toDouble() ?? 0.0;
            creditLimit = (accountData['creditLimit'] as num?)?.toDouble() ?? 0.0;
            creditUsed = 0.0;
          } else {
            // New format: dual-type (boolean fields)
            isDebit = (accountData['isDebit'] as bool?) ?? false;
            isCredit = (accountData['isCredit'] as bool?) ?? false;
            balance = (accountData['balance'] as num?)?.toDouble() ?? 0.0;
            creditLimit = (accountData['creditLimit'] as num?)?.toDouble() ?? 0.0;
            creditUsed = (accountData['creditUsed'] as num?)?.toDouble() ?? 0.0;
          }

          final companion = AccountModelCompanion(
            id: Value(accountData['id'] as int),
            name: Value(accountData['name'] as String),
            isDebit: Value(isDebit),
            isCredit: Value(isCredit),
            balance: Value(balance),
            creditLimit: Value(creditLimit),
            creditUsed: Value(creditUsed),
          );
          await _db.into(_db.accounts).insert(companion);
        }
      }

      // Import transactions
      if (tables['transactions'] != null) {
        final transactions = tables['transactions'] as List;
        for (final transactionJson in transactions) {
          final transactionData = transactionJson as Map<String, dynamic>;
          final companion = TransactionModelCompanion(
            id: Value(transactionData['id'] as int),
            value: Value((transactionData['value'] as num).toDouble()),
            description: Value(transactionData['description'] as String),
            date: Value(DateTime.parse(transactionData['date'] as String)),
            notes: transactionData['notes'] != null
                ? Value(transactionData['notes'] as String)
                : const Value.absent(),
            accountId: Value(transactionData['accountId'] as int),
            categoryId: Value(transactionData['categoryId'] as int),
          );
          await _db.into(_db.transactions).insert(companion);
        }
      }

      // Import recurring expenses
      if (tables['recurringExpenses'] != null) {
        final recurringExpenses = tables['recurringExpenses'] as List;
        for (final recurringJson in recurringExpenses) {
          final recurringData = recurringJson as Map<String, dynamic>;
          final companion = RecurringExpenseModelCompanion(
            id: Value(recurringData['id'] as int),
            value: Value((recurringData['value'] as num).toDouble()),
            description: Value(recurringData['description'] as String),
            chargeDay: Value(recurringData['chargeDay'] as int),
            accountId: Value(recurringData['accountId'] as int),
            categoryId: Value(recurringData['categoryId'] as int),
          );
          await _db.into(_db.recurringExpenses).insert(companion);
        }
      }

      // Import app settings
      if (tables['appSettings'] != null) {
        final appSettings = tables['appSettings'] as List;
        for (final settingJson in appSettings) {
          final settingData = settingJson as Map<String, dynamic>;
          final companion = AppSettingsModelCompanion(
            id: Value(settingData['id'] as int),
            monthlySalary: Value((settingData['monthlySalary'] as num).toDouble()),
            reserveBalance: Value((settingData['reserveBalance'] as num).toDouble()),
            maxReserveUsagePercentage: Value((settingData['maxReserveUsagePercentage'] as num).toDouble()),
            lastRecurringCheck: Value(DateTime.parse(settingData['lastRecurringCheck'] as String)),
          );
          await _db.into(_db.appSettings).insert(companion);
        }
      }
    } catch (e) {
      throw Exception('Erro ao importar dados: $e');
    }
  }

  @override
  Future<String> getDefaultBackupPath() async {
    try {
      // Try to get documents directory for more accessible backup
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final backupDir =
          Directory('${documentsDirectory.path}/backups');

      // Create backups directory if it doesn't exist
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return '${backupDir.path}/golden_experience_backup_$timestamp.json';
    } catch (e) {
      throw Exception('Erro ao determinar local de backup: $e');
    }
  }
}

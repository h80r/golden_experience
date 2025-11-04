import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/i_transaction_repository.dart';
import '../../core/utils/billing_cycle_utils.dart';
import '../datasources/local_database.dart';

/// Implementation of ITransactionRepository using Drift database
class TransactionRepositoryImpl implements ITransactionRepository {
  final LocalDatabase _db = LocalDatabase.instance;

  @override
  Future<int> create(Insertable<TransactionModel> transaction) async {
    return await _db.into(_db.transactions).insert(transaction);
  }

  @override
  Future<TransactionModel?> getById(int id) async {
    return await (_db.select(_db.transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<List<TransactionModel>> getAll() async {
    return await _db.select(_db.transactions).get();
  }

  @override
  Future<List<TransactionModel>> getByMonth(int month, int year) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1).subtract(Duration(seconds: 1));

    return await (_db.select(_db.transactions)
          ..where((t) => t.date.isBetweenValues(startDate, endDate)))
        .get();
  }

  @override
  Future<bool> update(Insertable<TransactionModel> transaction) async {
    try {
      final result = await _db.update(_db.transactions).replace(transaction);
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      final result = await (_db.delete(_db.transactions)
            ..where((t) => t.id.equals(id)))
          .go();
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<TransactionModel>> watchAll() {
    return _db.select(_db.transactions).watch();
  }

  @override
  Stream<List<TransactionModel>> watchCurrentMonth() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate =
        DateTime(now.year, now.month + 1, 1).subtract(Duration(seconds: 1));

    return (_db.select(_db.transactions)
          ..where((t) => t.date.isBetweenValues(startDate, endDate)))
        .watch();
  }

  @override
  Future<List<TransactionModel>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Normalize to start of day for startDate and end of day for endDate
    final normalizedStart =
        DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEnd =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return await (_db.select(_db.transactions)
          ..where(
              (t) => t.date.isBetweenValues(normalizedStart, normalizedEnd)))
        .get();
  }

  @override
  Stream<List<TransactionModel>> watchByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    // Normalize to start of day for startDate and end of day for endDate
    final normalizedStart =
        DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEnd =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return (_db.select(_db.transactions)
          ..where(
              (t) => t.date.isBetweenValues(normalizedStart, normalizedEnd)))
        .watch();
  }

  @override
  Future<List<TransactionModel>> getByAccountAndDateRange(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Normalize to start of day for startDate and end of day for endDate
    final normalizedStart =
        DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEnd =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return await (_db.select(_db.transactions)
          ..where((t) =>
              t.accountId.equals(accountId) &
              t.date.isBetweenValues(normalizedStart, normalizedEnd)))
        .get();
  }

  @override
  Stream<List<TransactionModel>> watchByAccountAndDateRange(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  ) {
    // Normalize to start of day for startDate and end of day for endDate
    final normalizedStart =
        DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEnd =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return (_db.select(_db.transactions)
          ..where((t) =>
              t.accountId.equals(accountId) &
              t.date.isBetweenValues(normalizedStart, normalizedEnd)))
        .watch();
  }

  @override
  Future<String> createInstallmentTransactions({
    required Insertable<TransactionModel> transaction,
    required int currentInstallment,
    required int totalInstallments,
    required int accountId,
  }) async {
    // Generate UUID for the installment group
    const uuid = Uuid();
    final installmentGroupId = uuid.v4();

    // Get account to access creditPaymentDay
    final account = await (_db.select(_db.accounts)
          ..where((a) => a.id.equals(accountId)))
        .getSingleOrNull();

    if (account == null) {
      throw Exception('Account not found: $accountId');
    }

    if (!account.isCredit || account.creditPaymentDay == null) {
      throw Exception(
          'Account must be a credit account with creditPaymentDay set');
    }

    final paymentDay = account.creditPaymentDay!;

    // Convert transaction to companion for manipulation
    final transactionData = transaction as TransactionModelCompanion;

    // Get the base transaction date
    final baseDate = transactionData.date.value;

    // Extract the base description
    final baseDescription = transactionData.description.value;

    // Calculate number of future installments to create
    final remainingInstallments = totalInstallments - currentInstallment;

    // Create current transaction with installment metadata
    await _db.into(_db.transactions).insert(
          TransactionModelCompanion(
            value: transactionData.value,
            description: Value('$baseDescription $currentInstallment/$totalInstallments'),
            date: transactionData.date,
            notes: transactionData.notes,
            accountId: transactionData.accountId,
            categoryId: transactionData.categoryId,
            transactionType: transactionData.transactionType,
            installmentNumber: Value(currentInstallment),
            installmentTotal: Value(totalInstallments),
            installmentGroupId: Value(installmentGroupId),
          ),
        );

    // Create future installments
    for (int i = 1; i <= remainingInstallments; i++) {
      final installmentNumber = currentInstallment + i;

      // Calculate the date for this future installment
      // Place it on the first day of the next billing cycle
      final futureDate = _calculateNextCycleStartDate(
        baseDate,
        paymentDay,
        cyclesAhead: i,
      );

      await _db.into(_db.transactions).insert(
            TransactionModelCompanion(
              value: transactionData.value,
              description: Value('$baseDescription $installmentNumber/$totalInstallments'),
              date: Value(futureDate),
              notes: transactionData.notes,
              accountId: transactionData.accountId,
              categoryId: transactionData.categoryId,
              transactionType: transactionData.transactionType,
              installmentNumber: Value(installmentNumber),
              installmentTotal: Value(totalInstallments),
              installmentGroupId: Value(installmentGroupId),
            ),
          );
    }

    return installmentGroupId;
  }

  @override
  Future<int> deleteInstallmentGroup(String installmentGroupId) async {
    return await (_db.delete(_db.transactions)
          ..where((t) => t.installmentGroupId.equals(installmentGroupId)))
        .go();
  }

  @override
  Future<List<TransactionModel>> getByInstallmentGroup(
      String installmentGroupId) async {
    return await (_db.select(_db.transactions)
          ..where((t) => t.installmentGroupId.equals(installmentGroupId))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  /// Calculates the start date of the next billing cycle(s)
  ///
  /// Uses billing_cycle_utils to calculate future billing cycle start dates
  /// based on the payment day and number of cycles ahead.
  ///
  /// Parameters:
  /// - [currentDate]: The reference date (usually the current transaction date)
  /// - [paymentDay]: The payment day of the credit card (1-31)
  /// - [cyclesAhead]: How many billing cycles ahead (1 for next cycle, 2 for cycle after, etc.)
  ///
  /// Returns the first day of the target billing cycle
  DateTime _calculateNextCycleStartDate(
    DateTime currentDate,
    int paymentDay, {
    required int cyclesAhead,
  }) {
    // Get the current billing cycle
    final currentCycle =
        calculateCurrentBillingCycleFromPaymentDay(paymentDay, currentDate);

    // Calculate the target cycle by adding months
    // Start from the end of the current cycle and move forward
    DateTime targetDate = currentCycle.end;

    for (int i = 0; i < cyclesAhead; i++) {
      // Move to next month's cycle
      final nextMonth = targetDate.month == 12 ? 1 : targetDate.month + 1;
      final nextYear = targetDate.month == 12 ? targetDate.year + 1 : targetDate.year;
      final nextCycle = calculateCurrentBillingCycleFromPaymentDay(
        paymentDay,
        DateTime(nextYear, nextMonth, 1),
      );
      targetDate = nextCycle.end;
    }

    // Return the start of the final target cycle
    final finalCycle = calculateCurrentBillingCycleFromPaymentDay(
      paymentDay,
      targetDate,
    );

    return finalCycle.start;
  }
}

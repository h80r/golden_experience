import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/utils/billing_cycle_utils.dart';
import '../../domain/repositories/i_invoice_repository.dart';
import '../datasources/local_database.dart';

/// Implementation of IInvoiceRepository using Drift database
///
/// **F17-T1 Implementation**: Invoice Manager with Time Navigation
///
/// This simplified repository implementation focuses on basic CRUD operations
/// for invoice periods without storing calculated values. All monetary
/// calculations are handled in the presentation layer via providers.
class InvoiceRepositoryImpl implements IInvoiceRepository {
  final LocalDatabase _db = LocalDatabase.instance;

  @override
  Future<int> create({
    required DateTime startDate,
    required DateTime endDate,
    bool isPaid = false,
  }) async {
    try {
      final invoiceId = await _db.into(_db.invoices).insert(
            InvoiceModelCompanion.insert(
              startDate: startDate,
              endDate: endDate,
              isPaid: Value(isPaid),
            ),
          );
      return invoiceId;
    } catch (e) {
      throw Exception('Failed to create invoice: $e');
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      final result =
          await (_db.delete(_db.invoices)..where((i) => i.id.equals(id))).go();
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<InvoiceModel>> getAll() async {
    return await (_db.select(_db.invoices)
          ..orderBy([
            (i) => OrderingTerm(
                  expression: i.startDate,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
  }

  @override
  Future<List<InvoiceModel>> getAllWithTransactions() async {
    // Get all invoices
    final allInvoices = await (_db.select(_db.invoices)
          ..orderBy([
            (i) => OrderingTerm(
                  expression: i.startDate,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();

    // Filter invoices that have transactions
    final invoicesWithTransactions = <InvoiceModel>[];

    for (final invoice in allInvoices) {
      final hasTransactions = await _hasTransactionsInPeriod(
        invoice.startDate,
        invoice.endDate,
      );
      if (hasTransactions) {
        invoicesWithTransactions.add(invoice);
      }
    }

    return invoicesWithTransactions;
  }

  @override
  Future<InvoiceModel?> getById(int id) async {
    return await (_db.select(_db.invoices)..where((i) => i.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<InvoiceModel?> getByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await (_db.select(_db.invoices)
          ..where(
              (i) => i.startDate.equals(startDate) & i.endDate.equals(endDate)))
        .getSingleOrNull();
  }

  @override
  Future<InvoiceModel?> getFirstUnpaidOrFirst() async {
    // Try to get first unpaid invoice
    final firstUnpaid = await (_db.select(_db.invoices)
          ..where((i) => i.isPaid.equals(false))
          ..orderBy([
            (i) => OrderingTerm(
                  expression: i.startDate,
                  mode: OrderingMode.asc,
                )
          ])
          ..limit(1))
        .getSingleOrNull();

    if (firstUnpaid != null) {
      return firstUnpaid;
    }

    // If all are paid (or no invoices), return the most recent one
    return await (_db.select(_db.invoices)
          ..orderBy([
            (i) => OrderingTerm(
                  expression: i.startDate,
                  mode: OrderingMode.desc,
                )
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<bool> markAsPaid(int invoiceId) async {
    try {
      final result = await (_db.update(_db.invoices)
            ..where((i) => i.id.equals(invoiceId)))
          .write(
        const InvoiceModelCompanion(
          isPaid: Value(true),
        ),
      );
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> recalculateUnpaidInvoiceDates() async {
    try {
      debugPrint(
          '[INVOICE_RECALC] ========== Starting recalculation ==========');

      // Get all unpaid invoices
      final unpaidInvoices = await (_db.select(_db.invoices)
            ..where((i) => i.isPaid.equals(false)))
          .get();

      debugPrint(
          '[INVOICE_RECALC] Found ${unpaidInvoices.length} unpaid invoices');

      if (unpaidInvoices.isEmpty) {
        debugPrint('[INVOICE_RECALC] No unpaid invoices to recalculate');
        return 0;
      }

      // Get all credit accounts
      final accounts = await _db.select(_db.accounts).get();
      final creditAccounts = accounts.where((a) => a.isCredit).toList();

      debugPrint(
          '[INVOICE_RECALC] Found ${creditAccounts.length} credit accounts');
      for (final acc in creditAccounts) {
        debugPrint(
            '[INVOICE_RECALC]   - ${acc.name}: paymentDay=${acc.creditPaymentDay}');
      }

      if (creditAccounts.isEmpty) {
        debugPrint('[INVOICE_RECALC] No credit accounts found');
        return 0;
      }

      int updatedCount = 0;

      // For each unpaid invoice, recalculate its period
      for (final invoice in unpaidInvoices) {
        debugPrint('[INVOICE_RECALC] Processing invoice ${invoice.id}:');
        debugPrint(
            '[INVOICE_RECALC]   Current period: ${invoice.startDate} to ${invoice.endDate}');
        debugPrint('[INVOICE_RECALC]   isPaid: ${invoice.isPaid}');

        // Skip invoices that have transactions - those periods are "locked"
        // Only recalculate empty future invoices
        final hasTransactions = await _hasTransactionsInPeriod(
          invoice.startDate,
          invoice.endDate,
        );

        debugPrint('[INVOICE_RECALC]   Has transactions: $hasTransactions');

        // Use the middle of the invoice period as a reference point to identify which cycle it represents
        final midPoint = invoice.startDate.add(
          Duration(
            days: (invoice.endDate.difference(invoice.startDate).inDays / 2)
                .round(),
          ),
        );

        debugPrint('[INVOICE_RECALC]   Midpoint reference: $midPoint');

        // Calculate what the period should be based on current card settings
        final newPeriod =
            calculateUnifiedInvoicePeriod(creditAccounts, midPoint);

        if (newPeriod == null) {
          debugPrint('[INVOICE_RECALC]   ❌ Could not calculate new period');
          continue;
        }

        debugPrint(
            '[INVOICE_RECALC]   New period would be: ${newPeriod.start} to ${newPeriod.end}');

        // Only update if dates have changed
        if (newPeriod.start != invoice.startDate ||
            newPeriod.end != invoice.endDate) {
          debugPrint('[INVOICE_RECALC]   ✅ UPDATING invoice dates');
          await (_db.update(_db.invoices)
                ..where((i) => i.id.equals(invoice.id)))
              .write(
            InvoiceModelCompanion(
              startDate: Value(newPeriod.start),
              endDate: Value(newPeriod.end),
            ),
          );
          updatedCount++;
        } else {
          debugPrint(
              '[INVOICE_RECALC]   ℹ️ No change needed - dates are the same');
        }
      }

      debugPrint(
          '[INVOICE_RECALC] ========== Recalculation complete: $updatedCount updated ==========');
      return updatedCount;
    } catch (e) {
      debugPrint('[INVOICE_RECALC] ❌ ERROR: $e');
      throw Exception('Failed to recalculate invoice dates: $e');
    }
  }

  @override
  Future<bool> unmarkPaid(int invoiceId) async {
    try {
      final result = await (_db.update(_db.invoices)
            ..where((i) => i.id.equals(invoiceId)))
          .write(
        const InvoiceModelCompanion(
          isPaid: Value(false),
        ),
      );
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<InvoiceModel>> watchAll() {
    return (_db.select(_db.invoices)
          ..orderBy([
            (i) => OrderingTerm(
                  expression: i.startDate,
                  mode: OrderingMode.desc,
                )
          ]))
        .watch();
  }

  @override
  Stream<List<InvoiceModel>> watchAllWithTransactions() {
    // Watch all invoices
    final invoicesStream = (_db.select(_db.invoices)
          ..orderBy([
            (i) => OrderingTerm(
                  expression: i.startDate,
                  mode: OrderingMode.desc,
                )
          ]))
        .watch();

    // Transform to filter only invoices with transactions
    return invoicesStream.asyncMap((invoices) async {
      final filtered = <InvoiceModel>[];
      for (final invoice in invoices) {
        final hasTransactions = await _hasTransactionsInPeriod(
          invoice.startDate,
          invoice.endDate,
        );
        if (hasTransactions) {
          filtered.add(invoice);
        }
      }
      return filtered;
    });
  }

  @override
  Stream<InvoiceModel?> watchByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return (_db.select(_db.invoices)
          ..where(
              (i) => i.startDate.equals(startDate) & i.endDate.equals(endDate)))
        .watchSingleOrNull();
  }

  /// Helper method to check if there are transactions in a billing period
  ///
  /// This checks if any credit accounts have transactions within the
  /// specified date range.
  ///
  /// **Parameters:**
  /// - [startDate]: The start of the billing period
  /// - [endDate]: The end of the billing period
  ///
  /// **Returns:**
  /// true if there are transactions in the period, false otherwise
  Future<bool> _hasTransactionsInPeriod(
    DateTime startDate,
    DateTime endDate,
  ) async {
    debugPrint(
        '[INVOICE_CHECK] Checking for transactions in period: $startDate to $endDate');

    // Get all credit accounts
    final accounts = await _db.select(_db.accounts).get();
    final creditAccounts = accounts.where((acc) => acc.isCredit).toList();

    debugPrint(
        '[INVOICE_CHECK] Checking ${creditAccounts.length} credit accounts');

    if (creditAccounts.isEmpty) {
      debugPrint('[INVOICE_CHECK] No credit accounts found');
      return false;
    }

    // Add 1 day to end date to make it inclusive
    final inclusiveEnd = endDate.add(const Duration(days: 1));

    // Check if any credit account has transactions in this period
    int totalCount = 0;
    for (final account in creditAccounts) {
      final count = await (_db.selectOnly(_db.transactions)
            ..addColumns([_db.transactions.id.count()])
            ..where(
              _db.transactions.accountId.equals(account.id) &
                  _db.transactions.date.isBiggerOrEqualValue(startDate) &
                  _db.transactions.date.isSmallerThanValue(inclusiveEnd),
            ))
          .map((row) => row.read(_db.transactions.id.count()))
          .getSingle();

      debugPrint(
          '[INVOICE_CHECK]   Account ${account.name}: $count transactions');
      totalCount += count ?? 0;

      if (count != null && count > 0) {
        debugPrint('[INVOICE_CHECK] ✅ Found transactions in period');
        return true;
      }
    }

    debugPrint(
        '[INVOICE_CHECK] ❌ No transactions found in period (total: $totalCount)');
    return false;
  }
}

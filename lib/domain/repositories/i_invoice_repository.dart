import '../../data/datasources/local_database.dart';

/// Interface for Invoice repository operations
///
/// **F17-T1 Implementation**: Invoice Manager with Time Navigation
///
/// This simplified repository focuses on invoice period tracking without
/// storing calculated values. All monetary amounts and breakdowns are
/// calculated dynamically via queries in the presentation layer.
///
/// **Design Principles:**
/// - Invoices store only: startDate, endDate, isPaid
/// - Periods are unified across all credit cards
/// - Values are never stored (always calculated on-demand)
/// - Only invoices with transactions are relevant
abstract class IInvoiceRepository {
  /// Creates a new invoice for a billing period
  ///
  /// **Parameters:**
  /// - [startDate]: The unified start date of the billing period
  /// - [endDate]: The unified end date of the billing period
  /// - [isPaid]: Whether the invoice has been paid (defaults to false)
  ///
  /// **Returns:**
  /// The ID of the created invoice
  ///
  /// **Throws:**
  /// Exception if an invoice with the same period already exists
  Future<int> create({
    required DateTime startDate,
    required DateTime endDate,
    bool isPaid = false,
  });

  /// Retrieves an invoice by its ID
  ///
  /// **Returns:**
  /// The invoice model, or null if not found
  Future<InvoiceModel?> getById(int id);

  /// Retrieves an invoice for a specific billing period
  ///
  /// **Parameters:**
  /// - [startDate]: The start date of the billing period
  /// - [endDate]: The end date of the billing period
  ///
  /// **Returns:**
  /// The invoice for the specified period, or null if none exists
  Future<InvoiceModel?> getByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Retrieves all invoices that have transactions
  ///
  /// This method filters out invoice periods that have zero transactions
  /// across all credit accounts, ensuring only relevant invoices are shown.
  ///
  /// **Returns:**
  /// List of invoices ordered by startDate descending (most recent first)
  Future<List<InvoiceModel>> getAllWithTransactions();

  /// Retrieves the first unpaid invoice, or the most recent invoice if all paid
  ///
  /// This is used to determine the default invoice period to display on
  /// the dashboard when the app opens.
  ///
  /// **Returns:**
  /// The first unpaid invoice, or null if no invoices exist
  Future<InvoiceModel?> getFirstUnpaidOrFirst();

  /// Retrieves all invoices ordered by date
  ///
  /// **Returns:**
  /// List of all invoices ordered by startDate descending
  Future<List<InvoiceModel>> getAll();

  /// Marks an invoice as paid
  ///
  /// **Parameters:**
  /// - [invoiceId]: The ID of the invoice to mark as paid
  ///
  /// **Returns:**
  /// true if successful, false otherwise
  Future<bool> markAsPaid(int invoiceId);

  /// Unmarks an invoice as paid (reverses payment status)
  ///
  /// **Parameters:**
  /// - [invoiceId]: The ID of the invoice to unmark
  ///
  /// **Returns:**
  /// true if successful, false otherwise
  Future<bool> unmarkPaid(int invoiceId);

  /// Watches an invoice for a specific billing period
  ///
  /// **Parameters:**
  /// - [startDate]: The start date of the billing period
  /// - [endDate]: The end date of the billing period
  ///
  /// **Returns:**
  /// Stream that emits the invoice whenever it changes, or null if none exists
  Stream<InvoiceModel?> watchByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Watches all invoices that have transactions
  ///
  /// **Returns:**
  /// Stream that emits the list of invoices whenever data changes
  Stream<List<InvoiceModel>> watchAllWithTransactions();

  /// Watches all invoices ordered by date
  ///
  /// **Returns:**
  /// Stream that emits all invoices ordered by startDate descending
  Stream<List<InvoiceModel>> watchAll();

  /// Deletes an invoice
  ///
  /// **Parameters:**
  /// - [id]: The ID of the invoice to delete
  ///
  /// **Returns:**
  /// true if successful, false otherwise
  Future<bool> delete(int id);

  /// Recalculates start/end dates for unpaid empty invoices based on current credit card configurations
  ///
  /// This should be called whenever a credit account's creditPaymentDay is updated to ensure
  /// invoice periods reflect the new billing cycles.
  ///
  /// **Important:** Only unpaid invoices WITHOUT transactions are updated. Invoices with transactions
  /// are considered "locked" because they represent actual spending history. Paid invoices are also
  /// never updated as they are historical records.
  ///
  /// **How it works:**
  /// 1. Fetches all unpaid invoices
  /// 2. Skips invoices that have transactions (locked periods)
  /// 3. For remaining empty invoices, uses midpoint date as a reference
  /// 4. Recalculates the period using current credit card payment days
  /// 5. Updates the invoice dates if they changed
  ///
  /// **Returns:**
  /// Number of invoices updated
  Future<int> recalculateUnpaidInvoiceDates();
}

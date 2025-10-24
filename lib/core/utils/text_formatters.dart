import 'package:intl/intl.dart';

String formatCurrency(double value, [String symbol = 'R\$ ']) {
  final formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: symbol,
    decimalDigits: 2,
  );
  return formatter.format(value);
}

String formatDate(DateTime date, {bool includeYear = false}) {
  // Format: "23/10" (day/month)
  final dateFormat = DateFormat(includeYear ? 'dd/MM/yyyy' : 'dd/MM');
  return dateFormat.format(date);
}

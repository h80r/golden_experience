/// Interface for backup and restore operations
abstract class IBackupRepository {
  /// Exports all app data to a JSON string
  ///
  /// Returns a JSON string containing all data from all tables
  Future<String> exportToJson();

  /// Imports data from a JSON string
  ///
  /// Parses the JSON and restores all data to the database
  /// Throws exception if JSON is invalid
  Future<void> importFromJson(String jsonData);

  /// Get the default backup file path
  Future<String> getDefaultBackupPath();
}

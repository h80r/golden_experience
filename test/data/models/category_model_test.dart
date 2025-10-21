import 'package:flutter_test/flutter_test.dart';
import 'package:golden_experience/data/models/category_model.dart';

void main() {
  group('CategoryModel', () {
    test('should create a valid CategoryModel instance', () {
      // Act
      final category = CategoryModel(
        name: 'Food',
      );

      // Assert
      expect(category.name, 'Food');
    });

    test('should create multiple categories with different names', () {
      // Act
      final category1 = CategoryModel(name: 'Transport');
      final category2 = CategoryModel(name: 'Entertainment');
      final category3 = CategoryModel(name: 'Bills');

      // Assert
      expect(category1.name, 'Transport');
      expect(category2.name, 'Entertainment');
      expect(category3.name, 'Bills');
    });
  });
}

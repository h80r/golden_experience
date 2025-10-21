// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_expense_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecurringExpenseModelCollection on Isar {
  IsarCollection<RecurringExpenseModel> get recurringExpenseModels =>
      this.collection();
}

const RecurringExpenseModelSchema = CollectionSchema(
  name: r'RecurringExpenseModel',
  id: 6832131763582375165,
  properties: {
    r'accountId': PropertySchema(
      id: 0,
      name: r'accountId',
      type: IsarType.long,
    ),
    r'categoryId': PropertySchema(
      id: 1,
      name: r'categoryId',
      type: IsarType.long,
    ),
    r'chargeDay': PropertySchema(
      id: 2,
      name: r'chargeDay',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: 4,
      name: r'value',
      type: IsarType.double,
    )
  },
  estimateSize: _recurringExpenseModelEstimateSize,
  serialize: _recurringExpenseModelSerialize,
  deserialize: _recurringExpenseModelDeserialize,
  deserializeProp: _recurringExpenseModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _recurringExpenseModelGetId,
  getLinks: _recurringExpenseModelGetLinks,
  attach: _recurringExpenseModelAttach,
  version: '3.1.0+1',
);

int _recurringExpenseModelEstimateSize(
  RecurringExpenseModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  return bytesCount;
}

void _recurringExpenseModelSerialize(
  RecurringExpenseModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.accountId);
  writer.writeLong(offsets[1], object.categoryId);
  writer.writeLong(offsets[2], object.chargeDay);
  writer.writeString(offsets[3], object.description);
  writer.writeDouble(offsets[4], object.value);
}

RecurringExpenseModel _recurringExpenseModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecurringExpenseModel(
    accountId: reader.readLong(offsets[0]),
    categoryId: reader.readLong(offsets[1]),
    chargeDay: reader.readLong(offsets[2]),
    description: reader.readString(offsets[3]),
    id: id,
    value: reader.readDouble(offsets[4]),
  );
  return object;
}

P _recurringExpenseModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recurringExpenseModelGetId(RecurringExpenseModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recurringExpenseModelGetLinks(
    RecurringExpenseModel object) {
  return [];
}

void _recurringExpenseModelAttach(
    IsarCollection<dynamic> col, Id id, RecurringExpenseModel object) {
  object.id = id;
}

extension RecurringExpenseModelQueryWhereSort
    on QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QWhere> {
  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecurringExpenseModelQueryWhere on QueryBuilder<RecurringExpenseModel,
    RecurringExpenseModel, QWhereClause> {
  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RecurringExpenseModelQueryFilter on QueryBuilder<
    RecurringExpenseModel, RecurringExpenseModel, QFilterCondition> {
  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> accountIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountId',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> accountIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accountId',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> accountIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accountId',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> accountIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accountId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> categoryIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> categoryIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> categoryIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> categoryIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> chargeDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chargeDay',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> chargeDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chargeDay',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> chargeDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chargeDay',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> chargeDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chargeDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
          QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
          QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> valueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel,
      QAfterFilterCondition> valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension RecurringExpenseModelQueryObject on QueryBuilder<
    RecurringExpenseModel, RecurringExpenseModel, QFilterCondition> {}

extension RecurringExpenseModelQueryLinks on QueryBuilder<RecurringExpenseModel,
    RecurringExpenseModel, QFilterCondition> {}

extension RecurringExpenseModelQuerySortBy
    on QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QSortBy> {
  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      sortByChargeDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chargeDay', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      sortByChargeDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chargeDay', Sort.desc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension RecurringExpenseModelQuerySortThenBy
    on QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QSortThenBy> {
  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByChargeDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chargeDay', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByChargeDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chargeDay', Sort.desc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QAfterSortBy>
      thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension RecurringExpenseModelQueryWhereDistinct
    on QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QDistinct> {
  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QDistinct>
      distinctByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId');
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QDistinct>
      distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QDistinct>
      distinctByChargeDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chargeDay');
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecurringExpenseModel, RecurringExpenseModel, QDistinct>
      distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }
}

extension RecurringExpenseModelQueryProperty on QueryBuilder<
    RecurringExpenseModel, RecurringExpenseModel, QQueryProperty> {
  QueryBuilder<RecurringExpenseModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecurringExpenseModel, int, QQueryOperations>
      accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<RecurringExpenseModel, int, QQueryOperations>
      categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<RecurringExpenseModel, int, QQueryOperations>
      chargeDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chargeDay');
    });
  }

  QueryBuilder<RecurringExpenseModel, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<RecurringExpenseModel, double, QQueryOperations>
      valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}

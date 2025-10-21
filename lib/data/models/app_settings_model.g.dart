// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsModelCollection on Isar {
  IsarCollection<AppSettingsModel> get appSettingsModels => this.collection();
}

const AppSettingsModelSchema = CollectionSchema(
  name: r'AppSettingsModel',
  id: -638838212012723081,
  properties: {
    r'lastRecurringCheck': PropertySchema(
      id: 0,
      name: r'lastRecurringCheck',
      type: IsarType.dateTime,
    ),
    r'maxReserveUsagePercentage': PropertySchema(
      id: 1,
      name: r'maxReserveUsagePercentage',
      type: IsarType.double,
    ),
    r'monthlySalary': PropertySchema(
      id: 2,
      name: r'monthlySalary',
      type: IsarType.double,
    ),
    r'reserveBalance': PropertySchema(
      id: 3,
      name: r'reserveBalance',
      type: IsarType.double,
    )
  },
  estimateSize: _appSettingsModelEstimateSize,
  serialize: _appSettingsModelSerialize,
  deserialize: _appSettingsModelDeserialize,
  deserializeProp: _appSettingsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appSettingsModelGetId,
  getLinks: _appSettingsModelGetLinks,
  attach: _appSettingsModelAttach,
  version: '3.1.0+1',
);

int _appSettingsModelEstimateSize(
  AppSettingsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _appSettingsModelSerialize(
  AppSettingsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.lastRecurringCheck);
  writer.writeDouble(offsets[1], object.maxReserveUsagePercentage);
  writer.writeDouble(offsets[2], object.monthlySalary);
  writer.writeDouble(offsets[3], object.reserveBalance);
}

AppSettingsModel _appSettingsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettingsModel(
    id: id,
    lastRecurringCheck: reader.readDateTime(offsets[0]),
    maxReserveUsagePercentage: reader.readDouble(offsets[1]),
    monthlySalary: reader.readDouble(offsets[2]),
    reserveBalance: reader.readDouble(offsets[3]),
  );
  return object;
}

P _appSettingsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingsModelGetId(AppSettingsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsModelGetLinks(AppSettingsModel object) {
  return [];
}

void _appSettingsModelAttach(
    IsarCollection<dynamic> col, Id id, AppSettingsModel object) {
  object.id = id;
}

extension AppSettingsModelQueryWhereSort
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QWhere> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsModelQueryWhere
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QWhereClause> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause>
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

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause> idBetween(
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

extension AppSettingsModelQueryFilter
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QFilterCondition> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      lastRecurringCheckEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastRecurringCheck',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      lastRecurringCheckGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastRecurringCheck',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      lastRecurringCheckLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastRecurringCheck',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      lastRecurringCheckBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastRecurringCheck',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      maxReserveUsagePercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxReserveUsagePercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      maxReserveUsagePercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxReserveUsagePercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      maxReserveUsagePercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxReserveUsagePercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      maxReserveUsagePercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxReserveUsagePercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      monthlySalaryEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlySalary',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      monthlySalaryGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlySalary',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      monthlySalaryLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlySalary',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      monthlySalaryBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlySalary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      reserveBalanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reserveBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      reserveBalanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reserveBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      reserveBalanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reserveBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      reserveBalanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reserveBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension AppSettingsModelQueryObject
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QFilterCondition> {}

extension AppSettingsModelQueryLinks
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QFilterCondition> {}

extension AppSettingsModelQuerySortBy
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QSortBy> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByLastRecurringCheck() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRecurringCheck', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByLastRecurringCheckDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRecurringCheck', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByMaxReserveUsagePercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxReserveUsagePercentage', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByMaxReserveUsagePercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxReserveUsagePercentage', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySalary', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByMonthlySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySalary', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByReserveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reserveBalance', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByReserveBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reserveBalance', Sort.desc);
    });
  }
}

extension AppSettingsModelQuerySortThenBy
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QSortThenBy> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByLastRecurringCheck() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRecurringCheck', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByLastRecurringCheckDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRecurringCheck', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByMaxReserveUsagePercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxReserveUsagePercentage', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByMaxReserveUsagePercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxReserveUsagePercentage', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySalary', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByMonthlySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySalary', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByReserveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reserveBalance', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByReserveBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reserveBalance', Sort.desc);
    });
  }
}

extension AppSettingsModelQueryWhereDistinct
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByLastRecurringCheck() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastRecurringCheck');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByMaxReserveUsagePercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxReserveUsagePercentage');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlySalary');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByReserveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reserveBalance');
    });
  }
}

extension AppSettingsModelQueryProperty
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QQueryProperty> {
  QueryBuilder<AppSettingsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettingsModel, DateTime, QQueryOperations>
      lastRecurringCheckProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastRecurringCheck');
    });
  }

  QueryBuilder<AppSettingsModel, double, QQueryOperations>
      maxReserveUsagePercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxReserveUsagePercentage');
    });
  }

  QueryBuilder<AppSettingsModel, double, QQueryOperations>
      monthlySalaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlySalary');
    });
  }

  QueryBuilder<AppSettingsModel, double, QQueryOperations>
      reserveBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reserveBalance');
    });
  }
}

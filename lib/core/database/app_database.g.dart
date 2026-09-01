// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>($TransactionsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<Currency, String> currency =
      GeneratedColumn<String>(
        'currency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Currency>($TransactionsTable.$convertercurrency);
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subcategoryIdMeta = const VerificationMeta(
    'subcategoryId',
  );
  @override
  late final GeneratedColumn<int> subcategoryId = GeneratedColumn<int>(
    'subcategory_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DebtOperation?, String>
  debtOperation = GeneratedColumn<String>(
    'debt_operation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<DebtOperation?>($TransactionsTable.$converterdebtOperationn);
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usdTryRateMeta = const VerificationMeta(
    'usdTryRate',
  );
  @override
  late final GeneratedColumn<double> usdTryRate = GeneratedColumn<double>(
    'usd_try_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eurTryRateMeta = const VerificationMeta(
    'eurTryRate',
  );
  @override
  late final GeneratedColumn<double> eurTryRate = GeneratedColumn<double>(
    'eur_try_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xauTryRateMeta = const VerificationMeta(
    'xauTryRate',
  );
  @override
  late final GeneratedColumn<double> xauTryRate = GeneratedColumn<double>(
    'xau_try_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rateSnapshotAtMeta = const VerificationMeta(
    'rateSnapshotAt',
  );
  @override
  late final GeneratedColumn<DateTime> rateSnapshotAt =
      GeneratedColumn<DateTime>(
        'rate_snapshot_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    currency,
    amountMinor,
    categoryId,
    subcategoryId,
    debtOperation,
    transactionDate,
    description,
    usdTryRate,
    eurTryRate,
    xauTryRate,
    rateSnapshotAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('subcategory_id')) {
      context.handle(
        _subcategoryIdMeta,
        subcategoryId.isAcceptableOrUnknown(
          data['subcategory_id']!,
          _subcategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('usd_try_rate')) {
      context.handle(
        _usdTryRateMeta,
        usdTryRate.isAcceptableOrUnknown(
          data['usd_try_rate']!,
          _usdTryRateMeta,
        ),
      );
    }
    if (data.containsKey('eur_try_rate')) {
      context.handle(
        _eurTryRateMeta,
        eurTryRate.isAcceptableOrUnknown(
          data['eur_try_rate']!,
          _eurTryRateMeta,
        ),
      );
    }
    if (data.containsKey('xau_try_rate')) {
      context.handle(
        _xauTryRateMeta,
        xauTryRate.isAcceptableOrUnknown(
          data['xau_try_rate']!,
          _xauTryRateMeta,
        ),
      );
    }
    if (data.containsKey('rate_snapshot_at')) {
      context.handle(
        _rateSnapshotAtMeta,
        rateSnapshotAt.isAcceptableOrUnknown(
          data['rate_snapshot_at']!,
          _rateSnapshotAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      currency: $TransactionsTable.$convertercurrency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}currency'],
        )!,
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      subcategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subcategory_id'],
      ),
      debtOperation: $TransactionsTable.$converterdebtOperationn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}debt_operation'],
        ),
      ),
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      usdTryRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}usd_try_rate'],
      ),
      eurTryRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}eur_try_rate'],
      ),
      xauTryRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}xau_try_rate'],
      ),
      rateSnapshotAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}rate_snapshot_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<Currency, String, String> $convertercurrency =
      const EnumNameConverter<Currency>(Currency.values);
  static JsonTypeConverter2<DebtOperation, String, String>
  $converterdebtOperation = const EnumNameConverter<DebtOperation>(
    DebtOperation.values,
  );
  static JsonTypeConverter2<DebtOperation?, String?, String?>
  $converterdebtOperationn = JsonTypeConverter2.asNullable(
    $converterdebtOperation,
  );
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final int id;
  final TransactionType type;

  /// Currency the user entered the amount in.
  final Currency currency;

  /// Amount in [currency], scaled by 100 so no float rounding can creep in.
  final int amountMinor;
  final int categoryId;

  /// Added in schema v3; null for rows created before subcategories existed.
  final int? subcategoryId;

  /// Added in schema v3. Non-null rows are debt movements, not spending.
  final DebtOperation? debtOperation;
  final DateTime transactionDate;
  final String? description;
  final double? usdTryRate;
  final double? eurTryRate;
  final double? xauTryRate;
  final DateTime? rateSnapshotAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TransactionRow({
    required this.id,
    required this.type,
    required this.currency,
    required this.amountMinor,
    required this.categoryId,
    this.subcategoryId,
    this.debtOperation,
    required this.transactionDate,
    this.description,
    this.usdTryRate,
    this.eurTryRate,
    this.xauTryRate,
    this.rateSnapshotAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    {
      map['currency'] = Variable<String>(
        $TransactionsTable.$convertercurrency.toSql(currency),
      );
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || subcategoryId != null) {
      map['subcategory_id'] = Variable<int>(subcategoryId);
    }
    if (!nullToAbsent || debtOperation != null) {
      map['debt_operation'] = Variable<String>(
        $TransactionsTable.$converterdebtOperationn.toSql(debtOperation),
      );
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || usdTryRate != null) {
      map['usd_try_rate'] = Variable<double>(usdTryRate);
    }
    if (!nullToAbsent || eurTryRate != null) {
      map['eur_try_rate'] = Variable<double>(eurTryRate);
    }
    if (!nullToAbsent || xauTryRate != null) {
      map['xau_try_rate'] = Variable<double>(xauTryRate);
    }
    if (!nullToAbsent || rateSnapshotAt != null) {
      map['rate_snapshot_at'] = Variable<DateTime>(rateSnapshotAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      type: Value(type),
      currency: Value(currency),
      amountMinor: Value(amountMinor),
      categoryId: Value(categoryId),
      subcategoryId: subcategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategoryId),
      debtOperation: debtOperation == null && nullToAbsent
          ? const Value.absent()
          : Value(debtOperation),
      transactionDate: Value(transactionDate),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      usdTryRate: usdTryRate == null && nullToAbsent
          ? const Value.absent()
          : Value(usdTryRate),
      eurTryRate: eurTryRate == null && nullToAbsent
          ? const Value.absent()
          : Value(eurTryRate),
      xauTryRate: xauTryRate == null && nullToAbsent
          ? const Value.absent()
          : Value(xauTryRate),
      rateSnapshotAt: rateSnapshotAt == null && nullToAbsent
          ? const Value.absent()
          : Value(rateSnapshotAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<int>(json['id']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      currency: $TransactionsTable.$convertercurrency.fromJson(
        serializer.fromJson<String>(json['currency']),
      ),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      subcategoryId: serializer.fromJson<int?>(json['subcategoryId']),
      debtOperation: $TransactionsTable.$converterdebtOperationn.fromJson(
        serializer.fromJson<String?>(json['debtOperation']),
      ),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      description: serializer.fromJson<String?>(json['description']),
      usdTryRate: serializer.fromJson<double?>(json['usdTryRate']),
      eurTryRate: serializer.fromJson<double?>(json['eurTryRate']),
      xauTryRate: serializer.fromJson<double?>(json['xauTryRate']),
      rateSnapshotAt: serializer.fromJson<DateTime?>(json['rateSnapshotAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'currency': serializer.toJson<String>(
        $TransactionsTable.$convertercurrency.toJson(currency),
      ),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'categoryId': serializer.toJson<int>(categoryId),
      'subcategoryId': serializer.toJson<int?>(subcategoryId),
      'debtOperation': serializer.toJson<String?>(
        $TransactionsTable.$converterdebtOperationn.toJson(debtOperation),
      ),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'description': serializer.toJson<String?>(description),
      'usdTryRate': serializer.toJson<double?>(usdTryRate),
      'eurTryRate': serializer.toJson<double?>(eurTryRate),
      'xauTryRate': serializer.toJson<double?>(xauTryRate),
      'rateSnapshotAt': serializer.toJson<DateTime?>(rateSnapshotAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TransactionRow copyWith({
    int? id,
    TransactionType? type,
    Currency? currency,
    int? amountMinor,
    int? categoryId,
    Value<int?> subcategoryId = const Value.absent(),
    Value<DebtOperation?> debtOperation = const Value.absent(),
    DateTime? transactionDate,
    Value<String?> description = const Value.absent(),
    Value<double?> usdTryRate = const Value.absent(),
    Value<double?> eurTryRate = const Value.absent(),
    Value<double?> xauTryRate = const Value.absent(),
    Value<DateTime?> rateSnapshotAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TransactionRow(
    id: id ?? this.id,
    type: type ?? this.type,
    currency: currency ?? this.currency,
    amountMinor: amountMinor ?? this.amountMinor,
    categoryId: categoryId ?? this.categoryId,
    subcategoryId: subcategoryId.present
        ? subcategoryId.value
        : this.subcategoryId,
    debtOperation: debtOperation.present
        ? debtOperation.value
        : this.debtOperation,
    transactionDate: transactionDate ?? this.transactionDate,
    description: description.present ? description.value : this.description,
    usdTryRate: usdTryRate.present ? usdTryRate.value : this.usdTryRate,
    eurTryRate: eurTryRate.present ? eurTryRate.value : this.eurTryRate,
    xauTryRate: xauTryRate.present ? xauTryRate.value : this.xauTryRate,
    rateSnapshotAt: rateSnapshotAt.present
        ? rateSnapshotAt.value
        : this.rateSnapshotAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      currency: data.currency.present ? data.currency.value : this.currency,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      subcategoryId: data.subcategoryId.present
          ? data.subcategoryId.value
          : this.subcategoryId,
      debtOperation: data.debtOperation.present
          ? data.debtOperation.value
          : this.debtOperation,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      description: data.description.present
          ? data.description.value
          : this.description,
      usdTryRate: data.usdTryRate.present
          ? data.usdTryRate.value
          : this.usdTryRate,
      eurTryRate: data.eurTryRate.present
          ? data.eurTryRate.value
          : this.eurTryRate,
      xauTryRate: data.xauTryRate.present
          ? data.xauTryRate.value
          : this.xauTryRate,
      rateSnapshotAt: data.rateSnapshotAt.present
          ? data.rateSnapshotAt.value
          : this.rateSnapshotAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('currency: $currency, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('categoryId: $categoryId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('debtOperation: $debtOperation, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('description: $description, ')
          ..write('usdTryRate: $usdTryRate, ')
          ..write('eurTryRate: $eurTryRate, ')
          ..write('xauTryRate: $xauTryRate, ')
          ..write('rateSnapshotAt: $rateSnapshotAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    currency,
    amountMinor,
    categoryId,
    subcategoryId,
    debtOperation,
    transactionDate,
    description,
    usdTryRate,
    eurTryRate,
    xauTryRate,
    rateSnapshotAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.currency == this.currency &&
          other.amountMinor == this.amountMinor &&
          other.categoryId == this.categoryId &&
          other.subcategoryId == this.subcategoryId &&
          other.debtOperation == this.debtOperation &&
          other.transactionDate == this.transactionDate &&
          other.description == this.description &&
          other.usdTryRate == this.usdTryRate &&
          other.eurTryRate == this.eurTryRate &&
          other.xauTryRate == this.xauTryRate &&
          other.rateSnapshotAt == this.rateSnapshotAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<int> id;
  final Value<TransactionType> type;
  final Value<Currency> currency;
  final Value<int> amountMinor;
  final Value<int> categoryId;
  final Value<int?> subcategoryId;
  final Value<DebtOperation?> debtOperation;
  final Value<DateTime> transactionDate;
  final Value<String?> description;
  final Value<double?> usdTryRate;
  final Value<double?> eurTryRate;
  final Value<double?> xauTryRate;
  final Value<DateTime?> rateSnapshotAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.currency = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.subcategoryId = const Value.absent(),
    this.debtOperation = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.description = const Value.absent(),
    this.usdTryRate = const Value.absent(),
    this.eurTryRate = const Value.absent(),
    this.xauTryRate = const Value.absent(),
    this.rateSnapshotAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required TransactionType type,
    required Currency currency,
    required int amountMinor,
    required int categoryId,
    this.subcategoryId = const Value.absent(),
    this.debtOperation = const Value.absent(),
    required DateTime transactionDate,
    this.description = const Value.absent(),
    this.usdTryRate = const Value.absent(),
    this.eurTryRate = const Value.absent(),
    this.xauTryRate = const Value.absent(),
    this.rateSnapshotAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : type = Value(type),
       currency = Value(currency),
       amountMinor = Value(amountMinor),
       categoryId = Value(categoryId),
       transactionDate = Value(transactionDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionRow> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? currency,
    Expression<int>? amountMinor,
    Expression<int>? categoryId,
    Expression<int>? subcategoryId,
    Expression<String>? debtOperation,
    Expression<DateTime>? transactionDate,
    Expression<String>? description,
    Expression<double>? usdTryRate,
    Expression<double>? eurTryRate,
    Expression<double>? xauTryRate,
    Expression<DateTime>? rateSnapshotAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (currency != null) 'currency': currency,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (categoryId != null) 'category_id': categoryId,
      if (subcategoryId != null) 'subcategory_id': subcategoryId,
      if (debtOperation != null) 'debt_operation': debtOperation,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (description != null) 'description': description,
      if (usdTryRate != null) 'usd_try_rate': usdTryRate,
      if (eurTryRate != null) 'eur_try_rate': eurTryRate,
      if (xauTryRate != null) 'xau_try_rate': xauTryRate,
      if (rateSnapshotAt != null) 'rate_snapshot_at': rateSnapshotAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<TransactionType>? type,
    Value<Currency>? currency,
    Value<int>? amountMinor,
    Value<int>? categoryId,
    Value<int?>? subcategoryId,
    Value<DebtOperation?>? debtOperation,
    Value<DateTime>? transactionDate,
    Value<String?>? description,
    Value<double?>? usdTryRate,
    Value<double?>? eurTryRate,
    Value<double?>? xauTryRate,
    Value<DateTime?>? rateSnapshotAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      amountMinor: amountMinor ?? this.amountMinor,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      debtOperation: debtOperation ?? this.debtOperation,
      transactionDate: transactionDate ?? this.transactionDate,
      description: description ?? this.description,
      usdTryRate: usdTryRate ?? this.usdTryRate,
      eurTryRate: eurTryRate ?? this.eurTryRate,
      xauTryRate: xauTryRate ?? this.xauTryRate,
      rateSnapshotAt: rateSnapshotAt ?? this.rateSnapshotAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (currency.present) {
      map['currency'] = Variable<String>(
        $TransactionsTable.$convertercurrency.toSql(currency.value),
      );
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (subcategoryId.present) {
      map['subcategory_id'] = Variable<int>(subcategoryId.value);
    }
    if (debtOperation.present) {
      map['debt_operation'] = Variable<String>(
        $TransactionsTable.$converterdebtOperationn.toSql(debtOperation.value),
      );
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (usdTryRate.present) {
      map['usd_try_rate'] = Variable<double>(usdTryRate.value);
    }
    if (eurTryRate.present) {
      map['eur_try_rate'] = Variable<double>(eurTryRate.value);
    }
    if (xauTryRate.present) {
      map['xau_try_rate'] = Variable<double>(xauTryRate.value);
    }
    if (rateSnapshotAt.present) {
      map['rate_snapshot_at'] = Variable<DateTime>(rateSnapshotAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('currency: $currency, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('categoryId: $categoryId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('debtOperation: $debtOperation, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('description: $description, ')
          ..write('usdTryRate: $usdTryRate, ')
          ..write('eurTryRate: $eurTryRate, ')
          ..write('xauTryRate: $xauTryRate, ')
          ..write('rateSnapshotAt: $rateSnapshotAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRateCacheTable extends ExchangeRateCache
    with TableInfo<$ExchangeRateCacheTable, ExchangeRateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRateCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usdTryRateMeta = const VerificationMeta(
    'usdTryRate',
  );
  @override
  late final GeneratedColumn<double> usdTryRate = GeneratedColumn<double>(
    'usd_try_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eurTryRateMeta = const VerificationMeta(
    'eurTryRate',
  );
  @override
  late final GeneratedColumn<double> eurTryRate = GeneratedColumn<double>(
    'eur_try_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xauTryRateMeta = const VerificationMeta(
    'xauTryRate',
  );
  @override
  late final GeneratedColumn<double> xauTryRate = GeneratedColumn<double>(
    'xau_try_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUpdatedAtMeta = const VerificationMeta(
    'sourceUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> sourceUpdatedAt =
      GeneratedColumn<DateTime>(
        'source_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseCurrencyMeta = const VerificationMeta(
    'baseCurrency',
  );
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
    'base_currency',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 8),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 40),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usdTryRate,
    eurTryRate,
    xauTryRate,
    fetchedAt,
    sourceUpdatedAt,
    cachedAt,
    baseCurrency,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExchangeRateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usd_try_rate')) {
      context.handle(
        _usdTryRateMeta,
        usdTryRate.isAcceptableOrUnknown(
          data['usd_try_rate']!,
          _usdTryRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_usdTryRateMeta);
    }
    if (data.containsKey('eur_try_rate')) {
      context.handle(
        _eurTryRateMeta,
        eurTryRate.isAcceptableOrUnknown(
          data['eur_try_rate']!,
          _eurTryRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eurTryRateMeta);
    }
    if (data.containsKey('xau_try_rate')) {
      context.handle(
        _xauTryRateMeta,
        xauTryRate.isAcceptableOrUnknown(
          data['xau_try_rate']!,
          _xauTryRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_xauTryRateMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('source_updated_at')) {
      context.handle(
        _sourceUpdatedAtMeta,
        sourceUpdatedAt.isAcceptableOrUnknown(
          data['source_updated_at']!,
          _sourceUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    if (data.containsKey('base_currency')) {
      context.handle(
        _baseCurrencyMeta,
        baseCurrency.isAcceptableOrUnknown(
          data['base_currency']!,
          _baseCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      usdTryRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}usd_try_rate'],
      )!,
      eurTryRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}eur_try_rate'],
      )!,
      xauTryRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}xau_try_rate'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      sourceUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}source_updated_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      ),
      baseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_currency'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $ExchangeRateCacheTable createAlias(String alias) {
    return $ExchangeRateCacheTable(attachedDatabase, alias);
  }
}

class ExchangeRateRow extends DataClass implements Insertable<ExchangeRateRow> {
  final int id;
  final double usdTryRate;
  final double eurTryRate;
  final double xauTryRate;

  /// When the app successfully retrieved the response.
  final DateTime fetchedAt;

  /// Quote time reported by the provider. Added in v3; null when the provider
  /// exposes no trustworthy source timestamp.
  final DateTime? sourceUpdatedAt;

  /// When the row was persisted locally. Added in v3.
  final DateTime? cachedAt;

  /// Base currency of the upstream response. Added in v3.
  final String? baseCurrency;
  final String source;
  const ExchangeRateRow({
    required this.id,
    required this.usdTryRate,
    required this.eurTryRate,
    required this.xauTryRate,
    required this.fetchedAt,
    this.sourceUpdatedAt,
    this.cachedAt,
    this.baseCurrency,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usd_try_rate'] = Variable<double>(usdTryRate);
    map['eur_try_rate'] = Variable<double>(eurTryRate);
    map['xau_try_rate'] = Variable<double>(xauTryRate);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    if (!nullToAbsent || sourceUpdatedAt != null) {
      map['source_updated_at'] = Variable<DateTime>(sourceUpdatedAt);
    }
    if (!nullToAbsent || cachedAt != null) {
      map['cached_at'] = Variable<DateTime>(cachedAt);
    }
    if (!nullToAbsent || baseCurrency != null) {
      map['base_currency'] = Variable<String>(baseCurrency);
    }
    map['source'] = Variable<String>(source);
    return map;
  }

  ExchangeRateCacheCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRateCacheCompanion(
      id: Value(id),
      usdTryRate: Value(usdTryRate),
      eurTryRate: Value(eurTryRate),
      xauTryRate: Value(xauTryRate),
      fetchedAt: Value(fetchedAt),
      sourceUpdatedAt: sourceUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUpdatedAt),
      cachedAt: cachedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedAt),
      baseCurrency: baseCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(baseCurrency),
      source: Value(source),
    );
  }

  factory ExchangeRateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRateRow(
      id: serializer.fromJson<int>(json['id']),
      usdTryRate: serializer.fromJson<double>(json['usdTryRate']),
      eurTryRate: serializer.fromJson<double>(json['eurTryRate']),
      xauTryRate: serializer.fromJson<double>(json['xauTryRate']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      sourceUpdatedAt: serializer.fromJson<DateTime?>(json['sourceUpdatedAt']),
      cachedAt: serializer.fromJson<DateTime?>(json['cachedAt']),
      baseCurrency: serializer.fromJson<String?>(json['baseCurrency']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usdTryRate': serializer.toJson<double>(usdTryRate),
      'eurTryRate': serializer.toJson<double>(eurTryRate),
      'xauTryRate': serializer.toJson<double>(xauTryRate),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'sourceUpdatedAt': serializer.toJson<DateTime?>(sourceUpdatedAt),
      'cachedAt': serializer.toJson<DateTime?>(cachedAt),
      'baseCurrency': serializer.toJson<String?>(baseCurrency),
      'source': serializer.toJson<String>(source),
    };
  }

  ExchangeRateRow copyWith({
    int? id,
    double? usdTryRate,
    double? eurTryRate,
    double? xauTryRate,
    DateTime? fetchedAt,
    Value<DateTime?> sourceUpdatedAt = const Value.absent(),
    Value<DateTime?> cachedAt = const Value.absent(),
    Value<String?> baseCurrency = const Value.absent(),
    String? source,
  }) => ExchangeRateRow(
    id: id ?? this.id,
    usdTryRate: usdTryRate ?? this.usdTryRate,
    eurTryRate: eurTryRate ?? this.eurTryRate,
    xauTryRate: xauTryRate ?? this.xauTryRate,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    sourceUpdatedAt: sourceUpdatedAt.present
        ? sourceUpdatedAt.value
        : this.sourceUpdatedAt,
    cachedAt: cachedAt.present ? cachedAt.value : this.cachedAt,
    baseCurrency: baseCurrency.present ? baseCurrency.value : this.baseCurrency,
    source: source ?? this.source,
  );
  ExchangeRateRow copyWithCompanion(ExchangeRateCacheCompanion data) {
    return ExchangeRateRow(
      id: data.id.present ? data.id.value : this.id,
      usdTryRate: data.usdTryRate.present
          ? data.usdTryRate.value
          : this.usdTryRate,
      eurTryRate: data.eurTryRate.present
          ? data.eurTryRate.value
          : this.eurTryRate,
      xauTryRate: data.xauTryRate.present
          ? data.xauTryRate.value
          : this.xauTryRate,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      sourceUpdatedAt: data.sourceUpdatedAt.present
          ? data.sourceUpdatedAt.value
          : this.sourceUpdatedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRateRow(')
          ..write('id: $id, ')
          ..write('usdTryRate: $usdTryRate, ')
          ..write('eurTryRate: $eurTryRate, ')
          ..write('xauTryRate: $xauTryRate, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('sourceUpdatedAt: $sourceUpdatedAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usdTryRate,
    eurTryRate,
    xauTryRate,
    fetchedAt,
    sourceUpdatedAt,
    cachedAt,
    baseCurrency,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRateRow &&
          other.id == this.id &&
          other.usdTryRate == this.usdTryRate &&
          other.eurTryRate == this.eurTryRate &&
          other.xauTryRate == this.xauTryRate &&
          other.fetchedAt == this.fetchedAt &&
          other.sourceUpdatedAt == this.sourceUpdatedAt &&
          other.cachedAt == this.cachedAt &&
          other.baseCurrency == this.baseCurrency &&
          other.source == this.source);
}

class ExchangeRateCacheCompanion extends UpdateCompanion<ExchangeRateRow> {
  final Value<int> id;
  final Value<double> usdTryRate;
  final Value<double> eurTryRate;
  final Value<double> xauTryRate;
  final Value<DateTime> fetchedAt;
  final Value<DateTime?> sourceUpdatedAt;
  final Value<DateTime?> cachedAt;
  final Value<String?> baseCurrency;
  final Value<String> source;
  const ExchangeRateCacheCompanion({
    this.id = const Value.absent(),
    this.usdTryRate = const Value.absent(),
    this.eurTryRate = const Value.absent(),
    this.xauTryRate = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.sourceUpdatedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.source = const Value.absent(),
  });
  ExchangeRateCacheCompanion.insert({
    this.id = const Value.absent(),
    required double usdTryRate,
    required double eurTryRate,
    required double xauTryRate,
    required DateTime fetchedAt,
    this.sourceUpdatedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    required String source,
  }) : usdTryRate = Value(usdTryRate),
       eurTryRate = Value(eurTryRate),
       xauTryRate = Value(xauTryRate),
       fetchedAt = Value(fetchedAt),
       source = Value(source);
  static Insertable<ExchangeRateRow> custom({
    Expression<int>? id,
    Expression<double>? usdTryRate,
    Expression<double>? eurTryRate,
    Expression<double>? xauTryRate,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? sourceUpdatedAt,
    Expression<DateTime>? cachedAt,
    Expression<String>? baseCurrency,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usdTryRate != null) 'usd_try_rate': usdTryRate,
      if (eurTryRate != null) 'eur_try_rate': eurTryRate,
      if (xauTryRate != null) 'xau_try_rate': xauTryRate,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (sourceUpdatedAt != null) 'source_updated_at': sourceUpdatedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (source != null) 'source': source,
    });
  }

  ExchangeRateCacheCompanion copyWith({
    Value<int>? id,
    Value<double>? usdTryRate,
    Value<double>? eurTryRate,
    Value<double>? xauTryRate,
    Value<DateTime>? fetchedAt,
    Value<DateTime?>? sourceUpdatedAt,
    Value<DateTime?>? cachedAt,
    Value<String?>? baseCurrency,
    Value<String>? source,
  }) {
    return ExchangeRateCacheCompanion(
      id: id ?? this.id,
      usdTryRate: usdTryRate ?? this.usdTryRate,
      eurTryRate: eurTryRate ?? this.eurTryRate,
      xauTryRate: xauTryRate ?? this.xauTryRate,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      sourceUpdatedAt: sourceUpdatedAt ?? this.sourceUpdatedAt,
      cachedAt: cachedAt ?? this.cachedAt,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usdTryRate.present) {
      map['usd_try_rate'] = Variable<double>(usdTryRate.value);
    }
    if (eurTryRate.present) {
      map['eur_try_rate'] = Variable<double>(eurTryRate.value);
    }
    if (xauTryRate.present) {
      map['xau_try_rate'] = Variable<double>(xauTryRate.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (sourceUpdatedAt.present) {
      map['source_updated_at'] = Variable<DateTime>(sourceUpdatedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRateCacheCompanion(')
          ..write('id: $id, ')
          ..write('usdTryRate: $usdTryRate, ')
          ..write('eurTryRate: $eurTryRate, ')
          ..write('xauTryRate: $xauTryRate, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('sourceUpdatedAt: $sourceUpdatedAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $ExchangeRateCacheTable exchangeRateCache =
      $ExchangeRateCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    transactions,
    exchangeRateCache,
  ];
}

typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required TransactionType type,
      required Currency currency,
      required int amountMinor,
      required int categoryId,
      Value<int?> subcategoryId,
      Value<DebtOperation?> debtOperation,
      required DateTime transactionDate,
      Value<String?> description,
      Value<double?> usdTryRate,
      Value<double?> eurTryRate,
      Value<double?> xauTryRate,
      Value<DateTime?> rateSnapshotAt,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<TransactionType> type,
      Value<Currency> currency,
      Value<int> amountMinor,
      Value<int> categoryId,
      Value<int?> subcategoryId,
      Value<DebtOperation?> debtOperation,
      Value<DateTime> transactionDate,
      Value<String?> description,
      Value<double?> usdTryRate,
      Value<double?> eurTryRate,
      Value<double?> xauTryRate,
      Value<DateTime?> rateSnapshotAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Currency, Currency, String> get currency =>
      $composableBuilder(
        column: $table.currency,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subcategoryId => $composableBuilder(
    column: $table.subcategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DebtOperation?, DebtOperation, String>
  get debtOperation => $composableBuilder(
    column: $table.debtOperation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get usdTryRate => $composableBuilder(
    column: $table.usdTryRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get eurTryRate => $composableBuilder(
    column: $table.eurTryRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get xauTryRate => $composableBuilder(
    column: $table.xauTryRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get rateSnapshotAt => $composableBuilder(
    column: $table.rateSnapshotAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subcategoryId => $composableBuilder(
    column: $table.subcategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get debtOperation => $composableBuilder(
    column: $table.debtOperation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get usdTryRate => $composableBuilder(
    column: $table.usdTryRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get eurTryRate => $composableBuilder(
    column: $table.eurTryRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get xauTryRate => $composableBuilder(
    column: $table.xauTryRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get rateSnapshotAt => $composableBuilder(
    column: $table.rateSnapshotAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Currency, String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subcategoryId => $composableBuilder(
    column: $table.subcategoryId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DebtOperation?, String> get debtOperation =>
      $composableBuilder(
        column: $table.debtOperation,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get usdTryRate => $composableBuilder(
    column: $table.usdTryRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get eurTryRate => $composableBuilder(
    column: $table.eurTryRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get xauTryRate => $composableBuilder(
    column: $table.xauTryRate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get rateSnapshotAt => $composableBuilder(
    column: $table.rateSnapshotAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            TransactionRow,
            BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>,
          ),
          TransactionRow,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<Currency> currency = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int?> subcategoryId = const Value.absent(),
                Value<DebtOperation?> debtOperation = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> usdTryRate = const Value.absent(),
                Value<double?> eurTryRate = const Value.absent(),
                Value<double?> xauTryRate = const Value.absent(),
                Value<DateTime?> rateSnapshotAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                type: type,
                currency: currency,
                amountMinor: amountMinor,
                categoryId: categoryId,
                subcategoryId: subcategoryId,
                debtOperation: debtOperation,
                transactionDate: transactionDate,
                description: description,
                usdTryRate: usdTryRate,
                eurTryRate: eurTryRate,
                xauTryRate: xauTryRate,
                rateSnapshotAt: rateSnapshotAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TransactionType type,
                required Currency currency,
                required int amountMinor,
                required int categoryId,
                Value<int?> subcategoryId = const Value.absent(),
                Value<DebtOperation?> debtOperation = const Value.absent(),
                required DateTime transactionDate,
                Value<String?> description = const Value.absent(),
                Value<double?> usdTryRate = const Value.absent(),
                Value<double?> eurTryRate = const Value.absent(),
                Value<double?> xauTryRate = const Value.absent(),
                Value<DateTime?> rateSnapshotAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => TransactionsCompanion.insert(
                id: id,
                type: type,
                currency: currency,
                amountMinor: amountMinor,
                categoryId: categoryId,
                subcategoryId: subcategoryId,
                debtOperation: debtOperation,
                transactionDate: transactionDate,
                description: description,
                usdTryRate: usdTryRate,
                eurTryRate: eurTryRate,
                xauTryRate: xauTryRate,
                rateSnapshotAt: rateSnapshotAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        TransactionRow,
        BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>,
      ),
      TransactionRow,
      PrefetchHooks Function()
    >;
typedef $$ExchangeRateCacheTableCreateCompanionBuilder =
    ExchangeRateCacheCompanion Function({
      Value<int> id,
      required double usdTryRate,
      required double eurTryRate,
      required double xauTryRate,
      required DateTime fetchedAt,
      Value<DateTime?> sourceUpdatedAt,
      Value<DateTime?> cachedAt,
      Value<String?> baseCurrency,
      required String source,
    });
typedef $$ExchangeRateCacheTableUpdateCompanionBuilder =
    ExchangeRateCacheCompanion Function({
      Value<int> id,
      Value<double> usdTryRate,
      Value<double> eurTryRate,
      Value<double> xauTryRate,
      Value<DateTime> fetchedAt,
      Value<DateTime?> sourceUpdatedAt,
      Value<DateTime?> cachedAt,
      Value<String?> baseCurrency,
      Value<String> source,
    });

class $$ExchangeRateCacheTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRateCacheTable> {
  $$ExchangeRateCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get usdTryRate => $composableBuilder(
    column: $table.usdTryRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get eurTryRate => $composableBuilder(
    column: $table.eurTryRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get xauTryRate => $composableBuilder(
    column: $table.xauTryRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sourceUpdatedAt => $composableBuilder(
    column: $table.sourceUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExchangeRateCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRateCacheTable> {
  $$ExchangeRateCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get usdTryRate => $composableBuilder(
    column: $table.usdTryRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get eurTryRate => $composableBuilder(
    column: $table.eurTryRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get xauTryRate => $composableBuilder(
    column: $table.xauTryRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sourceUpdatedAt => $composableBuilder(
    column: $table.sourceUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExchangeRateCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRateCacheTable> {
  $$ExchangeRateCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get usdTryRate => $composableBuilder(
    column: $table.usdTryRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get eurTryRate => $composableBuilder(
    column: $table.eurTryRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get xauTryRate => $composableBuilder(
    column: $table.xauTryRate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get sourceUpdatedAt => $composableBuilder(
    column: $table.sourceUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$ExchangeRateCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExchangeRateCacheTable,
          ExchangeRateRow,
          $$ExchangeRateCacheTableFilterComposer,
          $$ExchangeRateCacheTableOrderingComposer,
          $$ExchangeRateCacheTableAnnotationComposer,
          $$ExchangeRateCacheTableCreateCompanionBuilder,
          $$ExchangeRateCacheTableUpdateCompanionBuilder,
          (
            ExchangeRateRow,
            BaseReferences<
              _$AppDatabase,
              $ExchangeRateCacheTable,
              ExchangeRateRow
            >,
          ),
          ExchangeRateRow,
          PrefetchHooks Function()
        > {
  $$ExchangeRateCacheTableTableManager(
    _$AppDatabase db,
    $ExchangeRateCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRateCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRateCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRateCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> usdTryRate = const Value.absent(),
                Value<double> eurTryRate = const Value.absent(),
                Value<double> xauTryRate = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<DateTime?> sourceUpdatedAt = const Value.absent(),
                Value<DateTime?> cachedAt = const Value.absent(),
                Value<String?> baseCurrency = const Value.absent(),
                Value<String> source = const Value.absent(),
              }) => ExchangeRateCacheCompanion(
                id: id,
                usdTryRate: usdTryRate,
                eurTryRate: eurTryRate,
                xauTryRate: xauTryRate,
                fetchedAt: fetchedAt,
                sourceUpdatedAt: sourceUpdatedAt,
                cachedAt: cachedAt,
                baseCurrency: baseCurrency,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double usdTryRate,
                required double eurTryRate,
                required double xauTryRate,
                required DateTime fetchedAt,
                Value<DateTime?> sourceUpdatedAt = const Value.absent(),
                Value<DateTime?> cachedAt = const Value.absent(),
                Value<String?> baseCurrency = const Value.absent(),
                required String source,
              }) => ExchangeRateCacheCompanion.insert(
                id: id,
                usdTryRate: usdTryRate,
                eurTryRate: eurTryRate,
                xauTryRate: xauTryRate,
                fetchedAt: fetchedAt,
                sourceUpdatedAt: sourceUpdatedAt,
                cachedAt: cachedAt,
                baseCurrency: baseCurrency,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExchangeRateCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExchangeRateCacheTable,
      ExchangeRateRow,
      $$ExchangeRateCacheTableFilterComposer,
      $$ExchangeRateCacheTableOrderingComposer,
      $$ExchangeRateCacheTableAnnotationComposer,
      $$ExchangeRateCacheTableCreateCompanionBuilder,
      $$ExchangeRateCacheTableUpdateCompanionBuilder,
      (
        ExchangeRateRow,
        BaseReferences<_$AppDatabase, $ExchangeRateCacheTable, ExchangeRateRow>,
      ),
      ExchangeRateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$ExchangeRateCacheTableTableManager get exchangeRateCache =>
      $$ExchangeRateCacheTableTableManager(_db, _db.exchangeRateCache);
}

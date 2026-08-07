// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalFoodsTable extends LocalFoods
    with TableInfo<$LocalFoodsTable, LocalFood> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalFoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesPer100gMeta = const VerificationMeta(
    'caloriesPer100g',
  );
  @override
  late final GeneratedColumn<double> caloriesPer100g = GeneratedColumn<double>(
    'calories_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinPer100gGramsMeta =
      const VerificationMeta('proteinPer100gGrams');
  @override
  late final GeneratedColumn<double> proteinPer100gGrams =
      GeneratedColumn<double>(
        'protein_per100g_grams',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _carbsPer100gGramsMeta = const VerificationMeta(
    'carbsPer100gGrams',
  );
  @override
  late final GeneratedColumn<double> carbsPer100gGrams =
      GeneratedColumn<double>(
        'carbs_per100g_grams',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fatPer100gGramsMeta = const VerificationMeta(
    'fatPer100gGrams',
  );
  @override
  late final GeneratedColumn<double> fatPer100gGrams = GeneratedColumn<double>(
    'fat_per100g_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultServingGramsMeta =
      const VerificationMeta('defaultServingGrams');
  @override
  late final GeneratedColumn<double> defaultServingGrams =
      GeneratedColumn<double>(
        'default_serving_grams',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _defaultServingLabelMeta =
      const VerificationMeta('defaultServingLabel');
  @override
  late final GeneratedColumn<String> defaultServingLabel =
      GeneratedColumn<String>(
        'default_serving_label',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<FoodSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FoodSource>($LocalFoodsTable.$convertersource);
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    brand,
    barcode,
    caloriesPer100g,
    proteinPer100gGrams,
    carbsPer100gGrams,
    fatPer100gGrams,
    defaultServingGrams,
    defaultServingLabel,
    source,
    isVerified,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalFood> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('calories_per100g')) {
      context.handle(
        _caloriesPer100gMeta,
        caloriesPer100g.isAcceptableOrUnknown(
          data['calories_per100g']!,
          _caloriesPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesPer100gMeta);
    }
    if (data.containsKey('protein_per100g_grams')) {
      context.handle(
        _proteinPer100gGramsMeta,
        proteinPer100gGrams.isAcceptableOrUnknown(
          data['protein_per100g_grams']!,
          _proteinPer100gGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinPer100gGramsMeta);
    }
    if (data.containsKey('carbs_per100g_grams')) {
      context.handle(
        _carbsPer100gGramsMeta,
        carbsPer100gGrams.isAcceptableOrUnknown(
          data['carbs_per100g_grams']!,
          _carbsPer100gGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbsPer100gGramsMeta);
    }
    if (data.containsKey('fat_per100g_grams')) {
      context.handle(
        _fatPer100gGramsMeta,
        fatPer100gGrams.isAcceptableOrUnknown(
          data['fat_per100g_grams']!,
          _fatPer100gGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fatPer100gGramsMeta);
    }
    if (data.containsKey('default_serving_grams')) {
      context.handle(
        _defaultServingGramsMeta,
        defaultServingGrams.isAcceptableOrUnknown(
          data['default_serving_grams']!,
          _defaultServingGramsMeta,
        ),
      );
    }
    if (data.containsKey('default_serving_label')) {
      context.handle(
        _defaultServingLabelMeta,
        defaultServingLabel.isAcceptableOrUnknown(
          data['default_serving_label']!,
          _defaultServingLabelMeta,
        ),
      );
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalFood map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalFood(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      caloriesPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_per100g'],
      )!,
      proteinPer100gGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_per100g_grams'],
      )!,
      carbsPer100gGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_per100g_grams'],
      )!,
      fatPer100gGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_per100g_grams'],
      )!,
      defaultServingGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_serving_grams'],
      ),
      defaultServingLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_serving_label'],
      ),
      source: $LocalFoodsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verified'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalFoodsTable createAlias(String alias) {
    return $LocalFoodsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FoodSource, String, String> $convertersource =
      const EnumNameConverter<FoodSource>(FoodSource.values);
}

class LocalFood extends DataClass implements Insertable<LocalFood> {
  final String id;
  final String name;
  final String? brand;
  final String? barcode;
  final double caloriesPer100g;
  final double proteinPer100gGrams;
  final double carbsPer100gGrams;
  final double fatPer100gGrams;
  final double? defaultServingGrams;
  final String? defaultServingLabel;
  final FoodSource source;
  final bool isVerified;
  final DateTime createdAt;
  const LocalFood({
    required this.id,
    required this.name,
    this.brand,
    this.barcode,
    required this.caloriesPer100g,
    required this.proteinPer100gGrams,
    required this.carbsPer100gGrams,
    required this.fatPer100gGrams,
    this.defaultServingGrams,
    this.defaultServingLabel,
    required this.source,
    required this.isVerified,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['calories_per100g'] = Variable<double>(caloriesPer100g);
    map['protein_per100g_grams'] = Variable<double>(proteinPer100gGrams);
    map['carbs_per100g_grams'] = Variable<double>(carbsPer100gGrams);
    map['fat_per100g_grams'] = Variable<double>(fatPer100gGrams);
    if (!nullToAbsent || defaultServingGrams != null) {
      map['default_serving_grams'] = Variable<double>(defaultServingGrams);
    }
    if (!nullToAbsent || defaultServingLabel != null) {
      map['default_serving_label'] = Variable<String>(defaultServingLabel);
    }
    {
      map['source'] = Variable<String>(
        $LocalFoodsTable.$convertersource.toSql(source),
      );
    }
    map['is_verified'] = Variable<bool>(isVerified);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalFoodsCompanion toCompanion(bool nullToAbsent) {
    return LocalFoodsCompanion(
      id: Value(id),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      caloriesPer100g: Value(caloriesPer100g),
      proteinPer100gGrams: Value(proteinPer100gGrams),
      carbsPer100gGrams: Value(carbsPer100gGrams),
      fatPer100gGrams: Value(fatPer100gGrams),
      defaultServingGrams: defaultServingGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultServingGrams),
      defaultServingLabel: defaultServingLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultServingLabel),
      source: Value(source),
      isVerified: Value(isVerified),
      createdAt: Value(createdAt),
    );
  }

  factory LocalFood.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalFood(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      caloriesPer100g: serializer.fromJson<double>(json['caloriesPer100g']),
      proteinPer100gGrams: serializer.fromJson<double>(
        json['proteinPer100gGrams'],
      ),
      carbsPer100gGrams: serializer.fromJson<double>(json['carbsPer100gGrams']),
      fatPer100gGrams: serializer.fromJson<double>(json['fatPer100gGrams']),
      defaultServingGrams: serializer.fromJson<double?>(
        json['defaultServingGrams'],
      ),
      defaultServingLabel: serializer.fromJson<String?>(
        json['defaultServingLabel'],
      ),
      source: $LocalFoodsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'barcode': serializer.toJson<String?>(barcode),
      'caloriesPer100g': serializer.toJson<double>(caloriesPer100g),
      'proteinPer100gGrams': serializer.toJson<double>(proteinPer100gGrams),
      'carbsPer100gGrams': serializer.toJson<double>(carbsPer100gGrams),
      'fatPer100gGrams': serializer.toJson<double>(fatPer100gGrams),
      'defaultServingGrams': serializer.toJson<double?>(defaultServingGrams),
      'defaultServingLabel': serializer.toJson<String?>(defaultServingLabel),
      'source': serializer.toJson<String>(
        $LocalFoodsTable.$convertersource.toJson(source),
      ),
      'isVerified': serializer.toJson<bool>(isVerified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalFood copyWith({
    String? id,
    String? name,
    Value<String?> brand = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    double? caloriesPer100g,
    double? proteinPer100gGrams,
    double? carbsPer100gGrams,
    double? fatPer100gGrams,
    Value<double?> defaultServingGrams = const Value.absent(),
    Value<String?> defaultServingLabel = const Value.absent(),
    FoodSource? source,
    bool? isVerified,
    DateTime? createdAt,
  }) => LocalFood(
    id: id ?? this.id,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    barcode: barcode.present ? barcode.value : this.barcode,
    caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
    proteinPer100gGrams: proteinPer100gGrams ?? this.proteinPer100gGrams,
    carbsPer100gGrams: carbsPer100gGrams ?? this.carbsPer100gGrams,
    fatPer100gGrams: fatPer100gGrams ?? this.fatPer100gGrams,
    defaultServingGrams: defaultServingGrams.present
        ? defaultServingGrams.value
        : this.defaultServingGrams,
    defaultServingLabel: defaultServingLabel.present
        ? defaultServingLabel.value
        : this.defaultServingLabel,
    source: source ?? this.source,
    isVerified: isVerified ?? this.isVerified,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalFood copyWithCompanion(LocalFoodsCompanion data) {
    return LocalFood(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      caloriesPer100g: data.caloriesPer100g.present
          ? data.caloriesPer100g.value
          : this.caloriesPer100g,
      proteinPer100gGrams: data.proteinPer100gGrams.present
          ? data.proteinPer100gGrams.value
          : this.proteinPer100gGrams,
      carbsPer100gGrams: data.carbsPer100gGrams.present
          ? data.carbsPer100gGrams.value
          : this.carbsPer100gGrams,
      fatPer100gGrams: data.fatPer100gGrams.present
          ? data.fatPer100gGrams.value
          : this.fatPer100gGrams,
      defaultServingGrams: data.defaultServingGrams.present
          ? data.defaultServingGrams.value
          : this.defaultServingGrams,
      defaultServingLabel: data.defaultServingLabel.present
          ? data.defaultServingLabel.value
          : this.defaultServingLabel,
      source: data.source.present ? data.source.value : this.source,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalFood(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('barcode: $barcode, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('proteinPer100gGrams: $proteinPer100gGrams, ')
          ..write('carbsPer100gGrams: $carbsPer100gGrams, ')
          ..write('fatPer100gGrams: $fatPer100gGrams, ')
          ..write('defaultServingGrams: $defaultServingGrams, ')
          ..write('defaultServingLabel: $defaultServingLabel, ')
          ..write('source: $source, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    brand,
    barcode,
    caloriesPer100g,
    proteinPer100gGrams,
    carbsPer100gGrams,
    fatPer100gGrams,
    defaultServingGrams,
    defaultServingLabel,
    source,
    isVerified,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalFood &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.barcode == this.barcode &&
          other.caloriesPer100g == this.caloriesPer100g &&
          other.proteinPer100gGrams == this.proteinPer100gGrams &&
          other.carbsPer100gGrams == this.carbsPer100gGrams &&
          other.fatPer100gGrams == this.fatPer100gGrams &&
          other.defaultServingGrams == this.defaultServingGrams &&
          other.defaultServingLabel == this.defaultServingLabel &&
          other.source == this.source &&
          other.isVerified == this.isVerified &&
          other.createdAt == this.createdAt);
}

class LocalFoodsCompanion extends UpdateCompanion<LocalFood> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> barcode;
  final Value<double> caloriesPer100g;
  final Value<double> proteinPer100gGrams;
  final Value<double> carbsPer100gGrams;
  final Value<double> fatPer100gGrams;
  final Value<double?> defaultServingGrams;
  final Value<String?> defaultServingLabel;
  final Value<FoodSource> source;
  final Value<bool> isVerified;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalFoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.barcode = const Value.absent(),
    this.caloriesPer100g = const Value.absent(),
    this.proteinPer100gGrams = const Value.absent(),
    this.carbsPer100gGrams = const Value.absent(),
    this.fatPer100gGrams = const Value.absent(),
    this.defaultServingGrams = const Value.absent(),
    this.defaultServingLabel = const Value.absent(),
    this.source = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalFoodsCompanion.insert({
    required String id,
    required String name,
    this.brand = const Value.absent(),
    this.barcode = const Value.absent(),
    required double caloriesPer100g,
    required double proteinPer100gGrams,
    required double carbsPer100gGrams,
    required double fatPer100gGrams,
    this.defaultServingGrams = const Value.absent(),
    this.defaultServingLabel = const Value.absent(),
    required FoodSource source,
    this.isVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       caloriesPer100g = Value(caloriesPer100g),
       proteinPer100gGrams = Value(proteinPer100gGrams),
       carbsPer100gGrams = Value(carbsPer100gGrams),
       fatPer100gGrams = Value(fatPer100gGrams),
       source = Value(source);
  static Insertable<LocalFood> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? barcode,
    Expression<double>? caloriesPer100g,
    Expression<double>? proteinPer100gGrams,
    Expression<double>? carbsPer100gGrams,
    Expression<double>? fatPer100gGrams,
    Expression<double>? defaultServingGrams,
    Expression<String>? defaultServingLabel,
    Expression<String>? source,
    Expression<bool>? isVerified,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (barcode != null) 'barcode': barcode,
      if (caloriesPer100g != null) 'calories_per100g': caloriesPer100g,
      if (proteinPer100gGrams != null)
        'protein_per100g_grams': proteinPer100gGrams,
      if (carbsPer100gGrams != null) 'carbs_per100g_grams': carbsPer100gGrams,
      if (fatPer100gGrams != null) 'fat_per100g_grams': fatPer100gGrams,
      if (defaultServingGrams != null)
        'default_serving_grams': defaultServingGrams,
      if (defaultServingLabel != null)
        'default_serving_label': defaultServingLabel,
      if (source != null) 'source': source,
      if (isVerified != null) 'is_verified': isVerified,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalFoodsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? brand,
    Value<String?>? barcode,
    Value<double>? caloriesPer100g,
    Value<double>? proteinPer100gGrams,
    Value<double>? carbsPer100gGrams,
    Value<double>? fatPer100gGrams,
    Value<double?>? defaultServingGrams,
    Value<String?>? defaultServingLabel,
    Value<FoodSource>? source,
    Value<bool>? isVerified,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalFoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      barcode: barcode ?? this.barcode,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      proteinPer100gGrams: proteinPer100gGrams ?? this.proteinPer100gGrams,
      carbsPer100gGrams: carbsPer100gGrams ?? this.carbsPer100gGrams,
      fatPer100gGrams: fatPer100gGrams ?? this.fatPer100gGrams,
      defaultServingGrams: defaultServingGrams ?? this.defaultServingGrams,
      defaultServingLabel: defaultServingLabel ?? this.defaultServingLabel,
      source: source ?? this.source,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (caloriesPer100g.present) {
      map['calories_per100g'] = Variable<double>(caloriesPer100g.value);
    }
    if (proteinPer100gGrams.present) {
      map['protein_per100g_grams'] = Variable<double>(
        proteinPer100gGrams.value,
      );
    }
    if (carbsPer100gGrams.present) {
      map['carbs_per100g_grams'] = Variable<double>(carbsPer100gGrams.value);
    }
    if (fatPer100gGrams.present) {
      map['fat_per100g_grams'] = Variable<double>(fatPer100gGrams.value);
    }
    if (defaultServingGrams.present) {
      map['default_serving_grams'] = Variable<double>(
        defaultServingGrams.value,
      );
    }
    if (defaultServingLabel.present) {
      map['default_serving_label'] = Variable<String>(
        defaultServingLabel.value,
      );
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $LocalFoodsTable.$convertersource.toSql(source.value),
      );
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalFoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('barcode: $barcode, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('proteinPer100gGrams: $proteinPer100gGrams, ')
          ..write('carbsPer100gGrams: $carbsPer100gGrams, ')
          ..write('fatPer100gGrams: $fatPer100gGrams, ')
          ..write('defaultServingGrams: $defaultServingGrams, ')
          ..write('defaultServingLabel: $defaultServingLabel, ')
          ..write('source: $source, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, servings, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final String id;
  final String name;
  final int servings;
  final DateTime createdAt;
  const Recipe({
    required this.id,
    required this.name,
    required this.servings,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['servings'] = Variable<int>(servings);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      servings: Value(servings),
      createdAt: Value(createdAt),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      servings: serializer.fromJson<int>(json['servings']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'servings': serializer.toJson<int>(servings),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Recipe copyWith({
    String? id,
    String? name,
    int? servings,
    DateTime? createdAt,
  }) => Recipe(
    id: id ?? this.id,
    name: name ?? this.name,
    servings: servings ?? this.servings,
    createdAt: createdAt ?? this.createdAt,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      servings: data.servings.present ? data.servings.value : this.servings,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('servings: $servings, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, servings, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.name == this.name &&
          other.servings == this.servings &&
          other.createdAt == this.createdAt);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> servings;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.servings = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required String name,
    this.servings = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Recipe> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? servings,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (servings != null) 'servings': servings,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? servings,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      servings: servings ?? this.servings,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('servings: $servings, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeIngredientsTable extends RecipeIngredients
    with TableInfo<$RecipeIngredientsTable, RecipeIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_foods (id)',
    ),
  );
  static const VerificationMeta _childRecipeIdMeta = const VerificationMeta(
    'childRecipeId',
  );
  @override
  late final GeneratedColumn<String> childRecipeId = GeneratedColumn<String>(
    'child_recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _quantityGramsMeta = const VerificationMeta(
    'quantityGrams',
  );
  @override
  late final GeneratedColumn<double> quantityGrams = GeneratedColumn<double>(
    'quantity_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingsCountMeta = const VerificationMeta(
    'servingsCount',
  );
  @override
  late final GeneratedColumn<double> servingsCount = GeneratedColumn<double>(
    'servings_count',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    foodId,
    childRecipeId,
    quantityGrams,
    servingsCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeIngredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('child_recipe_id')) {
      context.handle(
        _childRecipeIdMeta,
        childRecipeId.isAcceptableOrUnknown(
          data['child_recipe_id']!,
          _childRecipeIdMeta,
        ),
      );
    }
    if (data.containsKey('quantity_grams')) {
      context.handle(
        _quantityGramsMeta,
        quantityGrams.isAcceptableOrUnknown(
          data['quantity_grams']!,
          _quantityGramsMeta,
        ),
      );
    }
    if (data.containsKey('servings_count')) {
      context.handle(
        _servingsCountMeta,
        servingsCount.isAcceptableOrUnknown(
          data['servings_count']!,
          _servingsCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeIngredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      ),
      childRecipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_recipe_id'],
      ),
      quantityGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_grams'],
      ),
      servingsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}servings_count'],
      ),
    );
  }

  @override
  $RecipeIngredientsTable createAlias(String alias) {
    return $RecipeIngredientsTable(attachedDatabase, alias);
  }
}

class RecipeIngredient extends DataClass
    implements Insertable<RecipeIngredient> {
  final String id;
  final String recipeId;
  final String? foodId;
  final String? childRecipeId;
  final double? quantityGrams;
  final double? servingsCount;
  const RecipeIngredient({
    required this.id,
    required this.recipeId,
    this.foodId,
    this.childRecipeId,
    this.quantityGrams,
    this.servingsCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<String>(foodId);
    }
    if (!nullToAbsent || childRecipeId != null) {
      map['child_recipe_id'] = Variable<String>(childRecipeId);
    }
    if (!nullToAbsent || quantityGrams != null) {
      map['quantity_grams'] = Variable<double>(quantityGrams);
    }
    if (!nullToAbsent || servingsCount != null) {
      map['servings_count'] = Variable<double>(servingsCount);
    }
    return map;
  }

  RecipeIngredientsCompanion toCompanion(bool nullToAbsent) {
    return RecipeIngredientsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      childRecipeId: childRecipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(childRecipeId),
      quantityGrams: quantityGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(quantityGrams),
      servingsCount: servingsCount == null && nullToAbsent
          ? const Value.absent()
          : Value(servingsCount),
    );
  }

  factory RecipeIngredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeIngredient(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      foodId: serializer.fromJson<String?>(json['foodId']),
      childRecipeId: serializer.fromJson<String?>(json['childRecipeId']),
      quantityGrams: serializer.fromJson<double?>(json['quantityGrams']),
      servingsCount: serializer.fromJson<double?>(json['servingsCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'foodId': serializer.toJson<String?>(foodId),
      'childRecipeId': serializer.toJson<String?>(childRecipeId),
      'quantityGrams': serializer.toJson<double?>(quantityGrams),
      'servingsCount': serializer.toJson<double?>(servingsCount),
    };
  }

  RecipeIngredient copyWith({
    String? id,
    String? recipeId,
    Value<String?> foodId = const Value.absent(),
    Value<String?> childRecipeId = const Value.absent(),
    Value<double?> quantityGrams = const Value.absent(),
    Value<double?> servingsCount = const Value.absent(),
  }) => RecipeIngredient(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    foodId: foodId.present ? foodId.value : this.foodId,
    childRecipeId: childRecipeId.present
        ? childRecipeId.value
        : this.childRecipeId,
    quantityGrams: quantityGrams.present
        ? quantityGrams.value
        : this.quantityGrams,
    servingsCount: servingsCount.present
        ? servingsCount.value
        : this.servingsCount,
  );
  RecipeIngredient copyWithCompanion(RecipeIngredientsCompanion data) {
    return RecipeIngredient(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      childRecipeId: data.childRecipeId.present
          ? data.childRecipeId.value
          : this.childRecipeId,
      quantityGrams: data.quantityGrams.present
          ? data.quantityGrams.value
          : this.quantityGrams,
      servingsCount: data.servingsCount.present
          ? data.servingsCount.value
          : this.servingsCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredient(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('foodId: $foodId, ')
          ..write('childRecipeId: $childRecipeId, ')
          ..write('quantityGrams: $quantityGrams, ')
          ..write('servingsCount: $servingsCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    foodId,
    childRecipeId,
    quantityGrams,
    servingsCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeIngredient &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.foodId == this.foodId &&
          other.childRecipeId == this.childRecipeId &&
          other.quantityGrams == this.quantityGrams &&
          other.servingsCount == this.servingsCount);
}

class RecipeIngredientsCompanion extends UpdateCompanion<RecipeIngredient> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<String?> foodId;
  final Value<String?> childRecipeId;
  final Value<double?> quantityGrams;
  final Value<double?> servingsCount;
  final Value<int> rowid;
  const RecipeIngredientsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.childRecipeId = const Value.absent(),
    this.quantityGrams = const Value.absent(),
    this.servingsCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeIngredientsCompanion.insert({
    required String id,
    required String recipeId,
    this.foodId = const Value.absent(),
    this.childRecipeId = const Value.absent(),
    this.quantityGrams = const Value.absent(),
    this.servingsCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId);
  static Insertable<RecipeIngredient> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<String>? foodId,
    Expression<String>? childRecipeId,
    Expression<double>? quantityGrams,
    Expression<double>? servingsCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (foodId != null) 'food_id': foodId,
      if (childRecipeId != null) 'child_recipe_id': childRecipeId,
      if (quantityGrams != null) 'quantity_grams': quantityGrams,
      if (servingsCount != null) 'servings_count': servingsCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeIngredientsCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<String?>? foodId,
    Value<String?>? childRecipeId,
    Value<double?>? quantityGrams,
    Value<double?>? servingsCount,
    Value<int>? rowid,
  }) {
    return RecipeIngredientsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      foodId: foodId ?? this.foodId,
      childRecipeId: childRecipeId ?? this.childRecipeId,
      quantityGrams: quantityGrams ?? this.quantityGrams,
      servingsCount: servingsCount ?? this.servingsCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (childRecipeId.present) {
      map['child_recipe_id'] = Variable<String>(childRecipeId.value);
    }
    if (quantityGrams.present) {
      map['quantity_grams'] = Variable<double>(quantityGrams.value);
    }
    if (servingsCount.present) {
      map['servings_count'] = Variable<double>(servingsCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('foodId: $foodId, ')
          ..write('childRecipeId: $childRecipeId, ')
          ..write('quantityGrams: $quantityGrams, ')
          ..write('servingsCount: $servingsCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LogEntriesTable extends LogEntries
    with TableInfo<$LogEntriesTable, LogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinGramsMeta = const VerificationMeta(
    'proteinGrams',
  );
  @override
  late final GeneratedColumn<double> proteinGrams = GeneratedColumn<double>(
    'protein_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsGramsMeta = const VerificationMeta(
    'carbsGrams',
  );
  @override
  late final GeneratedColumn<double> carbsGrams = GeneratedColumn<double>(
    'carbs_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatGramsMeta = const VerificationMeta(
    'fatGrams',
  );
  @override
  late final GeneratedColumn<double> fatGrams = GeneratedColumn<double>(
    'fat_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityLabelMeta = const VerificationMeta(
    'quantityLabel',
  );
  @override
  late final GeneratedColumn<String> quantityLabel = GeneratedColumn<String>(
    'quantity_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LogMethod, String> method =
      GeneratedColumn<String>(
        'method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LogMethod>($LogEntriesTable.$convertermethod);
  static const VerificationMeta _sourceFoodIdMeta = const VerificationMeta(
    'sourceFoodId',
  );
  @override
  late final GeneratedColumn<String> sourceFoodId = GeneratedColumn<String>(
    'source_food_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_foods (id)',
    ),
  );
  static const VerificationMeta _sourceRecipeIdMeta = const VerificationMeta(
    'sourceRecipeId',
  );
  @override
  late final GeneratedColumn<String> sourceRecipeId = GeneratedColumn<String>(
    'source_recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loggedAt,
    displayName,
    calories,
    proteinGrams,
    carbsGrams,
    fatGrams,
    quantityLabel,
    method,
    sourceFoodId,
    sourceRecipeId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'log_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein_grams')) {
      context.handle(
        _proteinGramsMeta,
        proteinGrams.isAcceptableOrUnknown(
          data['protein_grams']!,
          _proteinGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinGramsMeta);
    }
    if (data.containsKey('carbs_grams')) {
      context.handle(
        _carbsGramsMeta,
        carbsGrams.isAcceptableOrUnknown(data['carbs_grams']!, _carbsGramsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsGramsMeta);
    }
    if (data.containsKey('fat_grams')) {
      context.handle(
        _fatGramsMeta,
        fatGrams.isAcceptableOrUnknown(data['fat_grams']!, _fatGramsMeta),
      );
    } else if (isInserting) {
      context.missing(_fatGramsMeta);
    }
    if (data.containsKey('quantity_label')) {
      context.handle(
        _quantityLabelMeta,
        quantityLabel.isAcceptableOrUnknown(
          data['quantity_label']!,
          _quantityLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityLabelMeta);
    }
    if (data.containsKey('source_food_id')) {
      context.handle(
        _sourceFoodIdMeta,
        sourceFoodId.isAcceptableOrUnknown(
          data['source_food_id']!,
          _sourceFoodIdMeta,
        ),
      );
    }
    if (data.containsKey('source_recipe_id')) {
      context.handle(
        _sourceRecipeIdMeta,
        sourceRecipeId.isAcceptableOrUnknown(
          data['source_recipe_id']!,
          _sourceRecipeIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      proteinGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_grams'],
      )!,
      carbsGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_grams'],
      )!,
      fatGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_grams'],
      )!,
      quantityLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantity_label'],
      )!,
      method: $LogEntriesTable.$convertermethod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}method'],
        )!,
      ),
      sourceFoodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_food_id'],
      ),
      sourceRecipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_recipe_id'],
      ),
    );
  }

  @override
  $LogEntriesTable createAlias(String alias) {
    return $LogEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LogMethod, String, String> $convertermethod =
      const EnumNameConverter<LogMethod>(LogMethod.values);
}

class LogEntry extends DataClass implements Insertable<LogEntry> {
  final String id;
  final DateTime loggedAt;
  final String displayName;
  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final String quantityLabel;
  final LogMethod method;
  final String? sourceFoodId;
  final String? sourceRecipeId;
  const LogEntry({
    required this.id,
    required this.loggedAt,
    required this.displayName,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.quantityLabel,
    required this.method,
    this.sourceFoodId,
    this.sourceRecipeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['display_name'] = Variable<String>(displayName);
    map['calories'] = Variable<double>(calories);
    map['protein_grams'] = Variable<double>(proteinGrams);
    map['carbs_grams'] = Variable<double>(carbsGrams);
    map['fat_grams'] = Variable<double>(fatGrams);
    map['quantity_label'] = Variable<String>(quantityLabel);
    {
      map['method'] = Variable<String>(
        $LogEntriesTable.$convertermethod.toSql(method),
      );
    }
    if (!nullToAbsent || sourceFoodId != null) {
      map['source_food_id'] = Variable<String>(sourceFoodId);
    }
    if (!nullToAbsent || sourceRecipeId != null) {
      map['source_recipe_id'] = Variable<String>(sourceRecipeId);
    }
    return map;
  }

  LogEntriesCompanion toCompanion(bool nullToAbsent) {
    return LogEntriesCompanion(
      id: Value(id),
      loggedAt: Value(loggedAt),
      displayName: Value(displayName),
      calories: Value(calories),
      proteinGrams: Value(proteinGrams),
      carbsGrams: Value(carbsGrams),
      fatGrams: Value(fatGrams),
      quantityLabel: Value(quantityLabel),
      method: Value(method),
      sourceFoodId: sourceFoodId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceFoodId),
      sourceRecipeId: sourceRecipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRecipeId),
    );
  }

  factory LogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogEntry(
      id: serializer.fromJson<String>(json['id']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      displayName: serializer.fromJson<String>(json['displayName']),
      calories: serializer.fromJson<double>(json['calories']),
      proteinGrams: serializer.fromJson<double>(json['proteinGrams']),
      carbsGrams: serializer.fromJson<double>(json['carbsGrams']),
      fatGrams: serializer.fromJson<double>(json['fatGrams']),
      quantityLabel: serializer.fromJson<String>(json['quantityLabel']),
      method: $LogEntriesTable.$convertermethod.fromJson(
        serializer.fromJson<String>(json['method']),
      ),
      sourceFoodId: serializer.fromJson<String?>(json['sourceFoodId']),
      sourceRecipeId: serializer.fromJson<String?>(json['sourceRecipeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'displayName': serializer.toJson<String>(displayName),
      'calories': serializer.toJson<double>(calories),
      'proteinGrams': serializer.toJson<double>(proteinGrams),
      'carbsGrams': serializer.toJson<double>(carbsGrams),
      'fatGrams': serializer.toJson<double>(fatGrams),
      'quantityLabel': serializer.toJson<String>(quantityLabel),
      'method': serializer.toJson<String>(
        $LogEntriesTable.$convertermethod.toJson(method),
      ),
      'sourceFoodId': serializer.toJson<String?>(sourceFoodId),
      'sourceRecipeId': serializer.toJson<String?>(sourceRecipeId),
    };
  }

  LogEntry copyWith({
    String? id,
    DateTime? loggedAt,
    String? displayName,
    double? calories,
    double? proteinGrams,
    double? carbsGrams,
    double? fatGrams,
    String? quantityLabel,
    LogMethod? method,
    Value<String?> sourceFoodId = const Value.absent(),
    Value<String?> sourceRecipeId = const Value.absent(),
  }) => LogEntry(
    id: id ?? this.id,
    loggedAt: loggedAt ?? this.loggedAt,
    displayName: displayName ?? this.displayName,
    calories: calories ?? this.calories,
    proteinGrams: proteinGrams ?? this.proteinGrams,
    carbsGrams: carbsGrams ?? this.carbsGrams,
    fatGrams: fatGrams ?? this.fatGrams,
    quantityLabel: quantityLabel ?? this.quantityLabel,
    method: method ?? this.method,
    sourceFoodId: sourceFoodId.present ? sourceFoodId.value : this.sourceFoodId,
    sourceRecipeId: sourceRecipeId.present
        ? sourceRecipeId.value
        : this.sourceRecipeId,
  );
  LogEntry copyWithCompanion(LogEntriesCompanion data) {
    return LogEntry(
      id: data.id.present ? data.id.value : this.id,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinGrams: data.proteinGrams.present
          ? data.proteinGrams.value
          : this.proteinGrams,
      carbsGrams: data.carbsGrams.present
          ? data.carbsGrams.value
          : this.carbsGrams,
      fatGrams: data.fatGrams.present ? data.fatGrams.value : this.fatGrams,
      quantityLabel: data.quantityLabel.present
          ? data.quantityLabel.value
          : this.quantityLabel,
      method: data.method.present ? data.method.value : this.method,
      sourceFoodId: data.sourceFoodId.present
          ? data.sourceFoodId.value
          : this.sourceFoodId,
      sourceRecipeId: data.sourceRecipeId.present
          ? data.sourceRecipeId.value
          : this.sourceRecipeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LogEntry(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('displayName: $displayName, ')
          ..write('calories: $calories, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('quantityLabel: $quantityLabel, ')
          ..write('method: $method, ')
          ..write('sourceFoodId: $sourceFoodId, ')
          ..write('sourceRecipeId: $sourceRecipeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    loggedAt,
    displayName,
    calories,
    proteinGrams,
    carbsGrams,
    fatGrams,
    quantityLabel,
    method,
    sourceFoodId,
    sourceRecipeId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogEntry &&
          other.id == this.id &&
          other.loggedAt == this.loggedAt &&
          other.displayName == this.displayName &&
          other.calories == this.calories &&
          other.proteinGrams == this.proteinGrams &&
          other.carbsGrams == this.carbsGrams &&
          other.fatGrams == this.fatGrams &&
          other.quantityLabel == this.quantityLabel &&
          other.method == this.method &&
          other.sourceFoodId == this.sourceFoodId &&
          other.sourceRecipeId == this.sourceRecipeId);
}

class LogEntriesCompanion extends UpdateCompanion<LogEntry> {
  final Value<String> id;
  final Value<DateTime> loggedAt;
  final Value<String> displayName;
  final Value<double> calories;
  final Value<double> proteinGrams;
  final Value<double> carbsGrams;
  final Value<double> fatGrams;
  final Value<String> quantityLabel;
  final Value<LogMethod> method;
  final Value<String?> sourceFoodId;
  final Value<String?> sourceRecipeId;
  final Value<int> rowid;
  const LogEntriesCompanion({
    this.id = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.displayName = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.quantityLabel = const Value.absent(),
    this.method = const Value.absent(),
    this.sourceFoodId = const Value.absent(),
    this.sourceRecipeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LogEntriesCompanion.insert({
    required String id,
    required DateTime loggedAt,
    required String displayName,
    required double calories,
    required double proteinGrams,
    required double carbsGrams,
    required double fatGrams,
    required String quantityLabel,
    required LogMethod method,
    this.sourceFoodId = const Value.absent(),
    this.sourceRecipeId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       loggedAt = Value(loggedAt),
       displayName = Value(displayName),
       calories = Value(calories),
       proteinGrams = Value(proteinGrams),
       carbsGrams = Value(carbsGrams),
       fatGrams = Value(fatGrams),
       quantityLabel = Value(quantityLabel),
       method = Value(method);
  static Insertable<LogEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? loggedAt,
    Expression<String>? displayName,
    Expression<double>? calories,
    Expression<double>? proteinGrams,
    Expression<double>? carbsGrams,
    Expression<double>? fatGrams,
    Expression<String>? quantityLabel,
    Expression<String>? method,
    Expression<String>? sourceFoodId,
    Expression<String>? sourceRecipeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (displayName != null) 'display_name': displayName,
      if (calories != null) 'calories': calories,
      if (proteinGrams != null) 'protein_grams': proteinGrams,
      if (carbsGrams != null) 'carbs_grams': carbsGrams,
      if (fatGrams != null) 'fat_grams': fatGrams,
      if (quantityLabel != null) 'quantity_label': quantityLabel,
      if (method != null) 'method': method,
      if (sourceFoodId != null) 'source_food_id': sourceFoodId,
      if (sourceRecipeId != null) 'source_recipe_id': sourceRecipeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LogEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? loggedAt,
    Value<String>? displayName,
    Value<double>? calories,
    Value<double>? proteinGrams,
    Value<double>? carbsGrams,
    Value<double>? fatGrams,
    Value<String>? quantityLabel,
    Value<LogMethod>? method,
    Value<String?>? sourceFoodId,
    Value<String?>? sourceRecipeId,
    Value<int>? rowid,
  }) {
    return LogEntriesCompanion(
      id: id ?? this.id,
      loggedAt: loggedAt ?? this.loggedAt,
      displayName: displayName ?? this.displayName,
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      quantityLabel: quantityLabel ?? this.quantityLabel,
      method: method ?? this.method,
      sourceFoodId: sourceFoodId ?? this.sourceFoodId,
      sourceRecipeId: sourceRecipeId ?? this.sourceRecipeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (proteinGrams.present) {
      map['protein_grams'] = Variable<double>(proteinGrams.value);
    }
    if (carbsGrams.present) {
      map['carbs_grams'] = Variable<double>(carbsGrams.value);
    }
    if (fatGrams.present) {
      map['fat_grams'] = Variable<double>(fatGrams.value);
    }
    if (quantityLabel.present) {
      map['quantity_label'] = Variable<String>(quantityLabel.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(
        $LogEntriesTable.$convertermethod.toSql(method.value),
      );
    }
    if (sourceFoodId.present) {
      map['source_food_id'] = Variable<String>(sourceFoodId.value);
    }
    if (sourceRecipeId.present) {
      map['source_recipe_id'] = Variable<String>(sourceRecipeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('displayName: $displayName, ')
          ..write('calories: $calories, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('quantityLabel: $quantityLabel, ')
          ..write('method: $method, ')
          ..write('sourceFoodId: $sourceFoodId, ')
          ..write('sourceRecipeId: $sourceRecipeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalFoodsTable localFoods = $LocalFoodsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeIngredientsTable recipeIngredients =
      $RecipeIngredientsTable(this);
  late final $LogEntriesTable logEntries = $LogEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localFoods,
    recipes,
    recipeIngredients,
    logEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recipe_ingredients', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LocalFoodsTableCreateCompanionBuilder =
    LocalFoodsCompanion Function({
      required String id,
      required String name,
      Value<String?> brand,
      Value<String?> barcode,
      required double caloriesPer100g,
      required double proteinPer100gGrams,
      required double carbsPer100gGrams,
      required double fatPer100gGrams,
      Value<double?> defaultServingGrams,
      Value<String?> defaultServingLabel,
      required FoodSource source,
      Value<bool> isVerified,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$LocalFoodsTableUpdateCompanionBuilder =
    LocalFoodsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> brand,
      Value<String?> barcode,
      Value<double> caloriesPer100g,
      Value<double> proteinPer100gGrams,
      Value<double> carbsPer100gGrams,
      Value<double> fatPer100gGrams,
      Value<double?> defaultServingGrams,
      Value<String?> defaultServingLabel,
      Value<FoodSource> source,
      Value<bool> isVerified,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$LocalFoodsTableReferences
    extends BaseReferences<_$AppDatabase, $LocalFoodsTable, LocalFood> {
  $$LocalFoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeIngredientsTable, List<RecipeIngredient>>
  _recipeIngredientsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeIngredients,
        aliasName: 'local_foods__id__recipe_ingredients__food_id',
      );

  $$RecipeIngredientsTableProcessedTableManager get recipeIngredientsRefs {
    final manager = $$RecipeIngredientsTableTableManager(
      $_db,
      $_db.recipeIngredients,
    ).filter((f) => f.foodId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeIngredientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LogEntriesTable, List<LogEntry>>
  _logEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.logEntries,
    aliasName: 'local_foods__id__log_entries__source_food_id',
  );

  $$LogEntriesTableProcessedTableManager get logEntriesRefs {
    final manager = $$LogEntriesTableTableManager(
      $_db,
      $_db.logEntries,
    ).filter((f) => f.sourceFoodId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_logEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalFoodsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalFoodsTable> {
  $$LocalFoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPer100gGrams => $composableBuilder(
    column: $table.proteinPer100gGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsPer100gGrams => $composableBuilder(
    column: $table.carbsPer100gGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPer100gGrams => $composableBuilder(
    column: $table.fatPer100gGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultServingGrams => $composableBuilder(
    column: $table.defaultServingGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultServingLabel => $composableBuilder(
    column: $table.defaultServingLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FoodSource, FoodSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recipeIngredientsRefs(
    Expression<bool> Function($$RecipeIngredientsTableFilterComposer f) f,
  ) {
    final $$RecipeIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeIngredients,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.recipeIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> logEntriesRefs(
    Expression<bool> Function($$LogEntriesTableFilterComposer f) f,
  ) {
    final $$LogEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.logEntries,
      getReferencedColumn: (t) => t.sourceFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogEntriesTableFilterComposer(
            $db: $db,
            $table: $db.logEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalFoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalFoodsTable> {
  $$LocalFoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPer100gGrams => $composableBuilder(
    column: $table.proteinPer100gGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsPer100gGrams => $composableBuilder(
    column: $table.carbsPer100gGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPer100gGrams => $composableBuilder(
    column: $table.fatPer100gGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultServingGrams => $composableBuilder(
    column: $table.defaultServingGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultServingLabel => $composableBuilder(
    column: $table.defaultServingLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalFoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalFoodsTable> {
  $$LocalFoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinPer100gGrams => $composableBuilder(
    column: $table.proteinPer100gGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsPer100gGrams => $composableBuilder(
    column: $table.carbsPer100gGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatPer100gGrams => $composableBuilder(
    column: $table.fatPer100gGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultServingGrams => $composableBuilder(
    column: $table.defaultServingGrams,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultServingLabel => $composableBuilder(
    column: $table.defaultServingLabel,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FoodSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> recipeIngredientsRefs<T extends Object>(
    Expression<T> Function($$RecipeIngredientsTableAnnotationComposer a) f,
  ) {
    final $$RecipeIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeIngredients,
          getReferencedColumn: (t) => t.foodId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> logEntriesRefs<T extends Object>(
    Expression<T> Function($$LogEntriesTableAnnotationComposer a) f,
  ) {
    final $$LogEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.logEntries,
      getReferencedColumn: (t) => t.sourceFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.logEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalFoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalFoodsTable,
          LocalFood,
          $$LocalFoodsTableFilterComposer,
          $$LocalFoodsTableOrderingComposer,
          $$LocalFoodsTableAnnotationComposer,
          $$LocalFoodsTableCreateCompanionBuilder,
          $$LocalFoodsTableUpdateCompanionBuilder,
          (LocalFood, $$LocalFoodsTableReferences),
          LocalFood,
          PrefetchHooks Function({
            bool recipeIngredientsRefs,
            bool logEntriesRefs,
          })
        > {
  $$LocalFoodsTableTableManager(_$AppDatabase db, $LocalFoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalFoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalFoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalFoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<double> caloriesPer100g = const Value.absent(),
                Value<double> proteinPer100gGrams = const Value.absent(),
                Value<double> carbsPer100gGrams = const Value.absent(),
                Value<double> fatPer100gGrams = const Value.absent(),
                Value<double?> defaultServingGrams = const Value.absent(),
                Value<String?> defaultServingLabel = const Value.absent(),
                Value<FoodSource> source = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFoodsCompanion(
                id: id,
                name: name,
                brand: brand,
                barcode: barcode,
                caloriesPer100g: caloriesPer100g,
                proteinPer100gGrams: proteinPer100gGrams,
                carbsPer100gGrams: carbsPer100gGrams,
                fatPer100gGrams: fatPer100gGrams,
                defaultServingGrams: defaultServingGrams,
                defaultServingLabel: defaultServingLabel,
                source: source,
                isVerified: isVerified,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> brand = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                required double caloriesPer100g,
                required double proteinPer100gGrams,
                required double carbsPer100gGrams,
                required double fatPer100gGrams,
                Value<double?> defaultServingGrams = const Value.absent(),
                Value<String?> defaultServingLabel = const Value.absent(),
                required FoodSource source,
                Value<bool> isVerified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFoodsCompanion.insert(
                id: id,
                name: name,
                brand: brand,
                barcode: barcode,
                caloriesPer100g: caloriesPer100g,
                proteinPer100gGrams: proteinPer100gGrams,
                carbsPer100gGrams: carbsPer100gGrams,
                fatPer100gGrams: fatPer100gGrams,
                defaultServingGrams: defaultServingGrams,
                defaultServingLabel: defaultServingLabel,
                source: source,
                isVerified: isVerified,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalFoodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({recipeIngredientsRefs = false, logEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recipeIngredientsRefs) db.recipeIngredients,
                    if (logEntriesRefs) db.logEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recipeIngredientsRefs)
                        await $_getPrefetchedData<
                          LocalFood,
                          $LocalFoodsTable,
                          RecipeIngredient
                        >(
                          currentTable: table,
                          referencedTable: $$LocalFoodsTableReferences
                              ._recipeIngredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalFoodsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeIngredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.foodId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (logEntriesRefs)
                        await $_getPrefetchedData<
                          LocalFood,
                          $LocalFoodsTable,
                          LogEntry
                        >(
                          currentTable: table,
                          referencedTable: $$LocalFoodsTableReferences
                              ._logEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalFoodsTableReferences(
                                db,
                                table,
                                p0,
                              ).logEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceFoodId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LocalFoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalFoodsTable,
      LocalFood,
      $$LocalFoodsTableFilterComposer,
      $$LocalFoodsTableOrderingComposer,
      $$LocalFoodsTableAnnotationComposer,
      $$LocalFoodsTableCreateCompanionBuilder,
      $$LocalFoodsTableUpdateCompanionBuilder,
      (LocalFood, $$LocalFoodsTableReferences),
      LocalFood,
      PrefetchHooks Function({bool recipeIngredientsRefs, bool logEntriesRefs})
    >;
typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      required String id,
      required String name,
      Value<int> servings,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> servings,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeIngredientsTable, List<RecipeIngredient>>
  _ingredientLinesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeIngredients,
    aliasName: 'recipes__id__recipe_ingredients__recipe_id',
  );

  $$RecipeIngredientsTableProcessedTableManager get ingredientLines {
    final manager = $$RecipeIngredientsTableTableManager(
      $_db,
      $_db.recipeIngredients,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingredientLinesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeIngredientsTable, List<RecipeIngredient>>
  _parentIngredientLinesTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeIngredients,
        aliasName: 'recipes__id__recipe_ingredients__child_recipe_id',
      );

  $$RecipeIngredientsTableProcessedTableManager get parentIngredientLines {
    final manager = $$RecipeIngredientsTableTableManager(
      $_db,
      $_db.recipeIngredients,
    ).filter((f) => f.childRecipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _parentIngredientLinesTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LogEntriesTable, List<LogEntry>>
  _logEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.logEntries,
    aliasName: 'recipes__id__log_entries__source_recipe_id',
  );

  $$LogEntriesTableProcessedTableManager get logEntriesRefs {
    final manager = $$LogEntriesTableTableManager(
      $_db,
      $_db.logEntries,
    ).filter((f) => f.sourceRecipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_logEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ingredientLines(
    Expression<bool> Function($$RecipeIngredientsTableFilterComposer f) f,
  ) {
    final $$RecipeIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeIngredients,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.recipeIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> parentIngredientLines(
    Expression<bool> Function($$RecipeIngredientsTableFilterComposer f) f,
  ) {
    final $$RecipeIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeIngredients,
      getReferencedColumn: (t) => t.childRecipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.recipeIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> logEntriesRefs(
    Expression<bool> Function($$LogEntriesTableFilterComposer f) f,
  ) {
    final $$LogEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.logEntries,
      getReferencedColumn: (t) => t.sourceRecipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogEntriesTableFilterComposer(
            $db: $db,
            $table: $db.logEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> ingredientLines<T extends Object>(
    Expression<T> Function($$RecipeIngredientsTableAnnotationComposer a) f,
  ) {
    final $$RecipeIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeIngredients,
          getReferencedColumn: (t) => t.recipeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> parentIngredientLines<T extends Object>(
    Expression<T> Function($$RecipeIngredientsTableAnnotationComposer a) f,
  ) {
    final $$RecipeIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeIngredients,
          getReferencedColumn: (t) => t.childRecipeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> logEntriesRefs<T extends Object>(
    Expression<T> Function($$LogEntriesTableAnnotationComposer a) f,
  ) {
    final $$LogEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.logEntries,
      getReferencedColumn: (t) => t.sourceRecipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.logEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, $$RecipesTableReferences),
          Recipe,
          PrefetchHooks Function({
            bool ingredientLines,
            bool parentIngredientLines,
            bool logEntriesRefs,
          })
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> servings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                name: name,
                servings: servings,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> servings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                name: name,
                servings: servings,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ingredientLines = false,
                parentIngredientLines = false,
                logEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ingredientLines) db.recipeIngredients,
                    if (parentIngredientLines) db.recipeIngredients,
                    if (logEntriesRefs) db.logEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ingredientLines)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeIngredient
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._ingredientLinesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientLines,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (parentIngredientLines)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeIngredient
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._parentIngredientLinesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).parentIngredientLines,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childRecipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (logEntriesRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          LogEntry
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._logEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).logEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceRecipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, $$RecipesTableReferences),
      Recipe,
      PrefetchHooks Function({
        bool ingredientLines,
        bool parentIngredientLines,
        bool logEntriesRefs,
      })
    >;
typedef $$RecipeIngredientsTableCreateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      required String id,
      required String recipeId,
      Value<String?> foodId,
      Value<String?> childRecipeId,
      Value<double?> quantityGrams,
      Value<double?> servingsCount,
      Value<int> rowid,
    });
typedef $$RecipeIngredientsTableUpdateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<String?> foodId,
      Value<String?> childRecipeId,
      Value<double?> quantityGrams,
      Value<double?> servingsCount,
      Value<int> rowid,
    });

final class $$RecipeIngredientsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredient
        > {
  $$RecipeIngredientsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('recipe_ingredients__recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocalFoodsTable _foodIdTable(_$AppDatabase db) =>
      db.localFoods.createAlias('recipe_ingredients__food_id__local_foods__id');

  $$LocalFoodsTableProcessedTableManager? get foodId {
    final $_column = $_itemColumn<String>('food_id');
    if ($_column == null) return null;
    final manager = $$LocalFoodsTableTableManager(
      $_db,
      $_db.localFoods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecipesTable _childRecipeIdTable(_$AppDatabase db) => db.recipes
      .createAlias('recipe_ingredients__child_recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager? get childRecipeId {
    final $_column = $_itemColumn<String>('child_recipe_id');
    if ($_column == null) return null;
    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childRecipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityGrams => $composableBuilder(
    column: $table.quantityGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servingsCount => $composableBuilder(
    column: $table.servingsCount,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalFoodsTableFilterComposer get foodId {
    final $$LocalFoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.localFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalFoodsTableFilterComposer(
            $db: $db,
            $table: $db.localFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableFilterComposer get childRecipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childRecipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityGrams => $composableBuilder(
    column: $table.quantityGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servingsCount => $composableBuilder(
    column: $table.servingsCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalFoodsTableOrderingComposer get foodId {
    final $$LocalFoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.localFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalFoodsTableOrderingComposer(
            $db: $db,
            $table: $db.localFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableOrderingComposer get childRecipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childRecipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantityGrams => $composableBuilder(
    column: $table.quantityGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get servingsCount => $composableBuilder(
    column: $table.servingsCount,
    builder: (column) => column,
  );

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalFoodsTableAnnotationComposer get foodId {
    final $$LocalFoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.localFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalFoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.localFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableAnnotationComposer get childRecipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childRecipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredient,
          $$RecipeIngredientsTableFilterComposer,
          $$RecipeIngredientsTableOrderingComposer,
          $$RecipeIngredientsTableAnnotationComposer,
          $$RecipeIngredientsTableCreateCompanionBuilder,
          $$RecipeIngredientsTableUpdateCompanionBuilder,
          (RecipeIngredient, $$RecipeIngredientsTableReferences),
          RecipeIngredient,
          PrefetchHooks Function({
            bool recipeId,
            bool foodId,
            bool childRecipeId,
          })
        > {
  $$RecipeIngredientsTableTableManager(
    _$AppDatabase db,
    $RecipeIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeIngredientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String?> foodId = const Value.absent(),
                Value<String?> childRecipeId = const Value.absent(),
                Value<double?> quantityGrams = const Value.absent(),
                Value<double?> servingsCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeIngredientsCompanion(
                id: id,
                recipeId: recipeId,
                foodId: foodId,
                childRecipeId: childRecipeId,
                quantityGrams: quantityGrams,
                servingsCount: servingsCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                Value<String?> foodId = const Value.absent(),
                Value<String?> childRecipeId = const Value.absent(),
                Value<double?> quantityGrams = const Value.absent(),
                Value<double?> servingsCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeIngredientsCompanion.insert(
                id: id,
                recipeId: recipeId,
                foodId: foodId,
                childRecipeId: childRecipeId,
                quantityGrams: quantityGrams,
                servingsCount: servingsCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeIngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({recipeId = false, foodId = false, childRecipeId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (recipeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.recipeId,
                                    referencedTable:
                                        $$RecipeIngredientsTableReferences
                                            ._recipeIdTable(db),
                                    referencedColumn:
                                        $$RecipeIngredientsTableReferences
                                            ._recipeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (foodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.foodId,
                                    referencedTable:
                                        $$RecipeIngredientsTableReferences
                                            ._foodIdTable(db),
                                    referencedColumn:
                                        $$RecipeIngredientsTableReferences
                                            ._foodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (childRecipeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.childRecipeId,
                                    referencedTable:
                                        $$RecipeIngredientsTableReferences
                                            ._childRecipeIdTable(db),
                                    referencedColumn:
                                        $$RecipeIngredientsTableReferences
                                            ._childRecipeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RecipeIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeIngredientsTable,
      RecipeIngredient,
      $$RecipeIngredientsTableFilterComposer,
      $$RecipeIngredientsTableOrderingComposer,
      $$RecipeIngredientsTableAnnotationComposer,
      $$RecipeIngredientsTableCreateCompanionBuilder,
      $$RecipeIngredientsTableUpdateCompanionBuilder,
      (RecipeIngredient, $$RecipeIngredientsTableReferences),
      RecipeIngredient,
      PrefetchHooks Function({bool recipeId, bool foodId, bool childRecipeId})
    >;
typedef $$LogEntriesTableCreateCompanionBuilder =
    LogEntriesCompanion Function({
      required String id,
      required DateTime loggedAt,
      required String displayName,
      required double calories,
      required double proteinGrams,
      required double carbsGrams,
      required double fatGrams,
      required String quantityLabel,
      required LogMethod method,
      Value<String?> sourceFoodId,
      Value<String?> sourceRecipeId,
      Value<int> rowid,
    });
typedef $$LogEntriesTableUpdateCompanionBuilder =
    LogEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> loggedAt,
      Value<String> displayName,
      Value<double> calories,
      Value<double> proteinGrams,
      Value<double> carbsGrams,
      Value<double> fatGrams,
      Value<String> quantityLabel,
      Value<LogMethod> method,
      Value<String?> sourceFoodId,
      Value<String?> sourceRecipeId,
      Value<int> rowid,
    });

final class $$LogEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $LogEntriesTable, LogEntry> {
  $$LogEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocalFoodsTable _sourceFoodIdTable(_$AppDatabase db) =>
      db.localFoods.createAlias('log_entries__source_food_id__local_foods__id');

  $$LocalFoodsTableProcessedTableManager? get sourceFoodId {
    final $_column = $_itemColumn<String>('source_food_id');
    if ($_column == null) return null;
    final manager = $$LocalFoodsTableTableManager(
      $_db,
      $_db.localFoods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceFoodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecipesTable _sourceRecipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('log_entries__source_recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager? get sourceRecipeId {
    final $_column = $_itemColumn<String>('source_recipe_id');
    if ($_column == null) return null;
    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceRecipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LogEntriesTable> {
  $$LogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quantityLabel => $composableBuilder(
    column: $table.quantityLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LogMethod, LogMethod, String> get method =>
      $composableBuilder(
        column: $table.method,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$LocalFoodsTableFilterComposer get sourceFoodId {
    final $$LocalFoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceFoodId,
      referencedTable: $db.localFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalFoodsTableFilterComposer(
            $db: $db,
            $table: $db.localFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableFilterComposer get sourceRecipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceRecipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LogEntriesTable> {
  $$LogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantityLabel => $composableBuilder(
    column: $table.quantityLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalFoodsTableOrderingComposer get sourceFoodId {
    final $$LocalFoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceFoodId,
      referencedTable: $db.localFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalFoodsTableOrderingComposer(
            $db: $db,
            $table: $db.localFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableOrderingComposer get sourceRecipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceRecipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LogEntriesTable> {
  $$LogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatGrams =>
      $composableBuilder(column: $table.fatGrams, builder: (column) => column);

  GeneratedColumn<String> get quantityLabel => $composableBuilder(
    column: $table.quantityLabel,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LogMethod, String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  $$LocalFoodsTableAnnotationComposer get sourceFoodId {
    final $$LocalFoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceFoodId,
      referencedTable: $db.localFoods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalFoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.localFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableAnnotationComposer get sourceRecipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceRecipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LogEntriesTable,
          LogEntry,
          $$LogEntriesTableFilterComposer,
          $$LogEntriesTableOrderingComposer,
          $$LogEntriesTableAnnotationComposer,
          $$LogEntriesTableCreateCompanionBuilder,
          $$LogEntriesTableUpdateCompanionBuilder,
          (LogEntry, $$LogEntriesTableReferences),
          LogEntry,
          PrefetchHooks Function({bool sourceFoodId, bool sourceRecipeId})
        > {
  $$LogEntriesTableTableManager(_$AppDatabase db, $LogEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> proteinGrams = const Value.absent(),
                Value<double> carbsGrams = const Value.absent(),
                Value<double> fatGrams = const Value.absent(),
                Value<String> quantityLabel = const Value.absent(),
                Value<LogMethod> method = const Value.absent(),
                Value<String?> sourceFoodId = const Value.absent(),
                Value<String?> sourceRecipeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LogEntriesCompanion(
                id: id,
                loggedAt: loggedAt,
                displayName: displayName,
                calories: calories,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                quantityLabel: quantityLabel,
                method: method,
                sourceFoodId: sourceFoodId,
                sourceRecipeId: sourceRecipeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime loggedAt,
                required String displayName,
                required double calories,
                required double proteinGrams,
                required double carbsGrams,
                required double fatGrams,
                required String quantityLabel,
                required LogMethod method,
                Value<String?> sourceFoodId = const Value.absent(),
                Value<String?> sourceRecipeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LogEntriesCompanion.insert(
                id: id,
                loggedAt: loggedAt,
                displayName: displayName,
                calories: calories,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                quantityLabel: quantityLabel,
                method: method,
                sourceFoodId: sourceFoodId,
                sourceRecipeId: sourceRecipeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LogEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceFoodId = false, sourceRecipeId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceFoodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceFoodId,
                                    referencedTable: $$LogEntriesTableReferences
                                        ._sourceFoodIdTable(db),
                                    referencedColumn:
                                        $$LogEntriesTableReferences
                                            ._sourceFoodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceRecipeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceRecipeId,
                                    referencedTable: $$LogEntriesTableReferences
                                        ._sourceRecipeIdTable(db),
                                    referencedColumn:
                                        $$LogEntriesTableReferences
                                            ._sourceRecipeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$LogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LogEntriesTable,
      LogEntry,
      $$LogEntriesTableFilterComposer,
      $$LogEntriesTableOrderingComposer,
      $$LogEntriesTableAnnotationComposer,
      $$LogEntriesTableCreateCompanionBuilder,
      $$LogEntriesTableUpdateCompanionBuilder,
      (LogEntry, $$LogEntriesTableReferences),
      LogEntry,
      PrefetchHooks Function({bool sourceFoodId, bool sourceRecipeId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalFoodsTableTableManager get localFoods =>
      $$LocalFoodsTableTableManager(_db, _db.localFoods);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeIngredientsTableTableManager get recipeIngredients =>
      $$RecipeIngredientsTableTableManager(_db, _db.recipeIngredients);
  $$LogEntriesTableTableManager get logEntries =>
      $$LogEntriesTableTableManager(_db, _db.logEntries);
}

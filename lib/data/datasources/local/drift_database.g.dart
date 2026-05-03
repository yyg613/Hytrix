// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $WatchHistoryTable extends WatchHistory
    with TableInfo<$WatchHistoryTable, WatchHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WatchHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _animeIdMeta = const VerificationMeta(
    'animeId',
  );
  @override
  late final GeneratedColumn<int> animeId = GeneratedColumn<int>(
    'anime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeIdMeta = const VerificationMeta(
    'episodeId',
  );
  @override
  late final GeneratedColumn<int> episodeId = GeneratedColumn<int>(
    'episode_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animeTitleMeta = const VerificationMeta(
    'animeTitle',
  );
  @override
  late final GeneratedColumn<String> animeTitle = GeneratedColumn<String>(
    'anime_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeTitleMeta = const VerificationMeta(
    'episodeTitle',
  );
  @override
  late final GeneratedColumn<String> episodeTitle = GeneratedColumn<String>(
    'episode_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _watchedAtMeta = const VerificationMeta(
    'watchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> watchedAt = GeneratedColumn<DateTime>(
    'watched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animeId,
    episodeId,
    animeTitle,
    episodeTitle,
    thumbnailUrl,
    progress,
    duration,
    watchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'watch_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<WatchHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('anime_id')) {
      context.handle(
        _animeIdMeta,
        animeId.isAcceptableOrUnknown(data['anime_id']!, _animeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animeIdMeta);
    }
    if (data.containsKey('episode_id')) {
      context.handle(
        _episodeIdMeta,
        episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_episodeIdMeta);
    }
    if (data.containsKey('anime_title')) {
      context.handle(
        _animeTitleMeta,
        animeTitle.isAcceptableOrUnknown(data['anime_title']!, _animeTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_animeTitleMeta);
    }
    if (data.containsKey('episode_title')) {
      context.handle(
        _episodeTitleMeta,
        episodeTitle.isAcceptableOrUnknown(
          data['episode_title']!,
          _episodeTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeTitleMeta);
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('watched_at')) {
      context.handle(
        _watchedAtMeta,
        watchedAt.isAcceptableOrUnknown(data['watched_at']!, _watchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WatchHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WatchHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      animeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anime_id'],
      )!,
      episodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_id'],
      )!,
      animeTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anime_title'],
      )!,
      episodeTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_title'],
      )!,
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
      watchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}watched_at'],
      )!,
    );
  }

  @override
  $WatchHistoryTable createAlias(String alias) {
    return $WatchHistoryTable(attachedDatabase, alias);
  }
}

class WatchHistoryData extends DataClass
    implements Insertable<WatchHistoryData> {
  final int id;
  final int animeId;
  final int episodeId;
  final String animeTitle;
  final String episodeTitle;
  final String? thumbnailUrl;
  final int progress;
  final int duration;
  final DateTime watchedAt;
  const WatchHistoryData({
    required this.id,
    required this.animeId,
    required this.episodeId,
    required this.animeTitle,
    required this.episodeTitle,
    this.thumbnailUrl,
    required this.progress,
    required this.duration,
    required this.watchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['anime_id'] = Variable<int>(animeId);
    map['episode_id'] = Variable<int>(episodeId);
    map['anime_title'] = Variable<String>(animeTitle);
    map['episode_title'] = Variable<String>(episodeTitle);
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    map['progress'] = Variable<int>(progress);
    map['duration'] = Variable<int>(duration);
    map['watched_at'] = Variable<DateTime>(watchedAt);
    return map;
  }

  WatchHistoryCompanion toCompanion(bool nullToAbsent) {
    return WatchHistoryCompanion(
      id: Value(id),
      animeId: Value(animeId),
      episodeId: Value(episodeId),
      animeTitle: Value(animeTitle),
      episodeTitle: Value(episodeTitle),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      progress: Value(progress),
      duration: Value(duration),
      watchedAt: Value(watchedAt),
    );
  }

  factory WatchHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WatchHistoryData(
      id: serializer.fromJson<int>(json['id']),
      animeId: serializer.fromJson<int>(json['animeId']),
      episodeId: serializer.fromJson<int>(json['episodeId']),
      animeTitle: serializer.fromJson<String>(json['animeTitle']),
      episodeTitle: serializer.fromJson<String>(json['episodeTitle']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      progress: serializer.fromJson<int>(json['progress']),
      duration: serializer.fromJson<int>(json['duration']),
      watchedAt: serializer.fromJson<DateTime>(json['watchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'animeId': serializer.toJson<int>(animeId),
      'episodeId': serializer.toJson<int>(episodeId),
      'animeTitle': serializer.toJson<String>(animeTitle),
      'episodeTitle': serializer.toJson<String>(episodeTitle),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'progress': serializer.toJson<int>(progress),
      'duration': serializer.toJson<int>(duration),
      'watchedAt': serializer.toJson<DateTime>(watchedAt),
    };
  }

  WatchHistoryData copyWith({
    int? id,
    int? animeId,
    int? episodeId,
    String? animeTitle,
    String? episodeTitle,
    Value<String?> thumbnailUrl = const Value.absent(),
    int? progress,
    int? duration,
    DateTime? watchedAt,
  }) => WatchHistoryData(
    id: id ?? this.id,
    animeId: animeId ?? this.animeId,
    episodeId: episodeId ?? this.episodeId,
    animeTitle: animeTitle ?? this.animeTitle,
    episodeTitle: episodeTitle ?? this.episodeTitle,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    progress: progress ?? this.progress,
    duration: duration ?? this.duration,
    watchedAt: watchedAt ?? this.watchedAt,
  );
  WatchHistoryData copyWithCompanion(WatchHistoryCompanion data) {
    return WatchHistoryData(
      id: data.id.present ? data.id.value : this.id,
      animeId: data.animeId.present ? data.animeId.value : this.animeId,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      animeTitle: data.animeTitle.present
          ? data.animeTitle.value
          : this.animeTitle,
      episodeTitle: data.episodeTitle.present
          ? data.episodeTitle.value
          : this.episodeTitle,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      progress: data.progress.present ? data.progress.value : this.progress,
      duration: data.duration.present ? data.duration.value : this.duration,
      watchedAt: data.watchedAt.present ? data.watchedAt.value : this.watchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WatchHistoryData(')
          ..write('id: $id, ')
          ..write('animeId: $animeId, ')
          ..write('episodeId: $episodeId, ')
          ..write('animeTitle: $animeTitle, ')
          ..write('episodeTitle: $episodeTitle, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('progress: $progress, ')
          ..write('duration: $duration, ')
          ..write('watchedAt: $watchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    animeId,
    episodeId,
    animeTitle,
    episodeTitle,
    thumbnailUrl,
    progress,
    duration,
    watchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WatchHistoryData &&
          other.id == this.id &&
          other.animeId == this.animeId &&
          other.episodeId == this.episodeId &&
          other.animeTitle == this.animeTitle &&
          other.episodeTitle == this.episodeTitle &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.progress == this.progress &&
          other.duration == this.duration &&
          other.watchedAt == this.watchedAt);
}

class WatchHistoryCompanion extends UpdateCompanion<WatchHistoryData> {
  final Value<int> id;
  final Value<int> animeId;
  final Value<int> episodeId;
  final Value<String> animeTitle;
  final Value<String> episodeTitle;
  final Value<String?> thumbnailUrl;
  final Value<int> progress;
  final Value<int> duration;
  final Value<DateTime> watchedAt;
  const WatchHistoryCompanion({
    this.id = const Value.absent(),
    this.animeId = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.animeTitle = const Value.absent(),
    this.episodeTitle = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.progress = const Value.absent(),
    this.duration = const Value.absent(),
    this.watchedAt = const Value.absent(),
  });
  WatchHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int animeId,
    required int episodeId,
    required String animeTitle,
    required String episodeTitle,
    this.thumbnailUrl = const Value.absent(),
    this.progress = const Value.absent(),
    this.duration = const Value.absent(),
    this.watchedAt = const Value.absent(),
  }) : animeId = Value(animeId),
       episodeId = Value(episodeId),
       animeTitle = Value(animeTitle),
       episodeTitle = Value(episodeTitle);
  static Insertable<WatchHistoryData> custom({
    Expression<int>? id,
    Expression<int>? animeId,
    Expression<int>? episodeId,
    Expression<String>? animeTitle,
    Expression<String>? episodeTitle,
    Expression<String>? thumbnailUrl,
    Expression<int>? progress,
    Expression<int>? duration,
    Expression<DateTime>? watchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animeId != null) 'anime_id': animeId,
      if (episodeId != null) 'episode_id': episodeId,
      if (animeTitle != null) 'anime_title': animeTitle,
      if (episodeTitle != null) 'episode_title': episodeTitle,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (progress != null) 'progress': progress,
      if (duration != null) 'duration': duration,
      if (watchedAt != null) 'watched_at': watchedAt,
    });
  }

  WatchHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? animeId,
    Value<int>? episodeId,
    Value<String>? animeTitle,
    Value<String>? episodeTitle,
    Value<String?>? thumbnailUrl,
    Value<int>? progress,
    Value<int>? duration,
    Value<DateTime>? watchedAt,
  }) {
    return WatchHistoryCompanion(
      id: id ?? this.id,
      animeId: animeId ?? this.animeId,
      episodeId: episodeId ?? this.episodeId,
      animeTitle: animeTitle ?? this.animeTitle,
      episodeTitle: episodeTitle ?? this.episodeTitle,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      progress: progress ?? this.progress,
      duration: duration ?? this.duration,
      watchedAt: watchedAt ?? this.watchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (animeId.present) {
      map['anime_id'] = Variable<int>(animeId.value);
    }
    if (episodeId.present) {
      map['episode_id'] = Variable<int>(episodeId.value);
    }
    if (animeTitle.present) {
      map['anime_title'] = Variable<String>(animeTitle.value);
    }
    if (episodeTitle.present) {
      map['episode_title'] = Variable<String>(episodeTitle.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (watchedAt.present) {
      map['watched_at'] = Variable<DateTime>(watchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WatchHistoryCompanion(')
          ..write('id: $id, ')
          ..write('animeId: $animeId, ')
          ..write('episodeId: $episodeId, ')
          ..write('animeTitle: $animeTitle, ')
          ..write('episodeTitle: $episodeTitle, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('progress: $progress, ')
          ..write('duration: $duration, ')
          ..write('watchedAt: $watchedAt')
          ..write(')'))
        .toString();
  }
}

class $AnimeTrackingTable extends AnimeTracking
    with TableInfo<$AnimeTrackingTable, AnimeTrackingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnimeTrackingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _animeIdMeta = const VerificationMeta(
    'animeId',
  );
  @override
  late final GeneratedColumn<int> animeId = GeneratedColumn<int>(
    'anime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentEpisodeMeta = const VerificationMeta(
    'currentEpisode',
  );
  @override
  late final GeneratedColumn<int> currentEpisode = GeneratedColumn<int>(
    'current_episode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalEpisodesMeta = const VerificationMeta(
    'totalEpisodes',
  );
  @override
  late final GeneratedColumn<int> totalEpisodes = GeneratedColumn<int>(
    'total_episodes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    animeId,
    status,
    currentEpisode,
    totalEpisodes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'anime_tracking';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnimeTrackingData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('anime_id')) {
      context.handle(
        _animeIdMeta,
        animeId.isAcceptableOrUnknown(data['anime_id']!, _animeIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('current_episode')) {
      context.handle(
        _currentEpisodeMeta,
        currentEpisode.isAcceptableOrUnknown(
          data['current_episode']!,
          _currentEpisodeMeta,
        ),
      );
    }
    if (data.containsKey('total_episodes')) {
      context.handle(
        _totalEpisodesMeta,
        totalEpisodes.isAcceptableOrUnknown(
          data['total_episodes']!,
          _totalEpisodesMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {animeId};
  @override
  AnimeTrackingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnimeTrackingData(
      animeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anime_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      currentEpisode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_episode'],
      )!,
      totalEpisodes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_episodes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AnimeTrackingTable createAlias(String alias) {
    return $AnimeTrackingTable(attachedDatabase, alias);
  }
}

class AnimeTrackingData extends DataClass
    implements Insertable<AnimeTrackingData> {
  final int animeId;
  final String status;
  final int currentEpisode;
  final int? totalEpisodes;
  final DateTime updatedAt;
  const AnimeTrackingData({
    required this.animeId,
    required this.status,
    required this.currentEpisode,
    this.totalEpisodes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['anime_id'] = Variable<int>(animeId);
    map['status'] = Variable<String>(status);
    map['current_episode'] = Variable<int>(currentEpisode);
    if (!nullToAbsent || totalEpisodes != null) {
      map['total_episodes'] = Variable<int>(totalEpisodes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AnimeTrackingCompanion toCompanion(bool nullToAbsent) {
    return AnimeTrackingCompanion(
      animeId: Value(animeId),
      status: Value(status),
      currentEpisode: Value(currentEpisode),
      totalEpisodes: totalEpisodes == null && nullToAbsent
          ? const Value.absent()
          : Value(totalEpisodes),
      updatedAt: Value(updatedAt),
    );
  }

  factory AnimeTrackingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnimeTrackingData(
      animeId: serializer.fromJson<int>(json['animeId']),
      status: serializer.fromJson<String>(json['status']),
      currentEpisode: serializer.fromJson<int>(json['currentEpisode']),
      totalEpisodes: serializer.fromJson<int?>(json['totalEpisodes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'animeId': serializer.toJson<int>(animeId),
      'status': serializer.toJson<String>(status),
      'currentEpisode': serializer.toJson<int>(currentEpisode),
      'totalEpisodes': serializer.toJson<int?>(totalEpisodes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AnimeTrackingData copyWith({
    int? animeId,
    String? status,
    int? currentEpisode,
    Value<int?> totalEpisodes = const Value.absent(),
    DateTime? updatedAt,
  }) => AnimeTrackingData(
    animeId: animeId ?? this.animeId,
    status: status ?? this.status,
    currentEpisode: currentEpisode ?? this.currentEpisode,
    totalEpisodes: totalEpisodes.present
        ? totalEpisodes.value
        : this.totalEpisodes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AnimeTrackingData copyWithCompanion(AnimeTrackingCompanion data) {
    return AnimeTrackingData(
      animeId: data.animeId.present ? data.animeId.value : this.animeId,
      status: data.status.present ? data.status.value : this.status,
      currentEpisode: data.currentEpisode.present
          ? data.currentEpisode.value
          : this.currentEpisode,
      totalEpisodes: data.totalEpisodes.present
          ? data.totalEpisodes.value
          : this.totalEpisodes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnimeTrackingData(')
          ..write('animeId: $animeId, ')
          ..write('status: $status, ')
          ..write('currentEpisode: $currentEpisode, ')
          ..write('totalEpisodes: $totalEpisodes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(animeId, status, currentEpisode, totalEpisodes, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnimeTrackingData &&
          other.animeId == this.animeId &&
          other.status == this.status &&
          other.currentEpisode == this.currentEpisode &&
          other.totalEpisodes == this.totalEpisodes &&
          other.updatedAt == this.updatedAt);
}

class AnimeTrackingCompanion extends UpdateCompanion<AnimeTrackingData> {
  final Value<int> animeId;
  final Value<String> status;
  final Value<int> currentEpisode;
  final Value<int?> totalEpisodes;
  final Value<DateTime> updatedAt;
  const AnimeTrackingCompanion({
    this.animeId = const Value.absent(),
    this.status = const Value.absent(),
    this.currentEpisode = const Value.absent(),
    this.totalEpisodes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AnimeTrackingCompanion.insert({
    this.animeId = const Value.absent(),
    required String status,
    this.currentEpisode = const Value.absent(),
    this.totalEpisodes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : status = Value(status);
  static Insertable<AnimeTrackingData> custom({
    Expression<int>? animeId,
    Expression<String>? status,
    Expression<int>? currentEpisode,
    Expression<int>? totalEpisodes,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (animeId != null) 'anime_id': animeId,
      if (status != null) 'status': status,
      if (currentEpisode != null) 'current_episode': currentEpisode,
      if (totalEpisodes != null) 'total_episodes': totalEpisodes,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AnimeTrackingCompanion copyWith({
    Value<int>? animeId,
    Value<String>? status,
    Value<int>? currentEpisode,
    Value<int?>? totalEpisodes,
    Value<DateTime>? updatedAt,
  }) {
    return AnimeTrackingCompanion(
      animeId: animeId ?? this.animeId,
      status: status ?? this.status,
      currentEpisode: currentEpisode ?? this.currentEpisode,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (animeId.present) {
      map['anime_id'] = Variable<int>(animeId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (currentEpisode.present) {
      map['current_episode'] = Variable<int>(currentEpisode.value);
    }
    if (totalEpisodes.present) {
      map['total_episodes'] = Variable<int>(totalEpisodes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnimeTrackingCompanion(')
          ..write('animeId: $animeId, ')
          ..write('status: $status, ')
          ..write('currentEpisode: $currentEpisode, ')
          ..write('totalEpisodes: $totalEpisodes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WatchHistoryTable watchHistory = $WatchHistoryTable(this);
  late final $AnimeTrackingTable animeTracking = $AnimeTrackingTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    watchHistory,
    animeTracking,
  ];
}

typedef $$WatchHistoryTableCreateCompanionBuilder =
    WatchHistoryCompanion Function({
      Value<int> id,
      required int animeId,
      required int episodeId,
      required String animeTitle,
      required String episodeTitle,
      Value<String?> thumbnailUrl,
      Value<int> progress,
      Value<int> duration,
      Value<DateTime> watchedAt,
    });
typedef $$WatchHistoryTableUpdateCompanionBuilder =
    WatchHistoryCompanion Function({
      Value<int> id,
      Value<int> animeId,
      Value<int> episodeId,
      Value<String> animeTitle,
      Value<String> episodeTitle,
      Value<String?> thumbnailUrl,
      Value<int> progress,
      Value<int> duration,
      Value<DateTime> watchedAt,
    });

class $$WatchHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $WatchHistoryTable> {
  $$WatchHistoryTableFilterComposer({
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

  ColumnFilters<int> get animeId => $composableBuilder(
    column: $table.animeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animeTitle => $composableBuilder(
    column: $table.animeTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeTitle => $composableBuilder(
    column: $table.episodeTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get watchedAt => $composableBuilder(
    column: $table.watchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WatchHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $WatchHistoryTable> {
  $$WatchHistoryTableOrderingComposer({
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

  ColumnOrderings<int> get animeId => $composableBuilder(
    column: $table.animeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animeTitle => $composableBuilder(
    column: $table.animeTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeTitle => $composableBuilder(
    column: $table.episodeTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get watchedAt => $composableBuilder(
    column: $table.watchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WatchHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $WatchHistoryTable> {
  $$WatchHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get animeId =>
      $composableBuilder(column: $table.animeId, builder: (column) => column);

  GeneratedColumn<int> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<String> get animeTitle => $composableBuilder(
    column: $table.animeTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get episodeTitle => $composableBuilder(
    column: $table.episodeTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<DateTime> get watchedAt =>
      $composableBuilder(column: $table.watchedAt, builder: (column) => column);
}

class $$WatchHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WatchHistoryTable,
          WatchHistoryData,
          $$WatchHistoryTableFilterComposer,
          $$WatchHistoryTableOrderingComposer,
          $$WatchHistoryTableAnnotationComposer,
          $$WatchHistoryTableCreateCompanionBuilder,
          $$WatchHistoryTableUpdateCompanionBuilder,
          (
            WatchHistoryData,
            BaseReferences<_$AppDatabase, $WatchHistoryTable, WatchHistoryData>,
          ),
          WatchHistoryData,
          PrefetchHooks Function()
        > {
  $$WatchHistoryTableTableManager(_$AppDatabase db, $WatchHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WatchHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WatchHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WatchHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> animeId = const Value.absent(),
                Value<int> episodeId = const Value.absent(),
                Value<String> animeTitle = const Value.absent(),
                Value<String> episodeTitle = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> duration = const Value.absent(),
                Value<DateTime> watchedAt = const Value.absent(),
              }) => WatchHistoryCompanion(
                id: id,
                animeId: animeId,
                episodeId: episodeId,
                animeTitle: animeTitle,
                episodeTitle: episodeTitle,
                thumbnailUrl: thumbnailUrl,
                progress: progress,
                duration: duration,
                watchedAt: watchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int animeId,
                required int episodeId,
                required String animeTitle,
                required String episodeTitle,
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> duration = const Value.absent(),
                Value<DateTime> watchedAt = const Value.absent(),
              }) => WatchHistoryCompanion.insert(
                id: id,
                animeId: animeId,
                episodeId: episodeId,
                animeTitle: animeTitle,
                episodeTitle: episodeTitle,
                thumbnailUrl: thumbnailUrl,
                progress: progress,
                duration: duration,
                watchedAt: watchedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WatchHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WatchHistoryTable,
      WatchHistoryData,
      $$WatchHistoryTableFilterComposer,
      $$WatchHistoryTableOrderingComposer,
      $$WatchHistoryTableAnnotationComposer,
      $$WatchHistoryTableCreateCompanionBuilder,
      $$WatchHistoryTableUpdateCompanionBuilder,
      (
        WatchHistoryData,
        BaseReferences<_$AppDatabase, $WatchHistoryTable, WatchHistoryData>,
      ),
      WatchHistoryData,
      PrefetchHooks Function()
    >;
typedef $$AnimeTrackingTableCreateCompanionBuilder =
    AnimeTrackingCompanion Function({
      Value<int> animeId,
      required String status,
      Value<int> currentEpisode,
      Value<int?> totalEpisodes,
      Value<DateTime> updatedAt,
    });
typedef $$AnimeTrackingTableUpdateCompanionBuilder =
    AnimeTrackingCompanion Function({
      Value<int> animeId,
      Value<String> status,
      Value<int> currentEpisode,
      Value<int?> totalEpisodes,
      Value<DateTime> updatedAt,
    });

class $$AnimeTrackingTableFilterComposer
    extends Composer<_$AppDatabase, $AnimeTrackingTable> {
  $$AnimeTrackingTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get animeId => $composableBuilder(
    column: $table.animeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentEpisode => $composableBuilder(
    column: $table.currentEpisode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalEpisodes => $composableBuilder(
    column: $table.totalEpisodes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnimeTrackingTableOrderingComposer
    extends Composer<_$AppDatabase, $AnimeTrackingTable> {
  $$AnimeTrackingTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get animeId => $composableBuilder(
    column: $table.animeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentEpisode => $composableBuilder(
    column: $table.currentEpisode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalEpisodes => $composableBuilder(
    column: $table.totalEpisodes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnimeTrackingTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnimeTrackingTable> {
  $$AnimeTrackingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get animeId =>
      $composableBuilder(column: $table.animeId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get currentEpisode => $composableBuilder(
    column: $table.currentEpisode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalEpisodes => $composableBuilder(
    column: $table.totalEpisodes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AnimeTrackingTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnimeTrackingTable,
          AnimeTrackingData,
          $$AnimeTrackingTableFilterComposer,
          $$AnimeTrackingTableOrderingComposer,
          $$AnimeTrackingTableAnnotationComposer,
          $$AnimeTrackingTableCreateCompanionBuilder,
          $$AnimeTrackingTableUpdateCompanionBuilder,
          (
            AnimeTrackingData,
            BaseReferences<
              _$AppDatabase,
              $AnimeTrackingTable,
              AnimeTrackingData
            >,
          ),
          AnimeTrackingData,
          PrefetchHooks Function()
        > {
  $$AnimeTrackingTableTableManager(_$AppDatabase db, $AnimeTrackingTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnimeTrackingTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnimeTrackingTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnimeTrackingTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> animeId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> currentEpisode = const Value.absent(),
                Value<int?> totalEpisodes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AnimeTrackingCompanion(
                animeId: animeId,
                status: status,
                currentEpisode: currentEpisode,
                totalEpisodes: totalEpisodes,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> animeId = const Value.absent(),
                required String status,
                Value<int> currentEpisode = const Value.absent(),
                Value<int?> totalEpisodes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AnimeTrackingCompanion.insert(
                animeId: animeId,
                status: status,
                currentEpisode: currentEpisode,
                totalEpisodes: totalEpisodes,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnimeTrackingTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnimeTrackingTable,
      AnimeTrackingData,
      $$AnimeTrackingTableFilterComposer,
      $$AnimeTrackingTableOrderingComposer,
      $$AnimeTrackingTableAnnotationComposer,
      $$AnimeTrackingTableCreateCompanionBuilder,
      $$AnimeTrackingTableUpdateCompanionBuilder,
      (
        AnimeTrackingData,
        BaseReferences<_$AppDatabase, $AnimeTrackingTable, AnimeTrackingData>,
      ),
      AnimeTrackingData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WatchHistoryTableTableManager get watchHistory =>
      $$WatchHistoryTableTableManager(_db, _db.watchHistory);
  $$AnimeTrackingTableTableManager get animeTracking =>
      $$AnimeTrackingTableTableManager(_db, _db.animeTracking);
}

import 'package:drift/drift.dart';

/// 观看历史表
class WatchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get animeId => integer()();
  IntColumn get episodeId => integer()();
  TextColumn get animeTitle => text()();
  TextColumn get episodeTitle => text()();
  TextColumn get thumbnailUrl => text().nullable()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  IntColumn get duration => integer().withDefault(const Constant(0))();
  DateTimeColumn get watchedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 追番状态表
class AnimeTracking extends Table {
  IntColumn get animeId => integer()();
  TextColumn get status => text()();
  IntColumn get currentEpisode => integer().withDefault(const Constant(0))();
  IntColumn get totalEpisodes => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {animeId};
}

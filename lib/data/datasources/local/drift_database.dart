import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../models/watch_history.dart';

part 'drift_database.g.dart';

@DriftDatabase(tables: [WatchHistory, AnimeTracking])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // 观看历史相关操作
  Future<List<WatchHistoryData>> getWatchHistory({int limit = 50}) {
    return (select(watchHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.watchedAt)])
          ..limit(limit))
        .get();
  }

  Future<int> insertWatchHistory(WatchHistoryCompanion entry) {
    return into(watchHistory).insert(entry);
  }

  Future<void> deleteWatchHistory(int id) {
    return (delete(watchHistory)..where((t) => t.id.equals(id))).go();
  }

  // 追番状态相关操作
  Future<List<AnimeTrackingData>> getAllTracking() {
    return select(animeTracking).get();
  }

  Future<AnimeTrackingData?> getTracking(int animeId) {
    return (select(animeTracking)..where((t) => t.animeId.equals(animeId)))
        .getSingleOrNull();
  }

  Future<int> insertTracking(AnimeTrackingCompanion entry) {
    return into(animeTracking).insertOnConflictUpdate(entry);
  }

  Future<void> deleteTracking(int animeId) {
    return (delete(animeTracking)..where((t) => t.animeId.equals(animeId)))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'anime_st.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

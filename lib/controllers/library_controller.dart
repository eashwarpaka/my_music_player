import 'dart:typed_data';
import 'package:on_audio_query/on_audio_query.dart';

class LibraryController {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  /// ---------------- PERMISSION ----------------

  Future<bool> requestPermission() async {
    try {
      bool status = await _audioQuery.permissionsStatus();

      if (!status) {
        status = await _audioQuery.permissionsRequest();
        await Future.delayed(const Duration(milliseconds: 700));
      }

      return status;
    } catch (e) {
      return false;
    }
  }

  /// ---------------- LOAD SONGS ----------------

  Future<List<SongModel>> loadSongs() async {
    try {
      return await _audioQuery.querySongs(
        sortType: SongSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
      );
    } catch (e) {
      return [];
    }
  }

  /// ---------------- LOAD ARTWORK ----------------

  Future<Uint8List?> loadArtwork(int id) async {
    try {
      return await _audioQuery.queryArtwork(id, ArtworkType.AUDIO);
    } catch (e) {
      return null;
    }
  }
}

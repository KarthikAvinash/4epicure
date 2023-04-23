import '../models/channel_model.dart';
import '../models/video_model.dart';

class FetchResult {
  final List<Video> videos;
  final List<Channel> channels;
  // final List<Playlist> playlists;
  final String nextPageToken;
  final int videoCount;

  FetchResult({
    this.videos = const [],
    this.channels = const [],
    this.nextPageToken = "",
    this.videoCount = 0,
  });
}

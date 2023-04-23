import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/playlist_model.dart';
import '../models/video_model.dart';
import '../providers/playlist_provider.dart';
import '../screens/home_screen.dart';
import '../screens/video_screen.dart';
import '../globals.dart';

final currentPlaylistProvider =
    StateNotifierProvider<PlaylistProvider, AsyncValue<Playlist>>(
        (ref) => PlaylistProvider(PlayListType.trending));
final relatedPlaylistProvider =
    StateNotifierProvider<PlaylistProvider, AsyncValue<Playlist>>(
        (ref) => PlaylistProvider(PlayListType.related));
final selectedVideoProvider = StateProvider<Video?>((ref) => null);

class NavScreen extends ConsumerWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    yt_vid_ctrl = true;
    return Scaffold(
      body: Stack(
        children: const [
          HomeScreen(),
          VideoScreen(),
        ],
      ),
    );
  }
}

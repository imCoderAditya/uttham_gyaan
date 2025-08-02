// ignore_for_file: deprecated_member_use, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controllers/video_controller.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  final VideoController _videoController = Get.find<VideoController>();
  late final YoutubePlayerController _playerController;
  bool _isFullScreen = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  final String _selectedQuality = 'Auto';
  final bool _showQualityMenu = false;

  // Static video data for demo
  final Map<String, dynamic> staticVideoData = {
    'video': {
      'VideoID': 12,
      'CourseID': 3,
      'Title': 'Advanced Flutter Animation Techniques',
      'VideoUrl':
          'https://www.youtube.com/watch?v=ghLSJVC62Hk&list=RDGMEM_6azG-gbwFIpRtH6PATXiQ&start_radio=1&rv=sfHcLUQwu8M',
      'DurationMinutes': 25,
      'SequenceOrder': 2,
      'CourseTitle': 'Flutter Pro Development Mastery',
    },
    'progress': {'WatchedDurationMinutes': 18, 'CompletionPercentage': 72.5, 'IsCompleted': false},
  };

  @override
  void initState() {
    super.initState();
    // Static YouTube URL - extract video ID
    String staticUrl =
        'https://www.youtube.com/watch?v=ghLSJVC62Hk&list=RDGMEM_6azG-gbwFIpRtH6PATXiQ&start_radio=1&rv=sfHcLUQwu8M';
    String videoId = YoutubePlayer.convertUrlToId(staticUrl) ?? 'ghLSJVC62Hk';

    _playerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: false,
        enableCaption: true,
        isLive: false,
        forceHD: true,
        startAt: 2, // Start at 30 seconds
      ),
    );

    _playerController.addListener(_onPlayerStateChange);

    // Add listener for position tracking
    _playerController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPosition = _playerController.value.position;
          _totalDuration = _playerController.metadata.duration;
        });
      }
    });
  }

  void _onPlayerStateChange() {
    if (_playerController.value.isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = _playerController.value.isFullScreen;
      });

      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    }
  }

  @override
  void dispose() {
    _playerController.removeListener(_onPlayerStateChange);
    _playerController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final orientation = MediaQuery.of(context).orientation;
    final videoData = staticVideoData['video'];
    final progressData = staticVideoData['progress'];

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _playerController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primaryColor,
        progressColors: ProgressBarColors(
          playedColor: AppColors.primaryColor,
          handleColor: AppColors.primaryColor,
          backgroundColor: Colors.grey.shade300,
          bufferedColor: Colors.grey.shade200,
        ),
        topActions: [
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              videoData['Title'] ?? 'Video Title',
              style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Add settings functionality
            },
          ),
        ],
      ),
      builder: (context, player) {
        if (orientation == Orientation.landscape && _isFullScreen) {
          return Scaffold(backgroundColor: Colors.black, body: Center(child: player));
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.headerGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: Text('Video Player', style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white)),
            leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: AppColors.white), onPressed: () => Get.back()),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
                  icon: Icon(Icons.more_vert, color: AppColors.white, size: 24.sp),
                  onPressed: () {
                    // Add more options
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Player Section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10.r, offset: Offset(0, 4.h)),
                    ],
                  ),
                  child: player,
                ),

                // Video Info Section
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primaryColor.withOpacity(0.1), AppColors.primaryColor.withOpacity(0.05)],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          videoData['CourseTitle'] ?? 'Course Title',
                          style: AppTextStyles.caption().copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Video Title
                      Text(
                        videoData['Title'] ?? 'Video Title',
                        style: AppTextStyles.headlineLarge().copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Progress Section
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                isDark
                                    ? [
                                      AppColors.primaryColor.withOpacity(0.1),
                                      AppColors.primaryColor.withOpacity(0.05),
                                    ]
                                    : [
                                      AppColors.primaryColor.withOpacity(0.08),
                                      AppColors.primaryColor.withOpacity(0.03),
                                    ],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.primaryColor.withOpacity(0.2), width: 1),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Progress',
                                  style: AppTextStyles.body().copyWith(fontWeight: FontWeight.w600, fontSize: 16.sp),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color:
                                        progressData['IsCompleted'] == true
                                            ? AppColors.sucessPrimary.withOpacity(0.1)
                                            : AppColors.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    progressData['IsCompleted'] == true ? 'Completed' : 'In Progress',
                                    style: AppTextStyles.caption().copyWith(
                                      color:
                                          progressData['IsCompleted'] == true
                                              ? AppColors.sucessPrimary
                                              : AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12.h),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: LinearProgressIndicator(
                                value: (progressData['CompletionPercentage'] ?? 0.0) / 100,
                                backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progressData['IsCompleted'] == true
                                      ? AppColors.sucessPrimary
                                      : AppColors.primaryColor,
                                ),
                                minHeight: 8.h,
                              ),
                            ),

                            SizedBox(height: 8.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${progressData['CompletionPercentage']?.toStringAsFixed(1) ?? '0.0'}% Complete',
                                  style: AppTextStyles.caption().copyWith(fontSize: 12.sp),
                                ),
                                Text(
                                  '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                                  style: AppTextStyles.caption().copyWith(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Video Details
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: Icons.access_time_rounded,
                            label: '${videoData['DurationMinutes'] ?? 0} min',
                            colorScheme: colorScheme,
                          ),
                          SizedBox(width: 12.w),
                          _buildInfoChip(
                            icon: Icons.playlist_play_rounded,
                            label: 'Lesson ${videoData['SequenceOrder'] ?? 1}',
                            colorScheme: colorScheme,
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _playerController.value.isPlaying
                                    ? _playerController.pause()
                                    : _playerController.play();
                                setState(() {});
                              },
                              icon: Icon(
                                _playerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 20.sp,
                              ),
                              label: Text(
                                _playerController.value.isPlaying ? 'Pause' : 'Play',
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                elevation: 2,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outline),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Skip forward 10 seconds
                                Duration newPosition = _currentPosition + const Duration(seconds: 10);
                                if (newPosition < _totalDuration) {
                                  _playerController.seekTo(newPosition);
                                }
                              },
                              icon: Icon(Icons.forward_10, color: colorScheme.onSurface, size: 24.sp),
                              padding: EdgeInsets.all(14.w),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outline),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: IconButton(
                              onPressed: () {
                                _playerController.toggleFullScreenMode();
                              },
                              icon: Icon(Icons.fullscreen, color: colorScheme.onSurface, size: 24.sp),
                              padding: EdgeInsets.all(14.w),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 100.h), // Bottom spacing
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label, required ColorScheme colorScheme}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: colorScheme.onSecondaryContainer),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTextStyles.caption().copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

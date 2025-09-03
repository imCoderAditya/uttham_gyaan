// ignore_for_file: deprecated_member_use, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_colors.dart';
import 'package:uttham_gyaan/app/core/config/theme/app_text_styles.dart';
import 'package:uttham_gyaan/app/data/model/quiz/quiz_result_model.dart';
import 'package:uttham_gyaan/app/data/model/video/video_details_model.dart';
import 'package:uttham_gyaan/app/modules/quiz/views/quiz_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/video_controller.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> with TickerProviderStateMixin {
  final VideoController _videoController = Get.find<VideoController>();

  late final YoutubePlayerController _playerController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isFullScreen = false;
  bool _isLoading = true;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Get video ID from arguments
    final videoId = Get.arguments?['videoId'] ?? 0;
    final courseId = Get.arguments?['courseId'] ?? 0;
    debugPrint("CourseId $courseId\n videoId Id : $videoId");
    _videoController.getQuizResult(videoId: videoId);
    _fetchVideoData(videoId);
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  Future<void> _fetchVideoData(int videoId) async {
    setState(() => _isLoading = true);

    await _videoController.fetchVideo(videoId);

    if (_videoController.videoDetailsModel.value?.data?.video?.videoUrl !=
        null) {
      _initializeYouTubePlayer();
    }

    setState(() => _isLoading = false);
    _animationController.forward();
  }

  void _initializeYouTubePlayer() {
    final videoUrl =
        _videoController.videoDetailsModel.value!.data!.video!.videoUrl!;
    final extractedVideoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';
    final watchedMinutes =
        _videoController
            .videoDetailsModel
            .value
            ?.data
            ?.progress
            ?.watchedDurationMinutes ??
        0;

    _playerController = YoutubePlayerController(
      initialVideoId: extractedVideoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: false,
        enableCaption: true,
        isLive: false,
        forceHD: true,
        startAt: watchedMinutes * 60, // Convert to seconds
      ),
    );

    _playerController.addListener(_onPlayerStateChange);
    _setupPositionTracking();
  }

  void _setupPositionTracking() {
    _playerController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPosition = _playerController.value.position;
          _totalDuration = _playerController.metadata.duration;
        });

        // Auto-hide controls after 3 seconds
        if (_playerController.value.isPlaying && _showControls) {
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted && _playerController.value.isPlaying) {
              setState(() => _showControls = false);
            }
          });
        }
      }
    });
  }

  void _onPlayerStateChange() {
    if (_playerController.value.isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = _playerController.value.isFullScreen;
      });

      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    }
  }

  double calculateProgressPercentage(Duration current, Duration total) {
    if (total.inSeconds == 0) return 0; // avoid division by zero
    return (current.inSeconds / total.inSeconds) * 100;
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (!_isLoading) {
      _playerController.removeListener(_onPlayerStateChange);
      _playerController.dispose();
    }
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    timeUpdateVideo();
    super.dispose();
  }

  Future<void> timeUpdateVideo() async {
    final videoData = _videoController.videoDetailsModel.value?.data;
    double percentage = calculateProgressPercentage(
      _currentPosition,
      _totalDuration,
    );
    debugPrint("Progress: ${percentage.toStringAsFixed(2)}%");
    final durato = _formatDuration(_currentPosition); // "02:35"
    final parts = durato.split(':'); // ["02", "35"]
    final currentTime = (int.parse(parts[0]) * 60) + int.parse(parts[1]);
    debugPrint("===>${currentTime.toString()}");
    if ((percentage) > (videoData?.progress?.completionPercentage ?? 0)) {
      _videoController.updateProgressBar(
        courseId: videoData?.video?.courseId,
        videoId: videoData?.video?.videoId,
        currentTime: currentTime,
        completionPercentage: double.parse(percentage.toStringAsFixed(2)),
        isCompleted: percentage >= 97.00,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final orientation = MediaQuery.of(context).orientation;
    return Obx(() {
      _videoController.isLoading.value;
      if (_isLoading) {
        return _buildLoadingScreen(theme);
      }

      final videoData = _videoController.videoDetailsModel.value?.data?.video;
      final progressData =
          _videoController.videoDetailsModel.value?.data?.progress;

      if (videoData == null) {
        return _buildErrorScreen(theme);
      }

      return YoutubePlayerBuilder(
        onExitFullScreen: () {
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        },
        player: _buildYouTubePlayer(videoData),
        builder: (context, player) {
          if (orientation == Orientation.landscape && _isFullScreen) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: player),
            );
          }

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: _buildAppBar(theme, videoData),
            body: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildVideoPlayer(player),
                  _buildVideoContent(
                    theme,
                    colorScheme,
                    isDark,
                    videoData,
                    progressData,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, video) {
    return AppBar(
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
      centerTitle: true,
      title: Text(
        'video_player'.tr,
        style: AppTextStyles.headlineMedium().copyWith(
          color: AppColors.white,
          fontSize: 18.sp,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16.w),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: Icon(
              Icons.bookmark_border,
              color: AppColors.white,
              size: 20.sp,
            ),
            onPressed: () {
              // Add bookmark functionality
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingScreen(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.headerGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  strokeWidth: 3,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'loading_video'.tr,
                style: AppTextStyles.headlineMedium().copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                Icons.error_outline,
                size: 64.sp,
                color: AppColors.red,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "failed_to_load_video".tr,
              style: AppTextStyles.headlineMedium().copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'check_connection_try_again'.tr,
              style: AppTextStyles.body().copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text('go_back'.tr),
            ),
          ],
        ),
      ),
    );
  }

  YoutubePlayer _buildYouTubePlayer(video) {
    return YoutubePlayer(
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
            video.title ?? 'video_title'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () => _showVideoOptions(),
        ),
      ],
      onReady: () {
        debugPrint('YouTube Player Ready');
      },
    );
  }

  Widget _buildVideoPlayer(Widget player) {
    return Hero(
      tag: 'video_player',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: player,
      ),
    );
  }

  Widget _buildVideoContent(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
    Video video,
    progress,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface, //borderRadius: BorderRadius.circular(0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCourseInfo(video, colorScheme),
                SizedBox(height: 20.h),
                _buildVideoTitle(video),
                SizedBox(height: 24.h),
                _buildProgressSection(progress, colorScheme, isDark),
                SizedBox(height: 28.h),
                _buildVideoStats(video, colorScheme),
                SizedBox(height: 32.h),
                _buildActionButtons(colorScheme),
                progress.isCompleted == true
                    ? SizedBox(height: 40.h)
                    : SizedBox(),
                (progress.isCompleted == true)
                    ? (_videoController
                                .videoDetailsModel
                                .value
                                ?.data
                                ?.isQuizCompleted ==
                            false)
                        ? _buildAdditionalInfo(
                          video,
                          colorScheme,
                        ) // quiz section
                        : Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () async {
                              await _videoController.getQuizResult(
                                videoId: video.videoId,
                              );
                              showQuizResultDialog(
                                context,
                                _videoController
                                    .quizResultModel
                                    .value
                                    ?.data
                                    ?.firstOrNull,
                              );

                              debugPrint(
                                _videoController
                                    .quizResultModel
                                    .value
                                    ?.data
                                    ?.firstOrNull
                                    .toString(),
                              );
                            },
                            color: AppColors.primaryColor,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            splashColor: Colors.white.withOpacity(0.2),
                            child: Text(
                              "complete_quiz".tr,
                              style: AppTextStyles.body().copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    : const SizedBox.shrink(), // if course not completed → show nothing

                SizedBox(height: 100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo(video, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withOpacity(0.15),
                AppColors.primaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle_filled,
                size: 16.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                video.courseTitle ?? '',
                style: AppTextStyles.caption().copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.face,
            size: 18.sp,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoTitle(video) {
    return Text(
      video.title ?? '',
      style: AppTextStyles.headlineLarge().copyWith(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildProgressSection(progress, ColorScheme colorScheme, bool isDark) {
    final completionPercentage = progress?.completionPercentage ?? 0.0;
    final isCompleted = progress?.isCompleted ?? false;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDark
                  ? [
                    AppColors.primaryColor.withOpacity(0.12),
                    AppColors.primaryColor.withOpacity(0.06),
                  ]
                  : [
                    AppColors.primaryColor.withOpacity(0.08),
                    AppColors.primaryColor.withOpacity(0.03),
                  ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 20.sp,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'your_progress'.tr,
                    style: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 17.sp,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color:
                      isCompleted
                          ? AppColors.sucessPrimary.withOpacity(0.15)
                          : AppColors.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  isCompleted ? 'completed'.tr : 'in_progress'.tr,
                  style: AppTextStyles.caption().copyWith(
                    color:
                        isCompleted
                            ? AppColors.sucessPrimary
                            : AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Stack(
            children: [
              Container(
                height: 10.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              Container(
                height: 10.h,
                width:
                    MediaQuery.of(context).size.width *
                    (completionPercentage / 100),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isCompleted
                            ? [
                              AppColors.sucessPrimary,
                              AppColors.sucessPrimary.withOpacity(0.8),
                            ]
                            : [
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.8),
                            ],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: (isCompleted
                              ? AppColors.sucessPrimary
                              : AppColors.primaryColor)
                          .withOpacity(0.3),
                      blurRadius: 4.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${completionPercentage.toStringAsFixed(1)}% ${"complete".tr}',
                style: AppTextStyles.caption().copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                style: AppTextStyles.caption().copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoStats(video, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.access_time_rounded,
            title: 'duration'.tr,
            value: '${video.durationMinutes ?? 0} ${"min".tr}',
            colorScheme: colorScheme,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            icon: Icons.playlist_play_rounded,
            title: 'lesson'.tr,
            value: '#${video.sequenceOrder ?? 1}',
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.sp, color: colorScheme.primary),
          SizedBox(height: 8.h),
          Text(
            title,
            style: AppTextStyles.caption().copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTextStyles.body().copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_isLoading) return;
              _playerController.value.isPlaying
                  ? _playerController.pause()
                  : _playerController.play();
              setState(() => _showControls = true);
            },
            icon: Icon(
              _playerController.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 22.sp,
              color: AppColors.white,
            ),
            label: Text(
              _playerController.value.isPlaying ? 'pause'.tr : 'play'.tr,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 3,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        _buildActionButton(
          icon: Icons.replay_10,
          onPressed: () {
            Duration newPosition =
                _currentPosition - const Duration(seconds: 10);
            if (newPosition < Duration.zero) newPosition = Duration.zero;
            _playerController.seekTo(newPosition);
          },
          colorScheme: colorScheme,
        ),
        SizedBox(width: 12.w),
        _buildActionButton(
          icon: Icons.forward_10,
          onPressed: () {
            Duration newPosition =
                _currentPosition + const Duration(seconds: 10);
            if (newPosition < _totalDuration) {
              _playerController.seekTo(newPosition);
            }
          },
          colorScheme: colorScheme,
        ),
        SizedBox(width: 12.w),
        _buildActionButton(
          icon: Icons.fullscreen,
          onPressed: () => _playerController.toggleFullScreenMode(),
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(14.r),
        color: colorScheme.surface,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: colorScheme.onSurface, size: 24.sp),
        padding: EdgeInsets.all(16.w),
      ),
    );
  }

  Widget _buildAdditionalInfo(Video video, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quiz_section'.tr,
          style: AppTextStyles.headlineMedium().copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.h),
        InkWell(
          onTap: () async {
            Get.to(QuizView(videoId: video.videoId));
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            width: double.infinity,
            alignment: Alignment.center,
            height: 55.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.accentColor),
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.accentColor.withValues(alpha: 0.2),
            ),
            child: Text(
              "start_quiz".tr,
              style: TextStyle(
                color: AppColors.accentColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showVideoOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'video_options'.tr,
              style: AppTextStyles.headlineMedium().copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.h),
            _buildOptionTile(Icons.speed, 'playback_speed'.tr, () {}),
            _buildOptionTile(Icons.hd, 'video_quality'.tr, () {}),
            _buildOptionTile(Icons.closed_caption, 'captions'.tr, () {}),
            _buildOptionTile(Icons.report, 'report_issue'.tr, () {}),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Get.theme.colorScheme.primary),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    );
  }

  void showQuizResultDialog(BuildContext context, QuizResult? quizResult) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Title
                  Center(
                    child: Text(
                      quizResult?.videoTitle ?? "no_title".tr,
                      style: AppTextStyles.headlineMedium().copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Results
                  _buildResultRow(
                    "attempted".tr,
                    quizResult?.attempted?.toString() ?? "0",
                  ),
                  _buildResultRow(
                    "correct".tr,
                    quizResult?.correct?.toString() ?? "0",
                  ),
                  _buildResultRow(
                    "accuracy".tr,
                    "${quizResult?.accuracyPercentage?.toStringAsFixed(2) ?? "0"}%",
                  ),

                  const SizedBox(height: 20),

                  // Close button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("ok".tr),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body()),
          Text(
            value,
            style: AppTextStyles.body().copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.sucessPrimary,
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

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

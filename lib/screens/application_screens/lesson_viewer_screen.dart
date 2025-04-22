import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:agri_chem/models/course_content_item.dart';

class LessonViewerScreen extends StatefulWidget {
  final CourseContentItem item;

  const LessonViewerScreen({super.key, required this.item});

  @override
  State<LessonViewerScreen> createState() => _LessonViewerScreenState();
}

class _LessonViewerScreenState extends State<LessonViewerScreen> {
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    if (widget.item.contentType == 'video' && widget.item.content != null) {
      final videoId = YoutubePlayer.convertUrlToId(widget.item.content!);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            enableCaption: true,
            hideThumbnail: false,
            controlsVisibleAtStart: true,
            forceHD: true,
            disableDragSeek: false,
            mute: false,
            loop: false,
            useHybridComposition: true,
            showLiveFullscreenButton: false,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _openCustomFullscreen() {
    if (_youtubeController == null) return;

    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.black,
            child: SafeArea(
              child: YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _youtubeController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red,
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    RemainingDuration(),
                  ],
                ),
                builder:
                    (context, player) => Stack(
                      children: [
                        Center(child: player),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;

    switch (widget.item.contentType) {
      case 'text':
        contentWidget = Padding(
          padding: const EdgeInsets.all(16.0),
          child: Html(
            data: widget.item.content ?? '<p>No content available</p>',
          ),
        );
        break;

      case 'image':
        contentWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Image.network(
              widget.item.content ?? '',
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.grey,
                );
              },
              fit: BoxFit.cover,
            ),
          ),
        );
        break;

      case 'video':
        contentWidget =
            _youtubeController != null
                ? Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: YoutubePlayer(
                          controller: _youtubeController!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.red,
                          bottomActions: [
                            CurrentPosition(),
                            ProgressBar(isExpanded: true),
                            RemainingDuration(),
                            IconButton(
                              icon: Icon(Icons.fullscreen, color: Colors.white),
                              onPressed: _openCustomFullscreen,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                : const Center(child: Text('Invalid YouTube URL'));
        break;

      case 'quiz':
        contentWidget = const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Quiz Viewer coming soon!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
        );
        break;

      default:
        contentWidget = const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Unknown content type',
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title ?? 'Untitled'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: contentWidget,
        ),
      ),
    );
  }
}

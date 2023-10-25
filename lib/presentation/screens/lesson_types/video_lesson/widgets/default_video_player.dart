import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class DefaultVideoPlayerWidget extends StatefulWidget {
  const DefaultVideoPlayerWidget({Key? key, required this.videoLink}) : super(key: key);

  final String videoLink;

  @override
  State<DefaultVideoPlayerWidget> createState() => _DefaultVideoPlayerWidgetState();
}

class _DefaultVideoPlayerWidgetState extends State<DefaultVideoPlayerWidget> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  double _aspectRatio = 16 / 9;

  bool _isLandscape = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _controller = VideoPlayerController.contentUri(Uri.parse(widget.videoLink))
        ..initialize().then((_) {
          setState(() {
            _controller?.play();
          });
        });
    } else {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoLink))
        ..initialize().then((_) {
          setState(() {
            _controller?.play();
          });
        });
    }

    // initCheviewController();
  }

  void initCheviewController() async {
    _chewieController = ChewieController(
      allowedScreenSleep: false,
      allowFullScreen: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      videoPlayerController: _controller!,
      aspectRatio: _aspectRatio,
      autoInitialize: true,
      autoPlay: true,
      showControls: true,
    );
    _chewieController?.addListener(() {
      if (_chewieController!.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Platform.isAndroid
          ? Chewie(
              controller: _chewieController!,
            )
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return AspectRatio(
                    aspectRatio:
                        !_isLandscape ? _controller!.value.aspectRatio : constraints.maxWidth / constraints.maxHeight,
                    child: Stack(
                      children: [
                        VideoPlayer(_controller!),
                        Opacity(
                          opacity: _controller!.value.isPlaying ? 0.0 : 1.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
                                });
                              },
                              child: Icon(
                                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_isLandscape) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                    DeviceOrientation.portraitDown,
                                  ]);

                                  _isLandscape = false;

                                  return;
                                }

                                _isLandscape = true;
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft,
                                ]);
                              });
                            },
                            child: Icon(
                              Icons.fullscreen,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

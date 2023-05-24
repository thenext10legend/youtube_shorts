// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Shorts',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Video> videos = [];
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> fetchVideos() async {
    var response = await http.get(
        Uri.parse('https://internship-service.onrender.com/videos?page=2'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      videos = data['videos'].map((e) => Video.fromJson(e)).toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Shorts'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _controller = VideoPlayerController.network(videos[index].url);
              _chewieController = ChewieController(
                videoPlayerController: _controller,
                showControls: true,
              );
              setState(() {});
            },
            child: Container(
              height: 200.0,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: _chewieController != null
                    ? Chewie(controller: _chewieController)
                    : Image.network(videos[index].thumbnailUrl),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Video {
  final String url;
  final String thumbnailUrl;

  Video({required this.url, required this.thumbnailUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}

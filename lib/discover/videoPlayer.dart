import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_fuqi/modal/video.dart';
import 'package:video_player/video_player.dart';


class videoPlayer extends StatefulWidget {

  Video mData;

  videoPlayer({Key key,this.mData}):super(key:key);

  @override
  _videoPlayerState createState() {
    // TODO: implement createState
    return _videoPlayerState();
  }
}

class _videoPlayerState extends State<videoPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(widget.mData.url);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.mData.desc),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: Center(
                  child: Chewie(
                    _controller,
                    aspectRatio: 3 / 2,
                    autoPlay: true,
                    looping: false,
                  ),
                )
            )
          ],
        )
    );
  }




}

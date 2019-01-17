class Video {
  final String url;
  final String desc;
  final String image;
  final String date;
  const Video({this.url,this.image,this.desc,this.date});

  static getVideoData(var data){
    return Video(
        url:data['url'],
        desc:data['desc'],
        image:data['image'],
        date:data['date']
    );
  }
}
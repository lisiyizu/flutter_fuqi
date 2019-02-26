class articleData{
  int id;
  String title;
  String brief;
  String content;
  String qq;
  String join;
  String pub_date;
  String head_img;
  String head_img2;
  String head_img3;
  String head_img4;
  String head_img5;
  int read_count;
  int comment_count;
  bool is_free;
  int author;
  var article_comment;

  setNewData(articleData newData){
    this.comment_count = newData.comment_count;
    this.article_comment = newData.article_comment;
  }

  articleData({this.id,this.article_comment,this.title,this.brief,this.content,this.qq,this.join,this.pub_date,this.head_img,this.head_img2,this.head_img3,this.head_img4,this.head_img5,this.read_count,this.comment_count,this.is_free,this.author});

  static getArticleData(var data){
      return articleData(
        id:data['id'],
        article_comment:data['article_comment'],
        title:data['title'],
        brief:data['brief'],
        qq:data['qq'],
        join:data['join'],
        content:data['content'],
        pub_date:data['pub_date'],
        head_img:data['head_img'],
        head_img2:data['head_img2'],
        head_img3:data['head_img3'],
        head_img4:data['head_img4'],
        head_img5:data['head_img5'],
        read_count:data['read_count'],
        comment_count:data['comment_count'],
        is_free:data['is_free'],
        author:data['author'],
      );
    }
}
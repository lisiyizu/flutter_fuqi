import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';


class LocatePage extends StatelessWidget {
  String current;

  LocatePage({Key key, @required this.current}) :super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text("位置选择"),
            centerTitle: true,
          ),
          body: ListView.builder(
              itemCount: Provinces.length+1,
              itemBuilder:  (BuildContext context,int index){
                if (index == 0) {
                  return Column(
                    children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 30),
                          child: ListTile(title: Text('当前位置:${current}'),trailing: Icon(IconData(0xe73d,fontFamily: Constants.IconFontFamily))),
                        ),
                        //分割线
                        Divider(color: Colors.black12,),
                    ],
                  );
                }else{
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 30.0,right: 30.0),
                        child: ListTile(
                            title: Text(Provinces[index-1]),
                            trailing: Icon(IconData(0xe621,fontFamily: Constants.IconFontFamily),size:14.0),
                            onTap:() {
                              print(Provinces[index-1]);
                              Navigator.pop(context,Provinces[index-1]);
                            }
                        ),
                      ),
                      //分割线
                      Divider(color: Colors.black12,),
                    ],
                  );
                }
              }
            )
          );
    }
}





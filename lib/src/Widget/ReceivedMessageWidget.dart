import 'package:arm_flutter_test_app/src/ui/FullScreenImage.dart';
import 'package:flutter/material.dart';
import 'package:arm_flutter_test_app/config/app_config.dart' as config;


class ReceivedMessageWidget extends StatelessWidget {
  final String content;
  final String imageAddress;
  final String time;
  final bool isImage;
  const ReceivedMessageWidget({
    Key key,
    this.content,
    this.time,
    this.isImage,
    this.imageAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.only(right: 75.0, left: 8.0, top: 8.0, bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)),
        child: Container(
          color: config.ArmColors().mainColor(1),
          child: Stack(
            children: <Widget>[
              !isImage
                  ? Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, left: 8.0, top: 8.0, bottom: 15.0),
                      child: Text(
                        content,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, left: 8.0, top: 8.0, bottom: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: InkWell(
                              onTap: (() {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => FullScreenImage(
                                          photoUrl: imageAddress,
                                        )));
                              }),
                              child: Hero(
                                tag: imageAddress,
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(imageAddress),
                                  placeholder:
                                  AssetImage('assets/images/placeholder.jpg'),
                                  width: 150.0,
                                  height: 150.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            content,
                          )
                        ],
                      ),
                    ),
              Positioned(
                bottom: 1,
                right: 10,
                child: Text(
                  time,
                  style: TextStyle(
                      fontSize: 10, color: Colors.black.withOpacity(0.6)),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

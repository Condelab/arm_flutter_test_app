import 'dart:async';
import 'dart:io';

import 'package:arm_flutter_test_app/models/Message.dart';
import 'package:arm_flutter_test_app/services/helper.dart';
import 'package:arm_flutter_test_app/src/Widget/ReceivedMessageWidget.dart';
import 'package:arm_flutter_test_app/src/Widget/SendedMessageWidget.dart';
import 'package:arm_flutter_test_app/src/Widget/uiAssist/UIhelpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import 'FullScreenImage.dart';

class ChatScreen extends StatefulWidget {
  String name;
  String photoUrl;
  String receiverUid;
  ChatScreen({this.name, this.photoUrl, this.receiverUid});

  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Message _message;
  var _formKey = GlobalKey<FormState>();
  var map = Map<String, dynamic>();
  CollectionReference _collectionReference;
  DocumentReference _receiverDocumentReference;
  DocumentReference _senderDocumentReference;
  DocumentReference _documentReference;
  DocumentSnapshot documentSnapshot;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _senderuid;
  var listItem;
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  StreamSubscription<DocumentSnapshot> subscription;
  File imageFile;
  Reference _storageReference = FirebaseStorage.instance.ref();
  TextEditingController _messageController;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();
    //getUID().then((user) {
    setState(() {
      //_senderuid = user.uid;
      _senderuid = MyAppState.currentUser.userID;
      print("sender uid : $_senderuid");
      getSenderPhotoUrl(_senderuid).then((snapshot) {
        setState(() {
          senderPhotoUrl = snapshot['profilePictureURL'];
          senderName = snapshot['firstName'];
        });
      });
      getReceiverPhotoUrl(widget.receiverUid).then((snapshot) {
        setState(() {
          receiverPhotoUrl = snapshot['profilePictureURL'];
          receiverName = snapshot['firstName'];
        });
      });
    });
    //});
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  void addMessageToDb(Message message) async {
    print("Message : ${message.message}");
    map = message.toMap();

    print("Map : ${map}");
    _collectionReference = firestore
        .collection("messages")
        .doc(message.senderUid)
        .collection(widget.receiverUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _collectionReference = firestore
        .collection("messages")
        .doc(widget.receiverUid)
        .collection(message.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: showAppBar(context, widget.name, true, MyAppState.currentUser),
        body: Form(
          key: _formKey,
          child: _senderuid == null
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Column(
            children: <Widget>[
              Expanded(child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/chat_bg.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.linearToSrgbGamma()),
                  ),
                  child: ChatMessagesListWidget())),
              Divider(height: 0, color: Colors.black26),
              ChatInputWidget(),
            ],
          ),
        ));
  }

  Widget ChatInputWidget() {
    return Container(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextFormField(
          validator: (String input) {
            if (input.isEmpty) {
              return "Please enter message";
            }
          },
          maxLines: 20,
          controller: _messageController,
          onFieldSubmitted: (value) {
            _messageController.text = value;
          },
          decoration: InputDecoration(
            suffixIcon: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.send, color: Colors.black),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      sendMessage();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.image, color: Colors.black),
                  onPressed: () {
                    pickImage();
                  },
                ),
              ],
            ),
            border: InputBorder.none,
            hintText: "Enter message...",
          ),
        ),
      ),
    );
  }

  Future<String> pickImage() async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = selectedImage;
    });
    /*_storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');*/
    String imageName = getRandString(30);
    Reference upload = _storageReference.child("images/$imageName.png");
    UploadTask uploadTask = upload.putFile(imageFile);
    var url = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    print("URL: $url");
    uploadImageToDb(url);
    return url;
  }

  void uploadImageToDb(String downloadUrl) {
    _message = Message.withoutMessage(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        photoUrl: downloadUrl,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;

    print("Map : ${map}");
    _collectionReference = firestore
        .collection("messages")
        .doc(_message.senderUid)
        .collection(widget.receiverUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _collectionReference = firestore
        .collection("messages")
        .doc(widget.receiverUid)
        .collection(_message.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });
  }

  void sendMessage() async {
    print("Inside send message");
    var text = _messageController.text;
    print(text);

    _message = Message(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        message: text,
        timestamp: FieldValue.serverTimestamp(),
        type: 'text');

    print(
        "receiverUid: ${widget.receiverUid} , senderUid : ${_senderuid} , message: ${text}");
    print(
        "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");
    addMessageToDb(_message);
  }

  Future<DocumentSnapshot> getSenderPhotoUrl(String uid) {
    var senderDocumentSnapshot = firestore.collection('users').doc(uid).get();
    return senderDocumentSnapshot;
  }

  Future<DocumentSnapshot> getReceiverPhotoUrl(String uid) {
    var receiverDocumentSnapshot = firestore.collection('users').doc(uid).get();
    return receiverDocumentSnapshot;
  }

  Widget ChatMessagesListWidget() {
    print("SENDERUID : $_senderuid");
    return Column(
       children: [
         StreamBuilder(
           stream: firestore
               .collection('messages')
               .doc(_senderuid)
               .collection(widget.receiverUid)
               .orderBy('timestamp', descending: false)
               .snapshots(),
           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
             if (!snapshot.hasData) {
               return Center(
                 child: CircularProgressIndicator(),
               );
             } else {
               listItem = snapshot.data.docs;
               return Flexible(child: ListView.builder(
                 shrinkWrap: true,
                 padding: EdgeInsets.all(10.0),
                 itemBuilder: (context, index) => chatMessageItem(snapshot.data.docs[index]),
                 itemCount: snapshot.data.docs.length,
               ));
             }
           },
         )
       ],
    );
  }

  Widget chatMessageItem(DocumentSnapshot documentSnapshot) {
    return buildChatLayout1(documentSnapshot);
  }

  Widget buildChatLayout1(DocumentSnapshot snapshot) {
    if (snapshot['timestamp'] != null) {
      final Timestamp timestamp = snapshot['timestamp'] as Timestamp;
      final DateTime dateTime = timestamp.toDate();
      final dateString = DateFormat('hh:mm').format(dateTime);

    return snapshot['senderUid'] != _senderuid
    ? Align(
      alignment: Alignment(-1, 0),
      child: ReceivedMessageWidget (
        content: snapshot['type'] == 'text' ? snapshot['message'] : "",
        time: dateString,
        isImage: snapshot['type'] != "text" ? true : false,
        imageAddress: snapshot['type'] != 'text'  ? snapshot['photoUrl'] : "",
      ),
    )
        : Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content: snapshot['type'] == 'text' ? snapshot['message'] : "",
        time: dateString,
        isImage: snapshot['type'] != 'text' ? true : false,
        imageAddress: snapshot['type'] != 'text'  ? snapshot['photoUrl'] : "",
      ),
    );
  }
  }



  Widget buildChatLayout(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: snapshot['senderUid'] == _senderuid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              snapshot['senderUid'] == _senderuid
                  ? CircleAvatar(
                      backgroundImage: senderPhotoUrl == null
                          ? AssetImage('assets/images/placeholder.jpg')
                          : NetworkImage(senderPhotoUrl),
                      radius: 20.0,
                    )
                  : CircleAvatar(
                      backgroundImage: receiverPhotoUrl == null
                          ? AssetImage('assets/images/placeholder.jpg')
                          : NetworkImage(receiverPhotoUrl),
                      radius: 20.0,
                    ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  snapshot['senderUid'] == _senderuid
                      ? new Text(
                          senderName == null ? "" : senderName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        )
                      : new Text(
                          receiverName == null ? "" : receiverName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                  snapshot['type'] == 'text'
                      ? new Text(
                          snapshot['message'],
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        )
                      : InkWell(
                          onTap: (() {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                          photoUrl: snapshot['photoUrl'],
                                        )));
                          }),
                          child: Hero(
                            tag: snapshot['photoUrl'],
                            child: FadeInImage(
                              image: NetworkImage(snapshot['photoUrl']),
                              placeholder:
                                  AssetImage('assets/images/placeholder.jpg'),
                              width: 200.0,
                              height: 200.0,
                            ),
                          ),
                        )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

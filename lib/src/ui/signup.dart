
import 'dart:io';
import 'package:arm_flutter_test_app/helpers/baseState.dart';
import 'package:arm_flutter_test_app/helpers/constants.dart';
import 'package:arm_flutter_test_app/models/User.dart';
import 'package:arm_flutter_test_app/services/Authenticate.dart';
import 'package:arm_flutter_test_app/src/ui/homePage.dart';
import 'package:arm_flutter_test_app/utils/uidata.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:arm_flutter_test_app/services/helper.dart';
import 'package:arm_flutter_test_app/src/Widget/uiAssist/UIhelpers.dart';
import 'package:arm_flutter_test_app/src/Widget/uiAssist/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arm_flutter_test_app/src/Widget/bezierContainer.dart';
import 'package:arm_flutter_test_app/src/ui/loginPage.dart';
import 'package:flutter/services.dart';
import 'package:arm_flutter_test_app/config/app_config.dart' as config;
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../main.dart';

File _image;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends BaseState<SignUpPage> {
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String firstName, lastName, email, mobile, password, confirmPassword;

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        _doSubmit();
      },
      child: ButtonWidget(buttonText: "Proceed", buttonColor: config.ArmColors().mainColor(1)),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputWidget() {
    return Column(
      children: <Widget>[
        textFormFieldWidget("First Name", TextFormField(
            validator: validateName,
            onSaved: (String val) {
              firstName = val;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            decoration: inputDecoration("First Name"))),
        textFormFieldWidget("Last Name", TextFormField(
            validator: validateName,
            onSaved: (String val) {
              lastName = val;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            decoration: inputDecoration("Last Name"))),
        textFormFieldWidget("Phone Number", TextFormField(
            keyboardType: TextInputType.phone,
            validator: validateMobile,
            onSaved: (String val) {
              mobile = val;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            decoration: inputDecoration("Phone Number"))),
        textFormFieldWidget("Email Address", TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
            onSaved: (String val) {
              email = val;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            decoration: inputDecoration("Email Address"))),
        textFormFieldWidget("Password", TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            validator: validatePassword,
            onSaved: (String val) {
              password = val;
            },
            controller: _passwordController,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            decoration: inputDecoration("Password"))),
        textFormFieldWidget("Confirm Password", TextFormField(
            keyboardType: TextInputType.visiblePassword,
            validator: (val) => validateConfirmPassword(_passwordController.text, val),
            obscureText: true,
            onSaved: (String val) {
              confirmPassword = val;
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            decoration: inputDecoration("Confirm Password"))),
      ],
    );
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Add profile picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
            await _imagePicker.getImage(source: ImageSource.gallery);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
            await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Future<void> getLostData() async {
    final LostData response = await _imagePicker.getLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (Platform.isAndroid) {
      getLostData();
    }
    return Scaffold(
      body: Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [config.ArmColors().mainColor(1), config.ArmColors().secondColor(1)])),
          child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .6,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    appTitle(),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 8.0, top: 32, right: 8, bottom: 8),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey.shade400,
                            child: ClipOval(
                              child: SizedBox(
                                width: 170,
                                height: 170,
                                child: _image == null
                                    ? Image.asset(
                                  'assets/images/placeholder.jpg',
                                  fit: BoxFit.cover,
                                )
                                    : Image.file(_image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 80,
                            right: 0,
                            child: FloatingActionButton(
                                backgroundColor: config.ArmColors().mainColor(1),
                                child: Icon(Icons.camera_alt),
                                mini: true,
                                onPressed: _onCameraClick),
                          )
                        ],
                      ),
                    ),
                new Form(
                  key: _key,
                  autovalidateMode: _validate,
                  child: _inputWidget(),
                ),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: 20),  //height * .14
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: appBackButton(context)),
          ],
        ),
      ),
    );
  }

  _doSubmit() async {
    if (_key.currentState.validate()) {
      if (_image == null) {
        showAlertDialog(context, 'Failed', 'please select an image');
        return;
      }

      _key.currentState.save();
      showProgress(context, 'Creating new account, Please wait...', false);
      var profilePicUrl = '';
      try {
        auth.UserCredential result = await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
        updateProgress('Please wait...');
        if (_image != null) {
          updateProgress('Uploading image, Please wait...');
          profilePicUrl = await FireStoreUtils()
              .uploadUserImageToFireStorage(_image, result.user.uid);
        }
        User user = User(
            email: email,
            firstName: firstName,
            phoneNumber: mobile,
            userID: result.user.uid,
            active: true,
            lastName: lastName,
            profilePictureURL: profilePicUrl);
        await FireStoreUtils.firestore
            .collection(USERS)
            .doc(result.user.uid)
            .set(user.toJson());
        hideProgress();
        MyAppState.currentUser = user;
        sharedPreferencesClass.setLoginChecker(true);
        pushAndRemoveUntil(context, HomePageWidget(user: user), false);
      } on auth.FirebaseAuthException catch (error) {
        hideProgress();
        String message = 'Couldn\'t sign up';
        switch (error.code) {
          case 'email-already-in-use':
            message = 'Email address already in use';
            break;
          case 'invalid-email':
            message = 'validEmail';
            break;
          case 'operation-not-allowed':
            message = 'Email/password accounts are not enabled';
            break;
          case 'weak-password':
            message = 'password is too weak.';
            break;
          case 'too-many-requests':
            message = 'Too many requests, '
                'Please try again later.';
            break;
        }
        showAlertDialogOk(context, UIData.txtError, message, "OK", AlertType.error);
        print(error.toString());
      } catch (e) {
        print('_SignUpState._sendToServer $e');
        hideProgress();
        showAlertDialog(context, 'Failed', 'Sign up, Failed!');
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _image = null;
    super.dispose();
  }

  @override
  void castStatefulWidget() {
    widget is SignUpPage;
  }
}

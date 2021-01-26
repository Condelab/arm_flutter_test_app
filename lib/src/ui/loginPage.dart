import 'package:arm_flutter_test_app/helpers/baseState.dart';
import 'package:arm_flutter_test_app/helpers/constants.dart';
import 'package:arm_flutter_test_app/models/User.dart';
import 'package:arm_flutter_test_app/services/Authenticate.dart';
import 'package:arm_flutter_test_app/services/helper.dart';
import 'package:arm_flutter_test_app/src/Widget/uiAssist/UIhelpers.dart';
import 'package:arm_flutter_test_app/src/Widget/uiAssist/button.dart';
import 'package:arm_flutter_test_app/utils/uidata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:arm_flutter_test_app/src/ui/signup.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../main.dart';
import '../Widget/bezierContainer.dart';
import 'homePage.dart';
import 'package:arm_flutter_test_app/config/app_config.dart' as config;


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String email = '', password = '';


  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        await login();
      },
      child: ButtonWidget(buttonText: "Proceed", buttonColor: config.ArmColors().mainColor(1)),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
          ),
          Text('or', style: TextStyle(color: Colors.white)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      width: 150,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }
  Widget _googleButton() {
    return Container(
      height: 50,
      width: 150,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFDB4437),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('G',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFDB4437),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Google',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
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
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            decoration: inputDecoration("Password"))),
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .6,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  appTitle(),
                  SizedBox(height: 50),
              new Form(
                key: _key,
                autovalidateMode: _validate,
                child: _inputWidget()),
                  SizedBox(height: 20),
                  _submitButton(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password ?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                  ),
                  _divider(),
                  Row(
                    children: [
                      _facebookButton(),
                      SizedBox(width: 10),
                      _googleButton(),
                    ],
                  ),
                  SizedBox(height: 0), // height * .055
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: appBackButton(context)),
        ],
      ),
    ));
  }

  login() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Logging in, please wait...', false);
      User user = await loginWithUserNameAndPassword();
      if (user != null) {
        //pushAndRemoveUntil(context, HomeScreen(user: user), false);
        sharedPreferencesClass.setLoginChecker(true);
        pushAndRemoveUntil(context, HomePageWidget(user: user), false);
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Future<User> loginWithUserNameAndPassword() async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      DocumentSnapshot documentSnapshot = await FireStoreUtils.firestore
          .collection(USERS)
          .doc(result.user.uid)
          .get();
      if (documentSnapshot != null && documentSnapshot.exists) {
        User user = User.fromJson(documentSnapshot.data());
        user.active = true;
        await FireStoreUtils.updateCurrentUser(user);
        hideProgress();
        MyAppState.currentUser = user;
        return user;
      } else {
        showAlertDialogOk(context, UIData.txtError, 'Couldn\'t Authenticate [unknownError]', "OK", AlertType.error);
      }
    } on auth.FirebaseAuthException catch (error) {
      hideProgress();
      switch (error.code) {
        case "invalid-email":
          showAlertDialogOk(context, UIData.txtError, 'Couldn\'t Authenticate [malformedEmail]', "OK", AlertType.error);
          break;
          return null;
        case "wrong-password":
          showAlertDialogOk(context, UIData.txtError, 'Couldn\'t Authenticate [Wrong password]', "OK", AlertType.error);
          break;
        case "user-not-found":
          showAlertDialogOk(context, UIData.txtError, 'Couldn\'t Authenticate [No user corresponds to this email]', "OK", AlertType.error);
          break;
          return null;
          case "user-disabled":
          showAlertDialogOk(context, UIData.txtError, 'Couldn\'t Authenticate [This user is disabled]', "OK", AlertType.error);
          break;
          return null;
          case 'too-many-requests':
          showAlertDialogOk(context, UIData.txtError, 'Couldn\'t Authenticate [Too many requests, Please try again later]', "OK", AlertType.error);
          break;
          return null;
      }
      print("exception:"+ error.code.toString());
      return null;
    } catch (e) {
      hideProgress();
      showAlertDialogOk(context, UIData.txtError, 'Couldn\'t Authenticate [Login failed. Please try again]', "OK", AlertType.error);
      print(e.toString());
      return null;
    }
  }

  /*void _createUserFromFacebookLogin(
      FacebookLoginResult result, String userID) async {
    final token = result.accessToken.token;
    final graphResponse = await http.get('https://graph.facebook.com/v2'
        '.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=$token');
    final profile = json.decode(graphResponse.body);
    User user = User(
        firstName: profile['first_name'],
        lastName: profile['last_name'],
        email: profile['email'],
        profilePictureURL: profile['picture']['data']['url'],
        active: true,
        userID: userID);
    await FireStoreUtils.firestore
        .collection(Constants.USERS)
        .doc(userID)
        .set(user.toJson())
        .then((onValue) {
      MyAppState.currentUser = user;
      hideProgress();
      pushAndRemoveUntil(context, HomeScreen(user: user), false);
    });
  }

  void _syncUserDataWithFacebookData(
      FacebookLoginResult result, User user) async {
    final token = result.accessToken.token;
    final graphResponse = await http.get('https://graph.facebook.com/v2'
        '.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=$token');
    final profile = json.decode(graphResponse.body);
    user.profilePictureURL = profile['picture']['data']['url'];
    user.firstName = profile['first_name'];
    user.lastName = profile['last_name'];
    user.email = profile['email'];
    user.active = true;
    await FireStoreUtils.updateCurrentUser(user);
    MyAppState.currentUser = user;
    hideProgress();
    pushAndRemoveUntil(context, HomeScreen(user: user), false);
  }*/

  @override
  void castStatefulWidget() {
    widget is LoginPage;
  }
}

import 'package:arm_flutter_test_app/models/route_argument.dart';
import 'package:arm_flutter_test_app/src/ui/ChatScreen.dart';
import 'package:arm_flutter_test_app/src/ui/OtherUsersProfilePage.dart';
import 'package:arm_flutter_test_app/src/ui/homePage.dart';
import 'package:arm_flutter_test_app/src/ui/loginPage.dart';
import 'package:arm_flutter_test_app/src/ui/signup.dart';
import 'package:flutter/material.dart';
import 'package:arm_flutter_test_app/src/splash.dart';
import 'package:arm_flutter_test_app/src/ui/onboarding.dart';
import 'package:arm_flutter_test_app/src/ui/welcomePage.dart';
import 'package:arm_flutter_test_app/utils/uidata.dart';
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments as Map;

    switch (settings.name) {
      case UIData.routeMain:
        return MaterialPageRoute(builder: (_) => OnBoardingWidget());
      case UIData.routeSplash:
        return MaterialPageRoute(builder: (_) => SplashWidget());
      case UIData.routeWelcome:
        return MaterialPageRoute(builder: (_) => WelcomePageWidget());
      case UIData.routeSignup:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case UIData.routeLogin:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case UIData.routeHome:
        return MaterialPageRoute(builder: (_) => HomePageWidget());
      case UIData.routeOtherUsersProfile:
        return MaterialPageRoute(builder: (_) => OtherUsersProfilePageWidget(routeArgument: args['routeArgument'] as RouteArgument));
    /*case UIData.routeChatScreen:
        return MaterialPageRoute(builder: (_) => ChatScreen(routeArgument: args['routeArgument'] as RouteArgument));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();*/
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

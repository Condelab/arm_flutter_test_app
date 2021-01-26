import 'package:flutter/material.dart';

class App {
  BuildContext _context;
  double _height;
  double _width;
  double _heightPadding;
  double _widthPadding;

  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height - ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding = _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  double appHorizontalPadding(double v) {
    return _widthPadding * v;
  }
}

class Config {
  /// Define your default color (light or dark)
  // static final defaultColor = 'dark';
  static final defaultColor = 'light';

  /// Enable push notifications
  static final pushNotificationsEnabled = true;

/// AdMob settings
//static final adMobEnabled = false;
//static final adMobiOSAppID = 'ca-app-pub-7417532174662446~3143491712';
//static final adMobAndroidID = 'ca-app-pub-7417532174662446~2512936327';
//static final adMobAdUnitID = BannerAd.testAdUnitId;
//static final adMobPosition = 'bottom';
}


class ArmColors {
  Color _mainColor = Color(0xFFB9A994);
  Color _mainDarkColor = Color(0xFFB9A994);
  Color _secondColor = Color(0xFF000000);
  Color _secondDarkColor = Color(0xFF000000);
  Color _accentColor = Color(0xFFEEE7E1);
  Color _accentDarkColor = Color(0xFFEEE7E1);

  Color mainColor(double opacity) {
    return this._mainColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return this._secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return this._accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return this._mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return this._secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return this._accentDarkColor.withOpacity(opacity);
  }
}

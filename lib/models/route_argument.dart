class RouteArgument {
  dynamic id;
  List<dynamic> argumentsList;

  RouteArgument({this.argumentsList});

  @override
  String toString() {
    return '{id: $id, heroTag:${argumentsList.toString()}}';
  }
}

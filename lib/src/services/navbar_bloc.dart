import 'dart:async';

class NavBarBloc {
  final _navBarController = new StreamController<int>.broadcast();

  Function(int) get changePage => _navBarController.sink.add;
  Stream<int> get navBarStream => _navBarController.stream;

  dispose() {
    _navBarController?.close();
  }
}

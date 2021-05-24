import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/src/pages/heatmap_page.dart';
import 'package:stock_tracker/src/pages/home_page.dart';
import 'package:stock_tracker/src/pages/menu_page.dart';
import 'package:stock_tracker/src/services/navbar_bloc.dart';
import 'package:stock_tracker/src/widgets/navigation_bar.dart';

// ignore: must_be_immutable
class NavigationPage extends StatelessWidget {
  NavigationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Material(
      child: Stack(
        children: [
          buildPage(context, _size),
          // buildAppBar(_size),
          Positioned(
            bottom: 0.0,
            width: _size.width,
            child: CustomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget buildPage(BuildContext context, Size _size) {
    return StreamBuilder(
      initialData: 0,
      stream: Provider.of<NavBarBloc>(context).navBarStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData)
          switch (snapshot.data) {
            case 0:
              return HomePage();
              break;
            case 1:
              return HeatmapPage();
              break;
            case 3:
              return MenuPage();
              break;
            default:
              return HomePage();
              break;
          }
        else
          return Center(child: CircularProgressIndicator());
      },
    );
  }

  // Widget getPage(BuildContext context) {
  //   return StreamBuilder(
  //     stream: Provider.of(context).navBarStream,
  //     builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
  //       if (snapshot.hasData)
  //         return snapshot.data;
  //       else
  //         return Center(child: CircularProgressIndicator());
  //     },
  //   );
  // }

  // Positioned buildNavBar(Size _size) {
  //   return Positioned(
  //     bottom: 0.0,
  //     width: _size.width,
  //     child: CustomNavBar(),
  //   );
  // }

  // Positioned buildAppBar(Size _size) {
  //   return Positioned(
  //     top: 0.0,
  //     width: _size.width,
  //     child: CustomAppBar(size: _size),
  //   );
  // }
}

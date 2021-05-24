import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/services/navbar_bloc.dart';

class MenuItem {
  final IconData icon;
  final Color color;
  final double x;
  final pageIndex;
  MenuItem(this.pageIndex, {this.icon, this.color, this.x});
}

class CustomNavBar extends StatefulWidget {
  CustomNavBar({Key key}) : super(key: key);

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  MenuItem active;

  List items = [
    MenuItem(0, x: -1.0, icon: Icons.home),
    MenuItem(1, x: -0.0, icon: Icons.dashboard),
    MenuItem(3, x: 1.0, icon: Icons.menu),
  ];

  @override
  void initState() {
    super.initState();
    active = items[0];
  }

  final double navbarPadding = kDefaultPadding * 1.3;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: navbarPadding),
        child: Container(
          height: kNavBarHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: kSecondaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(0.0, 1.0),
                blurRadius: 2.0,
              ),
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, -1.0),
                blurRadius: 3.0,
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 70),
                alignment: Alignment(active.x, -1),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 1000),
                  height: 8,
                  width: w * (1 / items.length) - navbarPadding,
                  color: kPrimaryColor,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: items.map((item) {
                    return _button(item);
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(MenuItem item) {
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 1,
        child: Icon(
          item.icon,
          color: (active.icon == item.icon) ? kPrimaryColor : Colors.grey,
          size: 35.0,
        ),
      ),
      onTap: () {
        setState(() {
          active = item;
        });
        Provider.of<NavBarBloc>(context, listen: false)
            .changePage(item.pageIndex);
      },
    );
  }
}

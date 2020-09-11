import 'package:covid_19_app/fb/fb_home_screen.dart';
import 'package:covid_19_app/fb/widget/account_widget.dart';
import 'package:covid_19_app/page/all_countries_page.dart';
import 'package:covid_19_app/page/open_container_animation.dart';
import 'package:flutter/material.dart';

class FbNavBarScreen extends StatefulWidget {
  @override
  _FbNavBarScreenState createState() => _FbNavBarScreenState();
}

class _FbNavBarScreenState extends State<FbNavBarScreen> {
  bool _currentPage = false;
  // var _pages = [
  //   FbHomeScreen(),
  //   VideoScreen(),
  //   AccountScreen(),
  //   PeopleScreen(),
  //   AllCountriesPage(),
  // ];
  var _icons = [Icons.home, Icons.live_tv, Icons.account_circle, Icons.people, Icons.notifications, Icons.menu];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _pageLists() {
    var _pages = [
      FbHomeScreen(currentPage: _currentPage, pageIndex: _selectedIndex),
      VideoScreen(),
      AccountWidget(),
      //PeopleScreen(),
      OpenContainerAnimation(),
      AllCountriesPage(),
      Scaffold(
        appBar: AppBar(
          title: Text("Setting"),
        ),
      )
    ];
    return _pages;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _pageLists().length,
      child: Scaffold(
        // body: IndexedStack(
        //   index: _selectedIndex,
        //   children: _pages,
        // ),
        //appBar: AppBar(bottom: _tabBarMenu()),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: _pageLists().map((e) => e).toList(),
        ),
        bottomNavigationBar: _tabBarMenu(),
      ),
    );
  }

  Widget _tabBarMenu() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
        labelPadding: EdgeInsets.all(10),
        tabs: _icons
            .asMap()
            .entries
            .map(
              (e) => Icon(
                _icons[e.key],
                size: 30,
                color: e.key == _selectedIndex ? Colors.blue : null,
              ),
            )
            .toList(),
        onTap: (index) {
          setState(() {
            if (index == _selectedIndex) {
              _currentPage = true;
            } else {
              _currentPage = false;
            }
            _selectedIndex = index;
            print("nav $_currentPage");
          });
        },
      ),
    );

    //  BottomNavigationBar(
    //   backgroundColor: Colors.blueGrey,
    //   type: BottomNavigationBarType.fixed,
    //   currentIndex: selectedIndex,
    //   items: _icons
    //       .asMap()
    //       .entries
    //       .map(
    //         (e) => BottomNavigationBarItem(
    //           icon: Icon(
    //             _icons[e.key],
    //             color: e.key == selectedIndex ? Colors.white : Colors.black,
    //           ),
    //           title: SizedBox.shrink(),
    //         ),
    //       )
    //       .toList(),
    //   onTap: (index) {
    //     setState(() {
    //       selectedIndex = index;
    //     });
    //   },
    // ),
  }
}

class PeopleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("People"),
        automaticallyImplyLeading: false,
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        automaticallyImplyLeading: false,
      ),
    );
  }
}

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video"),
        automaticallyImplyLeading: false,
      ),
    );
  }
}

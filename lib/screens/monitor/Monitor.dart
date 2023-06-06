import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../user/UserView.dart';
import 'Dashboard.dart';
import 'Scanner.dart';
import 'ViewLogs.dart';
import 'Profile.dart';

class Monitor extends StatefulWidget {
  const Monitor({super.key});

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  int _pageIndex = 0;

  late PageController _pageController;

  final String logo = 'assets/images/Logo.svg';
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget bottomNavFunction() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _pageIndex = index;
        });
      },
      children: const <Widget>[
        Dashboard(),
        ViewLogs(),
        Profile(),
      ],
    );
  }

  void _swipeLeft() {
    if (_pageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _swipeRight() {
    if (_pageIndex < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(right: 7.5),
              child: SvgPicture.asset(
                logo,
                width: 40,
                colorFilter:
                    const ColorFilter.mode(Color(0xFF526bf2), BlendMode.srcIn),
              ),
            ),
            const Text(
              "Health",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'SF-UI-Display',
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const Text(
              "Mate",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'SF-UI-Display',
                  fontSize: 20,
                  fontWeight: FontWeight.w300),
            ),
          ]),
          backgroundColor: const Color(0xFF090c12),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          backgroundColor: const Color(0xFF526bf2),
          foregroundColor: Colors.white,
          type: ExpandableFabType.up,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scanner');
              },
              backgroundColor: const Color(0xFF526bf2),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),
            FloatingActionButton(
              backgroundColor: Colors.green,
              heroTag: null,
              child: const Icon(Icons.phone_android, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/user',
                    arguments: const UserView(
                      viewer: 'Monitor',
                    ));
              },
            ),
            FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 255, 72, 59),
              heroTag: null,
              child: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/monitor-signin');
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color(0xFF526bf2),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: const Color(0xFF090c12),
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _pageIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              label: 'Students',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Entry Request',
            ),
          ],
        ),
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _swipeRight();
            } else if (details.primaryVelocity! > 0) {
              _swipeLeft();
            }
          },
          child: bottomNavFunction(),
        ));
  }
}

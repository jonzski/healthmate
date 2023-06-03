import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cmsc_23_project/provider/auth_provider.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'Dashboard.dart';
import 'UserEntries.dart';
import 'Profile.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  int _pageIndex = 0;

  late PageController _pageController;
  GlobalKey _bottomNavigationKey = GlobalKey();

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
      children: <Widget>[Dashboard(), UserEntries(), Profile()],
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
    context.read<AuthProvider>().currentUser;
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
              "OHMS",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'SF-UI-Display',
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const Text(
              "Mobile",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'SF-UI-Display',
                  fontSize: 20,
                  fontWeight: FontWeight.w300),
            ),
          ]),
          backgroundColor: const Color(0xFF090c12),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          key: _bottomNavigationKey,
          backgroundColor: const Color(0xFF090c12),
          selectedItemColor: const Color(0xFF526bf2),
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
              label: 'Entry Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
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

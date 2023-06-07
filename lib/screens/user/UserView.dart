import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cmsc_23_project/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'Dashboard.dart';
import 'UserEntries.dart';
import 'Profile.dart';

class UserView extends StatefulWidget {
  final String viewer;
  const UserView({super.key, required this.viewer});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late String viewer;
  int _pageIndex = 0;

  late PageController _pageController;
  GlobalKey _bottomNavigationKey = GlobalKey();

  final String logo = 'assets/images/Logo.svg';
  @override
  void initState() {
    viewer = widget.viewer;
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
      children: <Widget>[
        Dashboard(viewer: viewer),
        const UserEntries(),
        Profile(viewer: viewer)
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
        body: viewer == 'Admin' || viewer == 'Monitor'
            ? Stack(
                children: [
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        _swipeRight();
                      } else if (details.primaryVelocity! > 0) {
                        _swipeLeft();
                      }
                    },
                    child: bottomNavFunction(),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      color: const Color(0xFF222429),
                      height: 35,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 5, right: 8),
                                  child: Icon(Icons.remove_red_eye_outlined),
                                ),
                                Text(
                                  'Viewing user\'s interface as $viewer',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF526bf2),
                                ),
                                child: const Text(
                                  'Exit View',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ]),
                    ),
                  )
                ],
              )
            : GestureDetector(
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

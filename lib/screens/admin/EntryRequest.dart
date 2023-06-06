import 'package:flutter/material.dart';
import 'EditRequest.dart';
import 'DeleteRequest.dart';

class EntryRequest extends StatefulWidget {
  const EntryRequest({Key? key}) : super(key: key);

  @override
  State<EntryRequest> createState() => _EntryRequestState();
}

class _EntryRequestState extends State<EntryRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF090c12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 20.0),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Entry Request',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'SF-UI-Display',
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
            ),
          ),
          Expanded(
            // Wrap the Column with Expanded widget
            child: DefaultTabController(
              length: 2, // length of tabs
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: const TabBar(
                      labelColor: Color(0xFF526bf2),
                      unselectedLabelColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text(
                            'Edit Request',
                            style: TextStyle(
                                fontFamily: 'SF-UI-Display', fontSize: 16.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Delete Request',
                            style: TextStyle(
                                fontFamily: 'SF-UI-Display', fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    // Wrap TabBarView with Expanded widget
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: const TabBarView(
                        children: <Widget>[
                          EditRequest(),
                          DeleteRequest(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

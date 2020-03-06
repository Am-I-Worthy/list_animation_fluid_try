import 'package:flutter/material.dart';
// import 'package:simple_gesture_detector/simple_gesture_detector.dart';
// import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: ScrollList(),
        ),
      ),
    );
  }
}

class ScrollList extends StatefulWidget {
  @override
  _ScrollListState createState() => _ScrollListState();
}

class _ScrollListState extends State<ScrollList> with TickerProviderStateMixin {
  ScrollController _controller;
  var rate = 1.0;
  var old = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          var current = scrollNotification.metrics.pixels;
          //print(current);
          setState(() {
            if (current > 10) {
              rate = (current - old).abs();
              print(rate);
              old = current;
            }

            if (scrollNotification.metrics.pixels >=
                scrollNotification.metrics.maxScrollExtent - 50) {
              rate = 0.0;
              print("max");
            }

            if (scrollNotification.metrics.pixels <=
                scrollNotification.metrics.minScrollExtent + 50) {
              rate = 0.0;
              print("min");
            }
          });

          return true;
        },
        child: CustomScrollView(
          controller: _controller,
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimatedPadding(
                    padding: EdgeInsets.only(
                        top: ((rate + 10).abs() > 50) ? 50 : (rate + 10).abs(),
                        left: 10.0,
                        right: 10.0),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    child: Container(
                      height: 100.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  );
                },
                childCount: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}

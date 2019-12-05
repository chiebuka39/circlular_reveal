
import 'package:circlular_reveal/page_indicator.dart';
import 'package:flutter/material.dart';

import 'Animation_Gesture/page_reveal.dart';
import 'Models/details.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'app.dart';

/// This is the main method of app, from here execution starts.
void main() => runApp(OnboardingScreen());
//void main() => runApp(App());

/// App widget class

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
          fontFamily: "DINPro"),
      debugShowCheckedModeBanner: false,
      home: new MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  PageController controller;
  // Current page showing
  int currentPage = 0;

  // nest page to be showed
  int nextPageIndex = 1;

  // percentage slide
  double slidePercent = 0.0;

  @override
  void initState() {
    controller = PageController(viewportFraction: 0.8, keepPage: false);
    controller.addListener(() {
      int next = controller.page.round();
      if (next > nextPageIndex) {
        print("hshhd $next");
        setState(() {
          nextPageIndex = next;
        });
      }
      if (next < currentPage) {
        nextPageIndex = next;
      }
      //print(next);
      setState(() {
        if (controller.position.haveDimensions) {
          slidePercent = (controller.page) - currentPage;
        }
      });
      if (controller.page == next) {
        print("got here this hone");
        setState(() {
          currentPage = next;
          //nextPageIndex = next+1;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: colors[currentPage],
          ),
          PageReveal(
            //next page reveal
            revealPercent: slidePercent,
            child: Container(
              color: colors[nextPageIndex],
            ),
          ),
          Positioned.fill(
            child: PageView.builder(
              onPageChanged: _onPageChanged,
              controller: controller,
              pageSnapping: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return buildMainContainer(index);
              },
              itemCount: 3,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                DotsIndicator(
                  controller: controller,
                  itemCount: 3,
                  selectedSize: 10,
                  selectedColor: Colors.black26,
                ),
                SizedBox(
                  height: 30,
                ),
                ButtonTheme(
                    buttonColor: Colors.black26,
                    minWidth: 200,
                    height: 45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: FlatButton(
                      color: Colors.black.withOpacity(0.2),
                      onPressed: () {},
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    ))
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.clear),
                  color: Colors.white,
                ),
                Spacer(flex: 2,),
                Text("Choose your plan", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                Spacer(flex: 3,),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onPageChanged(index) {
    setState(() {
      //currentPage = index;
    });
  }

  Widget buildMainContainer(int index) {
    return AnimatedBuilder(
      child: Material(
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Spacer(),
            SvgPicture.asset(detailsList[index].img, width: 80,height: 80,),
              SizedBox(height: 30,),
              Text(detailsList[index].title, style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Container(width:200,child: Text(detailsList[index].description, textAlign: TextAlign.center,)),
              Spacer(),
          ],),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
        ),
      ),
      animation: controller,
      builder: (BuildContext context, Widget child) {
        double value = 1;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
          return Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0),
                height: Curves.easeIn.transform(value) * 500,
                child: child,
              ));
        } else {
          return Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0),
                height:
                    Curves.easeIn.transform(index == 0 ? value : value * 0.5) *
                        500,
                child: child,
              ));
        }
      },
    );
  }

  Widget _detailsBuilder(index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
        }

        return Expanded(
          child: Transform.translate(
            offset: Offset(0, 100 + (-value * 100)),
            child: Opacity(
              opacity: value,
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      detailsList[index].title,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      detailsList[index].description,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      width: 80.0,
                      height: 5.0,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Read More",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

List<Color> colors = [Colors.red, Colors.green, Colors.blue];


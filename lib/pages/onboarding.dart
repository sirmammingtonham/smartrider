import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartrider/pages/welcome.dart';
import 'package:smartrider/pages/home.dart';


final kTitleStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Helvetica',
  fontSize: 30.0,
  height: 1.5,
);

final kSubtitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 22.0,
  height: 1.3,
);

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFF3594DD),
                Color(0xFF165DC0),
                Color(0xFF07489C),
                Color(0xFF083663),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      print('Skip');
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(homePage: HomePage())),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 600.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage("assets/app_icons/logo_v1.png"),
                                height: 300.0,
                                width: 150.0,
                              ),
                            ),
                            SizedBox(height: 50.0),
                            Center(
                              child: Text(
                                'Welcome to SmartRider!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26.0,
                                  height: 1.5,),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Center(
                              child: Text(
                                'All of your RPI transportation needs in one place, instantly accessible.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  height: 1.5,
                                )
                              ),
                            )
                            //  Image(
                            //    image: AssetImage('assets/onboarding_images/rpi_stock_photo.jpg'),
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image(
                                image: AssetImage("assets/onboarding_images/onboarding_page2_1.png"),
                                height: 300.0,
                                width: 150.0,
                                ),
                                Spacer(flex:1),
                                Image( 
                                  image: AssetImage("assets/onboarding_images/onboarding_page2_2.png"),
                                  height: 300.0, 
                                  width: 150.0,
                                )
                              ]
                            ),
                            SizedBox(height: 50.0),
                            Center(
                              child: Text(
                                'Interactive Map',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26.0,
                                  height: 1.5,),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Center(
                              child: Text(
                                'Easily locate nearby transporation stops and routes with live shuttle/bus tracking.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  height: 1.5,
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image(
                                image: AssetImage("assets/onboarding_images/onboarding_page3_1.png"),
                                height: 300.0,
                                width: 150.0,
                                ),
                                Spacer(flex:1),
                                Image( 
                                  image: AssetImage("assets/onboarding_images/onboarding_page3_2.png"),
                                  height: 300.0, 
                                  width: 150.0,
                                )
                              ]
                            ),
                            SizedBox(height: 50.0),
                            Center(
                              child: Text(
                                'Comprehensive Schedules',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                  height: 1.5,),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Center(
                              child: Text(
                                "Access transportation route arrival times throughout the day and schedule reminders for specific stops.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  height: 1.5,
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 30.0),
                            Text(
                              'SafeRide',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'SubText 3',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white
              ),
              height: 75,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(homePage: HomePage())),
                  );
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Get started',
                      style: TextStyle(
                        color: Color(0xFF083663),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
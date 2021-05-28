import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartrider/pages/welcome.dart';
import 'package:smartrider/pages/home.dart';

// prefs bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

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

bool onboardDone = false;

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 5;
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
        color: isActive ? Colors.black : Color(0xFF181c5b),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return onboardDone
            ? WelcomeScreen(homePage: HomePage())
            : AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {
                              BlocProvider.of<PrefsBloc>(context)
                                  .add(OnboardingComplete());
                              setState(() {
                                onboardDone = true;
                              });
                            },
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Color(0xFF1b1d5c),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
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
                                        image: AssetImage(
                                            "assets/app_icons/logo_v2.png"),
                                        height: 300.0,
                                        width: 300.0,
                                      ),
                                    ),
                                    SizedBox(height: 50.0),
                                    Center(
                                      child: Text(
                                        'Welcome to SmartRider!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF181c5b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Center(
                                      child: Text(
                                          'All of your RPI transportation needs in one place, instantly accessible.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF181c5b),
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                          )),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                              image: AssetImage(
                                                  "assets/onboarding_images/interactive_map.png"),
                                              height: 300.0,
                                              width: 300.0),
                                        ]),
                                    SizedBox(height: 50.0),
                                    Center(
                                      child: Text(
                                        'Interactive Map',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF181c5b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Center(
                                      child: Text(
                                          'Easily locate nearby transporation stops and routes with live shuttle/bus tracking.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF181c5b),
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                          )),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: AssetImage(
                                                "assets/onboarding_images/comprehensive_scheduling.png"),
                                            height: 300.0,
                                            width: 300.0,
                                          ),
                                        ]),
                                    SizedBox(height: 50.0),
                                    Center(
                                      child: Text(
                                        'Comprehensive Scheduling',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF181c5b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Center(
                                      child: Text(
                                          "Access transportation route arrival times throughout the day and schedule reminders for specific stops.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF181c5b),
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                          )),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              child: Image.asset(
                                                "assets/onboarding_images/request_transportation.png",
                                                height: 300.0,
                                                width: 300.0,
                                              ),
                                            ),
                                          ),
                                        ]),
                                    SizedBox(height: 50.0),
                                    Center(
                                      child: Text(
                                        'Request Transportation',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF181c5b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Center(
                                        child: Text(
                                            'With the integration of the RPI SafeRide application, easily make a request for a vehicle to transport you safely around the campus.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF181c5b),
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                              height: 1.5,
                                            ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: AssetImage(
                                                "assets/onboarding_images/customizable_view.png"),
                                            height: 340.0,
                                            width: 300.0,
                                          ),
                                        ]),
                                    SizedBox(height: 50.0),
                                    Center(
                                      child: Text(
                                        'Cuztomizable View',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF181c5b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Center(
                                      child: Text(
                                          "Conveniently choose which routes and stops are displayed on the map.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF181c5b),
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                          )),
                                    )
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Next',
                                          style: TextStyle(
                                            color: Color(0xFF181c5b),
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Color(0xFF181c5b),
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
              );
      }),
      bottomSheet: _currentPage == _numPages - 1 && !onboardDone 
          ? Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius:
                      BorderRadius.all(Radius.circular(double.infinity)),
                  color: Color(0xFF181c5b)),
              height: 75,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<PrefsBloc>(context).add(OnboardingComplete());
                  setState(() {
                    onboardDone = true;
                  });
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
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

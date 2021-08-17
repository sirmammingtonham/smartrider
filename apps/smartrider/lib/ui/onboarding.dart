// ignore_for_file: lines_longer_than_80_chars
// TODO: give a message that you need to verify phone number before calling saferide
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartrider/ui/welcome.dart';
import 'package:smartrider/ui/home.dart';
import 'package:sizer/sizer.dart';

// prefs bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

const kTitleStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Helvetica',
  fontSize: 30.0,
  height: 1.5,
);

const kSubtitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 22.0,
  height: 1.3,
);

bool onboardDone = false;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 5;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    final list = <Widget>[];
    for (var i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : const Color(0xFF181c5b),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return onboardDone
            ? const WelcomeScreen(homePage: HomePage())
            : AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              BlocProvider.of<PrefsBloc>(context)
                                  .add(const OnboardingComplete());
                              setState(() {
                                onboardDone = true;
                              });
                            },
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: const Color(0xFF1b1d5c),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 75.h,
                          child: PageView(
                            physics: const ClampingScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: Image(
                                        image: const AssetImage(
                                            'assets/onboarding_images/logo_v2.png'),
                                        height: 42.h,
                                        width: 87.w,
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                    Center(
                                      child: Text(
                                        'Welcome to SmartRider!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF181c5b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21.sp,
                                          height: 0.1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Center(
                                      child: Text(
                                          'All of your RPI transportation needs in one place, instantly accessible.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF181c5b),
                                            fontSize: 14.sp,
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
                                padding: const EdgeInsets.all(40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                              image: const AssetImage(
                                                  'assets/onboarding_images/interactive_map.png'),
                                              height: 35.h,
                                              width: 55.w),
                                        ]),
                                    const SizedBox(height: 50.0),
                                    Center(
                                      child: Text(
                                        'Interactive Map',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF181c5b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21.sp,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Center(
                                      child: Text(
                                          'Easily locate nearby transporation stops and routes with live shuttle/bus tracking.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF181c5b),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                            image: const AssetImage(
                                                'assets/onboarding_images/comprehensive_scheduling.png'),
                                            height: 27.h,
                                            width: 75.w,
                                          ),
                                        ]),
                                    const SizedBox(height: 50.0),
                                    Center(
                                      child: Text(
                                        'Comprehensive Scheduling',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF181c5b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21.sp,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Center(
                                      child: Text(
                                          'Access transportation route arrival times throughout the day and schedule reminders for specific stops.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF181c5b),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Image.asset(
                                              'assets/onboarding_images/request_transportation.png',
                                              height: 30.h,
                                              width: 50.w,
                                            ),
                                          ),
                                        ]),
                                    const SizedBox(height: 50.0),
                                    Center(
                                      child: Text(
                                        'Request Transportation',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF181c5b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21.sp,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Center(
                                        child: Text(
                                            'With the integration of the RPI SafeRide application, easily make a request for a vehicle to transport you safely around the campus.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(0xFF181c5b),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              height: 1.5,
                                            ))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                            image: const AssetImage(
                                                'assets/onboarding_images/customizable_view.png'),
                                            height: 35.h,
                                            width: 60.w,
                                          ),
                                        ]),
                                    const SizedBox(height: 50.0),
                                    Center(
                                      child: Text(
                                        'Cuztomizable View',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF181c5b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21.sp,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Center(
                                      child: Text(
                                          'Conveniently choose which routes and stops are displayed on the map.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF181c5b),
                                            fontSize: 14.sp,
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
                                  child: TextButton(
                                    onPressed: () {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
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
                                            color: const Color(0xFF181c5b),
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: const Color(0xFF181c5b),
                                          size: 12.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const Text(''),
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
                      const BorderRadius.all(Radius.circular(double.infinity)),
                  color: const Color(0xFF181c5b)),
              height: 10.h,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<PrefsBloc>(context)
                      .add(const OnboardingComplete());
                  setState(() {
                    onboardDone = true;
                  });
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Text(''),
    );
  }
}

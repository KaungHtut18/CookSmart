import 'package:cookbook/auth/wrapper.dart';
import 'package:cookbook/screens/welcome_pages/page1.dart';
import 'package:cookbook/screens/welcome_pages/page2.dart';
import 'package:cookbook/screens/welcome_pages/page3.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cookbook/constant/image.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<OnBoardingScreen> {
  //to keep track which page we are on
  final PageController _controller = PageController();
  //to track when we are on last page
  bool onLastPage = false;

  @override
  void dispose() {
    super.dispose();
   _controller.dispose();
  }

  _storeOnBoardInfo() async{
    int isViewed = 0;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('onBoard', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                //title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: Image.asset(logo),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    height: 400,
                    //page view
                    child: PageView(
                      onPageChanged: (index) => setState(() {
                        onLastPage = (index == 2);
                      }),
                      controller: _controller,
                      children: const [Page1(), Page2(), Page3()],
                    ),
                  ),
                ),
                //dot indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    dotColor: Color.fromRGBO(238, 90, 37, 0.73),
                    activeDotColor: Color.fromRGBO(238, 90, 37, 1),
                    dotHeight: 13,
                  ),
                ),
                const Spacer(),
                //buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _controller.jumpToPage(2),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      onLastPage
                          ? GestureDetector(
                              onTap: () async{
                                await _storeOnBoardInfo();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => Wrapper()));
                              },
                              child: Container(
                                height: 48,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  color: const Color.fromRGBO(238, 90, 37, 1),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => _controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn),
                              child: Container(
                                height: 48,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  color: Color(0xFFEE5A25),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

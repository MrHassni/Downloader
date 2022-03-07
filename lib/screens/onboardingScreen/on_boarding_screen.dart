import 'package:easy_download/screens/navigationHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'on_boarding_list.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  PageController? _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  _storeOnboardInfo() async {
    print("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }


  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: contents.length,
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, i) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: (){
                          _storeOnboardInfo();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NavigationHomeScreen(),
                        ),
                      );
                    }, child: const Text('Skip',style: TextStyle(fontSize: 12,color: Colors.white),)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.44,
                        child: Image.asset(
                        'assets/images/onboardingLeft.png',
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height*0.44 ,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32)
                        ),
                        child: Image.asset(
                          contents[i].image,
                          // height: MediaQuery.of(context).size.height*0.4,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.44,
                        child: Image.asset(
                          'assets/images/onboardingRight.png',
                        ),
                      ),
                    ],
                  ),
                  Text(
                    contents[i].discription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      if (currentIndex == contents.length - 1) {
                        _storeOnboardInfo();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NavigationHomeScreen(),
                          ),
                        );
                      }
                      _controller!.nextPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Container(
                      // color: Colors.red,
                        alignment: Alignment.center,
                        height:100,
                        width: 100,
                        child: Image.asset(contents[i].buttonImage)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
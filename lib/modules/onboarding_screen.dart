import 'package:flutter/material.dart';
import 'package:shop_app/modules/Login/LoginScreen.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/constant.dart';
import 'package:shop_app/shared/network/shared_pref.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class BoardingModel {
  late final String? image;
  late final String? title;
  late final String? body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/onboard_1.jpg',
        title: "on board one ",
        body: "on board one body"),
    BoardingModel(
        image: 'assets/onboard_1.jpg',
        title: "on board Two ",
        body: "on board Two body"),
    BoardingModel(
        image: 'assets/onboard_1.jpg',
        title: "on board Three ",
        body: "on board Three body"),
  ];


  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) => {
      if(value!){
        navigateAndFinish(context,  LoginScreen()),
      }
    });

  }

  var pageController = PageController();

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            // MaterialButton(
            //   onPressed: () {
            //     navigateAndFinish(context, LoginScreen());
            //   },
            //   child: Text(
            //     'Skip',
            //     style: TextStyle(color: Colors.deepOrange, fontSize: 18.0),
            //   ),
            // )
            defaultTextButton(
              function:submit,
              text: 'Skip' ,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (int index) {
                    if (index == boarding.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                    }
                  },
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildBoardingItem(boarding[index]),
                  itemCount: boarding.length,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  // Text("Indicator"),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: boarding.length,
                    effect: ExpandingDotsEffect(
                        activeDotColor: defaultColor,
                        dotColor: Colors.grey,
                        dotHeight: 10,
                        dotWidth: 10,
                        expansionFactor: 4,
                        spacing: 5),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if(isLast){
                        submit();
                      }else{
                        pageController.nextPage(
                            duration: Duration(microseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }

                    },
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset('${model.image}'),
          ),
          // SizedBox(height: 50.0),
          Text(
            "${model.title}",
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 50.0),
          Text(
            "${model.body}",
            style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
          ),
        ],
      );
}

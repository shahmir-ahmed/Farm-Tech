import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/select_user_type/select_user_type_view.dart';
import 'package:flutter/material.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int _current = 0;
  final carousel.CarouselSliderController _controller = carousel.CarouselSliderController();

  final imgList = [
    "assets/images/carousel-image-1.png",
    "assets/images/carousel-image-2.png",
    "assets/images/carousel-image-3.png",
  ];

  final carouselHeadingTextList = [
    "Get Rid of Third Person",
    "Help in Market Analysis",
    "Multi user",
  ];

  final carouselTextList = [
    "Using this application you can get rid of paying commission fee to third person. Now you can directly chat with buyers and deal with them.",
    "You'll have all of the market analysis in your pocket. You'll get to know the latest and genuine market rates of items.", // for buyer
    "Easily register your store on the platform and start selling your items, or if you are a buyer search for your desired items and purchase them directly.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.whiteColor,
      body: _getBody(context),
    );
  }

  _getBody(context) {
    return SafeArea(
        child: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          // carousel
          carousel.CarouselSlider(
            carouselController: _controller,
            options: carousel.CarouselOptions(
                viewportFraction: 1.0,
                autoPlay: true,
                // height: 430.0,
                height: MediaQuery.of(context).size.height - 100,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: [0, 1, 2].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  // single slider widget
                  return Container(
                      // width: MediaQuery.of(context).size.width,
                      // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      // decoration: BoxDecoration(color: Colors.amber),
                      child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      children: [
                        // image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                                // height: 200.0,
                                width: 340.0,
                                child: Image(image: AssetImage(imgList[i]))),
                          ],
                        ),
                        // space
                        const SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 30, 30, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // heading text
                                Text(carouselHeadingTextList[i],
                                    style: Utils.kAppHeading4BoldStyle),
                                // space
                                SizedBox(
                                  height: 10.0,
                                ),
                                // body text
                                Text(carouselTextList[i],
                                    style: Utils.kAppBody1RegularStyle
                                        .copyWith(color: Utils.lightGreyColor1))
                              ],
                            )),
                      ],
                    ),
                  ));
                },
              );
            }).toList(),
          ),
          // indicator and skip button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // space
              const SizedBox(
                width: 30.0,
              ),
              // indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                          width: 7.0,
                          // width: 7.0,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == entry.key
                                  ? Utils.greenColor
                                  : Utils.lightGreyColor1)));
                }).toList(),
              ),
              // skip text
              GestureDetector(
                onTap: () {
                  // close screen and show choose user screen
                  Navigator.pop(context);
                  // push choose user screen
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const SelectUserTypeView()));
                },
                child: Text('Skip',
                    style: Utils.kAppBody3RegularStyle
                        .copyWith(color: Utils.greenColor)),
              ),
            ],
          ),
          // space
          // const SizedBox(
          //   height: 20,
          // )
        ],
      ),
    ));
  }
}

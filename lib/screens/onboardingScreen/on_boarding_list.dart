class OnBoardingContent {
  String image;
  String buttonImage;
  String discription;
  OnBoardingContent({required this.image,required this.buttonImage, required this.discription,});
}

List<OnBoardingContent> contents = [
  OnBoardingContent(
    buttonImage: 'assets/images/onboardingFirstButton.png',
    image: 'assets/images/onboardingFirst.png',
    discription: 'Download the video of multiple social media platforms',
  ),
  OnBoardingContent(
    buttonImage: 'assets/images/onboardingSecondButton.png',
    image: 'assets/images/onboardingSecond.png',
    discription:  'Paste link and download with one click',
  ),
  OnBoardingContent(
    buttonImage: 'assets/images/onboardingThirdButton.png',
    image: 'assets/images/onboardingThird.png',
    discription:'Play videos and enjoy anytime anywhere',
  ),
];
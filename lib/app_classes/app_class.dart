import 'package:flutter_svg/svg.dart';

class AppClass {
  // Greeting Method
  String getGreeting() {
    final hour = DateTime.now().hour;
    print(hour);
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  // flutter SVG arrow Nex Code
  void svgArow() {
    SvgPicture.asset(
      'assets/images/arrow_forward.svg',
      semanticsLabel: 'My SVG Image',
      height: 100,
      width: 70,
    );
  }
}

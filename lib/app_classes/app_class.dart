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
}

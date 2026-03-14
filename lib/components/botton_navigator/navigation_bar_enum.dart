import 'package:task_radar/routes/routes.dart';

enum NavigationBarEnum {
  home(Routes.home),
  tasks(Routes.tasks),
  profile(Routes.profile);

  final String route;

  const NavigationBarEnum(this.route);

  static NavigationBarEnum fromLocation(String location) {
    if (location.startsWith(Routes.tasks)) {
      return NavigationBarEnum.tasks;
    }
    if (location.startsWith(Routes.profile)) {
      return NavigationBarEnum.profile;
    }
    return NavigationBarEnum.home;
  }
}

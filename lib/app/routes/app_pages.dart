import 'package:get/get.dart';

import '../modules/detail/bindings/detail_binding.dart';
import '../modules/detail/views/detail_view.dart';
import '../modules/deteksi/bindings/deteksi_binding.dart';
import '../modules/deteksi/views/deteksi_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notif/bindings/notif_binding.dart';
import '../modules/notif/views/notif_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/recipe/bindings/recipe_binding.dart';
import '../modules/recipe/views/recipe_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/register/views/verify_otp_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/register',
      page: () => RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(name: '/home', page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: '/profile',
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/recipe',
      page: () => RecipeView(),
      binding: RecipeBinding(),
    ),
    GetPage(
      name: '/notifications',
      page: () => NotifView(),
      binding: NotifBinding(),
    ),
    GetPage(
      name: '/detail',
      page: () => DetailView(),
      binding: DetailBinding(),
    ),
    GetPage(
      name: '/welcome',
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: '/verify-otp',
      page: () => VerifyOtpView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: '/deteksi',
      page: () => DeteksiView(),
      binding: DeteksiBinding(),
    ),
  ];
}

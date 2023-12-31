import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrade_traine_project/features/chat/screen/video_screen.dart';
import 'package:upgrade_traine_project/features/chat/screen/voice_screen.dart';
import 'package:upgrade_traine_project/features/notification/presentation/controller/notification_cubit.dart';
import 'package:upgrade_traine_project/features/profile/presentation/state_m/cubit/profile_cubit.dart';
import 'package:upgrade_traine_project/features/restaurant/presentation/state_m/cubit/new_cubit/new_restaurant_cubit.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'core/common/app_config.dart';
import 'core/common/provider_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/constants/app/app_constants.dart';
import 'core/datasources/shared_preference.dart';
import 'core/localization/flutter_localization.dart';
import 'core/navigation/navigation_service.dart';
import 'core/navigation/route_generator.dart';
import 'di/service_locator.dart';
import 'features/chat/screen/voice_call_screen.dart';
import 'features/coach/presentation/state_m/course_cubit/course_cubit.dart';
import 'features/home/presentation/state_m/bloc/story_cubit.dart';
import 'features/orders/controller/booking_cubit/booking_request_cubit.dart';
import 'features/orders/controller/order_cubit.dart';
import 'features/splash/presentation/screen/splash_screen.dart';
import 'generated/l10n.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';

class App extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const App({
    Key? key, required this.navigatorKey,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   if(message.data["MsgType"] == 1 || message.data["MsgType"] == 2){
//     showCallkitIncoming(const Uuid().v4(),phone: message.data["UserPhoneNumber"],name: message.data["UserName"],userId: message.data["SenderId"]);
//   }
//
// }

// Future<void> showCallkitIncoming(String uuid,
//     {required String phone, required String  name, required String userId}) async {
//   final params = CallKitParams(
//     id: uuid,
//     nameCaller: name,
//     appName: 'Callkit',
//     avatar: 'https://i.pravatar.cc/100',
//     handle: phone,
//     type: 0,
//     duration: 30000,
//     textAccept: 'Accept',
//     textDecline: 'Decline',
//     missedCallNotification: const NotificationParams(
//       showNotification: true,
//       isShowCallback: true,
//       subtitle: 'Missed call',
//       callbackText: 'Call back',
//     ),
//     extra: <String, dynamic>{'userId': userId},
//     headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
//
//     android: const AndroidParams(
//       isCustomNotification: true,
//       isShowLogo: false,
//       ringtonePath: 'system_ringtone_default',
//       backgroundColor: '#0955fa',
//       backgroundUrl: 'assets/test.png',
//       actionColor: '#4CAF50',
//     ),
//     ios: const IOSParams(
//       iconName: 'CallKitLogo',
//       handleType: '',
//       supportsVideo: true,
//       maximumCallGroups: 2,
//       maximumCallsPerCallGroup: 1,
//       audioSessionMode: 'default',
//       audioSessionActive: true,
//       audioSessionPreferredSampleRate: 44100.0,
//       audioSessionPreferredIOBufferDuration: 0.005,
//       supportsDTMF: true,
//       supportsHolding: true,
//       supportsGrouping: false,
//       supportsUngrouping: false,
//       ringtonePath: 'system_ringtone_default',
//     ),
//   );
//   await FlutterCallkitIncoming.showCallkitIncoming(params);
// }

class _AppState extends State<App> with WidgetsBindingObserver{
  // late final Uuid _uuid;
  // String? _currentUuid;
  //
  // late final FirebaseMessaging _firebaseMessaging;


  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: MultiProvider(
        providers: [
          ...ApplicationProvider().dependItems,
          Provider.value(value: routeObserver),
        ],
        child: Consumer<LocalizationProvider>(
          builder: (_, provider, __) {
            return ScreenUtilInit(
              designSize: AppConfig.screenUtilDesignSize(),
              builder: (context, Widget? child) {
                return MultiBlocProvider(
                 providers: [
                   BlocProvider(create: (context) => ProfileCubit()..getProfile()..getTrainers()),
                   BlocProvider(create: (context) => OrderCubit()),
                   BlocProvider(create: (context) => BookingRequestCubit()),
                   BlocProvider(create: (context) => NotificationCubit()),
                   BlocProvider(create: (context) => NewRestaurantCubit()),
                   BlocProvider(create: (context) => StoryCubit()),
                   BlocProvider(create: (context) => CourseCubit()),
                 ],
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: AppConstants.TITLE_APP_NAME,

                    /// Routing
                    navigatorKey: widget.navigatorKey,
                    // navigatorKey: getIt<NavigationService>().getNavigationKey,
                    onGenerateRoute: getIt<NavigationRoute>().generateRoute,
                    initialRoute: "/",

                    navigatorObservers: [routeObserver],

                    /// Setup app localization
                    supportedLocales: Translation.delegate.supportedLocales,
                    locale: provider.appLocal,

                    localizationsDelegates: const [
                      Translation.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,

                    ],

                    /// Run app at first time on device language
                    localeResolutionCallback: (locale, supportedLocales) {
                      if (provider.firstStart) {
                        provider.changeLanguage(
                            const Locale(AppConstants.LANG_AR), context);
                        provider.firstStartOff();

                        /// Check if the current device locale is supported
                      }
                    },

                    /// Theming
                    theme: AppConfig().themeData,
                    themeMode: AppConfig().themeMode,

                    /// Init screen
                    home: SplashScreen(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    ApplicationProvider().dispose(context);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

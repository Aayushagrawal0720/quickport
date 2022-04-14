import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localport_alter_delivery/pages/SplashScreen/loading_page.dart';
import 'package:localport_alter_delivery/pages/landing_page.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_all_partner_orders.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_authentication_services.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_current_orders_service.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_order_detail_service.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_order_status_update_service.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_vendor_user_detailbyid_service.dart';
import 'package:localport_alter_delivery/services/auth/code_resend_timer_service.dart';
import 'package:localport_alter_delivery/services/auth/signin_with_phonenumber.dart';
import 'package:localport_alter_delivery/services/location_locality_service.dart';
import 'package:localport_alter_delivery/services/notification/firebase_notification_services.dart';
import 'package:localport_alter_delivery/services/notification/local_notification_setup.dart';
import 'package:localport_alter_delivery/services/notification/notification_topic_subscription.dart';
import 'package:localport_alter_delivery/services/order_status_button_service.dart';
import 'package:localport_alter_delivery/services/profile_page_service.dart';
import 'package:localport_alter_delivery/widgets/Skeletons/locality_search_page_skeleton.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>SigninWithPhoneNumber()),
        ChangeNotifierProvider(create: (_)=>CodeResendTimerService()),
        ChangeNotifierProvider(create: (_)=>localportAuthenticationService()),
        ChangeNotifierProvider(create: (_)=>LocationLocalityService()),
        ChangeNotifierProvider(create: (_)=>LocalportCurrentOrdersService()),
        ChangeNotifierProvider(create: (_)=>LocalportAllPartnerOrder()),
        ChangeNotifierProvider(create: (_)=>LocalportVendorUserDetailById()),
        ChangeNotifierProvider(create: (_)=>LocalportOrderDetailsServce()),
        ChangeNotifierProvider(create: (_)=>OrderStatusButtonService()),
        ChangeNotifierProvider(create: (_)=>LocalportOrderStatusUpdateService()),
        ChangeNotifierProvider(create: (_)=>ProfilePageService()),
      ],
      child: MaterialApp(
        title: 'LP Delivery Partner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light
          )
        ),
        home: LoadingPage(),
      ),
    );
  }
}

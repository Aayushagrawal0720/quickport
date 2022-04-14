import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localport_alter_delivery/pages/CurrentOrder/current_order.dart';
import 'package:localport_alter_delivery/pages/OrderHistory/all_orders.dart';
import 'package:localport_alter_delivery/pages/Profile/profile_page.dart';
import 'package:localport_alter_delivery/resources/my_colors.dart';
import 'package:localport_alter_delivery/services/notification/firebase_notification_services.dart';
import 'package:localport_alter_delivery/services/notification/local_notification_setup.dart';
import 'package:localport_alter_delivery/services/notification/notification_topic_subscription.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Widget _appBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text(
                "Localport- Delivery Partner",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => const ProfilePage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: MyColors.color1.withAlpha(50),
                      shape: BoxShape.circle),
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      CupertinoIcons.person_solid,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 1,
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseNotificationService().setupInteractedMessage();
    LocalNotificationSetup().initializeLocalNotifications();
    NotificationTopicSubscription.subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _appBar(),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => CurrentOrder()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            offset: const Offset(1, 1),
                            blurRadius: 3)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Current order"),
                        Icon(Icons.chevron_right)
                      ],
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const AllOrders()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            offset: const Offset(1, 1),
                            blurRadius: 3)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Order history"),
                        Icon(Icons.chevron_right)
                      ],
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

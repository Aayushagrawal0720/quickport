import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_delivery/resources/my_colors.dart';
import 'package:localport_alter_delivery/resources/strings.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_current_orders_service.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_order_detail_service.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_order_status_update_service.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_vendor_user_detailbyid_service.dart';
import 'package:localport_alter_delivery/services/order_status_button_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatefulWidget {
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  fetchUserDetails() {
    Provider.of<LocalportVendorUserDetailById>(context, listen: false)
        .fetchDetails(
            Provider.of<LocalportOrderDetailsServce>(context, listen: false)
                .getOrder()
                .id)
        .then((value) {
      if (value == '') {
      } else {
        showFailMessage("can't fetch user details right now");
      }
    });
  }

  updateStatus() {
    String oid =
        Provider.of<LocalportOrderDetailsServce>(context, listen: false)
            .getOrder()
            .oid;
    String uid =
        Provider.of<LocalportVendorUserDetailById>(context, listen: false)
            .getUserData()['uid'];
    if (uid == null) {
      showFailMessage("Try Again");
      return;
    }
    String status =
        Provider.of<OrderStatusButtonService>(context, listen: false)
            .getStatus();

    Provider.of<LocalportOrderStatusUpdateService>(context, listen: false)
        .updateStatus(oid, status, uid)
        .then((value) {
      if (value == '') {
        Provider.of<LocalportCurrentOrdersService>(context, listen: false)
            .fetchOrders();
        Navigator.pop(context);
      } else {
        showFailMessage("Something went wrong");
      }
    });
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  listCard(String key, String value, {TextStyle style}) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "$key :",
                style: style ??
                    GoogleFonts.aBeeZee(
                        color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                value,
                maxLines: 3,
                style: style ??
                    GoogleFonts.aBeeZee(
                      color: Colors.black,
                    ),
              ),
            ),
            key == senderphone || key == receiverPhone
                ? GestureDetector(
                    onTap: () {
                      launch("tel:$value");
                    },
                    child: const CircleAvatar(child: Icon(Icons.call)))
                : Container()
          ],
        ));
  }

  Widget _appBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: const [
              CupertinoNavigationBarBackButton(
                color: MyColors.color1,
              ),
              Text(
                "Order Detail",
                style: TextStyle(color: Colors.black, fontSize: 20),
              )
            ],
          ),
          const Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<LocalportOrderDetailsServce>(
                  builder: (context, snapshot, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _appBar(),
                    Consumer<LocalportVendorUserDetailById>(
                      builder: (context, vsnapshot, child) {
                        return vsnapshot.isLoading()
                            ? Text(
                                "Loading user details...",
                                style: GoogleFonts.aBeeZee(color: Colors.red),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: Column(
                                  children: [
                                    vsnapshot.getUserData()['fname'] != null
                                        ? listCard(
                                            sendername,
                                            vsnapshot.getUserData()['fname'] +
                                                " " +
                                                vsnapshot
                                                    .getUserData()['lname'])
                                        : Container(),
                                    vsnapshot.getUserData()['mobile'] != null
                                        ? listCard(senderphone,
                                            vsnapshot.getUserData()['mobile'])
                                        : Container(),
                                    vsnapshot.getUserData()['vname'] != null
                                        ? listCard(vendorname,
                                            vsnapshot.getUserData()['vname'])
                                        : Container(),
                                  ],
                                ),
                              );
                      },
                    ),
                    listCard(receiverName, snapshot.getOrder().rName),
                    listCard(receiverPhone, snapshot.getOrder().rPhone),
                    listCard(parcelWeight, snapshot.getOrder().weight),
                    listCard(pickupLocation, snapshot.getOrder().pickutext),
                    listCard(dropLocation, snapshot.getOrder().dropText),
                    listCard(roundTrip, snapshot.getOrder().roundTrip.toString()),
                    listCard(delInstruction,
                        snapshot.getOrder().delInstruction ?? " del ins"),
                    const Divider(
                      thickness: 1,
                    ),
                    listCard("Status", snapshot.getOrder().status,
                        style: GoogleFonts.aBeeZee(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )),
                    listCard(distance, snapshot.getOrder().distance),
                    // listCard(deliveryCharge, snapshot.getOrder().dprice,
                    //     style: GoogleFonts.aBeeZee(
                    //       color: Colors.blue,
                    //       fontWeight: FontWeight.bold,
                    //     )),
                    snapshot.getOrder().payment != "null"
                        ? listCard(payment, "Done",
                            style: GoogleFonts.aBeeZee(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ))
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    snapshot.getOrder().status != "Delivered"
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                              onTap: () {
                                updateStatus();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade400,
                                          offset: const Offset(0, 0),
                                          blurRadius: 12)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  child: Center(child:
                                      Consumer<OrderStatusButtonService>(
                                          builder: (context, snapshot, child) {
                                    return Text(
                                      "Update status to : ${snapshot.getStatus()}",
                                      maxLines: 3,
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white),
                                    );
                                  })),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    snapshot.getOrder().status == "Delivered"
                        ? snapshot.getOrder().payment == "null"
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // updatePaymentStatus();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade400,
                                              offset: Offset(0, 0),
                                              blurRadius: 12)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      child: Center(
                                          child: Text(
                                        "Paid",
                                        maxLines: 3,
                                        style: GoogleFonts.aBeeZee(
                                            color: Colors.white),
                                      )),
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                        : Container(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

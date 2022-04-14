import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_delivery/DataClasses/order_history_object_class.dart';
import 'package:localport_alter_delivery/pages/CurrentOrder/order_detail_page.dart';
import 'package:localport_alter_delivery/resources/my_colors.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_order_detail_service.dart';
import 'package:localport_alter_delivery/services/order_status_button_service.dart';
import 'package:provider/provider.dart';

class OrderHistoryCard extends StatefulWidget {
  OrderHistoryObjectClass _historyObjectClass = OrderHistoryObjectClass();
  bool _detailed;

  OrderHistoryCard(this._historyObjectClass, this._detailed);

  @override
  _OrderHistoryCardState createState() =>
      _OrderHistoryCardState(_historyObjectClass);
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {
  OrderHistoryObjectClass _historyObjectClass = OrderHistoryObjectClass();

  _OrderHistoryCardState(this._historyObjectClass);

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  showVendorDialog(String status) {
    var dialog = Dialog(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              status == 'Pending' ? "Very soon..." : "On The Way...",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            Text(
              status == 'Pending'
                  ? "A delivery partner will be assigned soon"
                  : "A delivery partner will be at your location in no time",
              style: GoogleFonts.roboto(color: MyColors.fontgrey),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  decoration: const BoxDecoration(
                    color: MyColors.color1,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Text(
                        "Close",
                        style: GoogleFonts.roboto(color: Colors.white),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
    showCupertinoDialog(
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          if(widget._detailed || widget._historyObjectClass.status!='Delivered') {
            Provider.of<LocalportOrderDetailsServce>(context, listen: false)
                .setOrder(widget._historyObjectClass);
            var _osbs =
            Provider.of<OrderStatusButtonService>(context, listen: false);
            switch (widget._historyObjectClass.status) {
              case 'Pending':
                {
                  _osbs.setStatus('Way to pick up');
                  break;
                }
              case 'Way to pick up':
                {
                  _osbs.setStatus('On the way');
                  break;
                }
              case 'On the way':
                {
                  _osbs.setStatus('Delivered');
                  break;
                }
            }
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => OrderDetailPage()));
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                width: 0.05,
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 12,
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(
                      0,
                      0,
                    ))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.withAlpha(25),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget._historyObjectClass.rName,
                            maxLines: 3,
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            widget._historyObjectClass.dropText.split(",")[0],
                            maxLines: 5,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      Container(
                        color: Colors.grey.withAlpha(60),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget._historyObjectClass.status,
                            overflow: TextOverflow.visible,
                            maxLines: 3,
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pickup",
                          style: GoogleFonts.roboto(
                              color: MyColors.fontgrey, fontSize: 12),
                        ),
                        Text(
                          widget._historyObjectClass.pickutext.split(",")[0],
                          maxLines: 5,
                          textAlign: TextAlign.center,
                          style:
                              GoogleFonts.roboto(color: Colors.black, fontSize: 16),
                        ),
                        // widget._historyObjectClass.resamt==null? Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "Value",
                        //       style: GoogleFonts.roboto(
                        //           color: MyColors.fontgrey, fontSize: 12),
                        //     ),
                        //     Text(
                        //       widget._historyObjectClass.resamt,
                        //       style: GoogleFonts.roboto(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ],
                        // ):Container(),
                      ],
                    ),
                    Expanded(child: Container()),
                    widget._historyObjectClass.roundTrip
                        ? Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow:[
                            BoxShadow(
                                color: Colors.grey.withAlpha(35),
                                offset: Offset(0, 0),
                                blurRadius: 3
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Round trip",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                        : Container()
                  ],
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 12.0, right: 12.0, top: 5, bottom: 5),
                child: Divider(
                  height: 1,
                  color: MyColors.fontgrey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      widget._historyObjectClass.weight + " KG",
                      style: GoogleFonts.roboto(color: Colors.black),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget._historyObjectClass.distance + " KM",
                      style: GoogleFonts.roboto(color: Colors.black),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget._historyObjectClass.date.toString(),
                      style: GoogleFonts.roboto(
                        color: MyColors.fontgrey,
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

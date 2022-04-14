import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_delivery/DataClasses/order_history_object_class.dart';
import 'package:localport_alter_delivery/resources/lifecycle_event_handler.dart';
import 'package:localport_alter_delivery/resources/my_colors.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_current_orders_service.dart';
import 'package:localport_alter_delivery/widgets/order_history_card.dart';
import 'package:provider/provider.dart';

class CurrentOrder extends StatefulWidget {
  @override
  _CurrentOrderState createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  List<OrderHistoryObjectClass> _orders = [];

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
                "Current Order",
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

  fetchOrders() async {
    try {
      Provider.of<LocalportCurrentOrdersService>(context, listen: false)
          .fetchOrders();
    } catch (err) {
      print(err);
      showFailMessage("Please try again after sometime");
    }
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget orderList() {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      child: Consumer<LocalportCurrentOrdersService>(
          builder: (context, snapshot, child) {
        _orders = snapshot.getCurrentOrders();
        return snapshot.isLoading()
            ? const Center(
                child: CircularProgressIndicator(
                  color: MyColors.color1,
                ),
              )
            : _orders.isEmpty
                ? Center(
                    child: Text(
                  "No record found",
                  style: GoogleFonts.aBeeZee(),
                ))
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          return OrderHistoryCard(_orders[index], true);
                        }),
                  );
      }),
    );
  }

  Future<void> _refresh() async {
    print('refresh');
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [_appBar(), orderList()],
          ),
        ),
      )),
    );
  }
}

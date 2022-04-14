import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localport_alter_delivery/DataClasses/order_history_object_class.dart';
import 'package:localport_alter_delivery/resources/my_colors.dart';
import 'package:localport_alter_delivery/services/apiservice/localport_all_partner_orders.dart';
import 'package:localport_alter_delivery/widgets/order_history_card.dart';
import 'package:provider/provider.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({Key key}) : super(key: key);

  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  List<OrderHistoryObjectClass> _orders = [];

  fetchOrders() async {
    try {
      Provider.of<LocalportAllPartnerOrder>(context, listen: false)
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
    print(_orders.length);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Consumer<LocalportAllPartnerOrder>(
          builder: (context, snapshot, child) {
        _orders = snapshot.getAllOrders();
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
                          return OrderHistoryCard(_orders[index], false);
                        }),
                  );
      }),
    );
  }

  Widget historyType() {
    // return Consumer<OrderHistoryPageService>(
    //     builder: (context, snapshot, child) {
    //   return Container(
    //     child: Column(
    //       children: [
    //         orderList()
    //       ],
    //     ),
    //   );
    // });
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
                "Order history",
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
    fetchOrders();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _appBar(),
              Padding(padding: const EdgeInsets.all(8.0), child: orderList()),
            ],
          ),
        ),
      )),
    );
  }
}

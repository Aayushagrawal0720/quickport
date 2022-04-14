import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:localport_alter_delivery/DataClasses/delivery_charge_class.dart';
import 'package:localport_alter_delivery/DataClasses/order_history_object_class.dart';
import 'package:localport_alter_delivery/SharedPreferences/sharedpreferences_class.dart';
import 'package:localport_alter_delivery/resources/server_urls.dart';

class LocalportAllPartnerOrder with ChangeNotifier{
  bool _isLoading = true;
  bool _isError = false;
  String _message = '';
  List<OrderHistoryObjectClass> _orders = [];

  fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isLoading = true;
    _isError = false;
    _message = '';
    _orders.clear();
    notifyListeners();

    //-----------------
    String partnerid = await SharedPreferencesClass().getUid();
    Uri url = Uri.parse(partnerallorder);

    Map<String, String> header = {
      "Content-type": "application/json",
      "partnerid": partnerid
    };
    Response response = await get(url, headers: header);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      _message = responseData['message'];
      Map<String, dynamic> orderMap = {};
      if (status) {
        if (_message == 'no order found') {
        } else {
          var orderdata = responseData['data'];
          for (var d in orderdata) {
            orderMap[d['oid']] = {'oid': d['oid']};
          }
          for (var d in orderdata) {
            Map<String, dynamic> _temp =
            orderMap[d['oid']] as Map<String, dynamic>;
            _temp[d['key']] = d['value'];
          }
          for (var val in orderMap.values) {
            String rawdate = val['date'];
            DateTime datee = DateTime.parse(rawdate);
            datee = datee.toLocal();
            String date = DateFormat("dd-MM-yyy hh:mm").format(datee);

            List<DeliveryChargeClass> _deliveryCharges = [];
            if (val['price_distribution'] != null) {
              String h =
              val['price_distribution'].toString().replaceAll('{', '{"');
              h = h.replaceAll(':', '":');
              var priceDistributionObj = json.decode(h);
              for (var d in priceDistributionObj) {
                Map<String, int> _temp = Map<String, int>.from(d);
                _deliveryCharges.add(DeliveryChargeClass(
                    key: _temp.keys.first, value: _temp.values.first));
              }
            }
            _orders.add(
              OrderHistoryObjectClass(
                  weight: val['weight'],
                  // phone: ,
                  id: val['id'],
                  // uid: ,
                  status: val['status'],
                  // fname: ,
                  // lname: ,
                  date: date,
                  oid: val['oid'],
                  dprice: val['price'],
                  distance: val['distance'],
                  // delInstruction:
                  dropText: val['droploc'],
                  pickutext: val['pickuploc'],
                  // vendorName: ,
                  rName: val['dropname'],
                  rPhone: val['dropphone'],
                  payment: val['payment'].toString(),
                  delInstruction: val['delinstruction'],
                  roundTrip: val['round_trip'] == null
                      ? false
                      : val['round_trip'] == 'true',
                  priceDistribution: _deliveryCharges),
            );
          }
          _orders.sort((a,b)=>b.date.compareTo(a.date));
        }
        _isLoading = false;
        _isError = false;
      } else {
        _isLoading = false;
        _isError = true;
      }
    } else {
      _isLoading = false;
      _isError = true;
    }
    notifyListeners();
  }

  isLoading() => _isLoading;

  isError() => _isError;

  getAllOrders() => _orders;

  getMessage() => _message;
}
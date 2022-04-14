import 'package:flutter/cupertino.dart';
import 'package:localport_alter_delivery/DataClasses/order_history_object_class.dart';

class LocalportOrderDetailsServce with ChangeNotifier {
  OrderHistoryObjectClass _orderDetail;

  setOrder(OrderHistoryObjectClass order) {
    _orderDetail = order;
  }

  OrderHistoryObjectClass getOrder() => _orderDetail;
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

var firestore = FirebaseFirestore.instance;
var orderCollectionName = 'cafe-order';

class CafeInComplete extends StatefulWidget {
  const CafeInComplete({super.key});

  @override
  State<CafeInComplete> createState() => _CafeInCompleteState();
}

class _CafeInCompleteState extends State<CafeInComplete> {
  bool init = true;
  List<dynamic> orderDataList = [];

  Widget body = const Text('비어있음'); // Update the type to Widget

  Future<void> getOrders() async {
    var orders =
        firestore.collection(orderCollectionName).snapshots().listen((event) {
      setState(() {
        if (init) {
          orderDataList = event.docs.toList();
          init = false;
        } else {
          var orders = event.docChanges;
          orderDataList.insertAll(0, orders);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orderDataList.isEmpty
          ? const Text('empty')
          : ListView.separated(
              itemBuilder: (context, index) {
                var order = orderDataList[index];
                return ListTile(
                  leading: Text("${order['orderNumber']}"),
                  title: Text("${order['orderName']}"),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: orderDataList.length,
            ),
    );
  }
}

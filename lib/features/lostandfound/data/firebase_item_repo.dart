import 'package:cc/features/lostandfound/domain/entities/item.dart';
import 'package:cc/features/lostandfound/domain/repos/item_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseItemRepo implements ItemRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('item');
  @override
  Future<void> createItem(Item item) async {
    try {
      await itemsCollection.doc(item.id).set(item.toJson());
    } catch (e) {
      throw Exception("error in creating item: $e");
    }
  }

  @override
  Future<List<Item>> fetchAllItems() async {
    try {
      // ignore: non_constant_identifier_names
      final ItemSnapShot =
          await itemsCollection.orderBy('timestamp', descending: true).get();

      for (var doc in ItemSnapShot.docs) {
        debugPrint("Document ID: ${doc.id}");
        debugPrint("Document Data: ${doc.data()}");
      }
      final List<Item> allItem = ItemSnapShot.docs
          .map((doc) => Item.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allItem;
    } catch (e) {
      throw Exception("error in fetching items $e");
    }
  }

  @override
  Future<void> messageUser(String userId) {
    // TODO: implement messageUser
    throw UnimplementedError();
  }

  @override
  Future<void> claimItem(String itemId) async {
    try {
      await itemsCollection.doc(itemId).delete();
    } catch (e) {
      debugPrint("error in deleting :$e");
    }
  }
}

import 'package:cc/features/lostandfound/domain/entities/item.dart';

abstract class ItemRepo {
  Future<List<Item>> fetchAllItems();
  Future<void> createItem(Item item);
  Future<void> claimItem(String itemId);
  Future<void> messageUser(String userId);
}

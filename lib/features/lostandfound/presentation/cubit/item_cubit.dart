import 'package:cc/features/lostandfound/domain/entities/item.dart';
import 'package:cc/features/lostandfound/domain/repos/item_repo.dart';
import 'package:cc/features/lostandfound/presentation/cubit/item_state.dart';
import 'package:cc/features/storage/domain/storage_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemCubit extends Cubit<ItemStates> {
  final ItemRepo itemRepo;
  final StorageRepo storageRepo;

  ItemCubit({required this.itemRepo, required this.storageRepo})
      : super(ItemsInitial());

  Future<void> fetchAllItems() async {
    try {
      emit(ItemsLoading());
      debugPrint("Fetching all items...");

      final items = await itemRepo.fetchAllItems();

      debugPrint("Fetched posts: ${items.length}");
      emit(ItemsLoaded(items));
    } catch (e, stackTrace) {
      debugPrint("Error fetching items: $e\n$stackTrace");
      emit(ItemsError("Failed to fetch items: $e"));
    }
  }

  // Create a new item
  Future<void> createItem(Item item,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      if (imagePath != null) {
        emit(ItemsUploading());
        imageUrl = await storageRepo.uploadItemImageMobile(imagePath, item.id);
      } else if (imageBytes != null) {
        emit(ItemsUploading());
        imageUrl = await storageRepo.uploadItemImageWeb(imageBytes, item.id);
      }

      final newItem = item.copyWith(imageUrl: imageUrl);

      await itemRepo.createItem(newItem);
      emit(ItemsLoaded([newItem])); // Emit state with the newly created item
    } catch (e, stackTrace) {
      debugPrint("Error creating item: $e\n$stackTrace");
      emit(ItemsError("Failed to create item: $e"));
    }
  }

  // Claim an item
  Future<void> claimItem(String itemId) async {
    try {
      await itemRepo.claimItem(itemId);
    } catch (e) {
      emit(ItemsError("Failed to claim item: $e"));
    }
  }
}

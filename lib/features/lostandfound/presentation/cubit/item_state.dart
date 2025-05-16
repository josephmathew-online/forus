import 'package:cc/features/lostandfound/domain/entities/item.dart';

abstract class ItemStates {}

// Initial state
class ItemsInitial extends ItemStates {}

// Loading state
class ItemsLoading extends ItemStates {}

// Uploading state
class ItemsUploading extends ItemStates {}

// Error state
class ItemsError extends ItemStates {
  final String message;
  ItemsError(this.message);
}

// Loaded state
class ItemsLoaded extends ItemStates {
  final List<Item> items;
  ItemsLoaded(this.items);
}

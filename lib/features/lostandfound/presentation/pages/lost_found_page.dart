import 'package:cc/features/lostandfound/presentation/components/my_item_tile.dart';
import 'package:cc/features/lostandfound/presentation/cubit/item_cubit.dart';
import 'package:cc/features/lostandfound/presentation/cubit/item_state.dart';
import 'package:cc/features/lostandfound/presentation/pages/upload_lost_item-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LostAndFoundPage extends StatefulWidget {
  const LostAndFoundPage({super.key});

  @override
  State<LostAndFoundPage> createState() => _LostAndFoundPageState();
}

class _LostAndFoundPageState extends State<LostAndFoundPage> {
  late final ItemCubit itemCubit;
  @override
  void initState() {
    super.initState();
    itemCubit = context.read<ItemCubit>();
    fetchAllItems();
  }

  void fetchAllItems() {
    itemCubit.fetchAllItems();
  }

  void claimItem(String itemId) {
    itemCubit.claimItem(
      itemId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'lost and found',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UploadLostItemPage()));
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.add, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<ItemCubit, ItemStates>(builder: (context, state) {
          if (state is ItemsLoading || state is ItemsUploading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ItemsLoaded) {
            final allitems = state.items;
            if (allitems.isEmpty) {
              return const Center(
                child: Text('no items available'),
              );
            }
            return ListView.builder(
              itemCount: allitems.length,
              itemBuilder: (context, index) {
                final item = allitems[index];
                return MyItemTile(
                  item: item,
                  onClaimPressed: () => claimItem(item.id),
                );
              },
            );
          } else if (state is ItemsError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        }));
  }
}

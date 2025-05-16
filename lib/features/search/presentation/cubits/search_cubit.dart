import 'package:bloc/bloc.dart';
import 'package:cc/features/profile/domain/entities/profile_user.dart';
import 'package:cc/features/search/domain/search_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<List<ProfileUser>> {
  final SearchRepo searchRepo;

  SearchCubit({required this.searchRepo}) : super([]) {
    _loadAllUsers();
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      _loadAllUsers();
    } else {
      searchRepo.searchUsers(query).listen((users) {
        emit(users);
      });
    }
  }

  void _loadAllUsers() {
    searchRepo.getAllUsers().listen((users) {
      emit(users);
    });
  }
}

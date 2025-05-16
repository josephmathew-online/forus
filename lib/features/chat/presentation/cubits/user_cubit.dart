import 'package:cc/features/chat/data/firebase_user_repo.dart';
import 'package:cc/features/chat/domain/users.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<List<Users>> {
  final FirebaseUserRepo firebaseUserRepo;

  UserCubit(this.firebaseUserRepo) : super([]);

  void loadUsers() {
    firebaseUserRepo.getUsers().listen((users) {
      emit(users);
    });
  }
}

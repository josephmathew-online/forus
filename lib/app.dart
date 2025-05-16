import 'package:cc/features/auth/data/firebase_auth_repo.dart';
import 'package:cc/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:cc/features/auth/presentation/cubits/auth_states.dart';
import 'package:cc/features/auth/presentation/pages/auth_page.dart';
import 'package:cc/features/chat/data/firebase_user_repo.dart';
import 'package:cc/features/chat/presentation/cubits/oneline_status_cubit.dart';
import 'package:cc/features/chat/presentation/cubits/user_cubit.dart';
import 'package:cc/features/events/data/firebase_event_repo.dart';
import 'package:cc/features/events/presentation/cubit/event_cubit.dart';
import 'package:cc/features/home/presentation/home_page.dart';
import 'package:cc/features/lostandfound/data/firebase_item_repo.dart';
import 'package:cc/features/lostandfound/presentation/cubit/item_cubit.dart';
import 'package:cc/features/post/data/firebase_post_repo.dart';
import 'package:cc/features/post/presentation/cubits/post_cubit.dart';
import 'package:cc/features/profile/data/firebase_profile_repo.dart';
import 'package:cc/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:cc/features/search/data/firebase_search_repo.dart';
import 'package:cc/features/search/presentation/cubits/search_cubit.dart';
import 'package:cc/features/storage/data/firebase_storage_repo.dart';
import 'package:cc/themes/light_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //auth Cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
              profileRepo: firebaseProfileRepo,
              storageRepo: firebaseStorageRepo),
        ),
        //item cubit
        BlocProvider<ItemCubit>(
            create: (context) => ItemCubit(
                itemRepo: FirebaseItemRepo(),
                storageRepo: firebaseStorageRepo)),
        BlocProvider(create: (context) => OnlineStatusCubit()),
        //search cubit
        BlocProvider<SearchCubit>(
            create: (context) => SearchCubit(searchRepo: FirebaseSearchRepo())),
        //post cubit
        BlocProvider<PostCubit>(
            create: (context) => PostCubit(
                postRepo: firebasePostRepo, storageRepo: firebaseStorageRepo)),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit((FirebaseUserRepo())),
        ),
        BlocProvider<EventCubit>(
          create: (context) => EventCubit((FirebaseEventRepo())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, authState) {
            if (authState is Unauthenticated) {
              return AuthPage();
            }
            if (authState is Authenticated) {
              return HomePage();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthErrors) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}

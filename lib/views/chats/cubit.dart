import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/chat.dart';

part 'states.dart';

class ChatsCubit extends Cubit<ChatsStates> {
  ChatsCubit() : super(ChatsInit());

  static ChatsCubit of(context) => BlocProvider.of(context);

  List<Chat> chats = [];

  Future<void> init() async {
    _emit(ChatsLoading());
    await addCurrentUserToDatabase();
    await getChats();
    _emit(ChatsInit());
  }

  Future<void> addCurrentUserToDatabase() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': FirebaseAuth.instance.currentUser!.email,
    });
  }

  Future<void> getChats() async {
    final result = await FirebaseFirestore.instance.collection('users').get();
    for (var element in result.docs) {
      chats.add(Chat(
        id: element.id,
        email: element.data()['email'],
      ));
    }
  }

  void _emit(ChatsStates state) {
    if (!isClosed) {
      emit(state);
    }
  }

  String get uid => FirebaseAuth.instance.currentUser!.uid;
}
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/chat.dart';
import '../../core/models/message.dart';

part 'states.dart';

class MessagesCubit extends Cubit<MessagesStates> {
  MessagesCubit({required this.chat}) : super(MessagesInit());

  final Chat chat;

  static MessagesCubit of(context) => BlocProvider.of(context);
  StreamSubscription? _streamSubscription;

  final messageTXController = TextEditingController();

  List<Message> messages = [];

  Future<void> getMessages() async {
    _emit(MessagesLoading());
    _streamSubscription = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(chat.id)
        .orderBy('sent_at', descending: true)
        .snapshots()
        .listen(
      (event) {
        messages.clear();
        for (var i in event.docs) {
          messages.add(Message.fromJson(i.data()));
        }
        _emit(MessagesInit());
      },
    );
  }

  Future<void> sendMessage() async {
    final message = messageTXController.text;
    if (message.trim().isEmpty) return;
    messageTXController.clear();
    final messageJson = Message(
      message: message,
      senderUID: uid,
      sentAt: Timestamp.now(),
    ).toJson();
    await Future.wait([
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection(chat.id)
          .doc()
          .set(messageJson),
      FirebaseFirestore.instance
          .collection('users')
          .doc(chat.id)
          .collection(uid)
          .doc()
          .set(messageJson),
    ]);
    _emit(MessagesInit());
  }

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  void _emit(MessagesStates state) {
    if (!isClosed) {
      emit(state);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    messageTXController.dispose();
    return super.close();
  }
}

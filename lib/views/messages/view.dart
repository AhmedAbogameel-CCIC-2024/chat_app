import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/chat.dart';
import 'cubit.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesCubit(chat: chat)..getMessages(),
      child: Scaffold(
        appBar: AppBar(title: Text('Messages')),
        body: BlocBuilder<MessagesCubit, MessagesStates>(
          builder: (context, state) {
            final cubit = MessagesCubit.of(context);
            final messages = cubit.messages;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: messages.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderUID == FirebaseAuth.instance.currentUser!.uid;
                          return Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              UnconstrainedBox(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.75,
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Text(message.message),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: (isMe ? Colors.blue : Colors.grey)
                                        .withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cubit.messageTXController,
                            decoration: InputDecoration(
                              hintText: 'Message...',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: cubit.sendMessage,
                          icon: Icon(Icons.send),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

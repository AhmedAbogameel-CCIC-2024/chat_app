import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login/view.dart';
import '../messages/view.dart';
import 'cubit.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit()..init(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chats'),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginView(),
                  ),
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout_outlined),
            ),
          ],
        ),
        body: BlocBuilder<ChatsCubit, ChatsStates>(builder: (context, state) {
          final cubit = ChatsCubit.of(context);
          if (state is ChatsLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            itemCount: cubit.chats.length,
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index) {
              final chat = cubit.chats[index];
              return ListTile(
                leading: CircleAvatar(child: Text(chat.email.substring(0, 2))),
                title: Text(chat.email),
                subtitle: chat.id == FirebaseAuth.instance.currentUser!.uid
                    ? Text('Me')
                    : null,
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                contentPadding: EdgeInsets.zero,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagesView(chat: chat),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(),
          );
        }),
      ),
    );
  }
}

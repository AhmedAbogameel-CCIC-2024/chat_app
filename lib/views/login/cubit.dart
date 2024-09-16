import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/snack_bar.dart';
import '../chats/view.dart';

part 'states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit({required this.context}) : super(LoginInit());

  final BuildContext context;

  static LoginCubit of(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  Future<void> login() async {
    formKey.currentState!.save();
    if (!formKey.currentState!.validate()) return;
    _emit(LoginLoading());
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      if (result.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ChatsView()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'Something went wrong');
    } catch (e) {
      print(e);
    }
    _emit(LoginInit());
  }

  void _emit(LoginStates state) {
    if (!isClosed) {
      emit(state);
    }
  }
}

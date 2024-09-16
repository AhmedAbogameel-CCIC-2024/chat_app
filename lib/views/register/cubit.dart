import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/snack_bar.dart';
import '../chats/view.dart';

part 'states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit({required this.context}) : super(RegisterInit());

  final BuildContext context;
  static RegisterCubit of(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  Future<void> login() async {
    formKey.currentState!.save();
    if (!formKey.currentState!.validate()) return;
    _emit(RegisterLoading());
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    _emit(RegisterInit());
  }

  void _emit(RegisterStates state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
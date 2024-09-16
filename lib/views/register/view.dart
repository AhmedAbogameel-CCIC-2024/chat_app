import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(context: context),
      child: Scaffold(
        appBar: AppBar(title: Text("Register")),
        body: BlocBuilder<RegisterCubit, RegisterStates>(
          builder: (context, state) {
            final cubit = RegisterCubit.of(context);
            return Form(
              key: cubit.formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Icon(
                    Icons.login,
                    size: 90,
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    onSaved: (newValue) => cubit.email = newValue,
                    validator: (value) => value?.isEmpty ?? true ? 'Email cannot be empty' : null,
                    decoration: InputDecoration(
                      label: Text('Email'),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    onSaved: (newValue) => cubit.password = newValue,
                    validator: (value) => value?.isEmpty ?? true ? 'Password cannot be empty' : null,
                    decoration: InputDecoration(
                      label: Text('Password'),
                    ),
                  ),
                  SizedBox(height: 40),
                  Builder(
                    builder: (context) {
                      if (state is RegisterLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: cubit.login,
                        child: Text('Register'),
                      );
                    }
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

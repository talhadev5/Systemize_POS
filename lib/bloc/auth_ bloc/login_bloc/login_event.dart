import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:systemize_pos/data/models/users/user_model.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
  
}
class LoginApi extends LoginEvent {
  const LoginApi({
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

    @override
    List<Object> get props => [emailController, passwordController];
}

class LoadInitialData extends LoginEvent {}
class UpdateUserData extends LoginEvent {
  final UserModel updatedUserModel;

  const UpdateUserData(this.updatedUserModel);

  @override
  List<Object> get props => [updatedUserModel];
}
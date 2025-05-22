import 'package:equatable/equatable.dart';
import 'package:systemize_pos/data/models/users/user_model.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState extends Equatable {
  const LoginState({
    this.message,
    this.loginStatus = LoginStatus.initial,
    this.userModel,
  });

  final String? message;
  final LoginStatus loginStatus;
  final UserModel? userModel;

  LoginState copyWith({
    String? message,
    LoginStatus? loginStatus,
    UserModel? userModel, // again, replace with your real model class
  }) {
    return LoginState(
      message: message ?? this.message,
      loginStatus: loginStatus ?? this.loginStatus,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<Object?> get props => [message, loginStatus, userModel];
}

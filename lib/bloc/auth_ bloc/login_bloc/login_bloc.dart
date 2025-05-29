import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_event.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_state.dart';
import 'package:systemize_pos/data/models/users/user_model.dart';
import 'package:systemize_pos/data/services/api_service.dart';
import 'package:systemize_pos/data/services/storage/local_storage.dart';
import 'package:systemize_pos/utils/app_url.dart';
import 'package:systemize_pos/utils/constant.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<LoginApi>(loginApi);
    on<LoadInitialData>(loadInitialData);
    on<UpdateUserData>(updateUserData);
    on<LogoutEvent>(_logout);
  }
  // This is the constructor for the LoginBloc class, which initializes the state and sets up event handlers.
  void loadInitialData(LoadInitialData event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      final savedUserData = await LocalStorage.getData(key: 'user');
      if (savedUserData != null) {
        UserModel userModel = UserModel.fromJson(jsonDecode(savedUserData));
        emit(
          state.copyWith(
            loginStatus: LoginStatus.success,
            message: 'Loaded from storage',
            userModel: userModel,
          ),
        );
      } else {
        emit(
          state.copyWith(
            loginStatus: LoginStatus.initial,
            message: 'No user data found',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.error,
          message: 'Failed to load initial data: $e',
        ),
      );
    }
  }

  // This method handles the login API call
  void loginApi(LoginApi event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    await ApiService.postMethod(
      apiUrl: loginUser,
      postData: {
        'email': event.emailController.text,
        'password': event.passwordController.text,
      },
      executionMethod: (bool success, dynamic responseData) async {
        if (success) {
          UserModel userModel = UserModel.fromJson(responseData);

          emit(
            state.copyWith(
              loginStatus: LoginStatus.success,
              message: 'Login successful',
              userModel: userModel, // Store the parsed UserModel
            ),
          );
          await LocalStorage.saveData(
            key: "user",
            value: jsonEncode(userModel.toJson()),
          );
          await LocalStorage.saveData(
            key: AppKeys.authToken,
            value: responseData['access_token'],
          );
          log('Bearer ${await LocalStorage.getData(key: AppKeys.authToken)}');
          log('${userModel.userDetails?.name}');
        } else {
          emit(
            state.copyWith(
              loginStatus: LoginStatus.error,
              message: responseData['message'] ?? 'Login failed',
            ),
          );
        }
      },
    );
  }

  // This method updates the user data in the state
  void updateUserData(UpdateUserData event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        loginStatus: LoginStatus.success,
        userModel: event.updatedUserModel,
        message: 'User data updated',
      ),
    );
  }

  // logout method.........
  void _logout(LogoutEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    // Call logout API
    await ApiService.postMethod(
      apiUrl: logout, // <- your logout API URL
      authHeader: true,

      postData: {}, // if your logout API doesn't need data, leave it empty
      executionMethod: (bool success, dynamic responseData) async {
        if (success) {
          // Clear local storage after successful logout

          // Navigator.pushReplacementNamed(context, RoutesName.login);
          emit(
            state.copyWith(
              loginStatus: LoginStatus.loggedOut,
              userModel: null,
              message: 'Logged out successfully',
            ),
          );
        } else {
          emit(
            state.copyWith(
              loginStatus: LoginStatus.error,
              message: responseData['message'] ?? 'Logout failed',
            ),
          );
        }
        await LocalStorage.removeAll();
      },
    );
  }
}

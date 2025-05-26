import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<LoadUserProfile>(_onLoad);
    on<RefreshUserProfile>(_onRefresh);
  }

  Future<void> _onLoad(LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(loading: true));
    await Future.delayed(Duration(seconds: 1)); // simulate loading
    // replace with actual API/service calls
    emit(state.copyWith(
      loading: false,
      userName: 'John Doe',
      userEmail: 'john@example.com',
      userImage: '/profile.jpg',
      userRole: 'User',
    ));
  }

  Future<void> _onRefresh(RefreshUserProfile event, Emitter<ProfileState> emit) async {
    await _onLoad(LoadUserProfile(), emit);
  }
}

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

class LoadUserProfile extends ProfileEvent {}

class RefreshUserProfile extends ProfileEvent {}

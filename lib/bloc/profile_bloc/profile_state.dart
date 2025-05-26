class ProfileState {
  final bool loading;
  final String userName;
  final String userEmail;
  final String userImage;
  final String userRole;

  ProfileState({
    this.loading = true,
    this.userName = '',
    this.userEmail = '',
    this.userImage = '',
    this.userRole = '',
  });

  get loginStatus => null;

  ProfileState copyWith({
    bool? loading,
    String? userName,
    String? userEmail,
    String? userImage,
    String? userRole,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userImage: userImage ?? this.userImage,
      userRole: userRole ?? this.userRole,
    );
  }
}

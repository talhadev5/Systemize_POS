import 'package:equatable/equatable.dart';

class BottomNavState extends Equatable {
  final int selectedIndex;
  final String title;

  const BottomNavState({
    required this.selectedIndex,
    required this.title,
  });

  BottomNavState copyWith({
    int? selectedIndex,
    String? title,
  }) {
    return BottomNavState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      title: title ?? this.title,
    );
  }

  
  @override
   List<Object?> get props => [selectedIndex , title];
}


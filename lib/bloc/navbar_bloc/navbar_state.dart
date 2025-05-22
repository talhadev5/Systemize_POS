import 'package:equatable/equatable.dart';

class BottomNavState extends Equatable {
 const  BottomNavState({required this.selectedIndex});
  final int selectedIndex;
  @override
  List<Object?> get props => [selectedIndex];
}

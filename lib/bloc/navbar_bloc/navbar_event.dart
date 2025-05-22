import 'package:equatable/equatable.dart';

abstract class BottomNavEvent extends Equatable {
  const BottomNavEvent();

  @override
  List<Object> get props => [];
}

class BottomNavTabChanged extends BottomNavEvent {
  final int index;
  const BottomNavTabChanged(this.index);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/navbar_bloc/navbar_event.dart';
import 'package:systemize_pos/bloc/navbar_bloc/navbar_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc()
    : super(const BottomNavState(selectedIndex: 0, title: 'Products')) {
    on<BottomNavTabChanged>(_onTabChanged);
  }

  void _onTabChanged(BottomNavTabChanged event, Emitter<BottomNavState> emit) {
    emit(
      state.copyWith(
        selectedIndex: event.index,
        title: _getTitleForIndex(event.index),
      ),
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Products';
      case 1:
        return 'Profile';
      // case 2:
      //   return 'Profile';  
      default:
        return 'POS';
    }
  }
}

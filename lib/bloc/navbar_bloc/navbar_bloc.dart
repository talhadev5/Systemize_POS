import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/navbar_bloc/navbar_event.dart';
import 'package:systemize_pos/bloc/navbar_bloc/navbar_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavState(selectedIndex: 0)) {
    on<BottomNavTabChanged>((event, emit) {
      emit(BottomNavState(selectedIndex: event.index));
    });
  }
}

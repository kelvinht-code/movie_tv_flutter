import 'package:bloc/bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(currentTab: 0)) {
    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(currentTab: event.newIndex));
    });
  }
}

part of 'home_bloc.dart';

class HomeState {
  final int currentTab;

  HomeState({required this.currentTab});

  HomeState copyWith({int? currentTab}) {
    return HomeState(currentTab: currentTab ?? this.currentTab);
  }
}

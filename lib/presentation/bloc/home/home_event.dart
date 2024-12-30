part of 'home_bloc.dart';

abstract class HomeEvent {}

class ChangeTabEvent extends HomeEvent {
  final int newIndex;

  ChangeTabEvent(this.newIndex);
}

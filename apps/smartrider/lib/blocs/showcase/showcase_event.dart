part of 'showcase_bloc.dart';

abstract class ShowcaseEvent extends Equatable {
  const ShowcaseEvent();
}

class ShowcaseInitEvent extends ShowcaseEvent {
  const ShowcaseInitEvent();

  @override
  List<Object> get props => [];
}

part of 'showcase_bloc.dart';

abstract class ShowcaseState extends Equatable {
  const ShowcaseState();
}

class ShowcaseLoadingState extends ShowcaseState {
  const ShowcaseLoadingState();

  @override
  List<Object> get props => [];
}

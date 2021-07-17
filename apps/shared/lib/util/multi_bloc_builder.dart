// https://github.com/Usorsoft/flutter_multi_bloc_builder

library flutter_multi_bloc_builder;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class MultiBlocBuilder extends StatefulWidget {
  final Widget Function(BuildContext, BlocStates) _builder;
  final List<Bloc> _blocs;

  /// [MultiBlocBuilder] handles building a widget by observig state of variouse [Bloc]s
  /// and should be used in combination with the [flutter_bloc](https://pub.dev/packages/flutter_bloc) package.
  /// Specify the bloc to observed via the [blocs] parameter.
  /// The [builder] rebuilds each time a state change occurs and provides a context ([BuildContext]) and the states ([BlocStates]).
  ///
  /// How to use:
  /// ```
  /// final bloc1 = BlocProvider.of<MyBloc1>(context);
  /// final bloc2 = BlocProvider.of<MyBloc2>(context);
  /// final bloc3 = BlocProvider.of<MyBloc2>(context);
  ///
  /// MultiBlocBuilder(
  ///   blocs: [bloc1, bloc2, bloc3],
  ///   builder: (context, states) {
  ///     final state1 = states.get<MyBloc1State>();
  ///     final state2 = states.get<MyBloc2State>();
  ///     final state3 = states.get<MyBloc3State>();
  ///
  ///     if (state1 is Loading || state2 is Loading || state3 is Loading) {
  ///       return Text('Loading');
  ///     } else {
  ///       return Text('SHow some content');
  ///     }
  ///   }
  /// );
  /// ```
  MultiBlocBuilder(
      {required List<Bloc> blocs,
      required Widget Function(BuildContext, BlocStates) builder})
      : _blocs = blocs,
        _builder = builder;

  @override
  State<StatefulWidget> createState() => _MultiBlocState();
}

/// Serves as the state of the [MultiBlocBuilder].
class _MultiBlocState extends State<MultiBlocBuilder> {
  final _stateSubscriptions = <StreamSubscription>[];

  @override
  void initState() {
    super.initState();

    widget._blocs.forEach((bloc) {
      final subscription =
          bloc.stream.listen((dynamic state) => setState(() {}));
      _stateSubscriptions.add(subscription);
    });
  }

  @override
  Widget build(BuildContext context) {
    final states =
        widget._blocs.map<dynamic>((dynamic bloc) => bloc.state).toList();
    return widget._builder(context, BlocStates._private(states));
  }

  @override
  void dispose() {
    super.dispose();
    _stateSubscriptions.forEach((subscription) {
      subscription.cancel();
    });
  }
}

/// [BlocStates] serves as a container of [dynamic] objects (usually bloc states).
/// It is part of the [MultiBlocProvider] package and therefore mainly used
/// to provide a varety of bloc states via the [MultiBlocBuilder._builder] function.
///
/// A bloc states can be retrieved via the [get] method and the wanted type like this:
/// ```
/// final exampeState = blocStates.get<ExampleState>();
/// ```
///
class BlocStates {
  final List _stateContainer = <List>[];

  // Private contructor
  BlocStates._private(List states) {
    _stateContainer.addAll(states);
  }

  /// Retrieves the first object that matches the generic or null if no machting object available.
  /// __NOTE:__ Please ensure that [BlocStates] doesn't contain multiple objects of the same type.
  ///
  /// How to use:
  /// ```
  /// final exampeState = blocStates.get<ExampleState>();
  /// ```
  T get<T>() =>
      _stateContainer.firstWhere((dynamic entry) => (entry is T), orElse: null);
}

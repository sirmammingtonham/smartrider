import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// model imports
import 'package:smartrider/data/models/bus/bus_advisory.dart';
import 'package:smartrider/data/models/bus/bus_gtfs.dart';
import 'package:smartrider/data/models/bus/bus_updates.dart';
import 'package:smartrider/data/models/bus/bus_vehicles.dart';

// repository imports
import 'package:smartrider/data/repository/bus_repository.dart';

part 'bus_event.dart';
part 'bus_state.dart';

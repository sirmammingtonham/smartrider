## Checklists of tests that need to be written

### Widget tests (`lib/widgets`)
- [ ] `bus_schedules/bus_table.dart`
- [ ] `bus_schedules/bus_timeline.dart`
- [ ] `bus_schedules/bus_unavailable.dart`
- [ ] `custom_widgets/custom_expansion_tile.dart`
- [ ] `custom_widgets/custom_sticky_table.dart`
- [ ] `custom_widgets/custom_tooltip.dart`
- [ ] `destination_autocomplete.dart`
- [ ] `filter_dialog.dart`
- [ ] `icons.dart`
- [ ] `map_widget.dart`
- [ ] `saferide_status_widget.dart`
- [ ] `search_bar.dart`
- [ ] `shuttle_schedules/shuttle_table.dart`
- [ ] `shuttle_schedules/shuttle_timeline.dart`
- [ ] `shuttle_schedules/shuttle_unavailable.dart`

### Page tests (`lib/pages`)
- [ ] `../main.dart`
- [ ] `home.dart`
- [ ] `issue_request.dart`
- [ ] `onboarding.dart`
- [ ] `profile.dart`
- [ ] `settings.dart`
- [ ] `sliding_panel_page.dart`
- [ ] `welcome.dart`

### Model tests (`lib/dapackage:shared/models`)
- [ ] `backend/user.dart`
- [ ] `bus/bus_calendar.dart`
- [ ] `bus/bus_route.dart`
- [ ] `bus/bus_shape.dart`
- [ ] `bus/bus_stop.dart`
- [ ] `bus/bus_timetable.dart`
- [ ] `bus/bus_trip.dart`
- [ ] `bus/bus_trip_update.dart`
- [ ] `bus/bus_vehicle_update.dart`
- [ ] `bus/pb/gtfs-realtime.pb.dart`
- [ ] `bus/pb/gtfs-realtime.pbenum.dart`
- [ ] `bus/pb/gtfs-realtime.pbjson.dart`
- [ ] `bus/pb/gtfs-realtime.pbserver.dart`
- [ ] `bus/pb/gtfs-realtime.proto`
- [ ] `bus/unused/bus_agency.dart`
- [ ] `bus/unused/bus_calendar_dates.dart`
- [ ] `bus/unused/bus_fare_attributes.dart`
- [ ] `bus/unused/bus_fare_rules.dart`
- [ ] `bus/unused/bus_feed_info.dart`
- [ ] `bus/unused/bus_stop_time.dart`
- [ ] `saferide/driver.dart`
- [ ] `saferide/estimate.dart`
- [ ] `saferide/location_data.dart`
- [ ] `saferide/order.dart`
- [ ] `shuttle/shuttle_eta.dart`
- [ ] `shuttle/shuttle_route.dart`
- [ ] `shuttle/shuttle_stop.dart`
- [ ] `shuttle/shuttle_update.dart`
- [ ] `shuttle/shuttle_vehicle.dart`
- [ ] `themes.dart`
- [ ] `themes_wip.dart`
- [ ] `time/time.dart`

### Provider tests (`lib/data/providers`)
- [ ] `authentication_provider.dart`
- [ ] `bus_provider.dart`
- [ ] `database.dart`
- [ ] `saferide_provider.dart`
- [ ] `shuttle_provider.dart`
  
### Repository tests (`lib/data/repositories`)
- [ ] `authentication_repository.dart`
- [x] `bus_repository.dart`
- [ ] `saferide_repository.dart`
- [x] `shuttle_repository.dart`
  
### BLoC tests (`lib/blocs`)
- [ ] `authentication/authentication_bloc.dart`
- [ ] `authentication/authentication_event.dart`
- [ ] `authentication/authentication_state.dart`
- [ ] `map/map_bloc.dart`
- [ ] `map/map_event.dart`
- [ ] `map/map_state.dart`
- [ ] `preferences/prefs_bloc.dart`
- [ ] `preferences/prefs_event.dart`
- [ ] `preferences/prefs_state.dart`
- [ ] `saferide/saferide_bloc.dart`
- [ ] `saferide/saferide_event.dart`
- [ ] `saferide/saferide_state.dart`
- [ ] `schedule/schedule_bloc.dart`
- [ ] `schedule/schedule_event.dart`
- [ ] `schedule/schedule_state.dart`
- [ ] `showcase/showcase_bloc.dart`
- [ ] `showcase/showcase_event.dart`
- [ ] `showcase/showcase_state.dart`

### Utility tests (`lib/util`)
- [ ] `bitmap_helpers.dart`
- [ ] `data.dart`
- [ ] `messages.dart`
- [ ] `multi_bloc_builder.dart`
- [ ] `strings.dart`

### Cloud Function tests (will go in functions folder)
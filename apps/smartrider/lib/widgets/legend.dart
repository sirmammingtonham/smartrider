import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared/models/bus/bus_shape.dart';
import 'package:shared/util/messages.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/pages/home.dart';

class Legend extends StatefulWidget {
  const Legend({Key? key}) : super(key: key);

  @override
  _LegendState createState() => _LegendState();
}

class _LegendState extends State<Legend> with TickerProviderStateMixin {
  bool _isExpanded = false;
  static const double fabSize = 56;

  @override
  void initState() {
    super.initState();
  }

  Widget _legendRouteTile({required String title, required Color color}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Icon(
                Icons.trip_origin,
                color: color,
              ),
              SizedBox(
                width: 15.sp,
              ),
              Text(title)
            ],
          ),
        ),
      );

  Widget _legendMarkerTile(
          {required String title,
          required String asset,
          double? size,
          Color? color}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                height: size,
                width: size,
                child: Center(
                  child: SvgPicture.asset(
                    asset,
                    color: color,
                  ),
                ),
              ),
              SizedBox(
                width: 15.sp,
              ),
              Text(title)
            ],
          ),
        ),
      );

  Widget _legendCard(List<Widget> children) => Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: children,
            ),
          ),
        ),
      ));

  Widget button(BuildContext context) => Showcase(
      key: showcaseLegend,
      description: legendButtonShowcaseMessage,
      shapeBorder: const CircleBorder(),
      child: FloatingActionButton(
        // backgroundColor: Theme.of(context).brightness == Brightness.light
        //     ? Colors.white
        //     : Colors.white70,
        onPressed: () {
          setState(() {
            _isExpanded = true;
          });
        },
        heroTag: 'legendViewButton',
        child: const Icon(
          Icons.help_outline,
          // color: Theme.of(context).brightness == Brightness.light
          //     ? Colors.black87
          //     : Theme.of(context).accentColor,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      final iconSize = Theme.of(context).iconTheme.size;
      final Widget legend;
      final double height;
      final double width;
      if (state is MapLoadedState) {
        switch (state.mapView) {
          case MapView.kBusView:
            {
              legend = _legendCard([
                _legendMarkerTile(
                    title: 'Bus Stop',
                    asset: 'assets/map_icons/marker_stop_bus.svg',
                    size: iconSize),
                _legendMarkerTile(
                    title: 'Realtime Bus',
                    asset: 'assets/map_icons/marker_vehicle.svg',
                    size: iconSize),
                _legendRouteTile(title: 'Route 87', color: busColors['87']!),
                _legendRouteTile(title: 'Route 286', color: busColors['286']!),
                _legendRouteTile(title: 'Route 289', color: busColors['289']!),
                _legendRouteTile(
                    title: 'CDTA Express', color: busColors['288']!),
              ]);
              height = 23.h;
              width = 40.w;
            }
            break;
          case MapView.kShuttleView:
            {
              final routeTiles = <Widget>[];
              final shuttleRoutes =
                  BlocProvider.of<MapBloc>(context).shuttleRoutes;
              for (final entry in shuttleRoutes.entries) {
                if (entry.value.active) {
                  routeTiles.add(_legendRouteTile(
                      title: entry.key,
                      color: shuttleRoutes[entry.key]!.color));
                }
              }
              legend = _legendCard([
                _legendMarkerTile(
                    title: 'Shuttle Stop',
                    asset: 'assets/map_icons/marker_stop_shuttle.svg',
                    size: iconSize),
                _legendMarkerTile(
                    title: 'Realtime Shuttle',
                    asset: 'assets/map_icons/marker_vehicle.svg',
                    size: iconSize),
                ...routeTiles
              ]);
              // add 3% screen height for each additional tile
              height = (11 + 3 * routeTiles.length).h;
              width = 45.w;
            }
            break;
          case MapView.kSaferideView:
            {
              legend = _legendCard([
                _legendMarkerTile(
                    title: 'Safe Ride',
                    asset: 'assets/map_icons/marker_saferide.svg',
                    size: iconSize),
                _legendMarkerTile(
                  title: 'Your Safe Ride',
                  asset: 'assets/map_icons/marker_saferide_alt.svg',
                  size: iconSize,
                ),
                _legendMarkerTile(
                    title: 'Pickup Location',
                    asset: 'assets/map_icons/marker_pickup.svg',
                    size: iconSize),
                _legendMarkerTile(
                    title: 'Dropoff Location',
                    asset: 'assets/map_icons/marker_dropoff.svg',
                    size: iconSize)
              ]);
              height = 17.h;
              width = 45.w;
            }
            break;
        }
      } else {
        legend = button(context);
        height = fabSize;
        width = fabSize;
      }

      return AnimatedContainer(
          curve: Curves.easeOutCubic,
          height: _isExpanded ? height : fabSize,
          width: _isExpanded ? width : fabSize,
          duration: const Duration(milliseconds: 333),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(_isExpanded ? 20 : 100),
            ),
          ),
          child: _isExpanded ? legend : button(context));
    });
  }
}

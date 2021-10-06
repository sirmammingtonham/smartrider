// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:sizer/sizer.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';

// bloc stuff
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';

// loading custom widgets and data
import 'package:smartrider/ui/widgets/saferide_status_widgets.dart'
    as saferide_widgets;

class PanelHeader extends StatelessWidget {
  const PanelHeader({Key? key, required this.panelController})
      : super(key: key);

  final PanelController panelController;

  Widget panelAppBar(BuildContext context) {
    void animatePanel() {
      final pc = BlocProvider.of<ScheduleBloc>(context).panelController;
      pc.animatePanelToPosition(pc.isPanelClosed ? 1 : 0);
    }

    final icon = InkWell(
      onTap: animatePanel,
      child: const Icon(
        Icons.expand_more,
        color: Colors.white,
        size: 30,
      ),
    );

    const title = Center(
      child: Text(
        'Schedules',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
    return Stack(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          height: saferide_widgets.saferideDefaultHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              icon,
              title,
              icon,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: InkWell(
            onTap: animatePanel,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 61,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saferideDriverCancelPopup(
      BuildContext context, SaferideCancelledState saferideState) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Driver Cancelled Your Ride!'),
        content: Text('REASON: ${saferideState.reason}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
// TODO: prompt to send email to student life or something
              BlocProvider.of<SaferideBloc>(context).add(SaferideNoEvent());
              Navigator.pop(context, 'Report');
            },
            child: const Text('Report Driver'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<SaferideBloc>(context).add(SaferideNoEvent());
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<SaferideBloc>(context),
      builder: (context, saferideState) {
        late final Widget appBarWidget;
        switch (saferideState.runtimeType) {
          case SaferideNoState:
          case SaferideDroppingOffState:
            appBarWidget = panelAppBar(context);
            break;
          case SaferideSelectingState:
            appBarWidget = saferide_widgets.saferideSelectionWidget(
                context, saferideState as SaferideSelectingState);

            break;
          case SaferideWaitingState:
            appBarWidget = saferide_widgets.saferideWaitingWidget(
                context, saferideState as SaferideWaitingState);
            break;
          case SaferidePickingUpState:
            appBarWidget = saferide_widgets.saferidePickingUpWidget(
                context, saferideState as SaferidePickingUpState);
            break;
          case SaferideCancelledState:
            _saferideDriverCancelPopup(
                context, saferideState as SaferideCancelledState);
            appBarWidget = Container();
            break;
          default:
            appBarWidget = Container();
            break;
        }
        return GestureDetector(
          onVerticalDragUpdate: (det) {
            if (det.primaryDelta! > 0.0) {
              panelController.close();
            }
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
              child: appBarWidget,
            ),
          ),
        );
      },
    );
  }
}

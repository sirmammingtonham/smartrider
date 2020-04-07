/// Below from https://github.com/fluttercommunity/flutter_google_places
/// Modified to better fit the ui of smartrider

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

class PlacesAutocompleteWidget extends StatefulWidget {
  final String apiKey;
  final String startText;
  final String hint;
  final BorderRadius overlayBorderRadius;
  final Location location;
  final num offset;
  final num radius;
  final String language;
  final String sessionToken;
  final List<String> types;
  final List<Component> components;
  final bool strictbounds;
  final String region;
  final Widget logo;
  final ValueChanged<PlacesAutocompleteResponse> onError;
  final int debounce;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  final String proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final BaseClient httpClient;

  PlacesAutocompleteWidget(
      {@required this.apiKey,
      this.hint = "Search",
      this.overlayBorderRadius,
      this.offset,
      this.location,
      this.radius,
      this.language,
      this.sessionToken,
      this.types,
      this.components,
      this.strictbounds,
      this.region,
      this.logo,
      this.onError,
      Key key,
      this.proxyBaseUrl,
      this.httpClient,
      this.startText,
      this.debounce = 300})
      : super(key: key);

  @override
  State<PlacesAutocompleteWidget> createState() => _PlacesAutocompleteState();

  static PlacesAutocompleteState of(BuildContext context) =>
      context.findAncestorStateOfType<PlacesAutocompleteState>();
}

class _PlacesAutocompleteState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final header = 
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 64,
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    color: theme.brightness == Brightness.light
                        ? Colors.black45
                        : null,
                    icon: _iconBack,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Padding(
                      child: _textField(context),
                      padding: const EdgeInsets.only(right: 8.0),
                    )
                  ),
                ],
              ),
        Divider(
          //height: 1.0,
        )
      ])));

    Widget body;

    final bodyBottomLeftBorderRadius = Radius.circular(10);

    final bodyBottomRightBorderRadius = Radius.circular(10);

    if (_searching) {
      body = Stack(
        children: <Widget>[_Loader()],
        alignment: FractionalOffset.bottomCenter,
      );
    } else if (_queryTextController.text.isEmpty ||
        _response == null ||
        _response.predictions.isEmpty) {
      body = Container(
        height: 30,
        width: 7777777,
        child: Material(
          borderRadius: BorderRadius.only(
            bottomLeft: bodyBottomLeftBorderRadius,
            bottomRight: bodyBottomRightBorderRadius,
          ),
          child: 
          Center( 
            child: Text("Note: Safe Ride won't go past 1 mile of campus",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      body = SingleChildScrollView(
        child: Material(
          borderRadius: BorderRadius.only(
            bottomLeft: bodyBottomLeftBorderRadius,
            bottomRight: bodyBottomRightBorderRadius,
          ),
          color: theme.dialogBackgroundColor,
          child: ListBody(
            children: _response.predictions
                .map(
                  (p) => PredictionTile(
                    prediction: p,
                    onTap: Navigator.of(context).pop,
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    final container = Container(
          child: Stack(children: <Widget>[
            header,
            Padding(padding: EdgeInsets.only(top: 48.0), child: 
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: body
              )
            ),
          ]));

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return Padding(padding: EdgeInsets.only(top: 8.0), child: container);
    }
    return container;
  }

  Icon get _iconBack => Theme.of(context).platform == TargetPlatform.iOS
      ? Icon(Icons.arrow_back_ios): Icon(Icons.arrow_back);



  Widget _textField(BuildContext context) => TextField(
        controller: _queryTextController,
        autofocus: true,
        style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black87
                : null,
            fontSize: 16.0),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black45
                : null,
            fontSize: 16.0,
          ),
          border: InputBorder.none,
        ),
      );
}

class _Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxHeight: 2.0),
        child: LinearProgressIndicator());
  }
}

class PoweredByGoogleImage extends StatelessWidget {
  final _poweredByGoogleWhite =
      "packages/flutter_google_places/assets/google_white.png";
  final _poweredByGoogleBlack =
      "packages/flutter_google_places/assets/google_black.png";

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Padding(
          padding: EdgeInsets.all(16.0),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? _poweredByGoogleWhite
                : _poweredByGoogleBlack,
            scale: 2.5,
          ))
    ]);
  }
}

class PredictionTile extends StatelessWidget {
  final Prediction prediction;
  final ValueChanged<Prediction> onTap;

  PredictionTile({@required this.prediction, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.location_on),
      title: Text(prediction.description),
      onTap: () {
        if (onTap != null) {
          onTap(prediction);
        }
      },
      trailing: Icon(Icons.arrow_forward),
    );
  }
}


abstract class PlacesAutocompleteState extends State<PlacesAutocompleteWidget> {
  TextEditingController _queryTextController;
  PlacesAutocompleteResponse _response;
  GoogleMapsPlaces _places;
  bool _searching;
  Timer _debounce;

  final _queryBehavior = BehaviorSubject<String>.seeded('');

  @override
  void initState() {
    super.initState();
    _queryTextController = TextEditingController(text: widget.startText);

    _places = GoogleMapsPlaces(
        apiKey: widget.apiKey,
        baseUrl: widget.proxyBaseUrl,
        httpClient: widget.httpClient);
    _searching = false;

    _queryTextController.addListener(_onQueryChange);

    _queryBehavior.stream.listen(doSearch);
  }

  Future<Null> doSearch(String value) async {
    if (mounted && value.isNotEmpty) {
      setState(() {
        _searching = true;
      });

      final res = await _places.autocomplete(
        value,
        offset: widget.offset,
        location: widget.location,
        radius: widget.radius,
        language: widget.language,
        sessionToken: widget.sessionToken,
        types: widget.types,
        components: widget.components,
        strictbounds: widget.strictbounds,
        region: widget.region,
      );

      if (res.errorMessage?.isNotEmpty == true ||
          res.status == "REQUEST_DENIED") {
        onResponseError(res);
      } else {
        onResponse(res);
      }
    } else {
      onResponse(null);
    }
  }

  void _onQueryChange() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: widget.debounce), () {
      _queryBehavior.add(_queryTextController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _places.dispose();
    _queryBehavior.close();
    _queryTextController.removeListener(_onQueryChange);
  }

  @mustCallSuper
  void onResponseError(PlacesAutocompleteResponse res) {
    if (!mounted) return;

    if (widget.onError != null) {
      widget.onError(res);
    }
    setState(() {
      _response = null;
      _searching = false;
    });
  }

  @mustCallSuper
  void onResponse(PlacesAutocompleteResponse res) {
    if (!mounted) return;

    setState(() {
      _response = res;
      _searching = false;
    });
  }
}

class PlacesAutocomplete {
  static Future<Prediction> show(
      {@required BuildContext context,
      @required String apiKey,
      String hint = "Search",
      BorderRadius overlayBorderRadius,
      num offset,
      Location location,
      num radius,
      String language,
      String sessionToken,
      List<String> types,
      List<Component> components,
      bool strictbounds,
      String region,
      Widget logo,
      ValueChanged<PlacesAutocompleteResponse> onError,
      String proxyBaseUrl,
      Client httpClient,
      String startText=""}) {
    final builder = (BuildContext ctx) => PlacesAutocompleteWidget(
        apiKey: apiKey,
        overlayBorderRadius: overlayBorderRadius,
        language: language,
        sessionToken: sessionToken,
        components: components,
        types: types,
        location: location,
        radius: radius,
        strictbounds: strictbounds,
        region: region,
        offset: offset,
        hint: hint,
        logo: logo,
        onError: onError,
        proxyBaseUrl: proxyBaseUrl,
        httpClient: httpClient,
        startText: startText,);

    return showDialog(context: context, builder: builder);
  }
}
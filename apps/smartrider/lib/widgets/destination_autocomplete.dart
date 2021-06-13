// ui imports
import 'package:flutter/material.dart';

// import places api
import 'package:google_maps_webservice/places.dart';

// session token generation
import 'dart:math';

import 'dart:async';

import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

/// Below from https://github.com/fluttercommunity/flutter_google_places

/// A text field like widget to input places with autocomplete.
///
/// The autocomplete field calls [onChanged] with the new address line
/// whenever the user input a new location.
///
/// To control the text that is displayed in the text field, use the
/// [controller]. For example, to set the initial value of the text field, use
/// a [controller] that already contains some text.
///
/// By default, an autocomplete field has a [decoration] that draws a divider
/// below the field. You can use the [decoration] property to control the
/// decoration, for example by adding a label or an icon. If you set the [decoration]
/// property to null, the decoration will be removed entirely, including the
/// extra padding introduced by the decoration to save space for the labels.
/// If you want the icon to be outside the input field use [decoration.icon].
/// If it should be inside the field use [leading].
///
/// To integrate the [PlacesAutocompleteField] into a [Form] with other [FormField]
/// widgets, consider using [PlacesAutocompleteFormField].
///
/// See also:
///
///  * [PlacesAutocompleteFormField], which integrates with the [Form] widget.
///  * [InputDecorator], which shows the labels and other visual elements that
///    surround the actual text editing widget.
class PlacesAutocompleteField extends StatefulWidget {
  /// Creates a text field like widget.
  ///
  /// To remove the decoration entirely (including the extra padding introduced
  /// by the decoration to save space for the labels), set the [decoration] to
  /// null.
  const PlacesAutocompleteField({
    Key? key,
    required this.apiKey,
    this.controller,
    this.leading,
    this.hint = "Search",
    this.trailing,
    this.trailingOnTap,
    this.offset,
    this.location,
    this.radius,
    this.language,
    this.sessionToken,
    this.types,
    this.components,
    this.strictbounds,
    this.onChanged,
    this.onSelected,
    this.onError,
    this.inputDecoration = const InputDecoration(),
  }) : super(key: key);

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Icon shown inside the field left to the text.
  final Icon? leading;

  /// Icon shown inside the field right to the text.
  final Icon? trailing;

  /// Callback when [trailing] is tapped on.
  final VoidCallback? trailingOnTap;

  /// Text that is shown, when no input was done, yet.
  final String hint;

  /// Your Google Maps Places API Key.
  ///
  /// For this key the Places Web API needs to be activated. For further
  /// information on how to do this, see their official documentation below.
  ///
  /// See also:
  ///
  /// * <https://developers.google.com/places/web-service/autocomplete>
  final String apiKey;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the autocomplete field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration inputDecoration;

  /// The position, in the input term, of the last character that the service
  /// uses to match predictions.
  ///
  /// For example, if the input is 'Google' and the
  /// offset is 3, the service will match on 'Goo'. The string determined by the
  /// offset is matched against the first word in the input term only. For
  /// example, if the input term is 'Google abc' and the offset is 3, the service
  /// will attempt to match against 'Goo abc'. If no offset is supplied, the
  /// service will use the whole term. The offset should generally be set to the
  /// position of the text caret.
  ///
  /// Source: https://developers.google.com/places/web-service/autocomplete
  final num? offset;

  final String? language;

  final String? sessionToken;

  final List<String>? types;

  final List<Component>? components;

  final Location? location;

  final num? radius;

  final bool? strictbounds;

  /// Called when the text being edited changes.
  final ValueChanged<String?>? onChanged;

  /// Called when an autocomplete entry is selected.
  final ValueChanged<Prediction>? onSelected;

  /// Callback when autocomplete has error.
  final ValueChanged<PlacesAutocompleteResponse>? onError;

  @override
  _LocationAutocompleteFieldState createState() =>
      _LocationAutocompleteFieldState();
}

class _LocationAutocompleteFieldState extends State<PlacesAutocompleteField> {
  TextEditingController? _controller;
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _controller = TextEditingController();
  }

  @override
  void didUpdateWidget(PlacesAutocompleteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null)
      _controller =
          TextEditingController.fromValue(oldWidget.controller!.value);
    else if (widget.controller != null && oldWidget.controller == null)
      _controller = null;
  }

  Future<Prediction?> _showAutocomplete() async => PlacesAutocomplete.show(
        context: context,
        apiKey: widget.apiKey,
        offset: widget.offset,
        onError: widget.onError,
        hint: widget.hint,
        language: widget.language,
        sessionToken: widget.sessionToken,
        components: widget.components,
        location: widget.location,
        radius: widget.radius,
        types: widget.types,
        strictbounds: widget.strictbounds,
      );

  void _handleTap() async {
    Prediction? p = await _showAutocomplete();

    if (p == null) return;

    setState(() {
      _effectiveController!.text = p.description!;
      if (widget.onChanged != null) {
        widget.onChanged!(p.description);
      }
      if (widget.onSelected != null) {
        widget.onSelected!(p);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = _effectiveController!;

    var text = controller.text.isNotEmpty
        ? Text(
            controller.text,
            softWrap: true,
          )
        : Text(
            widget.hint,
            style: TextStyle(fontSize: 16),
          );

    Widget child = Container(
        height: 50,
        child: Row(
          children: <Widget>[
            widget.leading ?? SizedBox(),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: text,
            ),
            widget.trailing != null
                ? GestureDetector(
                    onTap: widget.trailingOnTap,
                    child: widget.trailingOnTap != null
                        ? widget.trailing
                        : Icon(
                            widget.trailing!.icon,
                            color: Colors.grey,
                          ),
                  )
                : SizedBox()
          ],
        ));

    child = InputDecorator(
      decoration: widget.inputDecoration,
      child: child,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleTap,
      child: child,
    );
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

/// Below from https://github.com/fluttercommunity/flutter_google_places
/// Modified to better fit the ui of smartrider

class PlacesAutocompleteWidget extends StatefulWidget {
  final String apiKey;
  final String? startText;
  final String hint;
  final BorderRadius? overlayBorderRadius;
  final Location? location;
  final num? offset;
  final num? radius;
  final String? language;
  final String? sessionToken;
  final List<String>? types;
  final List<Component>? components;
  final bool? strictbounds;
  final String? region;
  final Widget? logo;
  final ValueChanged<PlacesAutocompleteResponse>? onError;
  final int debounce;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  final String? proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final BaseClient? httpClient;

  PlacesAutocompleteWidget(
      {required this.apiKey,
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
      Key? key,
      this.proxyBaseUrl,
      this.httpClient,
      this.startText,
      this.debounce = 300})
      : super(key: key);

  @override
  State<PlacesAutocompleteWidget> createState() => _PlacesAutocompleteState();

  static PlacesAutocompleteState? of(BuildContext context) =>
      context.findAncestorStateOfType<PlacesAutocompleteState>();
}

class _PlacesAutocompleteState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final header = Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 64,
        child: Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 5.0,
            child: Column(children: <Widget>[
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
                  )),
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
    } else if (_queryTextController!.text.isEmpty ||
        _response == null ||
        _response!.predictions.isEmpty) {
      body = Container(
        height: 30,
        width: 7777777,
        child: Material(
          borderRadius: BorderRadius.only(
            bottomLeft: bodyBottomLeftBorderRadius,
            bottomRight: bodyBottomRightBorderRadius,
          ),
          child: Center(
            child: Text(
              "Note: Safe Ride won't go past 1 mile of campus",
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
            children: _response!.predictions
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
      Padding(
          padding: EdgeInsets.only(top: 48.0),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0), child: body)),
    ]));

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return Padding(padding: EdgeInsets.only(top: 8.0), child: container);
    }
    return container;
  }

  Icon get _iconBack => Theme.of(context).platform == TargetPlatform.iOS
      ? Icon(Icons.arrow_back_ios)
      : Icon(Icons.arrow_back);

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
  final ValueChanged<Prediction>? onTap;

  PredictionTile({required this.prediction, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.location_on),
      title: Text(prediction.description!),
      onTap: () {
        if (onTap != null) {
          onTap!(prediction);
        }
      },
      trailing: Icon(Icons.arrow_forward),
    );
  }
}

abstract class PlacesAutocompleteState extends State<PlacesAutocompleteWidget> {
  TextEditingController? _queryTextController;
  PlacesAutocompleteResponse? _response;
  late GoogleMapsPlaces _places;
  late bool _searching;
  Timer? _debounce;
  late bool _disposed;

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

    _queryTextController!.addListener(_onQueryChange);

    _queryBehavior.stream.listen(doSearch);
    _disposed = false;
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
        types: widget.types!,
        components: widget.components!,
        strictbounds: widget.strictbounds!,
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
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: widget.debounce), () {
      if (!_disposed) {
        _queryBehavior.add(_queryTextController!.text);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _places.dispose();
    _disposed = true;
    _queryBehavior.close();
    _queryTextController!.removeListener(_onQueryChange);
  }

  @mustCallSuper
  void onResponseError(PlacesAutocompleteResponse res) {
    if (!mounted) return;

    if (widget.onError != null) {
      widget.onError!(res);
    }
    setState(() {
      _response = null;
      _searching = false;
    });
  }

  @mustCallSuper
  void onResponse(PlacesAutocompleteResponse? res) {
    if (!mounted) return;

    setState(() {
      _response = res;
      _searching = false;
    });
  }
}

class PlacesAutocomplete {
  static Future<Prediction?> show(
      {required BuildContext context,
      required String apiKey,
      String hint = "Search",
      BorderRadius? overlayBorderRadius,
      num? offset,
      Location? location,
      num? radius,
      String? language,
      String? sessionToken,
      List<String>? types,
      List<Component>? components,
      bool? strictbounds,
      String? region,
      Widget? logo,
      ValueChanged<PlacesAutocompleteResponse>? onError,
      String? proxyBaseUrl,
      Client? httpClient,
      String startText = ""}) {
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
          httpClient: httpClient as BaseClient?,
          startText: startText,
        );

    return showDialog(context: context, builder: builder);
  }
}

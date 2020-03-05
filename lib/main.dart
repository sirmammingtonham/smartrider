// import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrider/pages/home.dart';
import 'package:smartrider/widgets/theme.dart';
import 'package:smartrider/util/theme_notifier.dart';


void main() => runApp(
        ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(darkTheme),
        child: SmartRider(),
      ),
    );

class SmartRider extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Rider Prototype',
      theme: themeNotifier.getTheme(),
      home: HomePage(),
    );
  }
}

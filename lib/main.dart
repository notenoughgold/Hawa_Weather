import 'package:flutter/material.dart';
import 'package:hawa/blocs/location_bloc.dart';
import 'package:hawa/pages/root_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<LocationBloc>(
      builder: (context) => LocationBloc(),
      dispose: (context, value) => value.dispose(),
      child: MaterialApp(
        title: 'Hawa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(),
      ),
    );
  }
}

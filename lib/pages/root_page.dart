import 'package:flutter/material.dart';

import 'package:hawa/pages/home_page.dart';
import 'package:hawa/pages/location_selection_page.dart';
import 'package:hawa/blocs/location_bloc.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LocationBloc locationBloc = Provider.of<LocationBloc>(context);

    return StreamBuilder<String>(
        stream: locationBloc.locationObservable,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return snapshot.hasData
              ? HomePage(cityName: snapshot.data)
              : LocationSelectionPage();
        });
  }
}

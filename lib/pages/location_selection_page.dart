import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:hawa/blocs/location_bloc.dart';
import 'package:provider/provider.dart';

class LocationSelectionPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LocationBloc locationBloc = Provider.of<LocationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    height: 150,
                    width: 225,
                    child: FlareActor(
                      "assets/flare_anim/spinning_earth.flr",
                      animation: "spin",
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller,
                  key: Key("location"),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: "Enter a place",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () => locationBloc
                    .writeLocationToSharedPreference(controller.text),
                child: Icon(Icons.check),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

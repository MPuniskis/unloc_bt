import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformChannel extends StatefulWidget {
  const PlatformChannel({Key? key}) : super(key: key);

  @override
  State<PlatformChannel> createState() => _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {

  static const MethodChannel methodChannel =
  MethodChannel('samples.flutter.io/btAvailability');
  static const EventChannel eventChannel =
  EventChannel('samples.flutter.io/btState');

  String _btAvailability = 'BT Availability: unknown.';
  String _btState = 'BT State: unknown.';
  String _btName = 'BT Name: unknown.';

  Future<void> _getBTAvailability() async {
    String btAvailability;
    try {
      final String? result = await methodChannel.invokeMethod('getBTAvailability');
      btAvailability = 'BT Availability: $result';
    } on PlatformException {
      btAvailability = 'Failed to get BT Availability.';
    }
    setState(() {
      _btAvailability = btAvailability;
    });
  }

  Future<void> _getBTName() async {
    String btName;
    try {
      final String? result = await methodChannel.invokeMethod('getBTName');
      btName = 'BT Name: $result';
    } on PlatformException {
      btName = 'Failed to get BT Name.';
    }
    setState(() {
      _btName = btName;
    });
  }


  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object? event) {
    setState(() {
      _btState =
      "BT State: $event";
    });
  }

  void _onError(Object error) {
    setState(() {
      _btState = 'BT State: unknown.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_btAvailability, key: const Key('BT Availability label')),
              Text(_btState, key: const Key('BT Status label')),
              Text(_btName, key: const Key('BT Name label')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _getBTAvailability();
                    _getBTName();
                  },
                  child: const Text('Refresh'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PlatformChannel()));
}
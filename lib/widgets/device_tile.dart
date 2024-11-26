import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceTile extends StatefulWidget {
  const DeviceTile({
    super.key,
    required this.device,
    required this.onPressed,
  });

  final BluetoothDevice device;
  final void Function()? onPressed;
  @override
  State<DeviceTile> createState() => _DeviceTileState();
}

class _DeviceTileState extends State<DeviceTile> {
     BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = widget.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }
  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }
  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.bluetooth),
      title: Text(
        widget.device.platformName.isNotEmpty
            ? widget.device.platformName
            : 'Unknown Device',
      ),
      subtitle: Text(widget.device.remoteId.toString()),
      trailing: ElevatedButton(
        onPressed:isConnected?null: widget.onPressed,
        child:  Text(isConnected?'Open': 'Connect'),
      ),
    );
  }
}


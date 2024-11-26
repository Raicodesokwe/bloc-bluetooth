import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({
    super.key,
    required this.result,
    required this.onPressed,
  });

  final ScanResult result;
  final void Function()? onPressed;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
    BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = widget.result.device.connectionState.listen((state) {
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
        widget.result.device.platformName.isNotEmpty
            ? widget.result.device.platformName
            : 'Unknown Device',
      ),
      subtitle: Text(widget.result.device.remoteId.toString()),
      trailing: ElevatedButton(
        onPressed: (widget.result.advertisementData.connectable)
            ? widget.onPressed
            : null,
        child: Text(
          (widget.result.advertisementData.connectable)
              ?(isConnected?'Open': 'Connect')
              : 'Unavailable',
        ),
      ),
    );
  }
}
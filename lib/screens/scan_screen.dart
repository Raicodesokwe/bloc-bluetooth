import 'dart:async';
import 'package:coolerprodemo/widgets/device_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../widgets/scan_result_tile.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();

 _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
    // Listen to scan results
    _scanResultsSubscription =
        FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    });

    // Start scanning on screen load
    _startScan();
  }

 Future _startScan()async {
     // Fetch system devices
    _systemDevices = await FlutterBluePlus.systemDevices([]);
    FlutterBluePlus.startScan(
     androidScanMode: AndroidScanMode.lowLatency,
      timeout: const Duration(seconds: 60),
      androidUsesFineLocation: true,
    );
  }
Future onRefresh() async {
    if (_isScanning == false) {
     await  _startScan();
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(const Duration(milliseconds: 300));
  }
  void _stopScan() {

    FlutterBluePlus.stopScan();
  }
  Widget buildScanButton(BuildContext context) {

    return Row(
      children: [
        FilledButton(
          onPressed: _isScanning ? _stopScan : _startScan,
          
          style: FilledButton.styleFrom(
            backgroundColor: !_isScanning ? Colors.orange : Colors.red.shade700,
          ),
          child: Text(
            "${_isScanning ? "Stop" : "Start"} Scanning",
            style: Theme.of(context).primaryTextTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
       const SizedBox(
          width: 10,
        ),
      ],
    );
  }
  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
   
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
     return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Scan'),
        actions: [
         buildScanButton(context)
        ],
      ),
      body: RefreshIndicator(
             onRefresh: () async {
        await onRefresh();
      },
            child: Column(
                children: [
                  if (_systemDevices.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'System Devices',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  if (_systemDevices.isNotEmpty)
                    Column(
                      children: List.generate(
                         _systemDevices.length,
                         (index) {
                          final device = _systemDevices[index];
                          return DeviceTile(device: device,onPressed: (){
                             _connectToDevice(device);
                          },);
                        },
                      ),
                    ),
                  if (_scanResults.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Scanned Devices',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  if (_scanResults.isNotEmpty)
                    Column(
                  
                      children: List.generate(
                        _scanResults.length,
                        ( index) {
                          final result = _scanResults[index];
                          return ScanResultTile(result: result,onPressed: (){
                             _connectToDevice(result.device);
                          },);
                        },
                      ),
                    ),
                  if (_scanResults.isEmpty &&
                      !FlutterBluePlus.isScanningNow &&
                      _systemDevices.isEmpty)
                   const  Expanded(
                      child: Center(
                        child:   Text(
                            'No devices found. Press icon to try again.',
                            textAlign: TextAlign.center,
                          ),
                      ),
                    ),
                  if (FlutterBluePlus.isScanningNow)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                ],
              ),
          ),
    ),
  );
    
  }
  
  void _connectToDevice(BluetoothDevice device) async {
  try {
    // Show a loading dialog while connecting
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Attempt to connect to the device
    await device.connect(autoConnect: false);

    // Dismiss the loading dialog after connecting
    if (mounted) {
      Navigator.pop(context);
    }

    // Discover services
    List<BluetoothService> services = await device.discoverServices();

    // Show services in an alert dialog (or process them further)
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Connected to ${device.platformName}'),
          content: SizedBox(
            height: 200,
            child: ListView(
              children: services
                  .map((service) => ListTile(
                        title: Text(service.uuid.toString()),
                        subtitle: Text('Characteristics: ${service.characteristics.length}'),
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    // Dismiss the loading dialog if an error occurs
    if (mounted) {
      Navigator.pop(context);
    }

  if(mounted){
      // Show an error dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connection Error'),
        content: Text('Failed to connect to the device: $e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  }
}


}


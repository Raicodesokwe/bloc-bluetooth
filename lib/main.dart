import 'dart:async';

import 'package:coolerprodemo/data/cubits/add_transaction_cubit.dart';
import 'package:coolerprodemo/data/cubits/fetch_transactions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/bluetooth_off_screen.dart';
import 'screens/home_screen.dart';


void main() async{
    WidgetsFlutterBinding.ensureInitialized();
     await dotenv.load(fileName: ".env");
    await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FlutterBluePlus.setLogLevel(LogLevel.none, color: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? const HomeScreen()
        : BluetoothOffScreen(adapterState: _adapterState);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FetchTransactionsCubit(),
        ),
        BlocProvider(
          create: (_) => AddTransactionCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Transaction management demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
           textTheme: GoogleFonts.figtreeTextTheme(
          Theme.of(context).textTheme,
        ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
           appBarTheme: const AppBarTheme(
                  elevation: 0, backgroundColor: Colors.transparent),
        ),
         navigatorObservers: [
        BluetoothAdapterStateObserver(),
      ],
        home: screen,
      ),
    );
  }
}
//
// This observer listens for Bluetooth Off and dismisses the DeviceScreen
//
class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}


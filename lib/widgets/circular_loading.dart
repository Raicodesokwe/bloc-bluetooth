
import 'package:flutter/cupertino.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(
          radius: 20, color: Color(0xFF9C27B0)),
    );
  }
}

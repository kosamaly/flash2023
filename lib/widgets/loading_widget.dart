import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 32,
        width: 32,
        child: CircularProgressIndicator(
          color: Colors.amber,
        ),
      ),
    );
  }
}

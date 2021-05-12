import 'package:flutter/material.dart';

import '../res/res.dart';

class StreamErrorWidget extends StatelessWidget {
  const StreamErrorWidget({
    Key? key,
    required this.error,
    this.onTryAgain,
  }) : super(key: key);

  final String error;

  final GestureTapCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 75.sp,
            ),
            const SizedBox(height: 12),
            Text(
              'Something Went Wrong',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.7), fontSize: 22.sp),
            ),
            const SizedBox(height: 12),
            Text(
              error.toLowerCase().contains('SocketException'.toLowerCase())
                  ? 'No internet Connection'
                  : error,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.sp,
              ),
            ),
            const SizedBox(height: 24),
            if (onTryAgain != null)
              TextButton(
                onPressed: onTryAgain,
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 24.sp,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

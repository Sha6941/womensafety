import 'package:flutter/material.dart';
import '../../utils/quotes.dart';

class CustomAppBar extends StatelessWidget {
  final Function? onTap;
  final int? quoteIndex;

  CustomAppBar({this.onTap, this.quoteIndex});

  @override
  Widget build(BuildContext context) {
    bool showWarning = quoteIndex == null || quoteIndex! < 0 || quoteIndex! >= sweetSayings.length;

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (showWarning)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Invalid quote index',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ],
              ),
            if (!showWarning)
              Text(
                sweetSayings[quoteIndex!],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../utils/quotes.dart';
//
// class CustomAppBar extends StatelessWidget {
//   // const CustomAppBar({super.key});
//   Function? onTap;
//   int? quoteIndex;
//   CustomAppBar({this.onTap, this.quoteIndex});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         onTap!();
//       },
//       child: Container(
//         child: Text(
//           sweetSayings[quoteIndex!],
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
// import 'package:sewakantor/src/utils/adapt_size.dart';
// import 'package:sewakantor/src/utils/colors.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// Widget transactionStatusWidget({
//   required BuildContext contexts,
//   required String statusText,
//   required Color statusBodyColor,
//   required Color statusBorderColor,
//   required Color statusTextColor,
// }) {
//   AdaptSize.size(context: contexts);
//   return SizedBox(
//     width: AdaptSize.screenWidth / 4,
//     height: AdaptSize.screenHeight / 33.3,
//     child: Stack(
//       children: [
//         SizedBox(
//           width: AdaptSize.screenWidth / 4,
//           height: AdaptSize.screenHeight / 33.3,
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//                 color: statusBodyColor,
//                 border: Border.all(width: 1, color: statusBorderColor),
//                 borderRadius: BorderRadius.circular(42)),
//           ),
//         ),
//         Align(
//           alignment: Alignment.center,
//           child: Text(
//             statusText,
//             style: Theme.of(contexts).textTheme.bodySmall!.copyWith(
//                 color: statusTextColor,
//                 fontSize: AdaptSize.screenHeight / 1000 * 11),
//           ),
//         )
//       ],
//     ),
//   );
// }

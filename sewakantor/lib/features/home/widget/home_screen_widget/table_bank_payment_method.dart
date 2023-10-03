import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/widgets/divider_widget.dart';

Widget textTableBankPaymentMethod({
  TextStyle? contentTextStyle,
  required String text1,
  required String text2,
  required String text3,
  required String text4,
  required String text5,
  required String text6,
  required String text7,
  required String text8,
  required String text9,
  required String text10,
}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(
      AdaptSize.pixel20,
      0,
      AdaptSize.pixel20,
      0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AdaptSize.screenHeight * 0.01,
        ),

        ///text content
        Table(
          columnWidths: const {1: FractionColumnWidth(.95)},
          children: [
            TableRow(
              children: [
                Text(
                  '1',
                  style: contentTextStyle,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight * .007),
                  child: Text(
                    text1,
                    style: contentTextStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '2',
                  style: contentTextStyle,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight * .007),
                  child: Text(
                    text2,
                    style: contentTextStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '3',
                  style: contentTextStyle,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight * .007),
                  child: Text(
                    text3,
                    style: contentTextStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '4',
                  style: contentTextStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AdaptSize.screenHeight * .007,
                  ),
                  child: Text(
                    text4,
                    style: contentTextStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '5',
                  style: contentTextStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AdaptSize.screenHeight * .007,
                  ),
                  child: Text(
                    text5,
                    style: contentTextStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '6',
                  style: contentTextStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AdaptSize.screenHeight * .007,
                  ),
                  child: Text(
                    text6,
                    style: contentTextStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '7',
                  style: contentTextStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AdaptSize.screenHeight * .007,
                  ),
                  child: Text(
                    text7,
                    style: contentTextStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '8',
                  style: contentTextStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AdaptSize.screenHeight * .007,
                  ),
                  child: Text(
                    text8,
                    style: contentTextStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '10',
                  style: contentTextStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AdaptSize.screenHeight * .007,
                  ),
                  child: Text(
                    text9,
                    style: contentTextStyle,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '10',
                  style: contentTextStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AdaptSize.screenHeight * .007,
                  ),
                  child: Text(
                    text10,
                    style: contentTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(
          height: AdaptSize.screenHeight * .007,
        ),
        dividerWdiget(width: double.infinity, opacity: .1),
      ],
    ),
  );
}

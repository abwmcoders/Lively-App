import 'package:flutter/material.dart';

class UIHelper {
  //! font size
  static const double kSmallFont = 11.0;
  static const double kMediumFont = 14.0;
  static const double kExtraMediumFont = 24.0;
  static const double kLargeFont = 40.0;

  //! vertical spacing constants
  static const double _verticalSpaceSmall = 10.0;
  static const double _verticalSpaceMedium = 30.0;
  static const double _verticalSpaceMediumExtra = 48.0;
  static const double _verticalSpaceLarge = 60.0;

  static const Widget verticalSPaceSmall = SizedBox(
    height: _verticalSpaceSmall,
  );
  static const Widget verticalSpaceMedium = SizedBox(
    height: _verticalSpaceMedium,
  );
  static const Widget verticalSpaceMediumExtra = SizedBox(
    height: _verticalSpaceMediumExtra,
  );
  static const Widget verticalSpaceLarge = SizedBox(
    height: _verticalSpaceLarge,
  );

  //! horizontal spacing constants
  static const double _horizontalSpaceSmall = 10.0;
  static const double _horizontalSpaceMedium = 20.0;
  static const double _horizontalSpaceLarge = 40.0;

  static const Widget horizontalSpaceSmall = SizedBox(
    width: _horizontalSpaceSmall,
  );
  static const Widget horizontalSpaceMedium = SizedBox(
    width: _horizontalSpaceMedium,
  );
  static const Widget horizontalSPaceLarge = SizedBox(
    width: _horizontalSpaceLarge,
  );
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenAwareSize(double value, BuildContext context,
    {bool width = false}) {
  if (width) {
    return screenWidth(context) * (value / 414);
  } else {
    return screenHeight(context) * (value / 1181);
  }
}

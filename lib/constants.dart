import 'package:flutter/material.dart';

// Dimensions constants.
const double kDefaultPadding = 20.0;
const double kAppBarHeight = 70;

// Theme constants.
const Color kPrimaryColor = Color(0xFF32ff7e);
const Color kSecondaryColor = Color(0xFF4b4b4b);
const Color kSearchText = Color(0xFF919191);

// This color goes well with primary green. Saved it just for the record.
const _otherColor = Color.fromRGBO(90, 70, 178, 1.0);

// API Data
const String kApiKey = 'bthvogn48v6rsb74nu8g';
const String kUrl = 'finnhub.io';

// Config data.
int kQuotesRange = 5;

LinearGradient kLinearGradient = LinearGradient(
  colors: [
    kPrimaryColor,
    Color(0xFF27B0B4),
  ],
);

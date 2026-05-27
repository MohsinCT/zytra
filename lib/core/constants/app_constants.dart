import 'package:flutter/material.dart';


// ─── Brand Colours ───────────────────────────────────────────────────────────

/// Zytra primary brand pink — used for CTAs, pins, active states.
const Color kPrimaryPink = Color(0xFFFF2D6F);

/// Light pink tint for backgrounds / containers.
const Color kPrimaryPinkLight = Color(0xFFFFF0F5);

/// Pink with low opacity — borders, subtle fills.
const Color kPrimaryPinkFaint = Color(0x1AFF2D6F); // 10 % opacity

/// App background grey.
const Color kBackgroundGrey = Color(0xFFF8F9FA);

/// Standard dark text colour.
const Color kTextDark = Color(0xFF1A1A2E);

/// Muted secondary text colour.
const Color kTextMuted = Color(0xFF8A8A9A);

// ─── Spacing ─────────────────────────────────────────────────────────────────

const double kSpacingXS = 4.0;
const double kSpacingSM = 8.0;
const double kSpacingMD = 16.0;
const double kSpacingLG = 24.0;
const double kSpacingXL = 32.0;

// ─── Border Radii ────────────────────────────────────────────────────────────

const double kRadiusSM = 8.0;
const double kRadiusMD = 12.0;
const double kRadiusLG = 16.0;
const double kRadiusXL = 24.0;
const double kRadiusRound = 100.0;

// ─── Named Routes ────────────────────────────────────────────────────────────

const String kRouteCategory = '/category';
const String kRouteSelectLocation = '/select-location';
const String kRouteMapConfirmation = '/map-confirmation';

// ─── Location ────────────────────────────────────────────────────────────────

/// Timeout for GPS position fetch on real devices.
const Duration kLocationTimeout = Duration(seconds: 15);

/// Debounce delay for reverse-geocoding after map camera settles.
const Duration kGeocodeDebounce = Duration(milliseconds: 600);

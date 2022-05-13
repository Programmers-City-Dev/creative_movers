import 'package:creative_movers/helpers/app_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalization on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
}

extension StringX on String{
  String get toFirstUppercase => AppUtils.capitalizeFirstCharacter(this);
}
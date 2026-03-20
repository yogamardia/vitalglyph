import 'package:flutter/widgets.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/l10n/generated/app_localizations.dart';

export 'package:vitalglyph/l10n/generated/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension AllergySeverityL10n on AllergySeverity {
  String localizedName(AppLocalizations l10n) => switch (this) {
        AllergySeverity.mild => l10n.allergySeverityMild,
        AllergySeverity.moderate => l10n.allergySeverityModerate,
        AllergySeverity.severe => l10n.allergySeveritySevere,
        AllergySeverity.lifeThreatening => l10n.allergySeverityLifeThreatening,
      };
}

extension LockTimeoutL10n on LockTimeout {
  String localizedName(AppLocalizations l10n) => switch (this) {
        LockTimeout.immediately => l10n.lockTimeoutImmediately,
        LockTimeout.after1Min => l10n.lockTimeoutAfter1Min,
        LockTimeout.after5Min => l10n.lockTimeoutAfter5Min,
        LockTimeout.never => l10n.lockTimeoutNever,
      };
}

extension BiologicalSexL10n on BiologicalSex {
  String localizedName(AppLocalizations l10n) => switch (this) {
        BiologicalSex.male => l10n.biologicalSexMale,
        BiologicalSex.female => l10n.biologicalSexFemale,
        BiologicalSex.other => l10n.biologicalSexOther,
      };
}

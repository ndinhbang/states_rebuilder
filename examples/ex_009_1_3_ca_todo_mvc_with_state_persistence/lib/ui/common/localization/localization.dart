import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'languages/language_base.dart';

final locale = RM.inject<Locale>(
  () => Locale.fromSubtags(languageCode: 'en'),
  onData: (_) {
    return i18n.refresh();
  },
  persist: () => PersistState(
    key: '__localization__',
    fromJson: (String json) => Locale.fromSubtags(languageCode: json),
    toJson: (locale) =>
        I18N.supportedLocale.contains(locale) ? locale.languageCode : 'und',
  ),
);

final Injected<I18N> i18n = RM.inject(
  () {
    return I18N.getLanguages(locale.state);
  },
);

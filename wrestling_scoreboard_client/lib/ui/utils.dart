import 'package:flutter/foundation.dart';

final isMobile =
    !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

import 'package:flutter_riverpod/flutter_riverpod.dart';

class messageidnotifier extends StateNotifier<String> {
  messageidnotifier() : super("");

  void ontoggle(String messageid) {
    state = state == messageid ? "" : messageid;
  }
}

final messageidnotifierprovider =
    StateNotifierProvider<messageidnotifier, String>(
        (ref) => messageidnotifier());

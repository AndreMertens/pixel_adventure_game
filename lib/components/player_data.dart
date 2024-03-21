import 'package:flutter/foundation.dart';

// This class stores the player progress persistently.

class PlayerData extends ChangeNotifier {
  int _currentScore = 0;

  int get currentScore => _currentScore;
  set currentScore(int value) {
    _currentScore = value;

    notifyListeners();
  }
}

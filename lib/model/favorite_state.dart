import 'package:flutter/material.dart';

class FavoriteState extends ChangeNotifier {
  Map<String, bool> _favoriteStatus = {};

  bool isFavorite(String itemId){
    return _favoriteStatus[itemId] ?? false;
  }
  void toggleFavorite(String itemId){
    _favoriteStatus[itemId] = !(_favoriteStatus[itemId] ?? false);
    notifyListeners();
  }
}

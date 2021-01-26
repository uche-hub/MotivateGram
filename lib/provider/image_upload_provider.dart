import 'package:flutter/cupertino.dart';
import 'package:motivate_gram/enum/view_state.dart';

class ImageUploadProvider with ChangeNotifier {
  ViewState _viewState = ViewState.IDLE;
  ViewState get getViewState => _viewState;

  void setToLoading() {
    _viewState = ViewState.LOADING;
    notifyListeners();
  }

  void setTOIdle() {
    _viewState = ViewState.IDLE;
    notifyListeners();
  }
}
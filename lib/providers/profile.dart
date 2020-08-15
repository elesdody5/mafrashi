import 'package:flutter/cupertino.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/model/user.dart';

class ProfileProvider with ChangeNotifier {
  ProfileRepository _profileRepository;

  ProfileProvider(this._profileRepository);

  User _user;

  User get user => _user;

  Future<void> getUserData() async {
    _user = await _profileRepository.fetchUserData();
    notifyListeners();
  }
}

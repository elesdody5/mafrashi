abstract class UserManager {
  Future<void> saveUserData(String email, String password);
  Future<void> deleteUserData();
  Future<String> getUserPassword();
  Future<String> getUserEmail();

  Future<void> saveToken(String token);

  Future<String> getToken();
}

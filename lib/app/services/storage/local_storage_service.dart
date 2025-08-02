import 'package:get_storage/get_storage.dart';
import 'package:uttham_gyaan/app/services/storage/storage_keys.dart';

class LocalStorageService {
  static final _storage = GetStorage();

  /// Write any value to local storage
  static Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  /// Read value from local storage
  static T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  /// Remove a key
  static Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  /// Clear all storage (use carefully!)
  static Future<void> clear() async {
    await _storage.erase();
  }

  // -----------------------------
  // 🔒 Common Use Functions (optional)
  // -----------------------------

  static bool isLoggedIn() => read<bool>(StorageKeys.isLoggedIn) ?? false;

  static String? getUserId() => read<String>(StorageKeys.userId);
  static String? getPatientId() => read<String>(StorageKeys.userPatientId);

  static Future<void> saveLogin({required String userId}) async {
    await write(StorageKeys.userId, userId);
    await write(StorageKeys.isLoggedIn, true);
  }

  static Future<void> savePatientLogin({required String patientId}) async {
    await write(StorageKeys.userPatientId, patientId);
    await write(StorageKeys.isLoggedIn, true);
  }

  static Future<void> logout() async {
    await remove(StorageKeys.userId);
    await write(StorageKeys.isLoggedIn, false);
    // Get.offAllNamed(Routes.LOGIN);
  }
}

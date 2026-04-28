import 'package:local_auth/local_auth.dart';

  class AuthService {
    static final _auth = LocalAuthentication();

    static Future<bool> authenticateWithBiometrics() async {
      final isAvailable = await _auth.canCheckBiometrics;
      if (!isAvailable) return false;
      return await _auth.authenticate(
        localizedReason: 'استخدم بصمتك لتأكيد الهوية',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    }
  }
  
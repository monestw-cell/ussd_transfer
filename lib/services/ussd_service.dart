import 'package:ussd_launcher/ussd_launcher.dart';

  class UssdService {
    static Future<String?> startSession(String ussdCode, int simSlot) async {
      try {
        final result = await UssdLauncher.launchUssd(
          code: ussdCode,
          subscriptionId: simSlot,
          hideWindow: true,
        );
        return result?.message;
      } catch (e) {
        throw _handleError(e);
      }
    }

    static Future<String?> sendReply(String reply) async {
      try {
        final result = await UssdLauncher.sendReply(reply);
        return result?.message;
      } catch (e) {
        throw _handleError(e);
      }
    }

    static Future<void> endSession() async {
      await UssdLauncher.closeSession();
    }

    static Exception _handleError(dynamic e) {
      final msg = e.toString();
      if (msg.contains('no network')) return Exception('لا يوجد اتصال بالشبكة');
      if (msg.contains('not supported')) return Exception('USSD غير مدعوم من المشغل');
      return Exception(msg);
    }
  }
  
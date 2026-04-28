import 'package:ussd_launcher/ussd_launcher.dart';
import 'package:flutter/services.dart';

class UssdService {
  // دالة لبدأ جلسة USSD متعددة الخطوات
  Future<void> startMultiStepSession(String code, List<String> options, int slotIndex) async {
    try {
      print('بدء جلسة USSD للكود: $code');
      
      // تشغيل الجلسة المتعددة
      await UssdLauncher.multisessionUssd(
        code: code,
        slotIndex: slotIndex,
        options: options,
        initialDelayMs: 1000,
        optionDelayMs: 1500,
      );
      
      print('انتهت جلسة USSD بنجاح');
    } on PlatformException catch (e) {
      print('خطأ في جلسة USSD: ${e.code} - ${e.message}');
    }
  }

  // دالة لإلغاء الجلسة الحالية
  void cancelSession() {
    UssdLauncher.cancelSession();
  }
}
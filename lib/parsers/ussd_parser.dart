enum UssdType { menu, pinInput, phoneInput, amountInput, confirm, success, error, unknown }

  class ParsedUssd {
    final UssdType type;
    final String message;
    final List<MapEntry<String, String>> menuItems;
    final String? hint;

    ParsedUssd({required this.type, required this.message, this.menuItems = const [], this.hint});
  }

  class UssdParser {
    static ParsedUssd parse(String raw) {
      final lines = raw.trim().split('\n');
      final menuRegex = RegExp(r'^\s*(\d+|[#*])\s*[\.-–]\s*(.+)$');
      final items = <MapEntry<String, String>>[];
      for (var line in lines) {
        final match = menuRegex.firstMatch(line);
        if (match != null) {
          items.add(MapEntry(match.group(1)!, match.group(2)!.trim()));
        }
      }
      if (items.isNotEmpty) {
        if (items.length == 2 &&
            (items[0].value.contains('تأكيد') || items[1].value.contains('إلغاء'))) {
          return ParsedUssd(type: UssdType.confirm, message: raw, menuItems: items);
        }
        return ParsedUssd(type: UssdType.menu, message: raw, menuItems: items);
      }
      if (raw.contains(RegExp(r'(كلمة.?السر|الرقم.?السري|PIN|password)', caseSensitive: false))) {
        return ParsedUssd(type: UssdType.pinInput, message: raw, hint: 'أدخل الرقم السري');
      }
      if (raw.contains(RegExp(r'(رقم.?المستلم|رقم.?الجوال|phone|recipient)', caseSensitive: false))) {
        return ParsedUssd(type: UssdType.phoneInput, message: raw, hint: 'أدخل رقم الجوال');
      }
      if (raw.contains(RegExp(r'(المبلغ|amount|قيمة)', caseSensitive: false))) {
        return ParsedUssd(type: UssdType.amountInput, message: raw, hint: 'أدخل المبلغ');
      }
      if (raw.contains(RegExp(r'(تمت.?العمليه|نجاح|success|تم.?التحويل)', caseSensitive: false))) {
        return ParsedUssd(type: UssdType.success, message: raw);
      }
      if (raw.contains(RegExp(r'(خطأ|فشل|غير.?صحيح|غير.?كافي|error|fail)', caseSensitive: false))) {
        return ParsedUssd(type: UssdType.error, message: raw);
      }
      return ParsedUssd(type: UssdType.unknown, message: raw);
    }

    static String? extractReference(String text) {
      final ref = RegExp(r'(?:#|رقم.?العملية|ref)[:\s]*([A-Za-z0-9]+)').firstMatch(text);
      return ref?.group(1);
    }

    static double? extractAmount(String text) {
      final match = RegExp(r'(\d+(?:\.\d+)?)\s*(شيكل|₪|دينار)').firstMatch(text);
      if (match != null) return double.tryParse(match.group(1)!);
      return null;
    }
  }
  
import 'dart:convert';

class JournalEntry {
  final int? id;
  final String date;
  final String content;
  final Map<String, double>? moods; // key = mood name, value = intensity

  JournalEntry({
    this.id,
    required this.date,
    required this.content,
    this.moods,
  });

  // Convert object -> Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'content': content,
      // store map as JSON string
      'moods': moods != null ? jsonEncode(moods) : null,
    };
  }

  /*String moodsToJson() =>
      moods!.entries.map((e) => '${e.key}:${e.value}').join(',');*/

  // Convert Map -> object
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    // moods may be stored as JSON string or already as a map
    return JournalEntry(
      id: map['id'] as int?,
      date: map['date'] as String,
      content: map['content'] as String,
      moods: _parseMoods(map['moods']),
    );
  }

  static Map<String, double> _parseMoods(dynamic moodsData) {
    if (moodsData == null) return {};

    // If already a Map (e.g. decoded by some APIs)
    if (moodsData is Map) {
      return moodsData.map<String, double>((k, v) {
        if (v is num) return MapEntry(k.toString(), v.toDouble());
        final parsed = double.tryParse(v.toString());
        return MapEntry(k.toString(), parsed ?? 0.0);
      });
    }

    // If it's a JSON string
    if (moodsData is String) {
      final s = moodsData.trim();
      // try JSON decode
      try {
        final decoded = jsonDecode(s);
        if (decoded is Map) {
          return decoded.map<String, double>((k, v) {
            if (v is num) return MapEntry(k.toString(), v.toDouble());
            final parsed = double.tryParse(v.toString());
            return MapEntry(k.toString(), parsed ?? 0.0);
          });
        }
      } catch (_) {
        // fallback to "key:val,key2:val2" parsing
        try {
          final out = <String, double>{};
          for (final part in s.split(',')) {
            final kv = part.split(':');
            if (kv.length != 2) continue;
            final key = kv[0].trim();
            final val = double.tryParse(kv[1].trim()) ?? 0.0;
            out[key] = val;
          }
          return out;
        } catch (_) {
          // final fallback below
        }
      }
    }

    return {};
  }
}


import 'dart:convert';
import 'dart:html' as html;

class DownloadService {
  // CSV ডাউনলোড করুন
  static void downloadCSV(List<Map<String, dynamic>> data, String filename) {
    if (data.isEmpty) return;

    // হেডার তৈরি করুন
    final headers = data.first.keys.join(',');
    final rows = data.map((row) => row.values.join(',')).join('\n');
    final csv = '$headers\n$rows';

    // BOM যোগ করুন (UTF-8 এর জন্য)
    final blob = html.Blob([utf8.encode(csv) as List<int>], 'text/csv;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = '$filename.csv';
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  // JSON ডাউনলোড করুন
  static void downloadJSON(Map<String, dynamic> data, String filename) {
    final jsonString = jsonEncode(data);
    final blob = html.Blob([jsonString], 'application/json;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = '$filename.json';
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }
}

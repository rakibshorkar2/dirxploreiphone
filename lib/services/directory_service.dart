import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:html/parser.dart' as hp;
import '../models/directory_item.dart';
import '../models/proxy_config.dart';

class DirectoryService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
  ));

  void configureProxy(ProxyConfig? proxy) {
    _dio.httpClientAdapter = IOHttpClientAdapter(); // reset or configure
    if (proxy != null && proxy.isEnabled && proxy.host.isNotEmpty) {
      // SOCKS5 proxy configuration via standard IOHttpClientAdapter 
      // requires custom HttpClient configuration.
    }
  }

  Future<List<DirectoryItem>> fetchDirectory(String url) async {
    try {
      final response = await _dio.get<String>(url);
      if (response.data == null) return [];

      return _parseHtml(response.data!, url);
    } catch (e) {
      rethrow;
    }
  }

  List<DirectoryItem> _parseHtml(String htmlContent, String baseUrl) {
    final document = hp.parse(htmlContent);
    final List<DirectoryItem> items = [];
    final links = document.querySelectorAll('a');

    // Ensure baseUrl ends with / for correct joining
    final sanitizedBaseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

    for (final link in links) {
      final href = link.attributes['href'];
      if (href == null || href.isEmpty) continue;

      // Skip parent directory links or fragments
      if (href == '../' || href.startsWith('?') || href.startsWith('#')) continue;

      final name = Uri.decodeFull(link.text.trim());
      if (name.isEmpty || name == 'Parent Directory') continue;

      final isDirectory = href.endsWith('/');
      final fullUrl = Uri.parse(sanitizedBaseUrl).resolve(href).toString();

      // Attempt to find metadata text following or near the anchor tag for size/date (Apache/Nginx standard listings)
      // Usually Apache/Nginx format: <a href="file">file</a> 25-Jul-2023 14:20 1024
      // We'll keep it robust: if text content contains sibling info, parse it, or leave as null.
      int? size;
      DateTime? lastModified;

      final parentText = link.parent?.text ?? '';
      if (parentText.isNotEmpty) {
        // Simple regex or split attempt to extract date/size
        try {
          final parts = parentText.split(RegExp(r'\s{2,}|\t+'));
          // Look for items matching date pattern or sizes
          for (final part in parts) {
            if (part.contains('-') && part.contains(':')) {
              // likely a date like 2023-07-25 14:20
              lastModified = DateTime.tryParse(part.trim());
            } else {
              final numeric = int.tryParse(part.trim());
              if (numeric != null) {
                size = numeric;
              }
            }
          }
        } catch (_) {}
      }

      items.add(DirectoryItem(
        name: isDirectory && !name.endsWith('/') ? '$name/' : name,
        url: fullUrl,
        isDirectory: isDirectory,
        size: size,
        lastModified: lastModified,
      ));
    }

    return items;
  }
}

import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

/// Xpath 解析器
class XpathParser {
  final Document _document;

  XpathParser(String html) : _document = html_parser.parse(html);

  List<Element> query(String xpath) {
    try {
      final selector = _xpathToCss(xpath);
      return _document.querySelectorAll(selector);
    } catch (e) {
      return [];
    }
  }

  String? text(String xpath) {
    final elements = query(xpath);
    if (elements.isEmpty) return null;
    return elements.first.text?.trim();
  }

  String? attribute(String xpath, String attr) {
    final elements = query(xpath);
    if (elements.isEmpty) return null;
    return elements.first.attributes[attr];
  }

  String _xpathToCss(String xpath) {
    if (xpath.isEmpty) return '';
    var result = xpath.replaceFirst(RegExp(r'^/+'), '');

    // strip leading / or //
    result = result.replaceAll(RegExp(r'^/+'), '');

    // [@class='xxx'] -> .xxx
    result = result.replaceAllMapped(
      RegExp(r"\[@class='([^']+)'\]"),
      (m) => '.' + m.group(1)!.replaceAll(' ', '.'),
    );

    // [@id='xxx'] -> #xxx
    result = result.replaceAllMapped(
      RegExp(r"\[@id='([^']+)'\]"),
      (m) => '#' + m.group(1)!,
    );

    // [@title='xxx'] -> [title="xxx"]
    result = result.replaceAllMapped(
      RegExp(r"\[@(\w+)='([^']+)'\]"),
      (m) => '[' + m.group(1)! + '="' + m.group(2)! + '"]',
    );

    // [@href] -> [href]
    result = result.replaceAllMapped(
      RegExp(r'\[@(\w+)\]'),
      (m) => '[' + m.group(1)! + ']',
    );

    // contains(@class, 'xxx') -> [class*="xxx"]
    result = result.replaceAllMapped(
      RegExp(r"contains\(@class,\s*'([^']+)'\)"),
      (m) => '[class*="' + m.group(1)! + '"]',
    );

    // [N] -> :nth-child(N)
    result = result.replaceAllMapped(
      RegExp(r'\[(\d+)\]'),
      (m) => ':nth-child(' + m.group(1)! + ')',
    );

    // text() removal
    result = result.replaceAll(RegExp(r'/text\(\)'), '');

    // descendant combinator
    result = result.replaceAll('//', ' ');

    // child combinator
    result = result.replaceAll('/', ' > ');

    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();
    return result;
  }
}

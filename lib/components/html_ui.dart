import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlWidgetUI extends StatelessWidget {
  final String? htmlContent;
  const HtmlWidgetUI({super.key, this.htmlContent});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      htmlContent.toString(),
      customStylesBuilder: (element) {
        if (element.classes.contains('foo')) {
          return {'color': 'red'};
        }
        return null;
      },

      // Custom widget builder for specific attributes
      customWidgetBuilder: (element) {
        if (element.attributes['foo'] == 'bar') {
          return const FooBarWidget(); // Replace with your widget
        }
        if (element.attributes['fizz'] == 'buzz') {
          return const InlineCustomWidget(child: FizzBuzzWidget()); // Replace with your widget
        }
        return null;
      },

      // Handle link taps
      onTapUrl: (url) {
        debugPrint('Tapped link: $url');
        return true;
      },

      // How the HTML body should be rendered
      renderMode: RenderMode.column,

      // Default text style
      textStyle: const TextStyle(fontSize: 14),
    );
  }
}

// Dummy widgets used above – replace with your real widgets
class FooBarWidget extends StatelessWidget {
  const FooBarWidget({super.key});
  @override
  Widget build(BuildContext context) =>
      Container(color: Colors.redAccent, padding: const EdgeInsets.all(8), child: const Text('Custom FooBarWidget'));
}

class FizzBuzzWidget extends StatelessWidget {
  const FizzBuzzWidget({super.key});
  @override
  Widget build(BuildContext context) => const Text('FizzBuzz');
}

class InlineCustomWidget extends StatelessWidget {
  final Widget child;
  const InlineCustomWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) => IntrinsicWidth(child: child);
}

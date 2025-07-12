import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Виджет замена для SvgPicture.asset
class CustomSvgPicture extends StatelessWidget {
  const CustomSvgPicture(
    this.path, {
    super.key,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.contain,
    this.theme,
    this.alignment = Alignment.center,
    this.network = false,
    this.placeholderBuilder,
  });

  const CustomSvgPicture.square(
    this.path, {
    super.key,
    double? dimension,
    this.color,
    this.fit = BoxFit.contain,
    this.theme,
    this.alignment = Alignment.center,
    this.network = false,
    this.placeholderBuilder,
  })  : height = dimension,
        width = dimension;

  const CustomSvgPicture.network(
    this.path, {
    super.key,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.contain,
    this.theme,
    this.alignment = Alignment.center,
    this.placeholderBuilder,
  }) : network = true;

  final double? height;
  final double? width;
  final Color? color;

  /// Если SVG сильно растягивается и не соответствует нужному размеру
  /// (пример - внутренний [SizedBox] должен быть больше чем картинка),
  /// то достаточно передать сюда [BoxFit.scaleDown]
  /// Таким образом картинка будет занимать родной для себя размер
  final BoxFit fit;
  final String path;
  final SvgTheme? theme;
  final Alignment alignment;
  final bool network;
  final Widget Function(BuildContext)? placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      // Костыль для Impeller, пока он не умеет корректно работать с [ColorFilter.mode]
      // Приходится городить костыли. Без этого виджета, картинка будет без сглаживания
      // https://stackoverflow.com/questions/67588713/flutter-changing-svg-icon-color
      child: Transform.scale(
        scale: 0.9999,
        child: network
            ? SvgPicture.network(
                path,
                placeholderBuilder: placeholderBuilder,
                alignment: alignment,
                colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcATop) : null,
                fit: fit,
                theme: theme,
              )
            : SvgPicture.asset(
                path,
                alignment: alignment,
                colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcATop) : null,
                fit: fit,
                theme: theme,
              ),
      ),
    );
  }
}

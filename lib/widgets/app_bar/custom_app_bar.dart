import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lenses/styles/const_colors_styles.dart';
import 'package:lenses/styles/const_text_styles.dart';
import 'package:lenses/widgets/app_bar/app_bar_leading_back_arrow.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.toolbarHeight = kToolbarHeight,
    this.leadingWidth = 56,
    this.titleSpacing,
    this.backgroundColor,
    this.centerTitle = false,
    this.actionsPadding,
    this.systemOverlayStyle,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;

  /// По умолчанию использована высота из дизайна Material [kToolbarHeight], как и во всем приложении
  final double toolbarHeight;

  /// Ширина ведущего виджета
  final double leadingWidth;

  /// Отступы для заголовка, если отступ null, то используем значение из темы [appBarTheme.titleSpacing],
  /// если нет и его то берем [NavigationToolbar.kMiddleSpacing]
  final double? titleSpacing;

  /// Фоновый цвет AppBar
  final Color? backgroundColor;

  /// Определяет, по центру ли будет находиться заголовок
  final bool centerTitle;

  /// Отступы вокруг [actions]
  /// Боковые отступы должны высчитываться так: желаемый размер минус 4, чтобы сама кнопка была 40 в диаметре,
  /// потому что ширина [IconButton] из коробки -- 48, а именно [kMinInteractiveDimension]
  final EdgeInsets? actionsPadding;

  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness, [Color? backgroundColor]) {
    final SystemUiOverlayStyle style = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    // For backward compatibility, create an overlay style without system navigation bar settings.
    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarBrightness: style.statusBarBrightness,
      statusBarIconBrightness: style.statusBarIconBrightness,
      systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
    );
  }

  @override
  Widget build(BuildContext context) {
    const appBarTheme = AppBarThemeData();

    // Если явно не задан leading виджет,
    // то будет отображаться кнопка перехода на предыдущий маршрут
    var leading = this.leading;

    if (leading == null && (ModalRoute.of(context)?.canPop ?? false)) {
      leading = const AppBarLeadingBackArrow();
    }

    if (leading != null) {
      leading = ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: leadingWidth),
        child: leading,
      );
    }

    // Обертка виджета заголовка в виджет стиля текста,
    // чтобы придать тексту необходимый вид во всем поддереве
    Widget? title = this.title;
    if (title != null) {
      title = DefaultTextStyle(
        style: AppTextStyles.heading.kH2,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: title,
      );
    }

    // Создание ряда с виджетами из списка активностей
    Widget? actions;
    if (this.actions != null && this.actions!.isNotEmpty) {
      actions = Padding(
        padding: actionsPadding ?? EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: this.actions!,
        ),
      );
    }

    final SystemUiOverlayStyle overlayStyle =
        systemOverlayStyle ??
        appBarTheme.systemOverlayStyle ??
        _systemOverlayStyleForBrightness(
          ThemeData.estimateBrightnessForColor(backgroundColor ?? AppColors.pureColors.white.o100),
          Colors.transparent,
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Material(
        color: backgroundColor ?? AppColors.pureColors.white.o100,
        child: SafeArea(
          bottom: false,
          child: CustomSingleChildLayout(
            delegate: _ToolbarContainerLayout(toolbarHeight),
            child: NavigationToolbar(
              leading: leading,
              middle: title,
              trailing: actions,
              centerMiddle: centerTitle,
              middleSpacing: titleSpacing ?? appBarTheme.titleSpacing ?? NavigationToolbar.kMiddleSpacing,
            ),
          ),
        ),
      ),
    );
  }
}

/// Т.к. некоторые области не имеют ограничений по высоте и не пользуются преимуществами
/// виджета [PreferredSizeWidget], из-за чего [CustomAppBar] без этого класса мог
/// выпадать в ошибку в таких областях.
/// П.С. как вариант, можно было обернуть часть [CustomAppBar] в [SizedBox]
class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
  const _ToolbarContainerLayout(this.toolbarHeight);

  final double toolbarHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.tighten(height: toolbarHeight);
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, toolbarHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0, size.height - childSize.height);
  }

  @override
  bool shouldRelayout(_ToolbarContainerLayout oldDelegate) => toolbarHeight != oldDelegate.toolbarHeight;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/common/localization/locale_controller.dart';
import 'package:lenses/common/utils/theme/const_colors_styles.dart';
import 'package:lenses/common/utils/theme/const_text_styles.dart';
import 'package:lenses/common/widgets/app_bar/app_bar_leading_back_arrow.dart';
import 'package:lenses/core/lenses/controllers/lenses_controller/lenses_controller.dart';
import 'package:lenses/l10n/app_localizations.dart';
import 'package:lenses/services/notifications/lens_replacement_reminder_service.dart';
import 'package:provider/provider.dart';

/// Кастомный AppBar приложения с кнопкой переключения языка справа.
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
    this.showLocaleToggle = true,
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

  /// Показывать кнопку RU/EN справа.
  final bool showLocaleToggle;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness, [Color? backgroundColor]) {
    final SystemUiOverlayStyle style = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
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

    Widget? title = this.title;
    if (title != null) {
      title = DefaultTextStyle(
        style: AppTextStyles.heading.kH2,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: title,
      );
    }

    final trailingChildren = <Widget>[
      ...?actions,
      if (showLocaleToggle) const _LocaleToggleButton(),
    ];

    Widget? trailing;
    if (trailingChildren.isNotEmpty) {
      trailing = Padding(
        padding: actionsPadding ?? const EdgeInsets.only(right: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: trailingChildren,
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
              trailing: trailing,
              centerMiddle: centerTitle,
              middleSpacing: titleSpacing ?? appBarTheme.titleSpacing ?? NavigationToolbar.kMiddleSpacing,
            ),
          ),
        ),
      ),
    );
  }
}

/// Кнопка переключения локали RU ↔ EN.
class _LocaleToggleButton extends StatelessWidget {
  const _LocaleToggleButton();

  @override
  Widget build(BuildContext context) {
    final localeController = context.read<LocaleController>();
    final l10n = AppLocalizations.of(context);

    return Observer(
      builder: (context) {
        final nextLanguage =
            localeController.isRussian ? l10n.semanticLanguageEn : l10n.semanticLanguageRu;

        return Semantics(
          button: true,
          label: l10n.semanticToggleLocale(nextLanguage),
          child: GestureDetector(
            onTap: () async {
              await localeController.toggle();
              if (!context.mounted) {
                return;
              }
              unawaited(
                GetIt.I<LensReplacementReminderService>().sync(
                  context.read<LensesController>().pairDates.value,
                  locale: localeController.locale,
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  localeController.localeCodeLabel,
                  style: AppTextStyles.heading.kH3.copyWith(
                    color: AppColors.pureColors.black.o100,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
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

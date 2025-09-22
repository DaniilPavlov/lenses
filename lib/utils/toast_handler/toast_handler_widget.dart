import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lenses/assets_gen/assets.gen.dart';
import 'package:lenses/models/toast_model.dart';
import 'package:lenses/styles/const_colors_styles.dart';
import 'package:lenses/utils/toast_handler/toast_handler_controller/toast_handler_controller.dart';
import 'package:lenses/widgets/custom_svg_picture.dart';

part 'toast_banner.dart';

///Виджет, который слушает ошибки с помощью [ToastHandlerController]
class ToastHandlerWidget extends StatefulWidget {
  const ToastHandlerWidget({required this.child, super.key});

  final Widget child;

  /// Метод, отдающий ошибку в [ToastHandlerController]
  static void handle(BuildContext context, {required ToastModel toast}) {
    _getController(context).handleToast(toast);
  }

  static ToastHandlerController _getController(BuildContext context) {
    final state = context.findRootAncestorStateOfType<_ToastHandlerWidgetState>();
    return state!.controller;
  }

  @override
  State<ToastHandlerWidget> createState() => _ToastHandlerWidgetState();
}

class _ToastHandlerWidgetState extends State<ToastHandlerWidget> {
  late ToastHandlerController controller;

  @override
  void initState() {
    super.initState();
    controller = ToastHandlerController();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Stack(
          children: [
            widget.child,
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    for (final error in controller.toasts) ...[ToastBanner(error), const SizedBox(height: 8)],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

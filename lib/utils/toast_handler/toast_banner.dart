part of 'toast_handler_widget.dart';

class ToastBanner extends StatefulWidget {
  const ToastBanner(this.toast, {super.key});

  final ToastModel toast;

  @override
  State<ToastBanner> createState() => _ToastBannerState();
}

class _ToastBannerState extends State<ToastBanner> with SingleTickerProviderStateMixin {
  late Tween<AlignmentGeometry> _startTween;
  late Tween<AlignmentGeometry> _middleTween;
  late Tween<AlignmentGeometry> _endTween;
  late Animation<AlignmentGeometry> _alignment;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 4000));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ToastHandlerWidget._getController(context).removeToast();
      }
    });
  }

  @override
  void didChangeDependencies() {
    final invisiblePoint = MediaQuery.sizeOf(context).width * 0.09;
    final startAlignment = Alignment(-invisiblePoint, 0);
    const middleAlignment = Alignment.center;
    final endAlignment = Alignment(invisiblePoint, 0);

    _startTween = Tween<AlignmentGeometry>(begin: startAlignment, end: middleAlignment);

    //Должен постоять на месте пару секунд
    _middleTween = Tween<AlignmentGeometry>(begin: middleAlignment, end: middleAlignment);

    _endTween = Tween<AlignmentGeometry>(begin: middleAlignment, end: endAlignment);

    _alignment = TweenSequence<AlignmentGeometry>([
      TweenSequenceItem(tween: _startTween.chain(CurveTween(curve: Curves.easeOutExpo)), weight: 3),
      TweenSequenceItem(tween: _middleTween, weight: 4),
      TweenSequenceItem(tween: _endTween.chain(CurveTween(curve: Curves.easeInExpo)), weight: 3),
    ]).animate(_animationController);

    _animationController.forward();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlignTransition(
      alignment: _alignment,
      child: Container(
        padding: const EdgeInsets.all(9),
        constraints: const BoxConstraints(maxWidth: 460),
        width: MediaQuery.sizeOf(context).width - 32,
        decoration: BoxDecoration(
          color: widget.toast.isError ? AppColors.pureColors.error.error : AppColors.pureColors.green.g900,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          spacing: 10,
          children: [
            CustomSvgPicture(
              widget.toast.isError ? Assets.icons.error.path : Assets.icons.check.path,
              height: 24,
              width: 24,
              color: AppColors.pureColors.white.o100,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: widget.toast.message,
                  style: TextStyle(color: AppColors.pureColors.white.o100),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

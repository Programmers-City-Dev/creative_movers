import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class CustomDropdownMenuExpansionTile extends StatefulWidget {
  const CustomDropdownMenuExpansionTile(
      {Key? key,
      required this.title,
      this.backgroundColor,
      this.onExpansionChanged,
      this.children = const <Widget>[],
      this.initiallyExpanded = false,
      this.maintainState = false,
      this.tilePadding,
      this.expandedCrossAxisAlignment,
      this.expandedAlignment,
      this.childrenPadding,
      this.icon,
      this.handleTap})
      : assert(
          expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
          '''CrossAxisAlignment.baseline is not supported since the expanded children
          are aligned in a column, not a row. Try to use another constant.''',
        ),
        super(key: key);

  final Widget title;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Color? backgroundColor;
  final bool initiallyExpanded;
  final bool maintainState;
  final EdgeInsetsGeometry? tilePadding;
  final Alignment? expandedAlignment;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final String? icon;
  final VoidCallback? handleTap;

  @override
  CustomDropdownMenuExpansionTileState createState() =>
      CustomDropdownMenuExpansionTileState();
}

class CustomDropdownMenuExpansionTileState
    extends State<CustomDropdownMenuExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!_isExpanded);
  }

  //added to programmatically collapse & expand the tile
  void _setExpanded(bool isExpanded) {
    if (_isExpanded != isExpanded) {
      setState(() {
        _isExpanded = isExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            setState(() {
              // Rebuild without widget.children.
            });
          });
        }
        PageStorage.of(context)?.writeState(context, _isExpanded);
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_isExpanded);
      }
    }
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isExpanded);
    }
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: GestureDetector(
              onTap: widget.handleTap ?? _handleTap,
              child: Container(
                decoration: const BoxDecoration(),
                child: Row(
                  children: [
                    widget.icon == null
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset(widget.icon!),
                              const SizedBox(
                                width: 12,
                              ),
                            ],
                          ),
                    widget.title,
                    const Spacer(),
                    Opacity(
                      opacity: .4,
                      child: RotationTransition(
                        turns: _iconTurns,
                        child: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment ?? Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subtitle1!.color
      ..end = theme.colorScheme.secondary;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.colorScheme.secondary;
    _backgroundColorTween.end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
        child: TickerMode(
          child: Padding(
            padding: widget.childrenPadding ?? EdgeInsets.zero,
            child: Column(
              crossAxisAlignment:
                  widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.start,
              children: [
                Divider(
                  thickness: 1,
                  height: 3,
                  color: Color(0xFFBDBDBD).withOpacity(.34),
                ),
                ...widget.children
              ],
            ),
          ),
          enabled: !closed,
        ),
        offstage: closed);

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}

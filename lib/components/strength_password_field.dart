import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _kAnimationDuration = const Duration(milliseconds: 200);
const _kAnimationCurve = Curves.decelerate;
const _kMinHeigth = 80.0;

const _kLabelColor = const Color(0xFFCECED1);
const _kLabelColouMoved = Color(0xFF989898);

const _kStrongColor = const Color(0xFF5ECA3C);
const _kMediumColor = const Color(0xFFFFA800);
const _kWeakColor = const Color(0xFFDA1111);

const _kStrongColorGradient = const LinearGradient(
    colors: [Color(0xFF3D8DF3), Color(0xFF81DBF8), _kStrongColor]);
const _kMediumColorGradient = const LinearGradient(
    colors: [Color(0xFFFFB800), _kMediumColor, Color(0xFF3F8FF3)]);
const _kWeakColorGradient = const LinearGradient(
    colors: [_kWeakColor, Color(0xFFFF0000), Color(0xFFFFB800)]);

const _kStrongLabel = 'Strong Password';
const _kMediumLabel = 'Medium Password';
const _kWeakLabel = 'Weak Password';

class StrengthField extends StatefulWidget {
  ///This custom text fied is based on [TextField] and displays
  ///in an animated way how strong the password entered is.
  ///
  ///This is based on the folowing:
  /// * Password is defined as being weak if the length is less than 4.
  /// * Password is defined to be of medium strength if the length is at least 4 but less than 7.
  /// * Password is defined to be strong if the length is at least 7.
  const StrengthField({
    Key? key,
    required this.label,
    required this.onChanged,
    this.controller,
  }) : super(key: key);

  ///Label represents what will be shown as a
  ///placholdler when the field is empty or not in focus. Must not be [null].
  final String label;

  ///TextEditingController to be passed on for finer control.
  final TextEditingController? controller;

  ///Method called every time there is a change in the text field.
  final Function(String) onChanged;
  @override
  _StrengthFieldState createState() => _StrengthFieldState();
}

class _StrengthFieldState extends State<StrengthField> {
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _controller;

  bool _labelMoved = false;
  _PasswordState _passwordStrengthState = _PasswordState.empty;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _focusNode.dispose();

    // Dispose the controler only if this widget created one and none was provided,
    // otherwse we let the disposing of the controller in the parent widget
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  ///This method gets caled each time there is a change in the teext field.
  ///After setting the current password state based on the provided value, [widget.onChanged] will be called.
  void _onChangeHandler(String value) {
    var state = _PasswordState.empty;
    if (value.length > 0 && value.length < 4) {
      state = _PasswordState.weak;
    } else if (value.length >= 4 && value.length < 7) {
      state = _PasswordState.medium;
    } else if (value.length >= 7) {
      state = _PasswordState.strong;
    }
    setState(() {
      _passwordStrengthState = state;
    });
    widget.onChanged(value);
  }

  ///Returns the correct gradient color based on [_passwordStrengthState].
  LinearGradient? get _stateGradientColor {
    switch (_passwordStrengthState) {
      case _PasswordState.weak:
        return _kWeakColorGradient;
      case _PasswordState.medium:
        return _kMediumColorGradient;
      case _PasswordState.strong:
        return _kStrongColorGradient;
      default:
        return null;
    }
  }

  ///Returns the correct labe color based on [_passwordStrengthState].
  Color? get _stateLabelColor {
    switch (_passwordStrengthState) {
      case _PasswordState.weak:
        return _kWeakColor;
      case _PasswordState.medium:
        return _kMediumColor;
      case _PasswordState.strong:
        return _kStrongColor;
      default:
        return null;
    }
  }

  ///Returns the correct password strenghtness label based on [_passwordStrengthState].
  String _stateLabel(BuildContext context) {
    ///At the moment the labels are hard coded.
    ///We pass the context so that later on we can internationalise it
    ///with ease using intl package, where ccontext is required. i.e., S.of(context).weakPassword;
    switch (_passwordStrengthState) {
      case _PasswordState.weak:
        return _kWeakLabel;
      case _PasswordState.medium:
        return _kMediumLabel;
      case _PasswordState.strong:
        return _kStrongLabel;
      default:
        return '';
    }
  }

  ///The node listener will let us know when the text field has/does not have focus.
  ///With this we can update whenever the label will animate.
  void _focusNodeListener() {
    final labelShouldMove = _controller.text.isNotEmpty || _focusNode.hasFocus;
    setState(() => _labelMoved = labelShouldMove);
  }

  ///This method returns the animated label shown above the text field.
  ///When the [TextField] is in focus or not empty, the label will animate.
  Widget _animatedLabel() {
    final lalbelAlignment =
        _labelMoved ? Alignment.topLeft : Alignment.centerLeft;
    final labelFontSize = _labelMoved ? 16.0 : 20.0;
    final labelColor = _labelMoved ? _kLabelColouMoved : _kLabelColor;
    final labelTextStyle =
        TextStyle(color: labelColor, fontSize: labelFontSize);

    return Container(
      constraints: BoxConstraints(minHeight: _kMinHeigth),
      child: AnimatedAlign(
        duration: _kAnimationDuration,
        curve: _kAnimationCurve,
        alignment: lalbelAlignment,
        child: AnimatedDefaultTextStyle(
          duration: _kAnimationDuration,
          curve: _kAnimationCurve,
          style: labelTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: Text(widget.label),
        ),
      ),
    );
  }

  ///This method returns the animated line and password's level of strenghtness label.
  ///The line and label will be shown when the current password
  ///state is [_PasswordState.weak], [_PasswordState.medium] and [_PasswordState.strong].
  Widget _animatedLine() {
    final lineHeigth = _stateGradientColor != null ? 4.0 : 0.0;
    final height = _kMinHeigth + 18;
    final lineContainer = AnimatedContainer(
      duration: _kAnimationDuration,
      curve: _kAnimationCurve,
      height: lineHeigth,
      decoration: BoxDecoration(
          gradient: _stateGradientColor,
          borderRadius: BorderRadius.circular(24)),
    );

    final lineLabel = Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AnimatedDefaultTextStyle(
        duration: _kAnimationDuration,
        curve: _kAnimationCurve,
        style: TextStyle(
          color: _stateLabelColor,
          fontWeight: FontWeight.bold,
        ),
        child: Text(_stateLabel(context)),
      ),
    );

    return Container(
      height: height,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [lineContainer, lineLabel],
        ),
      ),
    );
  }

  ///This method returns a text field with a checkmark displayed only when the current password state is [_PasswordState.strong].
  Widget _textField() {
    final bool displayCheckmark =
        _passwordStrengthState == _PasswordState.strong;
    final suffixIcon = displayCheckmark
        ? Icon(
            CupertinoIcons.checkmark_alt_circle_fill,
            color: _kStrongColor,
            size: 28,
          )
        : Container(height: 28, width: 28);

    return TextField(
      focusNode: _focusNode,
      obscureText: true,
      controller: _controller,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon: AnimatedSwitcher(
            duration: _kAnimationDuration,
            switchInCurve: _kAnimationCurve,
            switchOutCurve: _kAnimationCurve,
            child: suffixIcon),
      ),
      onChanged: _onChangeHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            _animatedLabel(),
            _textField(),
            _animatedLine(),
          ],
        ),
      ],
    );
  }
}

enum _PasswordState { empty, weak, medium, strong }

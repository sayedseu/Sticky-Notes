import 'package:flutter/material.dart';

class LoadingButton extends CustomRaisedButton {
  LoadingButton({
    Key key,
    @required String text,
    Color color = Colors.indigo,
    @required VoidCallback onPressed,
    Color textColor = Colors.white,
    double height = 50.0,
    bool loading = false,
  }) : super(
          key: key,
          child: Text(text, style: TextStyle(color: textColor, fontSize: 20.0)),
          color: color,
          textColor: textColor,
          height: height,
          borderRadius: 8,
          onPressed: onPressed,
          loading: loading,
        );
}

@immutable
class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({
    Key key,
    @required this.child,
    this.color,
    this.textColor,
    this.height = 50.0,
    this.borderRadius = 2.0,
    this.loading = false,
    this.onPressed,
  }) : super(key: key);
  final Widget child;
  final Color color;
  final Color textColor;
  final double height;
  final double borderRadius;
  final bool loading;
  final VoidCallback onPressed;

  Widget buildSpinner(BuildContext context) {
    final ThemeData data = Theme.of(context);
    return Theme(
      data: data.copyWith(accentColor: Colors.white70),
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: loading ? buildSpinner(context) : child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        // height / 2
        color: color,
        disabledColor: color,
        textColor: textColor,
        onPressed: onPressed,
      ),
    );
  }
}
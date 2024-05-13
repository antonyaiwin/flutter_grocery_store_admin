import 'package:flutter/material.dart';

class BaseKeepAlivePage extends StatefulWidget {
  const BaseKeepAlivePage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  _BaseKeepAlivePageState createState() => _BaseKeepAlivePageState();
}

class _BaseKeepAlivePageState extends State<BaseKeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

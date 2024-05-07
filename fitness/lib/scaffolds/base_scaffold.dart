import 'package:fitness/navbar/navbar.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold(
      {super.key, required this.body, this.appBar, this.showNavbar = true, });

  final Widget body;
  final AppBar? appBar;
  final bool showNavbar;

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  String _currentRoute = "/home";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _currentRoute = ModalRoute.of(context)?.settings.name ?? "/home";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: widget.appBar,
      body: widget.body,
      bottomNavigationBar: widget.showNavbar ? Hero(
        tag: "navbar",
        child: Navbar(
          currentRoute: _currentRoute,
        ),
      ) : null,
    );
  }
}

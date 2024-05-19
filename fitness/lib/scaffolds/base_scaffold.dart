import 'package:fitness/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.showNavbar = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true, 
  });

  final bool resizeToAvoidBottomInset;
  final Widget body;
  final AppBar? appBar;
  final bool showNavbar;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation; 

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
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation, 
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      bottomNavigationBar: widget.showNavbar
          ? Hero(
              tag: "navbar",
              child: Navbar(
                currentRoute: _currentRoute,
              ),
            )
          : null,
    );
  }
}
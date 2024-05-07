import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key, required this.currentRoute});

  final String currentRoute;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String? currentRoute;

  @override
  void initState() {
    super.initState();

    currentRoute = widget.currentRoute;
  }

  final List<String> _routeNames = [
    '/home',
    '/recepten',
    '/location',
    '/chat',
  ];

  int? getRouteIndex() {
    for (String route in _routeNames) {
      if (currentRoute == null) return 0;
      if (currentRoute!.startsWith(route)) {
        return _routeNames.indexOf(route);
      }
    }
  }

  void attemptPush(int index) {
    String goal = _routeNames[index];
    if (currentRoute == goal) return; // Don't push if already on the route
    if (currentRoute!.startsWith(goal)) {
      Navigator.pop(context); // We are on a subroute, pop one route back
      return;
    }
    // Push as a replacement
    Navigator.pushReplacementNamed(context, _routeNames[index]);
  }

  TextStyle _getTextStyle(BuildContext context, bool isSelected) {
    final color =
        isSelected ? Theme.of(context).colorScheme.surface : Colors.white;
    return (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
        .copyWith(color: color);
  }

  IconThemeData _getIconThemeData(BuildContext context, bool isSelected) {
    final color =
        isSelected ? Theme.of(context).colorScheme.surface : Colors.white;
    return IconThemeData(color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (states) =>
                _getTextStyle(context, states.contains(MaterialState.selected)),
          ),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
            (states) => _getIconThemeData(
                context, states.contains(MaterialState.selected)),
          ),
        ),
      ),
      child: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        indicatorColor: Theme.of(context).colorScheme.secondary,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_sharp),
            label: 'Recepten',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            label: 'Locatie Product',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            label: 'assitent',
          ),
        ],
        selectedIndex: getRouteIndex() ?? 0,
        onDestinationSelected: attemptPush,
      ),
    );
  }
}

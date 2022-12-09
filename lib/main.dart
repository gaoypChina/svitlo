import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/points_provider.dart';
import 'screens/map_screen.dart';
import 'widgets/active_dot.dart';
import 'widgets/fav_button.dart';
import 'widgets/graph_popup.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PointsProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SvitloApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {MapScreen.routeName: (_) => const MapScreen()},
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<PointsProvider>(
      builder: ((context, value, child) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () => Navigator.of(context).pushNamed(MapScreen.routeName),
                )
              ],
              title: const Text('Де світло'),
            ),
            body: Center(
              child: getList(value),
            )

            // },
            );
      }),
    );
  }

  Widget getList(PointsProvider pp) {
    if (pp.points.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: (() => pp.getchAndSet()),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (__) => GraphPopup(point: pp.points[index]),
              );
            },
            title: Text(pp.points[index].hostName),
            leading: ActiveDot(size: 16, active: pp.points[index].active),
            trailing: FavButton(
              favourite: pp.isFav(pp.points[index].hostId),
              onTap: () => pp.favTap(pp.points[index].hostId),
            ),
          );
        },
        itemCount: pp.points.length,
      ),
    );
  }
}

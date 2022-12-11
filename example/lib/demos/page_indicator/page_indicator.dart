/// roipeker 2020
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class PageIndicatorMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget buildPageIndicator() {
      return Center(
        child: Container(
          width: 100,
          height: 20,
          padding: EdgeInsets.all(4),
          color: Colors.grey.shade200,
          child: SceneBuilderWidget(
            builder: () => SceneController(
              front: PageIndicatorPaged(),
              config: SceneConfig.games,
            ),
            autoSize: true,
          ),
        ),
      );
    }

    /// sample 1, force the amount of Scenes to test
    // final body = SingleChildScrollView(
    //   child: Column(
    //     children: List.generate(10, (index) => buildPageIndicator()),
    //   ),
    // );

    /// sample 2, ListView builder lazily creates as you scroll.
    final body =
        ListView.builder(itemBuilder: (_, index) => buildPageIndicator());

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('page indicator (use keyboard Tab+arrows to move pages)'),
          elevation: 0,
          backgroundColor: Colors.black26,
        ),
        body: body);
  }
}

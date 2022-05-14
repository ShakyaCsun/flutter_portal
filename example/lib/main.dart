import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_portal/flutter_portal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Scaffold(
          body: Center(
            child: Grid(),
          ),
        ),
      ),
    );
  }
}

class Grid extends StatefulWidget {
  const Grid({super.key});

  @override
  GridState createState() => GridState();
}

class GridState extends State<Grid> {
  int selectedIndex = 1;
  // final key = GlobalKey();

  void _detectTapedItem(PointerEvent event) {
    final box = context.findRenderObject() as RenderBox?;
    final result = BoxHitTestResult();
    final local = box?.globalToLocal(event.position);
    if (local != null) {
      if (box?.hitTest(result, position: local) ?? false) {
        for (final hit in result.path) {
          /// temporary variable so that the [is] allows access of [index]
          final target = hit.target;
          if (target is _Foo) {
            final index = target.index;
            _selectIndex(index);
          }
        }
      }
    }
  }

  void _selectIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _detectTapedItem,
      onPointerMove: _detectTapedItem,
      behavior: HitTestBehavior.translucent,
      child: GridView.builder(
        // key: key,
        itemCount: 6,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Foo(
            index: index,
            child: Bar(
              index: index,
              selected: selectedIndex == index,
              child: ColoredBox(
                color: selectedIndex == index ? Colors.red : Colors.blue,
                child: const SizedBox.expand(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Bar extends StatelessWidget {
  const Bar({
    super.key,
    required this.selected,
    required this.index,
    required this.child,
  });

  final bool selected;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: selected,
      anchor: const Aligned(
        follower: Alignment.center,
        target: Alignment.center,
        widthFactor: 1.2,
        heightFactor: 1.2,
      ),
      behavior: HitTestBehavior.translucent,
      portalFollower: child,
      child: child,
    );
  }
}

class Foo extends SingleChildRenderObjectWidget {
  const Foo({super.child, required this.index, super.key}) : super();
  final int index;

  @override
  _Foo createRenderObject(BuildContext context) {
    return _Foo(index);
  }

  @override
  void updateRenderObject(BuildContext context, _Foo renderObject) {
    renderObject.index = index;
  }
}

class _Foo extends RenderProxyBox {
  _Foo(this.index);
  int index;
}

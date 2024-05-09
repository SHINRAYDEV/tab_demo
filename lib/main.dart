import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const kPageTitle = 'Settings';
List<String> kLabels = [
  "Edit Profile",
  "Accounts",
  "Security",
  "Notifications",
  "Privacy",
  "Activity",
  "Display",
  "Sound",
  "Accessibility"
];
const kTabBgColor = Color(0xFF8F32A9);
const kTabFgColor = Colors.white;

void main() {
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xFF5046AF)),
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends HookWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = useTabController(initialLength: kLabels.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text(kPageTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          MyTabBar(
            controller: _controller,
            labels: kLabels,
            backgroundColor: kTabBgColor,
            foregroundColor: kTabFgColor,
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children:
              kLabels.map((label) => Center(child: Text(label))).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MyTabBar extends HookWidget {
  final TabController controller;
  final List<String> labels;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? activeBackgroundColor;
  final Color? activeForegroundColor;
  final double? fontSize;

  const MyTabBar({
    super.key,
    required this.controller,
    required this.labels,
    required this.backgroundColor,
    required this.foregroundColor,
    this.activeBackgroundColor,
    this.activeForegroundColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final _activeIndex = useState(0);
    useEffect(() {
      controller.addListener(() {
        _activeIndex.value = controller.index;
      });
      return null;
    }, [controller]);

    List<Widget> tabs = labels.asMap().entries.map((entry) {
      final index = entry.key;
      final label = entry.value;
      final active = _activeIndex.value == index;
      return Positioned(
        key: ValueKey(index),
        left: index * 120.0,
        child: MyTab(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          activeBackgroundColor: activeBackgroundColor,
          activeForegroundColor: activeForegroundColor,
          fontSize: fontSize,
          active: active,
          label: label,
          onTap: () {
            controller.animateTo(index);
          },
        ),
      );
    }).toList();

    // 将激活的标签放到最后以确保其在最上层
    tabs.sort((a, b) {
      final aKey = a.key as ValueKey<int>;
      final bKey = b.key as ValueKey<int>;
      if (aKey.value == _activeIndex.value) {
        return 1;
      }
      if (bKey.value == _activeIndex.value) {
        return -1;
      }
      return 0;
    });

    return Container(
      color: Theme.of(context).primaryColor,
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: labels.length * 120.0, // 确保 SizedBox 宽度足以包含所有标签
          child: Stack(
            children: tabs,
          ),
        ),
      ),
    );
  }
}

class MyTab extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? activeBackgroundColor;
  final Color? activeForegroundColor;
  final double? fontSize;
  final bool active;
  final String label;
  final VoidCallback? onTap;

  const MyTab({
    super.key,
    this.active = false,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.activeBackgroundColor,
    this.activeForegroundColor,
    this.fontSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: active ? 40 : 32,
        width: 120, // 设置宽度以确保标签可以部分重叠
        alignment: Alignment.bottomLeft,
        child: CustomPaint(
          painter: active ? ActiveTabPainter() : InactiveTabPainter(),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  color: active ? Colors.black : Colors.white,
                  fontSize: fontSize),
            ),
          ),
        ),
      ),
    );
  }
}

class ActiveTabPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 8);
    path_0.cubicTo(0, 3.58172, 3.58172, 0, 8, 0);
    path_0.lineTo(117.717, 0);
    path_0.cubicTo(121.405, 0, 124.615, 2.5213, 125.489, 6.10435);
    path_0.lineTo(134, 41);
    path_0.lineTo(0, 41);
    path_0.lineTo(0, 8);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class InactiveTabPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 8);
    path_0.cubicTo(0, 3.58172, 3.58172, 0, 8, 0);
    path_0.lineTo(117.919, 0);
    path_0.cubicTo(121.513, 0, 124.666, 2.39629, 125.627, 5.85885);
    path_0.lineTo(134, 36);
    path_0.lineTo(0, 36);
    path_0.lineTo(0, 8);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffE6E6E6).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

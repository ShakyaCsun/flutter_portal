import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

// A minimalistic date picker

void main() => runApp(const MyApp());

class DeclarativeDatePicker extends StatelessWidget {
  const DeclarativeDatePicker({
    super.key,
    required this.visible,
    required this.onDismissed,
    required this.onClose,
    required this.child,
  });

  final bool visible;
  final Widget child;
  final VoidCallback onDismissed;
  final void Function(DateTime date) onClose;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      portalFollower: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              child: ModalBarrier(color: Colors.black38),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismissed,
            child: Center(
              child: Card(
                elevation: 16,
                child: ElevatedButton(
                  onPressed: () => onClose(DateTime.now()),
                  child: const Text('today'),
                ),
              ),
            ),
          )
        ],
      ),
      child: child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Example')),
          body: LayoutBuilder(
            builder: (_, __) {
              return LayoutBuilder(
                builder: (_, __) {
                  return const DatePickerUsageExample();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class DatePickerUsageExample extends StatefulWidget {
  const DatePickerUsageExample({super.key});

  @override
  State<DatePickerUsageExample> createState() => _DatePickerUsageExampleState();
}

class _DatePickerUsageExampleState extends State<DatePickerUsageExample> {
  DateTime? pickedDate;
  bool showDatePicker = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DeclarativeDatePicker(
        visible: showDatePicker,
        onClose: (date) => setState(() {
          showDatePicker = false;
          pickedDate = date;
        }),
        onDismissed: () => setState(() => showDatePicker = false),
        child: pickedDate == null
            ? ElevatedButton(
                onPressed: () => setState(() => showDatePicker = true),
                child: const Text('pick a date'),
              )
            : Text('The date picked: $pickedDate'),
      ),
    );
  }
}

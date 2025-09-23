
// ---------------- Reusable Widgets ----------------
import 'package:flutter/material.dart';

class SelectionCard<T> extends StatelessWidget {
  final T value;
  final T? selectedValue;
  final String title;
  final VoidCallback onTap;

  const SelectionCard({
  super.key,
  required this.value,
  required this.selectedValue,
  required this.title,
  required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
        ),
      ),
    );
  }
  }



class MultiSelectCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MultiSelectCard({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.blue[50] : Colors.white,
          border: Border.all(color: selected ? Colors.blue : Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.blue : Colors.black)),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// ---------------- Single Selection Card ----------------
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        elevation: isSelected ? 4 : 1,
        shadowColor: Colors.black26,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          splashColor: Colors.blue.withOpacity(0.2),
          highlightColor: Colors.blue.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isSelected ? Colors.blue[50] : Colors.white,
              border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.black87,
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Multi Selection Card (Updated) ----------------
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        elevation: selected ? 4 : 1,
        shadowColor: Colors.black26,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          splashColor: Colors.blue.withOpacity(0.2),
          highlightColor: Colors.blue.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: selected ? Colors.blue[50] : Colors.white,
              border: Border.all(color: selected ? Colors.blue : Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.blue : Colors.black87,
                      fontSize: 15,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: selected
                      ? const Icon(
                    Icons.check_circle_outline,
                    color: Colors.blue,
                    size: 20,
                  )
                      : const SizedBox(width: 20, height: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../utils/profile_setup_data.dart'; // Your enums and extensions

class FinancialStep extends StatelessWidget {
  final FinancialBackground? selectedBackground;
  final Function(FinancialBackground) onSelect;

  const FinancialStep({
    super.key,
    required this.selectedBackground,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: FinancialBackground.values.map((fb) {
        final isSelected = selectedBackground == fb;

        return GestureDetector(
          onTap: () => onSelect(fb),
          child: Container(
            width: double.infinity, // Make the tile full width
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[50] : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fb.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  fb.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );

  }
}

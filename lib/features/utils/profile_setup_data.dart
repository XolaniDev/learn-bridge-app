final List<String> provinces = [
  "Limpopo",
  "Gauteng",
  "Mpumalanga",
  "KwaZulu-Natal",
  "Eastern Cape",
  "Western Cape",
  "Northern Cape",
  "Free State",
  "North West"
];



enum Grade {
  grade7("Grade 7"),
  grade8("Grade 8"),
  grade9("Grade 9"),
  grade10("Grade 10"),
  grade11("Grade 11");

  final String displayName;
  const Grade(this.displayName);
}

const List<String> financialBackgroundOptions = [
  "Low Income",
  "Middle Income",
  "High Income",
];

enum FinancialBackground {
  low("Low", "Limited financial resources"),
  medium("Medium", "Moderate financial resources"),
  high("High", "Strong financial resources");

  final String displayName;
  final String description;

  const FinancialBackground(this.displayName, this.description);

  static FinancialBackground? fromString(String name) {
    try {
      return FinancialBackground.values.firstWhere(
            (e) => e.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

}

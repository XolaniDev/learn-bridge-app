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
  grade8("Grade 8"),
  grade9("Grade 9"),
  grade10("Grade 10"),
  grade11("Grade 11"),
  grade12("Grade 12");

  final String displayName;
  const Grade(this.displayName);
}

enum FinancialBackground {
  low("Low", "Limited financial resources"),
  medium("Medium", "Moderate financial resources"),
  high("High", "Strong financial resources");

  final String displayName;
  final String description; // ✅ add this

  const FinancialBackground(this.displayName, this.description);
}


// ---------------- Enum Extensions ----------------
// extension GradeExtension on Grade {
//   String get displayName {
//     switch (this) {
//       case Grade.g7: return "Grade 7";
//       case Grade.g8: return "Grade 8";
//       case Grade.g9: return "Grade 9";
//     }
//   }
// }
//
// extension FinancialExtension on FinancialBackground {
//   String get displayName {
//     switch (this) {
//       case FinancialBackground.low: return "Low Income Family";
//       case FinancialBackground.medium: return "Medium Income Family";
//       case FinancialBackground.high: return "High Income Family";
//     }
//   }
//
//   String get description {
//     switch (this) {
//       case FinancialBackground.low:
//         return "Access to maximum funding opportunities";
//       case FinancialBackground.medium:
//         return "Access to most funding opportunities";
//       case FinancialBackground.high:
//         return "Access to merit-based opportunities";
//     }
//   }
// }
//
// extension ProvinceExtension on Province {
//   String get displayName {
//     switch (this) {
//       case Province.easternCape: return "Eastern Cape";
//       case Province.freeState: return "Free State";
//       case Province.gauteng: return "Gauteng";
//       case Province.kwazuluNatal: return "KwaZulu-Natal";
//       case Province.limpopo: return "Limpopo";
//       case Province.mpumalanga: return "Mpumalanga";
//       case Province.northernCape: return "Northern Cape";
//       case Province.northWest: return "North West";
//       case Province.westernCape: return "Western Cape";
//     }
//   }
// }
enum Grade { g7, g8, g9 }
enum FinancialBackground { low, medium, high }
enum Province {
  easternCape,
  freeState,
  gauteng,
  kwazuluNatal,
  limpopo,
  mpumalanga,
  northernCape,
  northWest,
  westernCape
}


// ---------------- Enum Extensions ----------------
extension GradeExtension on Grade {
  String get displayName {
    switch (this) {
      case Grade.g7: return "Grade 7";
      case Grade.g8: return "Grade 8";
      case Grade.g9: return "Grade 9";
    }
  }
}

extension FinancialExtension on FinancialBackground {
  String get displayName {
    switch (this) {
      case FinancialBackground.low: return "Low Income Family";
      case FinancialBackground.medium: return "Medium Income Family";
      case FinancialBackground.high: return "High Income Family";
    }
  }

  String get description {
    switch (this) {
      case FinancialBackground.low:
        return "Access to maximum funding opportunities";
      case FinancialBackground.medium:
        return "Access to most funding opportunities";
      case FinancialBackground.high:
        return "Access to merit-based opportunities";
    }
  }
}

extension ProvinceExtension on Province {
  String get displayName {
    switch (this) {
      case Province.easternCape: return "Eastern Cape";
      case Province.freeState: return "Free State";
      case Province.gauteng: return "Gauteng";
      case Province.kwazuluNatal: return "KwaZulu-Natal";
      case Province.limpopo: return "Limpopo";
      case Province.mpumalanga: return "Mpumalanga";
      case Province.northernCape: return "Northern Cape";
      case Province.northWest: return "North West";
      case Province.westernCape: return "Western Cape";
    }
  }
}
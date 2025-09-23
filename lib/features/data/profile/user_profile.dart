// ---------------- UserProfile Model ----------------


import '../../pages/profile_page/profile_setup_page.dart';
import '../../utils/profile_setup_data.dart';

class UserProfile {
  Grade? grade;
  List<String> subjects;
  List<String> interests;
  FinancialBackground? financialBackground;
  Province? province;

  UserProfile({
    this.grade,
    List<String>? subjects,
    List<String>? interests,
    this.financialBackground,
    this.province,
  })  : subjects = subjects ?? [],
        interests = interests ?? [];
}

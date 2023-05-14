enum QualificationDegree {
  ca("CA"),
  cs("CS"),
  icwa("ICWA"),
  other("Other");

  final String title;
  const QualificationDegree(this.title);
}

enum QualificationUniversity {
  icai("ICAI"),
  icsi("ICSI"),
  icwa("ICWA"),
  barCounsilOfIndia("BAR COUNSIL OF INDIA"),
  other("Other");

  final String title;
  const QualificationUniversity(this.title);
}

enum YearsQualification {
  year2001("2001"),
  year2002("2002"),
  year2003("2003");

  final String title;
  const YearsQualification(this.title);
}

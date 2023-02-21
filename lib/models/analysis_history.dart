class AnalysisHistory {
  final String id;
  final String imagePath;
  final String? jerawatResult;
  final String? keriputResult;
  final String? kemerahanResult;
  final String? bercakHitamResult;
  final String? jenisKulitResult;
  final String date;

  AnalysisHistory({
    required this.id,
    required this.imagePath,
    this.jerawatResult,
    this.keriputResult,
    this.kemerahanResult,
    this.bercakHitamResult,
    this.jenisKulitResult,
    required this.date,
  });
}

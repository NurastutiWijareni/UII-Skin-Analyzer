class DeteksiModel {
  double? xmax;
  double? ymax;
  double? xmin;
  double? ymin;
  List<dynamic>? points;
  double? score;

  DeteksiModel({this.xmax, this.ymax, this.xmin, this.ymin, this.points, this.score});

  DeteksiModel.fromJson(Map<String, dynamic> json) {
    xmax = json['xmax'];
    ymax = json['ymax'];
    xmin = json['xmin'];
    ymin = json['ymin'];
    points = json['points'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['xmax'] = xmax;
    data['ymax'] = ymax;
    data['xmin'] = xmin;
    data['ymin'] = ymin;
    data['points'] = points;
    data['score'] = score;
    return data;
  }
}

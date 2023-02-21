class JSONResult {
  DeteksiObjek? deteksiObjek;

  JSONResult({this.deteksiObjek});

  JSONResult.fromJson(Map<String, dynamic> json) {
    deteksiObjek = json['deteksi_objek'] != null ? DeteksiObjek.fromJson(json['deteksi_objek']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (deteksiObjek != null) {
      data['deteksi_objek'] = deteksiObjek!.toJson();
    }
    return data;
  }
}

class DeteksiObjek {
  List<Jerawat>? jerawat;

  DeteksiObjek({this.jerawat});

  DeteksiObjek.fromJson(Map<String, dynamic> json) {
    if (json['jerawat'] != null) {
      jerawat = <Jerawat>[];
      json['jerawat'].forEach((v) {
        jerawat!.add(Jerawat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (jerawat != null) {
      data['jerawat'] = jerawat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Jerawat {
  double? xmax;
  double? ymax;
  double? xmin;
  double? ymin;
  double? score;

  Jerawat({this.xmax, this.ymax, this.xmin, this.ymin, this.score});

  Jerawat.fromJson(Map<String, dynamic> json) {
    xmax = json['xmax'];
    ymax = json['ymax'];
    xmin = json['xmin'];
    ymin = json['ymin'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['xmax'] = xmax;
    data['ymax'] = ymax;
    data['xmin'] = xmin;
    data['ymin'] = ymin;
    data['score'] = score;
    return data;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class MapData {
  // 1

  String? coord;
  String? img;
  String? title;
  // 2
  DocumentReference? reference;
  // 3
  MapData(this.title, {this.coord, this.img, this.reference});
  // 4
  factory MapData.fromJson(Map<dynamic, dynamic> json) => _MapFromJson(json);
  // 5
  Map<String, dynamic> toJson() => _MapToJson(this);
  @override
  String toString() => "Map<$title>";
}

MapData _MapFromJson(Map<dynamic, dynamic> json) {
  return MapData(
    json['title'] as String,
    coord : json['coord'] as String,
    img : json['img'] as String,
  );
}
//2
Map<String, dynamic> _MapToJson(MapData instance) =>
    <String, dynamic> {
      'title': instance.title,
      'coord': instance.coord,
      'img': instance.img,
    };

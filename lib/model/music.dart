import 'dart:convert';

import 'package:collection/collection.dart';

class MyMusicList {
  final List<MyMusic> music;
  MyMusicList({
    required this.music,
  });

  MyMusicList copyWith({
    List<MyMusic>? music,
  }) {
    return MyMusicList(
      music: music ?? this.music,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'music': music.map((x) => x.toMap()).toList(),
    };
  }

  factory MyMusicList.fromMap(Map<String, dynamic> map) {
    return MyMusicList(
      music: List<MyMusic>.from(map['music']?.map((x) => MyMusic.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MyMusicList.fromJson(String source) => MyMusicList.fromMap(json.decode(source));

  @override
  String toString() => 'MyMusicList(music: $music)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return other is MyMusicList &&
      listEquals(other.music, music);
  }

  @override
  int get hashCode => music.hashCode;
}

class MyMusic {
  final int id;
  final int order;
  final String name;
  final String tagline;
  final String color;
  final String desc;
  final String url;
  final String category;
  final String icon;
  final String image;
  final String lang;
  MyMusic({
    required this.id,
    required this.order,
    required this.name,
    required this.tagline,
    required this.color,
    required this.desc,
    required this.url,
    required this.category,
    required this.icon,
    required this.image,
    required this.lang,
  });

  MyMusic copyWith({
    int? id,
    int? order,
    String? name,
    String? tagline,
    String? color,
    String? desc,
    String? url,
    String? category,
    String? icon,
    String? image,
    String? lang,
  }) {
    return MyMusic(
      id: id ?? this.id,
      order: order ?? this.order,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      color: color ?? this.color,
      desc: desc ?? this.desc,
      url: url ?? this.url,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      lang: lang ?? this.lang,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order': order,
      'name': name,
      'tagline': tagline,
      'color': color,
      'desc': desc,
      'url': url,
      'category': category,
      'icon': icon,
      'image': image,
      'lang': lang,
    };
  }

  factory MyMusic.fromMap(Map<String, dynamic> map) {
    return MyMusic(
      id: map['id'],
      order: map['order'],
      name: map['name'],
      tagline: map['tagline'],
      color: map['color'],
      desc: map['desc'],
      url: map['url'],
      category: map['category'],
      icon: map['icon'],
      image: map['image'],
      lang: map['lang'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MyMusic.fromJson(String source) =>
      MyMusic.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MyMusic(id: $id, order: $order, name: $name, tagline: $tagline, color: $color, desc: $desc, url: $url, category: $category, icon: $icon, image: $image, lang: $lang)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyMusic &&
        other.id == id &&
        other.order == order &&
        other.name == name &&
        other.tagline == tagline &&
        other.color == color &&
        other.desc == desc &&
        other.url == url &&
        other.category == category &&
        other.icon == icon &&
        other.image == image &&
        other.lang == lang;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        order.hashCode ^
        name.hashCode ^
        tagline.hashCode ^
        color.hashCode ^
        desc.hashCode ^
        url.hashCode ^
        category.hashCode ^
        icon.hashCode ^
        image.hashCode ^
        lang.hashCode;
  }
}

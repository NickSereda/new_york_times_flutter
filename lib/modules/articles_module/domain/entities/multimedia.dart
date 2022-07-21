import 'package:freezed_annotation/freezed_annotation.dart';

part 'multimedia.freezed.dart';
part 'multimedia.g.dart';

/// Multimedia article item, part of [ArticleModel].

@freezed
class Multimedia with _$Multimedia {
    const factory Multimedia({
      @JsonKey(name: "url") String? url,
      @JsonKey(name: "caption") String? caption,
    }) = _Multimedia;

    factory Multimedia.fromJson(Map<String, dynamic> json) =>
        _$MultimediaFromJson(json);

}

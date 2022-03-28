import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ServiceCostType {
  @JsonValue("actual")
  actual,
  @JsonValue("forecasted")
  forecasted
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';

import '../../models/all.dart';

dynamic valueUnwrapped(AttributeValue? original) {
  if (original == null || original.nullValue == true) return null;
  return (original.nullValue == true)
      ? null
      : original.b ??
          original.boolValue ??
          original.bs ??
          original.n ??
          original.ns ??
          original.s ??
          original.ss ??
          original.l?.map((e) => valueUnwrapped(e)).toList() ??
          (original.m != null
              ? normalizeMap(original.m as Map<String, AttributeValue>)
              : null);
}

AttributeValue valueWrapped<T>(T? original) {
  if (original == null) {
    return AttributeValue(nullValue: true);
  } else if (original is ByteBuffer) {
    return AttributeValue(b: original.asUint8List());
  } else if (original is ByteData) {
    return AttributeValue(b: original.buffer.asUint8List());
  } else if (original is List<ByteBuffer>) {
    return AttributeValue(bs: original.map((e) => e.asUint8List()).toList());
  } else if (original is List<ByteData>) {
    return AttributeValue(
        bs: original.map((e) => e.buffer.asUint8List()).toList());
  } else if (original is bool) {
    return AttributeValue(boolValue: original);
  } else if (original is num) {
    return AttributeValue(n: original.toString());
  } else if (original is List<num>) {
    return AttributeValue(ns: original.map((e) => e.toString()).toList());
  } else if (original is String) {
    return AttributeValue(s: original);
  } else if (original is List<String>) {
    return AttributeValue(ss: original);
  } else if (original is List) {
    return AttributeValue(l: original.map((e) => valueWrapped(e)).toList());
  } else if (original is Map<String, dynamic>) {
    return AttributeValue(m: denormalizeMap(original));
  }

  throw ArgumentError("The original value is not supported.", "original");
}

Map<String, AttributeValue> denormalizeMap(Map<String, dynamic> original) {
  const converted = <String, AttributeValue>{};
  for (var key in original.keys) {
    converted[key] = valueWrapped(original[key]);
  }
  return converted;
}

Map<String, dynamic> normalizeMap(Map<String, AttributeValue> original) {
  const converted = <String, dynamic>{};
  for (var key in original.keys) {
    converted[key] = valueUnwrapped(original[key]);
  }
  return converted;
}

Map<String, dynamic>? recordDataToJson(
    Map<String, AttributeValue>? record, String? dataName) {
  if (record == null) return null;
  var data = dataName != null ? record[dataName]?.m : record;
  if (data == null) return null;
  return normalizeMap(data);
}

Map<String, AttributeValue> recordToKey(
    Todo record, String pkName, String skName, String pkValue) {
  var keyMap = <String, dynamic>{pkName: pkValue, skName: record.key};
  return denormalizeMap(keyMap);
}

Map<String, AttributeValue> makeFullKey(
    String pkName, String skName, String pkValue, String skValue) {
  var keyMap = <String, dynamic>{pkName: pkValue, skName: skValue};
  return denormalizeMap(keyMap);
}

Map<String, AttributeValue>? getStartKeyFromToken(
    String? token, String pkName, String skName) {
  if (token == null) return null;
  var keyRep = jsonDecode(utf8.decode(base64Decode(token)));
  var result = <String, AttributeValue>{
    pkName: AttributeValue(s: keyRep[pkName])
  };
  if (keyRep[skName] != null) {
    result[skName] = AttributeValue(s: keyRep[skName]);
  }

  return result;
}

String? getTokenFromStartKey(Map<String, AttributeValue>? key) {
  if (key == null) return null;
  return base64Encode(utf8.encode(jsonEncode(key)));
}

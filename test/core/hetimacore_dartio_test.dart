import 'package:unittest/unittest.dart' as unit;
import 'package:hetimacore/hetimacore.dart';
import 'package:hetimacore/hetimacore_dartio.dart';
import 'dart:async';
import 'dart:convert'; 

void main() {

  unit.test("arraybuilder: init", () async {
    HetimaDataDartIO io = new HetimaDataDartIO("./test/core/test.data");
    int l = await io.getLength();
    print("l = ${l}");
    ReadResult r = await io.read(0, l);
    String m = UTF8.decode(r.buffer);
    print("${m}");
  });
}
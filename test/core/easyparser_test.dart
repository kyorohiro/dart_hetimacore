import 'package:unittest/unittest.dart' as unit;
import 'dart:async' as async;
import 'package:hetimacore/hetimacore.dart';
import 'dart:convert' as convert;

void main() {
  unit.test("nextBuffer", () async {
    {
      ArrayBuilder b = new ArrayBuilder();
      b.appendIntList([1, 2, 3, 4, 5]);
      EasyParser parser = new EasyParser(b);
      List<int> bb = await parser.nextBuffer(3);
      unit.expect(bb, [1, 2, 3]);
    }
    {
      ArrayBuilder b = new ArrayBuilder();
      List<int> buffer = new List.filled(4, 0);
      List<int> out = [];
      b.appendIntList([1, 2, 3, 4, 5]);
      EasyParser parser = new EasyParser(b);
      List<int> bb = await parser.nextBuffer(3, buffer: buffer, outLength: out);
      unit.expect(bb, [1, 2, 3, 0]);
      unit.expect(out[0], 3);
    }
  });

  unit.test("nextString", () async {
    {
      ArrayBuilder b = new ArrayBuilder();
      b.appendString("abc");
      EasyParser parser = new EasyParser(b);
      String bb = await parser.nextString("abc");
      unit.expect(bb, "abc");
    }
    {
      ArrayBuilder b = new ArrayBuilder();
      List<int> buffer = new List.filled(4, 0);
      List<int> out = [];
      b.appendString("abc");
      EasyParser parser = new EasyParser(b);
      String bb = await parser.nextString("abc", buffer: buffer, outLength: out);
      unit.expect(bb, "abc");
      unit.expect(out[0], 3);
    }
  });

  unit.test("readSign", () async {
    {
      ArrayBuilder b = new ArrayBuilder();
      b.appendString("abc");
      EasyParser parser = new EasyParser(b);
      String bb = await parser.readSignWithLength(2);
      unit.expect(bb, "ab");
    }
    {
      ArrayBuilder b = new ArrayBuilder();
      List<int> buffer = new List.filled(4, 0);
      List<int> out = [];
      b.appendString("abcd");
      EasyParser parser = new EasyParser(b);
      String bb = await parser.readSignWithLength(4, buffer: buffer, outLength: out);
      unit.expect(bb, "abcd");
      unit.expect(out[0], 4);
    }
  });
}

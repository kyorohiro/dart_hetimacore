import 'package:unittest/unittest.dart' as unit;
import 'package:hetimacore/hetimacore.dart';
import 'package:hetimacore/hetimacore_dartio.dart';
import 'dart:async';
import 'dart:convert'; 

void main() {

  unit.test("arraybuilder: init", () async {
    {
      HetimaDataDartIO io = new HetimaDataDartIO("./test/core/test.data",erace:true);
      int l = await io.getLength();
      unit.expect(0, l);
      await io.write(UTF8.encode("abc"), 0);
      await io.write(UTF8.encode("def"), 3);
      io.close();
    }
    {
      HetimaDataDartIO io = new HetimaDataDartIO("./test/core/test.data");
      int l = await io.getLength();
      unit.expect(6, l);
      ReadResult r = await io.read(0, l);
      String m = UTF8.decode(r.buffer);
      unit.expect(m,"abcdef");
      io.close();
    }

    
  });
}
import 'package:unittest/unittest.dart' as unit;
import 'package:hetimacore/hetimacore.dart' as hetima;
import 'dart:async';

void main() {
  hetima.HetiTest test = new hetima.HetiTest("tt");

  unit.test("arraybuilder: init", () {
    hetima.ArrayBuilder builder = new hetima.ArrayBuilder();
    unit.expect(0, builder.size());
    unit.expect(0, builder.toList().length);
    unit.expect("", builder.toText());
  });

  unit.test("arraybuilder: senario", () {
    hetima.ArrayBuilder builder = new hetima.ArrayBuilder();
    builder.appendString("abc");
    unit.expect("abc", builder.toText());
    unit.expect(3, builder.toList().length);
    builder.appendString("abc");
    unit.expect("abcabc", builder.toText());
    unit.expect(6, builder.toList().length);
  });

  unit.test("arraybuilder: big/little", () {
    {
      List<int> ret = hetima.ByteOrder.parseLongByte(0xFF, hetima.ByteOrder.BYTEORDER_BIG_ENDIAN);
      unit.expect(ret[0], 0x00);
      unit.expect(ret[1], 0x00);
      unit.expect(ret[2], 0x00);
      unit.expect(ret[3], 0x00);
      unit.expect(ret[4], 0x00);
      unit.expect(ret[5], 0x00);
      unit.expect(ret[6], 0x00);
      unit.expect(ret[7], 0xFF);
      int v = hetima.ByteOrder.parseLong(ret, 0, hetima.ByteOrder.BYTEORDER_BIG_ENDIAN);
      unit.expect(v, 0xFF);
    }
    {
      List<int> ret = hetima.ByteOrder.parseIntByte(0xFF, hetima.ByteOrder.BYTEORDER_BIG_ENDIAN);
      unit.expect(ret[0], 0x00);
      unit.expect(ret[1], 0x00);
      unit.expect(ret[2], 0x00);
      unit.expect(ret[3], 0xFF);
      int v = hetima.ByteOrder.parseInt(ret, 0, hetima.ByteOrder.BYTEORDER_BIG_ENDIAN);
      unit.expect(v, 0xFF);
    }
    {
      List<int> ret = hetima.ByteOrder.parseShortByte(0xFF, hetima.ByteOrder.BYTEORDER_BIG_ENDIAN);
      unit.expect(ret[0], 0x00);
      unit.expect(ret[1], 0xFF);
      int v = hetima.ByteOrder.parseShort(ret, 0, hetima.ByteOrder.BYTEORDER_BIG_ENDIAN);
      unit.expect(v, 0xFF);
    }
  });

  unit.test("ArrayBuilderBuffer: ", () {
    hetima.ArrayBuilderBuffer buffer = new hetima.ArrayBuilderBuffer(5);
    unit.expect(5, buffer.length);

    buffer[0] = 1;
    buffer[1] = 2;
    buffer[2] = 3;
    buffer[3] = 4;
    buffer[4] = 5;

    buffer.clearInnerBuffer(3);

    unit.expect(0, buffer[0]);
    unit.expect(0, buffer[1]);
    unit.expect(0, buffer[2]);
    unit.expect(4, buffer[3]);
    unit.expect(5, buffer[4]);
    unit.expect(5, buffer.length);

    buffer.expand(10);
    buffer.clearInnerBuffer(4);
    unit.expect(0, buffer[0]);
    unit.expect(0, buffer[1]);
    unit.expect(0, buffer[2]);
    unit.expect(0, buffer[3]);
    unit.expect(5, buffer[4]);
    unit.expect(10, buffer.length);

    buffer[4] = 5;
    buffer[5] = 6;
    buffer[6] = 7;
    buffer[7] = 8;
    buffer[8] = 9;
    buffer[9] = 10;
    unit.expect(5, buffer[4]);
    unit.expect(6, buffer[5]);
    unit.expect(7, buffer[6]);
    unit.expect(8, buffer[7]);
    unit.expect(9, buffer[8]);
    unit.expect(10, buffer[9]);
    
    unit.expect([0,0,0,0,5,6,7,8,9,10], buffer.sublist(0, 10));
    unit.expect([0,0,5,6,7,8,9], buffer.sublist(2, 9));
    unit.expect([9], buffer.sublist(8, 9));
    unit.expect([], buffer.sublist(8, 8));
  });

  unit.test("ArrayBuilderBuffer: ", () {
    hetima.ArrayBuilderBuffer buffer = new hetima.ArrayBuilderBuffer(3);
    unit.expect(3, buffer.length);

    buffer[0] = 1;
    buffer[1] = 2;
    buffer[2] = 3;
    try {
      buffer[3] = 4;
      unit.expect(true, false);
    } catch (e) {
      unit.expect(true, true);
    }
    buffer.expand(5);
    buffer[3] = 4;
    buffer[4] = 5;
    unit.expect(2, buffer[1]);
    unit.expect(5, buffer[4]);
    unit.expect(5, buffer.length);
  });
  
  unit.test("ArrayBuilderBuffer: [2]", () async {
    hetima.ArrayBuilder builder = new hetima.ArrayBuilder();
    unit.expect(0, builder.size());

    bool isOK1 = false;
    bool isOK2 = false;
    builder.getByteFuture(5, 1).then((List<int > v) {
      unit.expect(builder.size(), 6);
      isOK1 = true;
    });
    await new Future(() {
      builder.appendByte(1);      
    });
    await new Future(() {
      builder.appendByte(2);      
    });
    await new Future(() {
      builder.appendByte(3);      
    });
    await new Future(() {
      builder.appendByte(4);      
    });
    await new Future(() {
      builder.appendByte(5);      
    });
    await new Future(() {
      builder.appendByte(6);      
    });
    
    builder.getByteFuture(8, 1).then((List<int > v) {
      unit.expect(v[0], 9);
      isOK2 = true;
    });
    await new Future(() {
      builder.appendIntList([7,8,9]);
    });
    
    return new Future(() {
    unit.expect(isOK1, true);
    unit.expect(isOK2, true);
    });
  });
  
  unit.test("ArrayBuilderBuffer: [2]", () async {
     hetima.ArrayBuilder builder = new hetima.ArrayBuilder();
     builder.getByteFuture(2, 3).then((List<int > v) {
       unit.expect(v.length, 2);
       unit.expect(3, v[0]);
       unit.expect(4, v[1]);
     });
     await new Future(() {
       builder.appendByte(1);      
     });
     await new Future(() {
       builder.appendByte(2);      
     });
     await new Future(() {
       builder.appendByte(3);      
     });
     await new Future(() {
       builder.appendByte(4);      
     });
     builder.fin();
   });

  unit.test("ArrayBuilderBuffer: [2]", () async {
     hetima.ArrayBuilder builder = new hetima.ArrayBuilder();
     List<int> buffer = new List<int>(1024);
     List<int> output = [];
     builder.getByteFuture(2, 3, buffer:buffer, output:output).then((List<int > v) {
       unit.expect(v.length, 1024);
       unit.expect(output[0], 2);
       unit.expect(3, v[0]);
       unit.expect(4, v[1]);
     });
     await new Future(() {
       builder.appendByte(1);      
     });
     await new Future(() {
       builder.appendByte(2);      
     });
     await new Future(() {
       builder.appendByte(3);      
     });
     await new Future(() {
       builder.appendByte(4);      
     });
     builder.fin();
   });
  
  unit.test("ArrayBuilderBuffer: [2]", () async {
     hetima.ArrayBuilder builder = new hetima.ArrayBuilder();
     List<int> buffer = new List<int>(1024);
     List<int> output = [1];
     builder.getByteFuture(2, 3, buffer:buffer, output:output).then((List<int > v) {
       unit.expect(v.length, 1024);
       unit.expect(output[0], 2);
       unit.expect(3, v[0]);
       unit.expect(4, v[1]);
     });
     await new Future(() {
       builder.appendByte(1);      
     });
     await new Future(() {
       builder.appendByte(2);      
     });
     await new Future(() {
       builder.appendByte(3);      
     });
     await new Future(() {
       builder.appendByte(4);      
     });
     builder.fin();
   });
}

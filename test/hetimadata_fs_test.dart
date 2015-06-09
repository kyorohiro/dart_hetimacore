import 'package:unittest/unittest.dart' as unit;
import 'package:hetimacore/hetimacore.dart';
import 'package:hetimacore/hetimacore_cl.dart';
import 'dart:async' as async;

void main() {
  unit.group("rba", (){

    //
    unit.test("add", () {
      HetimaDataFS dataFs = new HetimaDataFS("test");
      return dataFs.write([1,2,3], 0).then((WriteResult r) {
        return dataFs.read(0, 3);
      }).then((ReadResult r) {
        unit.expect(r.buffer,[1,2,3]);
      });
    });
    
    //
    unit.test("add", () {
      HetimaDataFS dataFs = new HetimaDataFS("test");
      return dataFs.write([1,2,3], 1).then((WriteResult r) {
        return dataFs.read(0, 4);
      }).then((ReadResult r) {
        unit.expect(r.buffer,[0,1,2,3]);
      });
    });
  });
}

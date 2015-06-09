import 'package:unittest/unittest.dart' as unit;
import 'package:hetimacore/hetimacore.dart';
import 'dart:async' as async;

void main() {
  unit.group("", (){
    //
    unit.test("hetimadata_cache: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory();
      HetimaDataCache cache = new HetimaDataCache(dummy);
      
      cache.write([1,2,3], 0).then((WriteResult w) {
        return cache.read(0, 5);
      }).then((ReadResult r) {
        unit.expect(r.buffer, [1,2,3]);
      });
    });
  });
}

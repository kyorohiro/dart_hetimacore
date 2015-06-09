import 'package:unittest/unittest.dart' as unit;
import 'package:hetimacore/hetimacore.dart';
import 'dart:async' as async;

void main() {
  unit.group("", (){

    //
    unit.test("hetimadata_cache 1: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory();
      HetimaDataCache cache = new HetimaDataCache(dummy);      
      return cache.write([1,2,3], 0).then((WriteResult w) {
        return cache.read(0, 5);
      }).then((ReadResult r) {
        print("--1--");
        unit.expect(r.buffer, [1,2,3]);
        return cache.flush();
      }).then((_) {
        print("--2--");
        unit.expect(dummy.getBuffer(0, 100), [1,2,3]);
     });
    });

    //
    unit.test("hetimadata_cache 2: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory();
      HetimaDataCache cache = new HetimaDataCache(dummy);      
      return cache.write([1,2,3], 3).then((WriteResult w) {
        return cache.read(0, 6);
      }).then((ReadResult r) {
        print("--1--");
        unit.expect(r.buffer, [0,0,0,1,2,3]);
        return cache.flush();
      }).then((_) {
        print("--2--");
        unit.expect(dummy.getBuffer(0, 100), [0,0,0,1,2,3]);
     });
    });

    //
    unit.test("hetimadata_cache 3: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory();
      HetimaDataCache cache = new HetimaDataCache(dummy,cacheSize: 3, cacheNum: 3);
      return cache.write([1,2,3], 3).then((WriteResult w) {
        return cache.read(0, 6);
      }).then((ReadResult r) {
        print("--1--");
        unit.expect(r.buffer, [0,0,0,1,2,3]);
        return cache.flush();
      }).then((_) {
        print("--2--");
        unit.expect(dummy.getBuffer(0, 100), [0,0,0,1,2,3]);
     });
    });
    
    //
    unit.test("hetimadata_cache 4: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory();
      HetimaDataCache cache = new HetimaDataCache(dummy,cacheSize: 3, cacheNum: 3);
      return cache.write([1,2,3,4], 3).then((WriteResult w) {
        return cache.read(0, 7);
      }).then((ReadResult r) {
        print("--1--");
        unit.expect(r.buffer, [0,0,0,1,2,3,4]);
        return cache.flush();
      }).then((_) {
        print("--2--");
        unit.expect(dummy.getBuffer(0, 100), [0,0,0,1,2,3,4]);
     });
    });

    //
    unit.test("hetimadata_cache 5: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory();
      HetimaDataCache cache = new HetimaDataCache(dummy,cacheSize: 3, cacheNum: 3);
      return cache.write([1,2,3,4,5,6,7], 2).then((WriteResult w) {
        return cache.read(0, 9);
      }).then((ReadResult r) {
        print("--1--");
        unit.expect(r.buffer, [0,0,1,2,3,4,5,6,7]);
        return cache.flush();
      }).then((_) {
        print("--2--");
        unit.expect(dummy.getBuffer(0, 100), [0,0,1,2,3,4,5,6,7]);
     });
    });

    //
    unit.test("hetimadata_cache 6: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory();
      HetimaDataCache cache = new HetimaDataCache(dummy,cacheSize: 3, cacheNum: 3);
      return cache.write([1,2,3,4,5,6,7], 4).then((WriteResult w) {
        return cache.read(0, 11);
      }).then((ReadResult r) {
        print("--1--");
        unit.expect(r.buffer, [0,0,0,0,1,2,3,4,5,6,7]);
        return cache.flush();
      }).then((_) {
        print("--2--");
        unit.expect(dummy.getBuffer(0, 100), [0,0,0,0,1,2,3,4,5,6,7]);
     });
    });
    //
    //
    unit.test("hetimadata_cache 7: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory();
      HetimaDataCache cache = new HetimaDataCache(dummy,cacheSize: 3, cacheNum: 3);
      return cache.write([], 4).then((WriteResult w) {
        return cache.read(0, 4);
      }).then((ReadResult r) {
        print("--1--");
        unit.expect(r.buffer, [0,0,0,0]);
        return cache.flush();
      }).then((_) {
        print("--2--");
        unit.expect(dummy.getBuffer(0, 100), [0,0,0,0]);
     });
    });
    
    //
    //
    unit.test("hetimadata_cache 8: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory();
      HetimaDataCache cache = new HetimaDataCache(dummy,cacheSize: 3, cacheNum: 3);
      return cache.write([], 0).then((WriteResult w) {
        return cache.read(0, 0);
      }).then((ReadResult r) {
        print("--1--");
        unit.expect(r.buffer, []);
        return cache.flush();
      }).then((_) {
        print("--2--");
        unit.expect(dummy.getBuffer(0, 100), []);
     });
    });

    //
    //
    unit.test("hetimadata_cache 9: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory([1,2,3,4,5]);
      
      return HetimaDataCache.createWithReuseCashData(dummy,cacheSize: 3, cacheNum: 3)
          .then((HetimaDataCache cache) {
        return cache.write([1,2,3], 3).then((WriteResult w) {
          return cache.read(0, 6);
        }).then((ReadResult r) {
          print("--1--");
          unit.expect(r.buffer, [1,2,3,1,2,3]);
          return cache.flush();
        }).then((_) {
          print("--2--");
          unit.expect(dummy.getBuffer(0, 100), [1,2,3,1,2,3]);
       });
      });
    });
    
    //
    //
    unit.test("hetimadata_cache 10: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory([1,2,3,4,5]);
      
      return HetimaDataCache.createWithReuseCashData(dummy,cacheSize: 3, cacheNum: 3)
          .then((HetimaDataCache cache) {
        return cache.write([1,2,3], 2).then((WriteResult w) {
          return cache.read(0, 6);
        }).then((ReadResult r) {
          print("--1--");
          unit.expect(r.buffer, [1,2,1,2,3]);
          return cache.flush();
        }).then((_) {
          print("--2--");
          unit.expect(dummy.getBuffer(0, 100), [1,2,1,2,3]);
       });
      });
    });
    
    //
    //
    unit.test("hetimadata_cache 11: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory([1,2,3,4,5]);
      
      return HetimaDataCache.createWithReuseCashData(dummy,cacheSize: 3, cacheNum: 3)
          .then((HetimaDataCache cache) {
        return cache.write([1,2,3], 1).then((WriteResult w) {
          return cache.read(0, 6);
        }).then((ReadResult r) {
          print("--1--");
          unit.expect(r.buffer, [1,1,2,3,5]);
          return cache.flush();
        }).then((_) {
          print("--2--");
          unit.expect(dummy.getBuffer(0, 100), [1,1,2,3,5]);
       });
      });
    });

    
    //
    //
    unit.test("hetimadata_cache 12: init", () {
      HetimaDataMemory dummy = new HetimaDataMemory([1,2,3,4,5]);
      
      return HetimaDataCache.createWithReuseCashData(dummy,cacheSize: 3, cacheNum: 3)
          .then((HetimaDataCache cache) {
        return cache.write([1,2,3], 0).then((WriteResult w) {
          return cache.read(0, 6);
        }).then((ReadResult r) {
          print("--1--");
          unit.expect(r.buffer, [1,2,3,4,5]);
          return cache.flush();
        }).then((_) {
          print("--2--");
          unit.expect(dummy.getBuffer(0, 100), [1,2,3,4,5]);
       });
      });
    });
  });
}

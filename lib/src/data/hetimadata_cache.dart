library hetimacore.cache;

import 'dart:async' as async;
import 'dart:core';
import 'hetimadata.dart';
import 'hetimadata_mem.dart';

class CashInfo {
  int index = 0;
  int length = 0;
  HetimaDataMemory dataBuffer = null;
  CashInfo(int index, int length) {
    this.index = index;
    this.length = length;
    this.dataBuffer = new HetimaDataMemory();
  }
}

class HetimaDataCache extends HetimaData {
  List<CashInfo> _cashInfoList = [];
  HetimaData _cashData = null;
  int cashSize = 1024;
  int cashNum = 3;

  bool get writable => true;
  bool get readable => true;
  int cashLength = 0;

  HetimaDataCache(HetimaData cashData, {cacheSize: 1024, cacheNum: 3}) {
    this._cashInfoList = [];
    this._cashData = cashData;
    this.cashSize = cashSize;
    this.cashNum = cashNum;
  }

  async.Future<int> getLength() {
    async.Completer<int> com = new async.Completer();
    _cashData.getLength().then((int len) {
      if (cashLength > len) {
        com.complete(cashLength);
      }
    }).catchError(com.completeError);
    return com.future;
  }

  async.Future<CashInfo> getCashInfo(int startA) {
    async.Future writeFunc(CashInfo info) {
      if (info == null) {
        async.Completer comp = new async.Completer();
        comp.complete(null);
        return comp.future;
      }
      return info.dataBuffer.getLength().then((int len) {
        return info.dataBuffer.read(0, len).then((ReadResult r) {
          return _cashData.write(r.buffer, info.index);
        });
      });
    }

    async.Future readFunc(CashInfo ret) {
      return _cashData.read(startA, cashSize).then((ReadResult r) {
        _cashInfoList.add(ret);
        return ret.dataBuffer.write(r.buffer, 0);
      });
    }

    async.Completer<CashInfo> com = new async.Completer();

    for (CashInfo c in _cashInfoList) {
      if (c.index <= startA && startA <= (c.index + c.length)) {
        _cashInfoList.remove(c);
        _cashInfoList.add(c);
        com.complete(c);
        return com.future;
      }
    }

    CashInfo removeInfo = null;
    CashInfo writeInfo = new CashInfo(startA - startA % cashSize, cashSize);
    // not found
    if (_cashInfoList.length >= 3) {
      removeInfo = _cashInfoList.removeAt(0);
    }

    writeFunc(removeInfo).then((WriteResult w) {
      return readFunc(writeInfo).then((WriteResult r) {
        com.complete(writeInfo);
      });
    }).catchError((e) {
      com.completeError(e);
    });
    return com.future;
  }

  async.Future<WriteResult> write(List<int> buffer, int start) {
    return getCashInfo(start).then((CashInfo ret) {
      int l = start + buffer.length;
      if (cashLength < l) {
        cashLength = l;
      }
      return ret.dataBuffer.write(buffer, start - ret.index);
    });
  }

  async.Future<ReadResult> read(int start, int end) {
    return getCashInfo(start).then((CashInfo ret) {
      return ret.dataBuffer.read(start - ret.index, end - start);
    });
  }

  void beToReadOnly() {}
}
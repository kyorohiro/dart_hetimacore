library hetimacore.mem;

import 'dart:async' as async;
import 'dart:core';
import 'hetimadata.dart';
import '../parser/arraybuilder.dart';

class HetimaDataMemory extends HetimaData {
  bool get writable => true;
  bool get readable => true;

  ArrayBuilder _dataBuffer = null;
  HetimaDataMemory() {
    _dataBuffer = new ArrayBuilder();
  }

  async.Future<int> getLength() {
    return _dataBuffer.getLength();
  }

  async.Future<WriteResult> write(Object buffer, int start) {
    async.Completer<WriteResult> comp = new async.Completer();
    if (buffer is List<int>) {
      _dataBuffer.appendIntList(buffer, start, buffer.length);
      comp.complete(new WriteResult());
    } else {
      // TODO
      throw new UnsupportedError("");
    }
    return comp.future;
  }

  async.Future<ReadResult> read(int start, int end) {
    async.Completer<ReadResult> comp = new async.Completer();
    _dataBuffer.getByteFuture(start, end - start).then((List<int> v) {
      comp.complete(new ReadResult(ReadResult.OK, v));
    });
    return comp.future;
  }

  void beToReadOnly() {
    _dataBuffer.fin();
  }
}

library hetimacore.mem;

import 'dart:async' as async;
import 'dart:core';
import 'hetimadata.dart';

class HetimaDataMemory extends HetimaData {
  bool get writable => true;
  bool get readable => true;

  List<int> _dataBuffer = null;
  HetimaDataMemory() {
    _dataBuffer = [];
  }

  async.Future<int> getLength() {
    async.Completer<int> comp = new async.Completer();
    comp.complete(_dataBuffer.length);
    return comp.future;
  }

  async.Future<WriteResult> write(Object buffer, int start) {
    async.Completer<WriteResult> comp = new async.Completer();
    if (buffer is List<int>) {
      for (int i = 0; i < buffer.length; i++) {
        if (start + i < _dataBuffer.length) {
          _dataBuffer[start + i] = buffer[i];
        } else {
          _dataBuffer.add(buffer[i]);
        }
      }
      comp.complete(new WriteResult());
    } else {
      // TODO
      throw new UnsupportedError("");
    }
    return comp.future;
  }

  async.Future<ReadResult> read(int start, int end) {
    async.Completer<ReadResult> comp = new async.Completer();
    comp.complete(new ReadResult(ReadResult.OK, _dataBuffer.sublist(start, end)));
    return comp.future;
  }

  void beToReadOnly() {
    //
  }
}

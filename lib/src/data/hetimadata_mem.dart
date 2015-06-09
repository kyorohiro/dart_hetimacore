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

  List<int> getBuffer(int start, int length) {
    int end = start+length;
    if(end > _dataBuffer.length) {
      end = _dataBuffer.length;
    }
    return _dataBuffer.sublist(start,end);
  }

  async.Future<int> getLength() {
    async.Completer<int> comp = new async.Completer();
    comp.complete(_dataBuffer.length);
    return comp.future;
  }

  async.Future<WriteResult> write(Object buffer, int start) {
    async.Completer<WriteResult> comp = new async.Completer();
    if (buffer is List<int>) {
      
      if(_dataBuffer.length < start) {
        _dataBuffer.addAll(new List.filled(start-_dataBuffer.length, 0));
      }

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

  async.Future<ReadResult> read(int offset, int length) {
    async.Completer<ReadResult> comp = new async.Completer();
    if(length > _dataBuffer.length) {
      length = _dataBuffer.length;
    }
    comp.complete(new ReadResult(ReadResult.OK, _dataBuffer.sublist(offset, offset+length)));
    return comp.future;
  }

  void beToReadOnly() {
    //
  }
}

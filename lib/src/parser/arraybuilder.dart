library hetimacore.array;

import 'dart:typed_data' as data;
import 'dart:convert' as convert;
import 'dart:async';
import 'dart:core';
import 'hetimareader.dart';
import 'arraybuilderbuffer.dart';

class ArrayBuilder extends HetimaReader {
  int _max = 1024;
  ArrayBuilderBuffer _buffer8;
  ArrayBuilderBuffer get rawbuffer8 => _buffer8;
  int _length = 0;
  List<GetByteFutureInfo> mGetByteFutreList = new List();

  int get clearedBuffer => _buffer8.clearedBuffer;

  ArrayBuilder({bufferSize: 1024}) {
    _max = bufferSize;
    _buffer8 = new ArrayBuilderBuffer(_max); //new data.Uint8List(_max);
  }

  ArrayBuilder.fromList(List<int> buffer, [isFin = false]) {
    _buffer8 = new ArrayBuilderBuffer.fromList(buffer);
    _length = buffer.length;
    if (isFin == true) {
      fin();
    }
  }

  bool updateA(GetByteFutureInfo info) {
    if (info.completerResult != null && info.index + info.completerResultLength-1 < _length) {
      for (int i = 0; i < info.completerResultLength; i++) {
        info.completerResult[i] = _buffer8[info.index + i];
      }
      info.completer.complete(info.completerResult);
      info.completerResult = null;
      info.completerResultLength = 0;
      return true;
    } else {
      return false;
    }
  }
  bool updateB() {
    List<GetByteFutureInfo> removeList = new List();
    for (GetByteFutureInfo f in mGetByteFutreList) {
      if (true == updateA(f)) {
        removeList.add(f);
      }
    }
    for (GetByteFutureInfo f in removeList) {
      mGetByteFutreList.remove(f);
    }
  }

  Future<List<int>> getByteFuture(int index, int length, {data.Uint8List buffer:null}) {
    GetByteFutureInfo info = new GetByteFutureInfo();
    if(buffer == null) {
      info.completerResult = new data.Uint8List(length);
    } else {
      info.completerResult = buffer;
    }
    if(info.completerResult.length < length) {
      throw {};
    }

    info.completerResultLength = length;
    info.index = index;
    info.completer = new Completer();

    if (false == updateA(info)) {
      mGetByteFutreList.add(info);
    }

    return info.completer.future;
  }

  int get(int index) {
    return 0xFF & _buffer8[index];
  }

  void clear() {
    _length = 0;
  }

  void clearInnerBuffer(int len) {
    _buffer8.clearInnerBuffer(len);
  }

  int size() {
    return _length;
  }

  Future<int> getLength() async {
    return _length;
  }

  void update(int plusLength) {
    if (_length + plusLength < _max) {
      return;
    } else {
      int nextMax = _length + plusLength + _max;
      _buffer8.expand(nextMax);
      _max = nextMax;
    }
  }

  void fin() {
    for (GetByteFutureInfo f in mGetByteFutreList) {
      if (f.completerResult != null) {
        f.completer.complete(f.completerResult);
        f.completerResult = null;
        f.completerResultLength = 0;
      }
    }
    mGetByteFutreList.clear();
    immutable = true;
  }

  void appendByte(int v) {
    if (immutable) {
      return;
    }
    update(1);
    _buffer8[_length] = v;
    _length += 1;
    
    updateB();

  }

  void appendString(String text) {
    List<int> code = convert.UTF8.encode(text);
    update(code.length);
    for (int i = 0; i < code.length; i++) {
      appendByte(code[i]);
    }
  }

  void appendIntList(List<int> buffer, [int index = 0, int length = -1]) {
    update(length);
    if (length < 0) {
      length = buffer.length;
    }
    for (int i = 0; i < length; i++) {
      _buffer8[_length+i] = buffer[index+i];
    }
    _length += length;
    updateB();
  }

  List toList() {
    return _buffer8.sublist(0, _length);
  }

  data.Uint8List toUint8List() {
    return new data.Uint8List.fromList(toList());
  }

  String toText() {
    return convert.UTF8.decode(toList());
  }
}

class GetByteFutureInfo {
  List<int> completerResult = new List();
  int completerResultLength = 0;
  int index = 0;
  Completer<List<int>> completer = null;
}

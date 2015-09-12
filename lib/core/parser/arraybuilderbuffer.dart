library hetimacore.arraybuffer;

import 'dart:typed_data' as data;
import 'dart:core';

class ArrayBuilderBuffer {
  int _clearedBuffer = 0;
  int _length = 0;
  List<int> _buffer8 = null;
  List<int> get rawbuffer8 => _buffer8;

  int get clearedBuffer => _clearedBuffer;
  bool _logon = false;

  ArrayBuilderBuffer(int max, {bool logon:false}) {
    _length = max;
    _buffer8 = new data.Uint8List(max);
    _logon = logon;
  }

  ArrayBuilderBuffer.fromList(List<int> buffer,{bool logon:false}) {
    _length = buffer.length;
    _buffer8 = new data.Uint8List.fromList(buffer);
    _logon = logon;
  }

  int operator [](int index) {
    int i = index - _clearedBuffer;
    if (i >= 0) {
      return _buffer8[index - _clearedBuffer];
    } else {
      return 0;
    }
  }

  void operator []=(int index, int value) {
    int i = index - _clearedBuffer;
    if (i >= 0) {
      _buffer8[i] = value;
    }
  }

  List<int> sublist(int start, int end) {
    data.Uint8List ret = new data.Uint8List(end - start);
    for (int j = 0; j < end - start; j++) {
      ret[j] = this[j + start];
    }
    return ret;
  }

  void clearInnerBuffer(int len, {bool reuse: true}) {
    if (_clearedBuffer >= len) {
      if(_logon) {
        print("(_clearedBuffer >= len) == (${_clearedBuffer} >= ${len})");
      }
      return;
    }

    if (length < len) {
      if(_logon) {
        print("(length < len) == (${length} < ${len})");
      }
      return;
    }

    int erace = len - _clearedBuffer;

    if (reuse == false) {
      _buffer8 = _buffer8.sublist(erace);
      _length = _buffer8.length;
    } else {
      for (int i = 0; i + erace < _length; i++) {
        _buffer8[i] = _buffer8[i+erace];
      }
      _length = _length-erace;
    }
    _clearedBuffer = len;
  }

  void expand(int nextMax) {
    nextMax = nextMax - _clearedBuffer;
    if (_buffer8.length >= nextMax) {
      _length = nextMax;
      return;
    }
    data.Uint8List next = new data.Uint8List(nextMax);
    for (int i = 0; i < _buffer8.length; i++) {
      next[i] = _buffer8[i];
    }
    _buffer8 = null;
    _buffer8 = next;
    _length = _buffer8.length;
  }

  int get length => _length + _clearedBuffer;
}

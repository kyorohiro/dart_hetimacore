library hetimacore.arraybuffer;

import 'dart:typed_data' as data;
import 'dart:core';


class ArrayBuilderBuffer {
  int _clearedBuffer = 0;
  List<int> _buffer8 = null;
  List<int> get rawbuffer8 => _buffer8;

  int get clearedBuffer => _clearedBuffer;

  ArrayBuilderBuffer(int max) {
    _buffer8 = new data.Uint8List(max);
  }

  ArrayBuilderBuffer.fromList(List<int> buffer) {
    _buffer8 = buffer;
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
    List<int> ret = [];
    {
      int s = start-_clearedBuffer;
      int e = end-_clearedBuffer;
      if(s<0) {
        ret.addAll(new List.filled(-1*s, 0));
        s=0;
      }      
      ret.addAll(_buffer8.sublist(s, e));
    }
    return ret;
  }

  void clearInnerBuffer(int len) {
    if(_clearedBuffer >= len) {
      return;
    }

    if(length <= len) {
      return;
    }

    int erace = len-_clearedBuffer;
    
    _buffer8 = _buffer8.sublist(erace);
    _clearedBuffer = len;
  }

  void expand(int nextMax) {
    nextMax = nextMax - _clearedBuffer;
    if (_buffer8.length >= nextMax) {
      return;
    }
    data.Uint8List next = new data.Uint8List(nextMax);
    for (int i = 0; i < _buffer8.length; i++) {
      next[i] = _buffer8[i];
    }
    _buffer8 = null;
    _buffer8 = next;
  }

  int get length => _buffer8.length + _clearedBuffer;
}

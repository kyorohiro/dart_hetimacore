library hetimacore.file;
import 'dart:typed_data' as data;
import 'dart:async' as async;
import 'dart:core';
import 'hetimadata.dart';
import '../parser/arraybuilder.dart';

abstract class HetimaDataMemory extends HetimaData {
  bool get writable => true;
  bool get readable => true;

  ArrayBuilder a = null;
  HetimaDataMemory() {
    
  }

  async.Future<int> getLength() {
    ;
  }

  async.Future<WriteResult> write(Object buffer, int start) {
    ;
  }

  async.Future<ReadResult> read(int start, int end) {
    ;
  }

  void beToReadOnly() {
    ;
  }
}

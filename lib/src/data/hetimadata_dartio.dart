library hetimacore_dartio.blob;
import 'dart:async' as async;
import 'dart:convert' as convert;
import 'dart:core';
import 'dart:math' as math;
import 'dart:typed_data' as data;
import 'dart:io';

import '../../hetimacore.dart';

class HetimaDataDartIO extends HetimaData {
  
  @override
  void beToReadOnly() {
    // TODO: implement beToReadOnly
  }

  @override
  async.Future<int> getLength() {
    // TODO: implement getLength
  }

  @override
  async.Future<ReadResult> read(int offset, int length, {List<int> tmp: null}) {
    // TODO: implement read
  }

  @override
  async.Future<WriteResult> write(Object buffer, int start) {
    // TODO: implement write
  }
}

class HetimaDataDartIOBuilder extends HetimaDataBuilder {

  async.Future<HetimaData> createHetimaData(String path) async {
    return null;
  }
}
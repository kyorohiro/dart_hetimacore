library hetimacore.file;
import 'dart:typed_data' as data;
import 'dart:async' as async;
import 'dart:core';
import '../../hetimacore.dart';

abstract class HetimaDataBuilder {
  async.Future<HetimaData> createHetimaData(String path);
}

abstract class HetimaData extends HetimaFileReader {
  bool get writable => false;
  bool get readable => false;
  async.Future<int> getLength();
  async.Future<WriteResult> write(Object buffer, int start);
  async.Future<ReadResult> read(int offset, int length, {List<int> tmp:null});
  void beToReadOnly();
}

abstract class HetimaFileWriter {
  async.Future<WriteResult> write(Object o, int start);
}

abstract class HetimaFileReader {
  async.Future<int> getLength();
  async.Future<ReadResult> read(int offset, int length);
}

class WriteResult {
}

class ReadResult {
  List<int> buffer;
  int length = 0;
  ReadResult(List<int> _buffer, [int length = -1]) {
    buffer = _buffer;
    if(length < 0) {
      this.length = _buffer.length;
    } else {
      this.length = length;
    }
  }
}

class HetimaBuilderToFile extends HetimaData {
  
  HetimaReader mBuilder;
  HetimaBuilderToFile(HetimaReader builder) {
    mBuilder = builder;
  }
  @override
  async.Future<int> getLength() {
    return mBuilder.getLength();
  }

  @override
  async.Future<ReadResult> read(int offset, int length, {List<int> tmp:null}) {
    async.Completer<ReadResult> cc = new async.Completer();
    mBuilder.getByteFuture(offset, length).then((List<int> b){
      ReadResult result = new ReadResult(new data.Uint8List.fromList(b));
      cc.complete(result);
    }).catchError((e){
      cc.completeError(e);
    });
    return cc.future;
  }

  @override
  async.Future<WriteResult> write(Object buffer, int start) {
    // todo
    return null;
  }
  
  void beToReadOnly() {
    mBuilder.fin();
  }
}

class HetimaFileToBuilder extends HetimaReader {

  HetimaData mFile;

  HetimaFileToBuilder(HetimaData f) {
    mFile = f;
  }

  @override
  async.Future<List<int>> getByteFuture(int index, int length) {
    async.Completer<List<int>> c = new async.Completer();
    mFile.read(index, length).then((ReadResult r) {
        c.complete(r.buffer.toList());
    }).catchError((e){
      c.completeError(e);
    });
    return c.future;
  }

  @override
  async.Future<int> getLength() {
    return mFile.getLength();
  }
}
library hetimacore_cl.blob;
import 'dart:typed_data' as data;
import 'dart:math' as math;
import 'dart:convert' as convert;
import 'dart:async' as async;
import 'dart:core';
import 'dart:html' as html;
import '../../hetimacore.dart';



class HetimaDataBlob extends HetimaData {
  html.Blob _mBlob;
  HetimaFileWriter _mWriter;

  bool get writable => (_mWriter == true);
  bool get readable => true;

  HetimaDataBlob(bl, [HetimaFileWriter writer = null]) {
    _mBlob = bl;
    _mWriter = writer;
  }

  async.Future<int> getLength() {
    async.Completer<int> ret = new async.Completer();
    ret.complete(_mBlob.size);
    return ret.future;
  }

  async.Future<WriteResult> write(Object o, int start) {
    return _mWriter.write(o, start);
  }


  async.Future<ReadResult> read(int offset, int length) {
    async.Completer<ReadResult> ret = new async.Completer<ReadResult>();
    async.StreamSubscription a = null;
    async.StreamSubscription b = null;
    async.StreamSubscription c = null;
    html.FileReader reader = new html.FileReader();
    a = reader.onLoadEnd.listen((html.ProgressEvent e) {
      ret.complete(new ReadResult(ReadResult.OK, reader.result));
      a.cancel();
      b.cancel();
      c.cancel();
    });
    b = reader.onError.listen((html.Event e) {
      print("read error : ${e}");
      ret.complete(new ReadResult(ReadResult.NG, null));
    });
    c = reader.onAbort.listen((html.ProgressEvent e) {
      print("read abort : ${e}");
      ret.complete(new ReadResult(ReadResult.NG, null));
    });
    reader.readAsArrayBuffer(_mBlob.slice(offset, offset+length));
    return ret.future;
  }

  void beToReadOnly() {
  }
}


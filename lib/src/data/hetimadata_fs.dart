library hetimacore_cl.impl;
import 'dart:typed_data' as data;
import 'dart:math' as math;
import 'dart:convert' as convert;
import 'dart:async' as async;
import 'dart:core';
import 'dart:html' as html;
import '../../hetimacore.dart';


class HetimaDataFSBuilder extends HetimaDataBuilder {
  async.Future<HetimaData> createHetimaData(String path) {
    async.Completer<HetimaData> co = new async.Completer();
    co.complete(new HetimaDataFS(path));
    return co.future;
  }
}

class HetimaDataFS extends HetimaData {
  String fileName = "";
  html.FileEntry _fileEntry = null;

  bool get writable => true;
  bool get readable => true;

  HetimaDataFS(String name) {
    fileName = name;
  }

  HetimaDataFS.fromFile(html.FileEntry fileEntry) {
    this._fileEntry = fileEntry;
    fileName = fileEntry.name;
  }

  async.Future<html.Entry> getEntry() {
    return init();
  }

  async.Future<html.Entry> init() {
    async.Completer<html.Entry> completer = new async.Completer();
    if (_fileEntry != null) {
      completer.complete(_fileEntry);
      return completer.future;
    }
    html.window.requestFileSystem(1024).then((html.FileSystem e) {
      e.root.createFile(fileName).then((html.Entry e) {
        _fileEntry = (e as html.FileEntry);
        completer.complete(_fileEntry);
      }).catchError((es) {
        completer.complete(null);
      });
    });
    return completer.future;
  }


  async.Future<int> getLength() {
    async.Completer<int> completer = new async.Completer();
    init().then((e) {
      html.FileReader reader = new html.FileReader();
      _fileEntry.file().then((html.File f) {
        completer.complete(f.size);
      });
    });
    return completer.future;
  }


  async.Future<WriteResult> write(Object buffer, int start) {
    async.Completer<WriteResult> completer = new async.Completer();
    init().then((e) {
      _fileEntry.createWriter().then((html.FileWriter writer) {
        writer.onWrite.listen((html.ProgressEvent e) {
          completer.complete(new WriteResult());
        });
        if (start > 0) {
          writer.seek(start);
        }
        writer.write(new html.Blob([buffer]));
      });
    });
    return completer.future;
  }

  async.Future<int> truncate(int fileSize) {
    async.Completer<int> completer = new async.Completer();
    init().then((e) {
      return _fileEntry.createWriter();
    }).then((html.FileWriter writer) {
      writer.truncate(fileSize);
      completer.complete(fileSize);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  async.Future<ReadResult> read(int offset, int length) {
    async.Completer<ReadResult> c_ompleter = new async.Completer();
    init().then((e) {
      html.FileReader reader = new html.FileReader();
      _fileEntry.file().then((html.File f) {
        reader.onLoad.listen((html.ProgressEvent e) {
          c_ompleter.complete(new ReadResult(ReadResult.OK, reader.result));
        });
        reader.readAsArrayBuffer(f.slice(offset, offset+length));
      });
    });
    return c_ompleter.future;
  }

  void beToReadOnly() {    
  }
}

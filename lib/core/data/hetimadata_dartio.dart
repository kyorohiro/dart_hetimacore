library hetimacore_dartio.blob;

import 'dart:async';
import 'dart:core';
import 'dart:typed_data' as data;
import 'dart:io';

import '../../hetimacore.dart';

class HetimaDataDartIO extends HetimaData {
  RandomAccessFile _randomFile = null;
  bool _readOnly = false;
  HetimaDartDartIO(String path) {
    File _f = new File(path);
    _randomFile = _f.openSync(mode: FileMode.WRITE);
  }

  @override
  void beToReadOnly() {
    _readOnly = true;
  }

  @override
  Future<int> getLength() => _randomFile.length();

  @override
  Future<ReadResult> read(int offset, int length, {List<int> tmp: null}) async {
    if (tmp == null) {
      tmp = new data.Uint8List(length);
    }
    int l = await _randomFile.readInto(tmp, offset, offset + length);
    return new ReadResult(tmp, l);
  }

  @override
  Future<WriteResult> write(Object buffer, int start) async {
    if (_readOnly == false) {
      await _randomFile.writeFrom(buffer, start);
    }
    return new WriteResult();
  }

  Future<int> truncate(int fileSize) async {
    await _randomFile.truncate(fileSize);
    return 0;
  }

  static Future<List<String>> getFiles(String path) async {
    Directory d = new Directory(path);
    List<FileSystemEntity> l = await d.list().toList();
    List<String> ret = [];
    for (FileSystemEntity e in l) {
      ret.add(e.path);
    }
    return ret;
  }

  static Future removeFile(String filename, {persistent: false}) async {
    if (await FileSystemEntity.isDirectory(filename)) {
      Directory d = new Directory(filename);
      return d.delete(recursive: true);
    } else if (await FileSystemEntity.isFile(filename)) {
      File f = new File(filename);
      return f.delete();
    }
  }
}

class HetimaDataDartIOBuilder extends HetimaDataBuilder {
  Future<HetimaData> createHetimaData(String path) async {
    return new HetimaDataDartIO();
  }
}
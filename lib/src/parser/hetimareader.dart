part of hetimacore;

abstract class HetimaReader {

  async.Future<List<int>> getByteFuture(int index, int length);

  async.Future<int> getLength();

  void fin() {
    immutable = true;
  }

  async.Completer completerFin = new async.Completer(); 

  async.Future<bool> onFin() {
    if(_immutable == true) {
      completerFin.complete(true);
    }
    return completerFin.future;
  }

  bool _immutable = false;

  bool get immutable => _immutable;

  void set immutable(bool v) {
    bool prev = _immutable;
    _immutable = v;
    if(prev == false && v== true) {
      completerFin.complete(v);
    }
  }

}

class HetimaReaderAdapter extends HetimaReader {
  HetimaReader _base = null;
  int _startIndex = 0;

  HetimaReaderAdapter(HetimaReader builder, int startIndex) {
    _base = builder;
    _startIndex = startIndex;
  }

  async.Future<int> getLength() {
    async.Completer<int> completer = new async.Completer();
    _base.getLength().then((int v){
      completer.complete(v - _startIndex);
    }).catchError((e){
      completer.completeError(e);
    });
    return completer.future;
  }

  async.Future<bool> onFin() {
   return _base.onFin();
  }

  async.Future<List<int>> getByteFuture(int index, int length) {
    async.Completer<List<int>> completer = new async.Completer();

    _base.getByteFuture(index + _startIndex, length).then((List<int> d) {
      completer.complete(d);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }
  
  void fin() {
    _base.fin();
  }
}

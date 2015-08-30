library hetimacore.uint8list;
import 'dart:typed_data';
import 'dart:math';


class Uint8ListWithLength implements List {

  Uint8List _buffer = null;
  Uint8List get rawbuffer => _buffer;
  int _currentLength = 0;
  int get currentLength => _currentLength;
  void setCurrentLength(int v) {
    _currentLength = v;
  }

  Uint8ListWithLength(int length) {
    _buffer = new Uint8List(length);
    _currentLength = length;
  }


  int get length => _buffer.length;
  void  set length(int v) {
    _buffer.length = v;
  }

  @override
  operator [](int index) => _buffer[index];

  @override
  void operator []=(int index, value) => _buffer[index] = value;

  @override
  void add(value) => _buffer.add(value);

  @override
  void addAll(Iterable iterable) => _buffer.addAll(iterable);

  @override
  bool any(bool test(element)) => _buffer.any(test);

  @override
  Map<int, dynamic> asMap() => _buffer.asMap();

  @override
  void clear() => _buffer.clear();

  @override
  bool contains(Object element) => _buffer.contains(element);

  @override
  elementAt(int index) => _buffer.elementAt(index);

  @override
  bool every(bool test(element)) => _buffer.every(test);

  @override
  Iterable expand(Iterable f(element)) => _buffer.expand(f);

  @override
  void fillRange(int start, int end, [fillValue]) => _buffer.fillRange(start, end);

  @override
  get first => _buffer.first;

  @override
  firstWhere(bool test(element), {orElse()}) => _buffer.firstWhere(test);

  @override
  fold(initialValue, combine(previousValue, element)) => _buffer.fold(initialValue, combine);

  @override
  void forEach(void f(element)) => _buffer.forEach(f);

  @override
  Iterable getRange(int start, int end) => _buffer.getRange(start, end);

  @override
  int indexOf(element, [int start = 0]) => _buffer.indexOf(element,start);

  @override
  void insert(int index, element) => _buffer.insert(index, element);

  @override
  void insertAll(int index, Iterable iterable) => _buffer.insertAll(index, iterable);

  @override
  bool get isEmpty => _buffer.isEmpty;

  @override
  bool get isNotEmpty => _buffer.isNotEmpty;

  @override
  Iterator get iterator => _buffer.iterator;

  @override
  String join([String separator = ""]) => _buffer.join(separator);

  @override
  get last => _buffer.last;

  @override
  int lastIndexOf(element, [int start]) => _buffer.lastIndexOf(element, start);

  @override
  lastWhere(bool test(element), {orElse()}) => _buffer.lastWhere(test, orElse:orElse);

  @override
  Iterable map(f(element)) => _buffer.map(f);

  @override
  reduce(combine(value, element)) => _buffer.reduce(combine);

  @override
  bool remove(Object value) => _buffer.remove(value);

  @override
  removeAt(int index) => _buffer.removeAt(index);

  @override
  removeLast() => _buffer.removeLast();

  @override
  void removeRange(int start, int end) => _buffer.removeRange(start, end);

  @override
  void removeWhere(bool test(element)) => _buffer.removeWhere(test);

  @override
  void replaceRange(int start, int end, Iterable replacement) => _buffer.replaceRange(start, end, replacement);

  @override
  void retainWhere(bool test(element)) => _buffer.retainWhere(test);

  @override
  Iterable get reversed => _buffer.reversed;

  @override
  void setAll(int index, Iterable iterable) => _buffer.setAll(index, iterable);

  @override
  void setRange(int start, int end, Iterable iterable, [int skipCount = 0]) => _buffer.setRange(start, end, iterable, skipCount);

  @override
  void shuffle([Random random]) => _buffer.shuffle(random);
  @override
  get single => _buffer.single;

  @override
  singleWhere(bool test(element)) => _buffer.singleWhere(test);
  @override
  Iterable skip(int count) => _buffer.skip(count);

  @override
  Iterable skipWhile(bool test(value)) => _buffer.skipWhile(test);

  @override
  void sort([int compare(a, b)]) => _buffer.sort(compare);

  @override
  List sublist(int start, [int end]) => _buffer.sublist(start, end);

  @override
  Iterable take(int count) => _buffer.take(count);

  @override
  Iterable takeWhile(bool test(value)) => _buffer.takeWhile(test);

  @override
  List toList({bool growable: true}) => _buffer.toList(growable:growable);

  @override
  Set toSet() => _buffer.toSet();

  @override
  Iterable where(bool test(element)) => _buffer.where(test);

}


class Event<T, V> {
  final T type;
  final V value;

  Event(this.type, {this.value});
}

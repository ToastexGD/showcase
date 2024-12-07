class _FutureTimeout {}

Future<T?> futureTimeout<T>(Future<T> future, Duration timeout) async {
  final res = await Future.any([
    future,
    Future.delayed(timeout).then((_) => _FutureTimeout()),
  ]);
  if (res is _FutureTimeout) {
    print("Timeout! after ${timeout}");
    return null;
  }
  return res as T;
}

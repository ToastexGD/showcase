class _FutureTimeout {}

Future<T?> futureTimeout<T>(Future<T> future, Duration timeout) async {
  await Future.any([
    future,
    Future.delayed(timeout).then((_) => _FutureTimeout()),
  ]);
  if (future is _FutureTimeout) {
    return null;
  }
  return future;
}

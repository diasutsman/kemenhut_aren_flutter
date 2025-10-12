List<List<int>> listSplitter(List<int> list, int size) {
  final chunks = <List<int>>[];
  for (var i = 0; i < list.length; i += size) {
    final chunk =
        list.sublist(i, i + size > list.length ? list.length : i + size);
    chunks.add(chunk);
  }
  return chunks;
}
// TODO: CHECK THIS
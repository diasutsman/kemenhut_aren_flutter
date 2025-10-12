String titleCaseConverter(String value) {
  if (value.contains('_')) {
    return value.split('_').map((e) => _convert2TitleCase(e)).join(' ');
  } else if (value.contains(' ')) {
    return value.split(' ').map((e) => _convert2TitleCase(e)).join(' ');
  } else {
    return _convert2TitleCase(value);
  }
}

String _convert2TitleCase(String value) {
  return '${value.substring(0, 1).toUpperCase()}${value.substring(1)}';
}

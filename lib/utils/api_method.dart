enum APIMethod {
  read,
  searchRead,
  create,
  write,
  onchange,
  unlink,
}

Map<APIMethod, String> apiMethodMap = {
  APIMethod.read: 'read',
  APIMethod.searchRead: 'search_read',
  APIMethod.create: 'create',
  APIMethod.write: 'write',
  APIMethod.onchange: 'onchange',
  APIMethod.unlink: 'unlink',
};

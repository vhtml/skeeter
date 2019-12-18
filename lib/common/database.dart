// final Future<Database> _initDatabase = openDatabase(
//   // Set the path to the database.
//   join(await getDatabasesPath(), 'skeeter.db'),
//   // When the database is first created, create tables.
//   onCreate: (db, version) {
//     return db.execute('''
//       CREATE TABLE rss(id INTEGER PRIMARY KEY, avatar TEXT, title TEXT, link TEXT)
//       'CREATE TABLE rss_feed_list(id INTEGER PRIMARY KEY, title TEXT, thumb TEXT, description TEXT',
//       'CREATE TABLE rss_feed(id INTEGER PRIMARY KEY, title TEXT, content TEXT, time INTEGER, link TEXT, favorite INTEGER, have_read INTEGER)'
//     ''');
//   }
// );
class Global {
  static bool get isRelease => bool.fromEnvironment('dart.vm.product');

  // 初始化全局信息
  static Future init() async {
    // todo
  }
}
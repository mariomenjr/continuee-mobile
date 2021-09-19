class Conditionals {
  static T? getValueOrNull<T>(bool conditional, T? value) =>
      conditional ? value : null;
}

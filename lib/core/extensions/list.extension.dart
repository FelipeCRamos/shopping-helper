extension ListReplacement<T> on List<T> {
  bool replaceWhere({
    required bool Function(T) predicate,
    required T Function(T) createObject,
  }) {
    final specificIndex = indexWhere(predicate);
    final replacedObj = this[specificIndex];
    if (specificIndex >= 0) {
      replaceRange(specificIndex, specificIndex + 1, [createObject(replacedObj)]);
      return true;
    } else {
      return false;
    }
  }
}

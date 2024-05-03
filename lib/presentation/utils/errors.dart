class UserAlreadyExistsException implements Exception{

  final String message;

  UserAlreadyExistsException(this.message);

  @override
  String toString() {
    return 'UserAlreadyExistsException: $message';
  }

}

class UserDoesNotExistException implements Exception{

  final String message;

  UserDoesNotExistException(this.message);

  @override
  String toString() {
    return 'UserDoesNotExistException: $message';
  }

}
class IncorrectPasswordException implements Exception{

  final String message;

  IncorrectPasswordException(this.message);

  @override
  String toString() {
    return 'IncorrectPasswordException: $message';
  }

}

class InsufficientAccountAmountException implements Exception{

  final int amount;

  InsufficientAccountAmountException(this.amount);

  @override
  String toString() {
    return 'Il vous manque $amount sur votre compte';
  }

}

class InsufficientCaisseAmountException implements Exception{

  final int amount;

  InsufficientCaisseAmountException(this.amount);

  @override
  String toString() {
    return 'Il vous manque $amount  dans votre caisse';
  }

}

class User {

  final String firstName;
  final bool hasBiometricLock;

  User({required this.firstName, required this.hasBiometricLock});

  factory User.fromMap(Map<String,dynamic> userMap) => User(firstName:
  userMap['firstName'], hasBiometricLock: userMap['hasBiometricLock']);

  Map<String,dynamic> toMap() => {'firstName' : firstName,'has'
      'BiometricL'
  'ock' : hasBiometricLock,};
}
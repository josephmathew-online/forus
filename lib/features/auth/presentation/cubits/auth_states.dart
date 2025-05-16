//auth states

import 'package:cc/features/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

//initial
class AuthInitial extends AuthStates {}

//loading
class AuthLoading extends AuthStates {}

//authenticated
class Authenticated extends AuthStates {
  final AppUser user;
  Authenticated(this.user);
}

//unauthenticated
class PasswordResetEmailSent extends AuthStates {}

class EmailVerificationPending extends AuthStates {}

class Unauthenticated extends AuthStates {}

class EmailNotVerified extends AuthStates {}

class EmailVerificationSent extends AuthStates {}

//errors
class AuthErrors extends AuthStates {
  final String message;
  AuthErrors(this.message);
}

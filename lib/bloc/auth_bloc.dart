import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }
  void _onAuthLoginRequested( event, state) async {
    emit(AuthLoading());

    try {
      final email = event.email;
      final password = event.password;
      if (!EmailValidator.validate(email)) {
        return emit(AuthFailure('Email is not valid'));
      } else if (password.length < 6) {
        return emit(AuthFailure('password must be at least 6 characters'));
      }
      // Simulate authentication delay for demonstration purposes.
     await Future.delayed(const Duration(seconds: 1), () {
        return emit(AuthSuccess('$email-$password'));
      });
    } catch (e) {
      return emit(AuthFailure(e.toString()));
    }
  }

  void _onAuthLogoutRequested(event, state) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 1), () {
        return emit(AuthInitial());
      });
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}

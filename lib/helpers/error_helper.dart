import 'package:firebase_auth/firebase_auth.dart';

String getFirebaseErrorMessage(dynamic error) {
  if (error is! FirebaseAuthException) {
    return 'Um erro inesperado ocorreu. Tente novamente.';
  }

  switch (error.code) {
    case 'unavailable':
      return 'Sem conexão com a internet. Verifique sua rede e tente novamente.';
    case 'permission-denied':
      return 'Você não tem permissão para realizar esta ação.';
    case 'user-not-found':
      return 'Nenhum usuário encontrado com este e-mail.';
    case 'wrong-password':
      return 'Senha incorreta. Por favor, tente novamente.';
    case 'invalid-email':
      return 'O formato do e-mail é inválido.';
    case 'user-disabled':
      return 'Este usuário foi desabilitado.';
    case 'email-already-in-use':
      return 'Este e-mail já está em uso por outra conta.';
    case 'weak-password':
      return 'A senha é muito fraca. Tente uma mais forte.';
    // Adicione outros códigos de erro comuns do Firebase aqui
    default:
      return 'Um erro inesperado ocorreu. Nossa equipe foi notificada.';
  }
}

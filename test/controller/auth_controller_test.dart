import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/repositories/auth_repository.dart';
import 'package:lista_compras/services/logger_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Gera o arquivo de mock com o comando:
// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateNiceMocks([MockSpec<AuthRepository>(), MockSpec<LoggerService>()])
import 'auth_controller_test.mocks.dart';

void main() {
  // Instancia os mocks
  late MockAuthRepository mockAuthRepository;
  late MockLoggerService mockLoggerService;
  late AuthController authController;

  // Roda antes de cada teste
  setUp(() {
    // Cria novas instâncias limpas para cada teste
    mockAuthRepository = MockAuthRepository();
    mockLoggerService = MockLoggerService();

    // Injeta os mocks no GetX para que o AuthController possa encontrá-los
    Get.put<AuthRepository>(mockAuthRepository);
    Get.put<LoggerService>(mockLoggerService);

    // Cria a instância do AuthController que será testada
    authController = AuthController();
  });

  // Roda depois de cada teste para limpar o GetX
  tearDown(() {
    Get.reset();
  });

  // Grupo de testes para o AuthController
  group('AuthController', () {

    test('Valor inicial de isLoginView deve ser true', () {
      // Verifica se o valor inicial da flag que controla a UI de login é 'true'
      expect(authController.isLoginView.value, isTrue);
    });

    test('toggleView deve inverter o valor de isLoginView de true para false', () {
      // Estado Inicial
      expect(authController.isLoginView.value, isTrue);

      // Ação
      authController.toggleView();

      // Verificação
      expect(authController.isLoginView.value, isFalse);
    });

    test('toggleView deve inverter o valor de isLoginView de false para true', () {
      // Estado Inicial: Força o valor para false
      authController.isLoginView.value = false;
      expect(authController.isLoginView.value, isFalse);

      // Ação
      authController.toggleView();

      // Verificação
      expect(authController.isLoginView.value, isTrue);
    });

    // Adicionaremos mais testes aqui para login, cadastro, etc.

  });
}

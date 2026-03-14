import 'package:task_radar/domain/user.dart';

class ProviderUser {
  /// Este provider e utilizado somente apos o login, por isso o User e definido
  /// como late e sera atribuido quando a autenticacao for concluida com sucesso.
  late User user;
}

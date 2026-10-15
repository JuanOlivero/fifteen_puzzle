import 'package:flutter/foundation.dart';
import 'app_settings.dart';
import 'settings_repository.dart';

/// Guarda las preferencias actuales y avisa a la UI cuando cambian.
/// Es el puente entre la pantalla de Configuración, el almacenamiento
/// y el resto de la app.
class SettingsController extends ChangeNotifier {
  SettingsController(this._repository) : _settings = _repository.load();

  final SettingsRepository _repository;
  AppSettings _settings;

  /// Preferencias actuales (solo lectura desde fuera).
  AppSettings get settings => _settings;

  /// Aplica unas preferencias nuevas: cambia el estado, avisa a quien
  /// esté escuchando y las guarda en el almacenamiento local.
  Future<void> update(AppSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await _repository.save(newSettings);
  }
}
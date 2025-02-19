import 'package:shared_preferences/shared_preferences.dart';

enum TipoChart {
  bar(id: 'bar'),
  line(id: 'line'),
  pie(id: 'pie');

  final String id;
  const TipoChart({required this.id});
}

class LocalDataSource {
  late SharedPreferences _prefs;

  Future<void> initialization() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setEjeX(
      {required List<String> data, required TipoChart tipo}) async {
    final identificador = '${tipo.id}_x';
    await _prefs.setStringList(identificador, data);
  }

  Future<void> setEjeY(
      {required List<String> data, required TipoChart tipo}) async {
    final identificador = '${tipo.id}_y';
    await _prefs.setStringList(identificador, data);
  }

  ({List<String> datosEjeX, List<String> datosEjeY}) obtenerDatos(
      TipoChart tipo) {
    final identificadorEjeX = '${tipo.id}_x';
    final identificadorEjeY = '${tipo.id}_y';

    final dataEjeX = _prefs.getStringList(identificadorEjeX) ?? [];
    final dataEjeY = _prefs.getStringList(identificadorEjeY) ?? [];

    return (datosEjeX: dataEjeX, datosEjeY: dataEjeY);
  }

  static final _singleton = LocalDataSource._internal();

  factory LocalDataSource() {
    return _singleton;
  }

  LocalDataSource._internal();
}

final localDataSource = LocalDataSource();

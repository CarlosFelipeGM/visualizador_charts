import 'package:visualizador_charts/data/data_sources/local_data_source.dart';
import 'package:visualizador_charts/data/models/pie_model.dart';

class PieRepository {
  final LocalDataSource localDataSource;
  final tipoChart = TipoChart.pie;

  PieRepository({required this.localDataSource});

  PieModel obtenerDatosTajadas() {
    final tajadasDatos = localDataSource.obtenerDatos(tipoChart);
    return PieModel.convertirDeDataLocal(tajadasDatos);
  }

  void guardarTajadasDatos(PieModel pieModel) async {
    await localDataSource.setEjeX(data: pieModel.etiqueta, tipo: tipoChart);
    await localDataSource.setEjeY(
      data: pieModel.valor.map((elemento) {
        return elemento.toString();
      }).toList(),
      tipo: tipoChart,
    );
  }
}

final pieRepository = PieRepository(localDataSource: localDataSource);

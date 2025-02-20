import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:visualizador_charts/data/models/pie_model.dart';
import 'package:visualizador_charts/data/repositories/pie_repository.dart';
import 'package:visualizador_charts/display/ui/components/input_grafico.dart';
import 'package:visualizador_charts/display/ui/utils/utils.dart';

class PantallaGraficoPies extends StatefulWidget {
  const PantallaGraficoPies({super.key});

  @override
  State<PantallaGraficoPies> createState() => _PantallaGraficoPiesState();
}

class _PantallaGraficoPiesState extends State<PantallaGraficoPies> {
  final _colores = [
    Colors.yellow,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.pink,
  ];
  final _etiquetaTextEditingController = TextEditingController();
  final _valorTextEditingController = TextEditingController();
  final _idFormulario = GlobalKey<FormState>();
  int touchedIndex = -1;

  PieModel? _pieModel;

  @override
  void initState() {
    super.initState();
    setState(() {
      _pieModel = pieRepository.obtenerDatosTajadas();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pieModel == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico de pies'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              height: 180,
              child: (_pieModel!.etiqueta.isNotEmpty)
                  ? _dibujarPie()
                  : Placeholder(),
            ),
          ),
          Form(
            key: _idFormulario,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 8,
                children: [
                  InputGrafico(
                    controller: _etiquetaTextEditingController,
                    label: 'Etiqueta',
                    autocorrect: false,
                    textInputType: TextInputType.text,
                    validator: (valor) {
                      return ValidacionDeData.validarCampoObligatorio(valor);
                    },
                  ),
                  InputGrafico(
                    controller: _valorTextEditingController,
                    label: 'Valor',
                    autocorrect: false,
                    textInputType: TextInputType.number,
                    validator: (valor) {
                      return ValidacionDeData.validarNumero(valor);
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      final esValiado = _idFormulario.currentState?.validate();
                      final pieModel = _pieModel;

                      if (esValiado == true && pieModel != null) {
                        setState(() {
                          pieModel.etiqueta
                              .add(_etiquetaTextEditingController.text);
                          pieModel.valor.add(
                              double.parse(_valorTextEditingController.text));
                        });

                        pieRepository.guardarTajadasDatos(pieModel);
                      }
                    },
                    label: const Text('Agregar'),
                    icon: Icon(Icons.add),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Alertas.mostrarAlertaDeConfirmacion(context,
                          alBorrar: (ctx) {
                        final pieModel = _pieModel;
                        if (pieModel != null) {
                          setState(() {
                            pieModel.etiqueta.removeLast();
                            pieModel.valor.removeLast();
                          });

                          pieRepository.guardarTajadasDatos(pieModel);

                          Navigator.pop(ctx);
                        }
                      });
                    },
                    label: const Text('Borrar último'),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  PieChart _dibujarPie() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 5,
        centerSpaceRadius: 40,
        sections: showingSections(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return _pieModel!.valor.asMap().entries.map((elemento) {
      final isTouched = elemento.key == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: _colores[elemento.key],
        value: elemento.value,
        title: _pieModel!.etiqueta[elemento.key],
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _etiquetaTextEditingController.dispose();
    _valorTextEditingController.dispose();
  }
}

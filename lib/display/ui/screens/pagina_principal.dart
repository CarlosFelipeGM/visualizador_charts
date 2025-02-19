import 'package:flutter/material.dart';
import 'package:visualizador_charts/display/routes/routes.dart';
import 'package:visualizador_charts/display/ui/components/tile_de_graficos.dart';

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizador de Charts'),
      ),
      body: ListView(
        children: [
          TileDeGraficos(
            titulo: 'Gráfico de barras',
            alPresionar: () {
              Navigator.pushNamed(context, Routes.graficoBarras);
            },
          ),
          TileDeGraficos(
            titulo: 'Gráfico de lineas',
            alPresionar: () {
              Navigator.pushNamed(context, Routes.graficoLineas);
            },
          ),
          TileDeGraficos(
            titulo: 'Gráfico de Pies',
            alPresionar: () {
              Navigator.pushNamed(context, Routes.graficoPies);
            },
          ),
        ],
      ),
    );
  }
}

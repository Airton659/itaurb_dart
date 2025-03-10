import 'package:flutter/material.dart';
import '../models/bairro.dart';
import '../data/bairros_data.dart';
import '../services/notification_service.dart';
import 'bairro_detail_screen.dart';

class NeighborhoodsScreen extends StatefulWidget {
  @override
  _NeighborhoodsScreenState createState() => _NeighborhoodsScreenState();
}

class _NeighborhoodsScreenState extends State<NeighborhoodsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<Bairro> bairros = [];
  List<String> bairrosFavoritos = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  List<Bairro> _filteredBairros = [];

  @override
  void initState() {
    super.initState();
    _inicializarDados();
  }

  Future<void> _inicializarDados() async {
    // Carregar bairros favoritos
    bairrosFavoritos = await _notificationService.getBairrosFavoritos();
    
    // Converter dados de bairros para o modelo
    bairrosData.forEach((nomeBairro, dadosColeta) {
      Bairro bairro = Bairro.fromJson(nomeBairro, dadosColeta);
      
      // Verificar se é favorito
      if (bairrosFavoritos.contains(nomeBairro)) {
        bairro.favorito = true;
      }
      
      bairros.add(bairro);
    });
    
    _filteredBairros = List.from(bairros);
    
    setState(() {
      isLoading = false;
    });

    // Se quiser testar notificações, você pode adicionar este código
    // para agendar uma notificação para 10 segundos no futuro
    // _scheduleTestNotification();
  }

  // Future<void> _scheduleTestNotification() async {
  //   await _notificationService.scheduleTestNotification();
  // }

  void _filterBairros(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBairros = List.from(bairros);
      } else {
        _filteredBairros = bairros
            .where((bairro) => bairro.nome.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar bairro...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: _filterBairros,
          ),
        ),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : _filteredBairros.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum bairro encontrado',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredBairros.length,
                      itemBuilder: (context, index) {
                        final bairro = _filteredBairros[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(
                              bairro.nome,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Clique para ver detalhes das coletas'),
                            trailing: IconButton(
                              icon: Icon(
                                bairro.favorito ? Icons.star : Icons.star_border,
                                color: bairro.favorito ? Colors.amber : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  bairro.favorito = !bairro.favorito;
                                });

                                if (bairro.favorito) {
                                  _notificationService.agendarNotificacoesBairro(bairro);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Notificações ativadas para ${bairro.nome}'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  _notificationService.cancelarNotificacoesBairro(bairro);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Notificações desativadas para ${bairro.nome}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BairroDetailScreen(bairro: bairro),
                                ),
                              ).then((_) {
                                // Atualizar estado ao voltar
                                setState(() {});
                              });
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
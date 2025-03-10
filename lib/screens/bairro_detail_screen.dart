import 'package:flutter/material.dart';
import '../models/bairro.dart';
import '../services/notification_service.dart';

class BairroDetailScreen extends StatefulWidget {
  final Bairro bairro;

  const BairroDetailScreen({super.key, required this.bairro});

  @override
  _BairroDetailScreenState createState() => _BairroDetailScreenState();
}

class _BairroDetailScreenState extends State<BairroDetailScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bairro.nome),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(
              widget.bairro.favorito ? Icons.star : Icons.star_border,
              color: widget.bairro.favorito ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              setState(() {
                widget.bairro.favorito = !widget.bairro.favorito;
              });

              if (widget.bairro.favorito) {
                _notificationService.agendarNotificacoesBairro(widget.bairro);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Notificações ativadas para ${widget.bairro.nome}'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                _notificationService.cancelarNotificacoesBairro(widget.bairro);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Notificações desativadas para ${widget.bairro.nome}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTipoColetaSection('Orgânica', Colors.brown),
            SizedBox(height: 24),
            _buildTipoColetaSection('Seletiva', Colors.blue),
            SizedBox(height: 24),
            _buildTipoColetaSection('Apoio', Colors.orange),
            SizedBox(height: 24),
            widget.bairro.favorito
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Você receberá notificações um dia antes de cada coleta.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Marque como favorito para receber notificações.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipoColetaSection(String tipoColeta, Color cor) {
    List coletas = widget.bairro.coletas[tipoColeta] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Coleta $tipoColeta',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: 8),
        if (coletas.isEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Não há coletas programadas deste tipo'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: coletas.length,
            itemBuilder: (context, index) {
              final coleta = coletas[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: cor),
                  title: Text(coleta.dia),
                  subtitle: Text('Horário: ${coleta.horario}'),
                ),
              );
            },
          ),
      ],
    );
  }
}
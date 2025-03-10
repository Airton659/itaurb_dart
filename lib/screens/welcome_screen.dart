import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo ao App de Coleta de Lixo',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Este aplicativo ajuda você a acompanhar os dias de coleta de lixo no seu bairro.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Como usar:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                SizedBox(height: 12),
                _buildInstructionItem(
                  icon: Icons.list,
                  text: 'Explore os bairros na aba "Bairros"',
                ),
                _buildInstructionItem(
                  icon: Icons.star,
                  text: 'Marque seus bairros como favoritos',
                ),
                _buildInstructionItem(
                  icon: Icons.notifications,
                  text: 'Receba notificações um dia antes da coleta',
                ),
                _buildInstructionItem(
                  icon: Icons.contact_phone,
                  text: 'Entre em contato conosco na aba "Contato"',
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Card(
            elevation: 4,
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipos de coleta:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildCollectionType(
                    color: Colors.brown,
                    title: 'Orgânica',
                    description: 'Restos de alimentos, materiais não recicláveis',
                  ),
                  SizedBox(height: 8),
                  _buildCollectionType(
                    color: Colors.blue,
                    title: 'Seletiva',
                    description: 'Materiais recicláveis: papel, plástico, vidro, metal',
                  ),
                  SizedBox(height: 8),
                  _buildCollectionType(
                    color: Colors.orange,
                    title: 'Apoio',
                    description: 'Coletas especiais como volumosos e rejeitos',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionType({
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          margin: EdgeInsets.only(top: 4),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
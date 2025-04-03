import 'package:flutter/material.dart';
import '../widgets/service_info_modal.dart';

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
          Card(
            elevation: 4,
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home_repair_service, 
                        size: 24, 
                        color: Colors.blue.shade800
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Serviços',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildServiceType(
                    context: context,
                    color: Colors.brown,
                    title: 'Orgânica',
                    modalTitle: 'Coleta Orgânica',
                    modalContent: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Proin in neque euismod, tincidunt risus nec, faucibus eros. '
                      'Quisque eget ipsum at elit ullamcorper pulvinar. '
                      'Nullam convallis urna in magna vestibulum, non vulputate nunc pellentesque.',
                  ),
                  SizedBox(height: 8),
                  _buildServiceType(
                    context: context,
                    color: Colors.blue,
                    title: 'Seletiva',
                    modalTitle: 'Coleta Seletiva',
                    modalContent: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Nunc at ultricies est. Phasellus mattis, eros non bibendum volutpat, '
                      'ipsum magna ornare dui, non luctus magna ex ut diam. '
                      'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae.',
                  ),
                  SizedBox(height: 8),
                  _buildServiceType(
                    context: context,
                    color: Colors.orange,
                    title: 'Apoio',
                    modalTitle: 'Coleta de Apoio',
                    modalContent: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Vivamus ultrices vehicula odio ac varius. '
                      'Nulla in enim tortor. Sed scelerisque tellus eget risus eleifend, '
                      'vitae condimentum nulla rutrum. Donec at mi finibus, lacinia orci nec, volutpat eros.',
                  ),
                  SizedBox(height: 8),
                  _buildServiceType(
                    context: context,
                    color: Colors.green,
                    title: 'Ecoponto',
                    modalTitle: 'Ecoponto',
                    modalContent: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Aliquam erat volutpat. Etiam non lectus in dolor efficitur placerat. '
                      'Nulla facilisi. Donec finibus magna eget eros dictum, ut efficitur mauris blandit. '
                      'Aenean semper mi vel urna pellentesque, ac luctus velit ultrices.',
                  ),
                  SizedBox(height: 8),
                  _buildServiceType(
                    context: context,
                    color: Colors.red,
                    title: 'Vigilância Patrimonial',
                    modalTitle: 'Vigilância Patrimonial',
                    modalContent: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Mauris tristique, massa et molestie facilisis, mi tortor porttitor nunc, '
                      'vel varius nulla magna ac lacus. Maecenas convallis vel ligula in fringilla. '
                      'Phasellus iaculis porttitor elementum.',
                  ),
                  SizedBox(height: 8),
                  _buildServiceType(
                    context: context,
                    color: Colors.purple,
                    title: 'Obras Públicas',
                    modalTitle: 'Obras Públicas',
                    modalContent: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Etiam commodo, dui sit amet auctor egestas, dolor felis euismod nisi, '
                      'a efficitur eros risus at lectus. Morbi sodales nibh vitae ex convallis, '
                      'eu volutpat arcu vulputate. Sed congue dolor sed felis placerat scelerisque.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceType({
    required BuildContext context,
    required Color color,
    required String title,
    String? description,  // Tornando o description opcional
    required String modalTitle,
    required String modalContent,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          _showServiceModal(
            context, 
            modalTitle,
            modalContent,
            color,
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }

  void _showServiceModal(
    BuildContext context, 
    String title, 
    String content,
    Color color,
  ) {
    showServiceInfoModal(
      context: context,
      title: title,
      content: content,
      color: color,
    );
  }
}
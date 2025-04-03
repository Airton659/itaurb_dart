import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  // Novos controllers para campos de endereço
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  String _selectedService = '';
  final List<Map<String, String>> _serviceTypes = [
    {'label': 'Selecione o tipo de serviço', 'value': ''},
    {'label': 'Sugestão', 'value': 'reclamacao'},
    // {'label': 'Coleta Especial', 'value': 'coleta_especial'},
    {'label': 'Lixo não recolhido', 'value': 'lixo_nao_recolhido'},
    {'label': 'Animal Morto', 'value': 'animal_morto'},
    {'label': 'Dúvida', 'value': 'duvida'},
  ];

  final String _whatsappNumber = '553138334000';

void _formatPhoneNumber(String text) {
  final cleanedText = text.replaceAll(RegExp(r'[^0-9]'), ''); // Remove caracteres não numéricos
  String formattedText = cleanedText;

  // Aplica a formatação apenas se o número tiver 11 dígitos
  if (cleanedText.length == 11) {
    formattedText = cleanedText.replaceAllMapped(
      RegExp(r'^(\d{2})(\d{5})(\d{4})$'),
      (match) => '(${match[1]}) ${match[2]}-${match[3]}',
    );
  }

  // Limita o texto a 15 caracteres (formato: (99) 99999-9999)
  if (formattedText.length > 15) {
    formattedText = formattedText.substring(0, 15);
  }

  _phoneController.value = TextEditingValue(
    text: formattedText,
    selection: TextSelection.collapsed(offset: formattedText.length),
  );
}

  bool _validatePhoneNumber(String phone) {
    final cleanedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return cleanedPhone.length == 11 && cleanedPhone[2] == '9';
  }

  Future<void> _sendToWhatsApp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_validatePhoneNumber(_phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira um número de celular válido com DDD (11 dígitos começando com 9).'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final message = '''
🔔 *NOVA SOLICITAÇÃO DE ATENDIMENTO*

👤 *Nome:* ${_nameController.text}
📱 *Telefone:* ${_phoneController.text}
${_emailController.text.isNotEmpty ? '📧 *E-mail:* ${_emailController.text}\n' : ''}
🔧 *Tipo de Serviço:* ${_serviceTypes.firstWhere((t) => t['value'] == _selectedService)['label']}

📍 *Endereço:*
Bairro: ${_bairroController.text}
${_ruaController.text.isNotEmpty ? 'Rua: ${_ruaController.text}\n' : ''}
${_numeroController.text.isNotEmpty ? 'Número: ${_numeroController.text}\n' : ''}

📝 *Mensagem:*
${_messageController.text}
    '''.trim();

    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = 'whatsapp://send?phone=$_whatsappNumber&text=$encodedMessage';

    try {
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        final webWhatsappUrl = 'https://wa.me/$_whatsappNumber?text=$encodedMessage';
        await launch(webWhatsappUrl);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao abrir WhatsApp. Certifique-se de que o aplicativo está instalado.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.green.shade800),
            ),
            SizedBox(width: 16),
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
                    content,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

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
                    'Entre em Contato',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Estamos aqui para ajudar! Envie suas dúvidas, sugestões ou relatos sobre a coleta de lixo.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite seu nome';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Celular *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: _formatPhoneNumber,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite seu celular';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Seção de endereço
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                'Endereço',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _bairroController,
                            decoration: InputDecoration(
                              labelText: 'Bairro *',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, informe o bairro';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _ruaController,
                            decoration: InputDecoration(
                              labelText: 'Rua',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _numeroController,
                            decoration: InputDecoration(
                              labelText: 'Número',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedService,
                      decoration: InputDecoration(
                        labelText: 'Tipo de Serviço *',
                        border: OutlineInputBorder(),
                      ),
                      items: _serviceTypes.map((service) {
                        return DropdownMenuItem<String>(
                          value: service['value'],
                          child: Text(service['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedService = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, selecione um tipo de serviço';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Mensagem *',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite sua mensagem';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _sendToWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Enviar Mensagem',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outras formas de contato:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildContactItem(
                    icon: Icons.phone,
                    title: 'Telefone',
                    content: '(31) 3833-4010',
                    onTap: () => _launchUrl('tel:3138334010'),
                  ),
                  Divider(),
                  _buildContactItem(
                    icon: Icons.email_outlined,
                    title: 'E-mail',
                    content: 'itaurb.oficial@itaurb.com.br',
                    onTap: () => _launchUrl('mailto:itaurb.oficial@itaurb.com.br'),
                  ),
                  Divider(),
                  _buildContactItem(
                    icon: Icons.location_on,
                    title: 'Endereço',
                    content: 'Av. Carlos Drummond de Andrade, 50 - Centro',
                    onTap: () => _launchUrl('https://maps.google.com'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
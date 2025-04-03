import 'package:flutter/material.dart';

class ServiceInfoModal extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final String? imageUrl;

  const ServiceInfoModal({
    super.key,
    required this.title,
    required this.content,
    required this.color,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey.shade200,
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Imagem ilustrativa',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                content,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: color.withOpacity(0.2),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Fechar',
                style: TextStyle(color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Função auxiliar para exibir o modal
void showServiceInfoModal({
  required BuildContext context,
  required String title,
  required String content,
  required Color color,
  String? imageUrl,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ServiceInfoModal(
        title: title,
        content: content,
        color: color,
        imageUrl: imageUrl,
      );
    },
  );
}
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bairro.dart';
import '../models/coleta.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_notification_app_icon',
      [
        NotificationChannel(
          channelKey: 'coleta_notification',
          channelName: 'Notificações de Coleta',
          channelDescription: 'Notificações sobre coletas de lixo',
          defaultColor: Colors.green,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        )
      ],
    );

    // Solicitar permissão para notificações
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  // Agendar todas as notificações para um bairro
  Future<void> agendarNotificacoesBairro(Bairro bairro) async {
    if (!bairro.favorito) return;

    // Cancelar notificações existentes para este bairro
    await cancelarNotificacoesBairro(bairro);

    // Para cada tipo de coleta
    bairro.coletas.forEach((tipoColeta, listaColetas) {
      // Para cada dia de coleta
      for (var coleta in listaColetas) {
        _agendarNotificacaoRecorrente(bairro.nome, tipoColeta, coleta);
      }
    });

    // Salvar bairro nos favoritos
    await _salvarBairroFavorito(bairro);
  }

  Future<void> _agendarNotificacaoRecorrente(String bairro, String tipoColeta, Coleta coleta) async {

    // Converter dia da semana para número (0 = domingo, 1 = segunda, etc.)
    int diaSemana = _converterDiaParaNumero(coleta.dia);
    
    // Parsear horário
    List<String> horario = coleta.horario.split(':');
    int hora = int.parse(horario[0]);
    int minuto = int.parse(horario[1]);
    
    // Calcular o próximo dia da semana
    DateTime agora = DateTime.now();
    DateTime proximaData = _proximaDataDoDia(diaSemana);
    
    // Definir horário da notificação (um dia antes, mesmo horário)
    DateTime notificacaoData = proximaData.subtract(Duration(days: 1));
    notificacaoData = DateTime(
      notificacaoData.year, 
      notificacaoData.month, 
      notificacaoData.day, 
      hora, 
      minuto
    );
    
    // Se a data já passou, avançar uma semana
    if (notificacaoData.isBefore(agora)) {
      notificacaoData = notificacaoData.add(Duration(days: 7));
    }

    // Criar ID único para a notificação
    int notificationId = (bairro.hashCode ^ tipoColeta.hashCode ^ coleta.dia.hashCode ^ coleta.horario.hashCode) & 0x7FFFFFFF;

    // Agendar notificação recorrente
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'coleta_notification',
        title: 'Coleta de Lixo Amanhã',
        body: 'Coleta $tipoColeta no bairro $bairro amanhã às ${coleta.horario}',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        weekday: notificacaoData.weekday,
        hour: notificacaoData.hour,
        minute: notificacaoData.minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  int _converterDiaParaNumero(String dia) {
    switch (dia.toLowerCase()) {
      case 'domingo': return 7;
      case 'segunda': return 1;
      case 'terça': return 2;
      case 'quarta': return 3;
      case 'quinta': return 4;
      case 'sexta': return 5;
      case 'sábado': return 6;
      default: return 1; // Segunda por padrão
    }
  }

  DateTime _proximaDataDoDia(int diaSemana) {
    DateTime agora = DateTime.now();
    int diasAteProximo = (diaSemana - agora.weekday) % 7;
    if (diasAteProximo == 0) {
      diasAteProximo = 7; // Se for hoje, considerar próxima semana
    }
    return agora.add(Duration(days: diasAteProximo));
  }

  Future<void> cancelarNotificacoesBairro(Bairro bairro) async {
    // Para cancelar todas as notificações relacionadas a um bairro,
    // temos que identificar os IDs das notificações

    bairro.coletas.forEach((tipoColeta, listaColetas) {
      for (var coleta in listaColetas) {
        // Gerar um ID mais previsível e garantir que seja um inteiro de 32 bits
        // usando operador & com 0x7FFFFFFF para limitar ao valor máximo positivo de 32 bits
        int notificationId = (bairro.nome.hashCode ^ tipoColeta.hashCode ^ coleta.dia.hashCode ^ coleta.horario.hashCode) & 0x7FFFFFFF;
        AwesomeNotifications().cancel(notificationId);
      }
    });

    if (!bairro.favorito) {
      await _removerBairroFavorito(bairro);
    }
  }

  Future<void> _salvarBairroFavorito(Bairro bairro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritos = prefs.getStringList('bairros_favoritos') ?? [];
    
    if (!favoritos.contains(bairro.nome)) {
      favoritos.add(bairro.nome);
      await prefs.setStringList('bairros_favoritos', favoritos);
    }
  }

  Future<void> _removerBairroFavorito(Bairro bairro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritos = prefs.getStringList('bairros_favoritos') ?? [];
    
    if (favoritos.contains(bairro.nome)) {
      favoritos.remove(bairro.nome);
      await prefs.setStringList('bairros_favoritos', favoritos);
    }
  }

  Future<List<String>> getBairrosFavoritos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('bairros_favoritos') ?? [];
  }

  // Future<void> scheduleTestNotification() async {
  // await AwesomeNotifications().createNotification(
  //   content: NotificationContent(
  //     id: 1000,
  //     channelKey: 'coleta_notification',
  //     title: 'Teste de Notificação',
  //     body: 'Esta é uma notificação de teste para verificar se está funcionando.',
  //     notificationLayout: NotificationLayout.Default,
  //   ),
  //   schedule: NotificationCalendar(
  //     second: 10,  // Agenda para 10 segundos no futuro
  //     repeats: false,
  //   ),
  //   );
  // }
}
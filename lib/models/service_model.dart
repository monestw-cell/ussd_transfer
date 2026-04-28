enum ServiceStatus { active, disabled }

  class TransferService {
    final String id;
    final String name;
    final String ussdCode;
    final String icon;
    final ServiceStatus status;
    final String? disabledMessage;

    const TransferService({
      required this.id,
      required this.name,
      required this.ussdCode,
      required this.icon,
      required this.status,
      this.disabledMessage,
    });
  }

  const List<TransferService> services = [
    TransferService(
      id: 'bank_palestine',
      name: 'بنك فلسطين',
      ussdCode: '*267#',
      icon: '🏦',
      status: ServiceStatus.active,
    ),
    TransferService(
      id: 'jawwal_pay',
      name: 'جوال باي',
      ussdCode: '*110#',
      icon: '📱',
      status: ServiceStatus.active,
    ),
    TransferService(
      id: 'pal_pay',
      name: 'بال بي',
      ussdCode: '*370#',
      icon: '⚠️',
      status: ServiceStatus.disabled,
      disabledMessage: 'هذه الخدمة متوقفة حالياً من المصدر',
    ),
  ];
  
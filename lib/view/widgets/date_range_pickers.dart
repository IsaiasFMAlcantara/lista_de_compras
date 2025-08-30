import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/controller/spending_analysis_controller.dart';

class DateRangePickers extends StatelessWidget {
  final SpendingAnalysisController controller;

  const DateRangePickers({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: controller.startDate.value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                controller.updateDateRange(picked, controller.endDate.value);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Data Inicial',
                border: OutlineInputBorder(),
              ),
              child: Text(
                controller.startDate.value != null
                    ? DateFormat(
                        'dd/MM/yyyy',
                      ).format(controller.startDate.value!)
                    : 'Selecione',
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: controller.endDate.value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                controller.updateDateRange(controller.startDate.value, picked);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Data Final',
                border: OutlineInputBorder(),
              ),
              child: Text(
                controller.endDate.value != null
                    ? DateFormat('dd/MM/yyyy').format(controller.endDate.value!)
                    : 'Selecione',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

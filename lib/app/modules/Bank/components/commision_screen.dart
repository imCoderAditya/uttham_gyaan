// lib/screens/commissions_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/coustom_bar.dart';
import '../controllers/bank_controller.dart';

class CommissionsScreen extends GetView<BankController> {
  const CommissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {

         return GetBuilder<BankController>(init:BankController(),

      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Commissions'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: controller.fetchCommissions,
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.error.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(controller.error.value, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.fetchCommissions,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final commissions = controller.filteredCommissions;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Earnings: \R${controller.commissionResponse.value.totalSuccessAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: controller.filterStatus.value,
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                          DropdownMenuItem(value: 'Success', child: Text('Success')),
                        ],
                        onChanged: (value) => controller.setFilter(value!),
                        hint: const Text('Filter by Status'),
                      ),
                      DropdownButton<String>(
                        value: controller.sortBy.value,
                        items: const [
                          DropdownMenuItem(value: 'none', child: Text('No Sort')),
                          DropdownMenuItem(value: 'amount', child: Text('Sort by Amount')),
                          DropdownMenuItem(value: 'date', child: Text('Sort by Date')),
                        ],
                        onChanged: (value) => controller.setSort(value!),
                        hint: const Text('Sort By'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Referred User', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: commissions
                          .map(
                            (commission) => DataRow(
                          cells: [
                            DataCell(Text(commission.commissionId.toString())),
                            DataCell(Text(commission.referredUserName)),
                            DataCell(Text('\$${commission.amount.toStringAsFixed(2)}')),
                            DataCell(
                              Chip(
                                label: Text(commission.status),
                                backgroundColor:
                                commission.status == 'Success' ? Colors.green[100] : Colors.red[100],
                                labelStyle: TextStyle(
                                  color: commission.status == 'Success' ? Colors.green[800] : Colors.red[800],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(DateTime.parse(commission.generatedDate)),
                              ),
                            ),
                          ],
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Commission Earnings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CustomBarChart(commissions: commissions),
                ],
              ),
            );
          }),
        );
      }
    );
  }
}
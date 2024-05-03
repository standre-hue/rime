// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/Info.dart';
import 'package:rime/data/models/Transaction.dart';
import 'package:rime/data/repositories/InfoRepository.dart';
import 'package:rime/data/repositories/TransactionRepository.dart';
import 'package:rime/presentation/providers/InfoProvider.dart';
import 'package:rime/presentation/providers/TransactionProvider.dart';
import 'package:rime/presentation/screens/components/my_fields.dart';
import 'package:rime/presentation/utils/constants.dart';
import 'package:rime/presentation/utils/responsive.dart';
import 'package:rime/presentation/widgets/CustomAppBar.dart';
import 'package:rime/presentation/widgets/CustomDrawer.dart';
import 'package:rime/presentation/widgets/TransactionCardDetails.dart';

import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  InfoRepository infoRepository = InfoRepository();
  TransactionRepository transactionRepository = TransactionRepository();
  List<Transaction> transactions = [];

  void loadData() async {
    try {
      List<Info> infos = [];

      Info info = await infoRepository.getTmoneyDepotInfo();
      Info info2 = await infoRepository.getTmoneyRetraitInfo();

      Info info3 = await infoRepository.getFloozDepotInfo();
      Info info4 = await infoRepository.getFloozRetraitInfo();

      infos.addAll([info, info2, info3, info4]);

      transactions = await transactionRepository.getRecentTransaction(10);


      context.read<InfoProvider>().setInfos(infos);
      context.read<TransactionProvider>().setRecentTransactions(transactions);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: "Dashboard",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        TransactionCardDetails(),
                        SizedBox(height: defaultPadding),
                        RecentTransaction(),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context)) StorageDetails(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: defaultPadding),
                  // On Mobile means if the screen is less than 850 we don't want to show it
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 2,
                      child: StorageDetails(),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

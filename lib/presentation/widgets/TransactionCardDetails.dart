import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rime/data/models/MyFiles.dart';
import 'package:rime/presentation/providers/InfoProvider.dart';
import 'package:rime/presentation/screens/components/file_info_card.dart';
import 'package:rime/presentation/utils/constants.dart';
import 'package:rime/presentation/utils/responsive.dart';
import 'package:rime/presentation/widgets/SaveTransactionDialog.dart';
import 'package:rime/presentation/widgets/TransactionCardDetail.dart';

class TransactionCardDetails extends StatefulWidget {
  const TransactionCardDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<TransactionCardDetails> createState() => _TransactionCardDetailsState();
}

class _TransactionCardDetailsState extends State<TransactionCardDetails> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Statistiques",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SaveTransactionDialog();
                    });
              },
              icon: Icon(Icons.add),
              label: Text("Ajouter une transaction"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: context.watch<InfoProvider>().infos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => TransactionCardDetail(
          info: context.watch<InfoProvider>().infos[index]),
    );
  }
}

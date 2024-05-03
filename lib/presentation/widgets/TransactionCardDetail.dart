import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rime/data/models/Info.dart';
import 'package:rime/presentation/utils/constants.dart';
import 'package:rime/presentation/utils/funcs.dart';

class TransactionCardDetail extends StatelessWidget {
  const TransactionCardDetail({super.key, required this.info, });


  final Info info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                
              ),
              IconButton(  
                onPressed: (){
                  
                },
                icon:Icon(Icons.more_vert, color: Colors.white54))
            ],
          ),
          Row(
            children: [
              Text(
                "Nombre de ${info.opType}: ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(frenchFormat.format(info.number),style: const TextStyle(fontWeight: FontWeight.bold,fontSize:18),)
            ],
          ),
          Row(
            children: [
              const Text(
                "Montant total: ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(frenchFormat.format(info.value),style:const TextStyle(fontWeight: FontWeight.bold,fontSize:18))
            ],
          ),
          /*ProgressLine(
            color: Colors.red,
            percentage: info.percentage,
          ),*/
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "2 Files",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white70),
              ),
              Text(
                "23",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
            ],
          )*/
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

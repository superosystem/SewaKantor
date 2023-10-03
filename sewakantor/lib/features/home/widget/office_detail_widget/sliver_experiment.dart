import 'package:flutter/material.dart';
import 'package:sewakantor/utils/adapt_size.dart';

class Sliver_Experiment extends StatefulWidget {
  const Sliver_Experiment({super.key});

  @override
  State<Sliver_Experiment> createState() => _Sliver_ExperimentState();
}

class _Sliver_ExperimentState extends State<Sliver_Experiment> {
  @override
  Widget build(BuildContext context) {
    AdaptSize.size(context: context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [SliverAppBar(), SliverToBoxAdapter(child: Container())],
      ),
    );
  }
}

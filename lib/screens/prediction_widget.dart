import 'package:baybayin_character_recognition/utils/baybayin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/prediction.dart';
import '../provider/prediction_provider.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;
  const PredictionWidget({super.key, required this.predictions});

  Widget _characterWidget(int index, Prediction? prediction, double labelSize,
      double charFontSize, double predSize) {
    return Column(
      children: [
        Text(
          Baybayin.labels[index],
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: labelSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          Baybayin.characters[index],
          style: TextStyle(
            fontSize: charFontSize,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.red.withOpacity(
                    (prediction.confidence * 2).clamp(0, 1).toDouble(),
                  ),
          ),
        ),
        Text(
          prediction == null ? '' : prediction.confidence.toStringAsFixed(2),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: predSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  List<dynamic> _getPredictionStyles(List<Prediction> predictions) {
    List<dynamic> data = List.filled(63, null);
    for (var pred in predictions) {
      data[pred.index] = pred;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = Provider.of<PredictionProvider>(context).isLoading;
    var styles = _getPredictionStyles(predictions);

    if (predictions.isEmpty && isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (predictions.length == 1) {
      Future.microtask(() {
        Provider.of<PredictionProvider>(context, listen: false)
            .setLoading(false);
      });
      return _characterWidget(predictions[0].index, predictions[0], 18, 60, 14);
    } else {
      Future.microtask(() {
        Provider.of<PredictionProvider>(context, listen: false)
            .setLoading(false);
      });
      return Column(
        children: [
          _characterWidget(predictions[0].index, predictions[0], 18, 60, 14),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(width: 30),
              scrollDirection: Axis.horizontal,
              itemCount: predictions.length - 1,
              itemBuilder: (context, index) {
                return _characterWidget(predictions[index + 1].index,
                    styles[predictions[index + 1].index], 14, 45, 14);
              },
            ),
          ),
        ],
      );
    }
  }
}

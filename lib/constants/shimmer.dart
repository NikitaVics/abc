import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Container(
                  width: 120,
                  height: 16,
                  color: Colors.white,
                ),
                Container(
                  width: 80,
                  height: 16,
                  color: Colors.white,
                ),
                 Container(
                  width: 120,
                  height: 16,
                  color: Colors.white,
                ),
                Container(
                  width: 80,
                  height: 16,
                  color: Colors.white,
                ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 4,
            )
          ],
        ),
      ),
    );
  }
}
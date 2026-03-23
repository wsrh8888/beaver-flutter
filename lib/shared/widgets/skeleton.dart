import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final ShapeBorder? shape;

  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.shape,
  });

  const Skeleton.circle({
    super.key,
    required double size,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  })  : width = size,
        height = size,
        borderRadius = size / 2,
        shape = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        period: const Duration(milliseconds: 1500),
        child: Container(
          width: width,
          height: height,
          decoration: shape != null
              ? ShapeDecoration(shape: shape!, color: Colors.white)
              : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
        ),
      ),
    );
  }
}

// 可选：针对 IM 列表、联系人等预设的几种骨架形态
class ListSkeleton extends StatelessWidget {
  final int count;
  const ListSkeleton({super.key, this.count = 10});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: count,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              const Skeleton.circle(size: 50),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(width: MediaQuery.of(context).size.width * 0.4, height: 16),
                    const SizedBox(height: 8),
                    Skeleton(width: MediaQuery.of(context).size.width * 0.7, height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

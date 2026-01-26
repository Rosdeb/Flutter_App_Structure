import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.backgroundColor,
    required this.height,
    required this.width,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius,
            shape: boxShape,
            color: backgroundColor,
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: colorFilter),
          ),
          child: child,
        ),
        placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800.withOpacity(0.6)
                : Colors.grey.withOpacity(0.6),
            highlightColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade700.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                border: border,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800.withOpacity(0.6)
                    : Colors.grey.withOpacity(0.6),
                borderRadius: borderRadius,
                shape: boxShape,
              ),
            )),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800.withOpacity(0.6)
                : Colors.grey.withOpacity(0.6),
            borderRadius: borderRadius,
            shape: boxShape,
          ),
          child: Icon(
            Icons.error,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade600
                : null,
          ),
        ));
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackagePanel extends StatelessWidget {
  const PackagePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sticker Packages',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF2D3436),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            'Package list / favorite package / package detail is reserved here.',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF7D8790),
              height: 1.5,
            ),
          ),
          SizedBox(height: 12.w),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.w),
                border: Border.all(color: const Color(0xFFE7ECF1)),
              ),
              alignment: Alignment.center,
              child: Text(
                'Waiting for EmojiStore package data',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFFA4ADB7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

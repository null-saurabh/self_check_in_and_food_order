import 'package:flutter/material.dart';
import 'package:wandercrew/widgets/widget_support.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final TextStyle? selectedTextStyle;
  final TextStyle? notSelectedTextStyle;

  const FilterButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap, this.selectedTextStyle, this.notSelectedTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            color: Color(0xffEDCC23).withOpacity(0.60),
          ),
        ),
        child: Text(
          label,
          style: isSelected ? selectedTextStyle != null ? selectedTextStyle : AppWidget.black12Text600Style() : selectedTextStyle != null ? notSelectedTextStyle :AppWidget.black12Text400Style(),
        ),
      ),
    );
  }
}
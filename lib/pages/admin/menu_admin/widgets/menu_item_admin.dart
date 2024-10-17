import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import '../../../../models/menu_item_model.dart';

class MenuItemWidget extends StatefulWidget {
  final MenuItemModel menuItem;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final void Function(bool) onToggleAvailability;
  final VoidCallback onEditPrice;
  final VoidCallback onEditNote;

  const MenuItemWidget({
    super.key,
    required this.menuItem,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
    required this.onEditPrice,
    required this.onEditNote,
  });

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  bool isExpanded = false;
  bool isOtherExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            // border: Border.all(color: Colors.black.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0.2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent, // Removes the border between expanded items
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ExpansionTile(
                backgroundColor: Colors.transparent,
                maintainState: true,
                title: Row(
                  children: [
                    Text(
                      widget.menuItem.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(" (!)",style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.red),),
                    Spacer(),
                    GestureDetector(
                      onTap: widget.onEdit,
                      child:Icon(Icons.edit, size: 16,color: Colors.black,
                      ),),
                    SizedBox(width: 8,),
                    GestureDetector(
                      onTap:widget.onDelete,
                      child:Icon(Icons.delete, size: 16,color: Colors.red,
                      ),),

                  ],
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    isExpanded = expanded;
                  });
                },
                children: isExpanded
                    ? [
                  _buildRowWithEdit("Price", "₹${widget.menuItem.price}", widget.onEditPrice),
                  if(widget.menuItem.stockCount != null)
                    _buildRow("Stock Count", "${widget.menuItem.stockCount.toString()}",false),
                  _buildRow("Preference", widget.menuItem.isVeg ? "Veg" : "Non-Veg",false),
                  _buildRow("Category", widget.menuItem.category,false),
                  _buildRow("Description", widget.menuItem.description ?? "",false),
                  _buildRowWithEdit("Note", widget.menuItem.notes ?? "No Notes", widget.onEditNote, textColor: Colors.red),
                  _buildSwitchRow("Availability", widget.menuItem.isAvailable),
                  _buildOthersSection(),
                ]
                    : [],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildRow(String title, String value,bool copyFunction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ", style: AppWidget.black16Text500Style()),
          Flexible(
            child: Text(value,style: AppWidget.black16Text400Style(),overflow: TextOverflow.visible, // Allow text to wrap
                softWrap: true,),
          ),
          if(copyFunction)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));


              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  width: 100,
                  backgroundColor: Colors.black.withOpacity(0.8),
                  content: Text("Copied!"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );

            },
            child: const Icon(
              Icons.copy,
              color: Colors.grey,
            ),
          ),



        ],
      ),
    );
  }

  Widget _buildRowWithEdit(String title, String value, VoidCallback onEdit, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("$title: ", style: AppWidget.black16Text500Style()),
          Row(
            children: [
              Text(value, style: TextStyle(color: textColor,fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins')),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onEdit,
                child:Icon(Icons.edit, size: 16,color: Color(0xff2563EB),
              ),)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String title, bool value) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      value: value,
      onChanged: widget.onToggleAvailability,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.white,
      activeTrackColor: Color(0xff2563EB),
      activeColor: Colors.white,
    );
  }

  Widget _buildOthersSection() {
    return ExpansionTile(
      title: const Text("Others", style: TextStyle(fontWeight: FontWeight.bold)),
      onExpansionChanged: (expanded) {
        setState(() {
          isOtherExpanded = expanded;
        });
      },
      children: isOtherExpanded
          ? [
        _buildRow("Preparation Time", widget.menuItem.preparationTime?.toString() ?? "N/A",false),
        _buildRow("Availability Time", "",false),
        // _buildRow("Offer Price", widget.menuItem.discountPrice != null ? "₹${widget.menuItem.discountPrice}" : "N/A"),
        _buildRow("No. of Orders", "${widget.menuItem.noOfOrders.toString()}",false),
        _buildRow("Item Image", widget.menuItem.image ?? "N/A",true),
        _buildRow("Item Tag", widget.menuItem.tags?.join(", ") ?? "N/A",false),
      ]
          : [],
    );
  }
}

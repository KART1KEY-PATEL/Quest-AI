import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/customTextField.dart';
import 'package:questias/utils/textUtil.dart';
import 'package:questias/widget/space_widget.dart';

class AddBooksPage extends StatelessWidget {
  AddBooksPage({super.key});
  List<String> _list = [
    'Developer',
    'Designer',
    'Consultant',
    'Student',
    'Add new category'
  ];
  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.sizeOf(context).width;
    double sH = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: customAppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: "Add Book",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sW * 0.05,
          vertical: sH * 0.02,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  CustomTextField(
                    hintText: "Book Title",
                    controller: TextEditingController(),
                    validate: true,
                    maxLines: 1,
                  ),
                  SpacingWidget(height: 0.02),
                  CustomTextField(
                    hintText: "Book Description",
                    controller: TextEditingController(),
                    validate: true,
                    maxLines: 5,
                  ),
                  SpacingWidget(height: 0.02),
                  CustomDropdown<String>(
                    listItemBuilder: (context, item, isSelected, onItemSelect) {
                      return Container(
                        child: txt(
                          item,
                        ),
                      );

                      return ListTile(
                        title: Text(item),
                        onTap: onItemSelect,
                        selected: isSelected,
                      );
                    },
                    hintText: 'Select job role',
                    items: _list,
                    initialItem: _list[0],
                    onChanged: (value) {
                      if (value == 'Add new category') {
                        Navigator.pushNamed(context, '/newCatgory');
                      }
                      print('changing value to: $value');
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

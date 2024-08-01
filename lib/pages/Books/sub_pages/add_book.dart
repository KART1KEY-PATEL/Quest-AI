import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/controller/book_provider.dart';
import 'package:questias/controller/category_provider.dart';
import 'package:questias/models/book_model.dart';
import 'package:questias/services/BackendService.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/customTextField.dart';
import 'package:questias/utils/textUtil.dart';
import 'package:questias/widget/space_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class AddBooksPage extends StatefulWidget {
  AddBooksPage({super.key});

  @override
  _AddBooksPageState createState() => _AddBooksPageState();
}

class _AddBooksPageState extends State<AddBooksPage> {
  String? _selectedCategory;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  BackendService _backendService = BackendService();
  String? _selectedPdfPath;
  String? _selectedCoverPath;
  bool _isPdfSelected = false;
  bool _isCoverSelected = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final categories =
          Provider.of<CategoryProvider>(context, listen: false).categories;
      if (categories.isNotEmpty) {
        setState(() {
          _selectedCategory = categories[0];
        });
      }
      print('Initial categories: $categories');
    });
  }

  void _showAddCategoryDialog(CategoryProvider categoryProvider) {
    TextEditingController _categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Category"),
          content: TextField(
            controller: _categoryController,
            decoration: const InputDecoration(hintText: "Enter category name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: txt("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String newCategory = _categoryController.text.trim();

                if (newCategory.isNotEmpty) {
                  await categoryProvider.addCategory(newCategory);
                  setState(() {
                    _selectedCategory = newCategory;
                  });
                }
                Navigator.pop(context);
              },
              child: txt("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedPdfPath = result.files.single.path;
        _isPdfSelected = true;
      });
    }
  }

  Future<void> _pickCover() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jped', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedCoverPath = result.files.single.path;
        _isCoverSelected = true;
      });
    }
  }

  Future<void> _addBookToApp(BookProvider bookProvider) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedCategory != null &&
        _selectedPdfPath != null &&
        _selectedCoverPath != null) {
      BookModel book = BookModel(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory!,
        bookUrl: null,
        bookCoverUrl: null,
      );

      try {
        await bookProvider.addBook(
            book, _selectedPdfPath!, _selectedCoverPath!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add book: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select a PDF file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.sizeOf(context).width;
    double sH = MediaQuery.sizeOf(context).height;
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: customAppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
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
                    controller: _titleController,
                    validate: true,
                    maxLines: 1,
                  ),
                  SpacingWidget(height: 0.02),
                  CustomTextField(
                    hintText: "Book Description",
                    controller: _descriptionController,
                    validate: true,
                    maxLines: 5,
                  ),
                  SpacingWidget(height: 0.02),
                  CustomDropdown<String>(
                    decoration: CustomDropdownDecoration(
                      closedBorder: Border.all(
                        color: AppColors.primaryButtonColor,
                        width: 1.0,
                      ),
                      closedBorderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    listItemBuilder: (context, item, isSelected, onItemSelect) {
                      return Container(
                        child: txt(item),
                      );
                    },
                    hintText: 'Select job role',
                    items: categoryProvider.categories,
                    initialItem: _selectedCategory,
                    onChanged: (value) {
                      if (value == 'Add new category') {
                        _showAddCategoryDialog(categoryProvider);
                      } else {
                        setState(() {
                          _selectedCategory = value;
                          print('Selected category: $value');
                        });
                      }
                    },
                  ),
                  SpacingWidget(height: 0.02),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    color: AppColors.primaryButtonColor,
                    child: InkWell(
                      onTap: _pickFile,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: SizedBox(
                          height: sH * 0.2,
                          width: sW,
                          child: _isPdfSelected
                              ? PDFView(
                                  filePath: _selectedPdfPath!,
                                  autoSpacing: false,
                                  enableSwipe: false,
                                  swipeHorizontal: false,
                                  pageSnap: false,
                                  fitPolicy: FitPolicy.HEIGHT,
                                  onRender: (_pages) {
                                    setState(() {
                                      // Optionally, you can handle the number of pages rendered
                                    });
                                  },
                                  onError: (error) {
                                    print(error.toString());
                                  },
                                  onPageError: (page, error) {
                                    print('$page: ${error.toString()}');
                                  },
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.post_add,
                                      size: sH * 0.05,
                                      color: AppColors.borderColor
                                          .withOpacity(0.5),
                                    ),
                                    txt("Add Book")
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  SpacingWidget(height: 0.02),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    color: AppColors.primaryButtonColor,
                    child: InkWell(
                      onTap: _pickCover,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: SizedBox(
                          height: sH * 0.2,
                          width: sW,
                          child: _isCoverSelected
                              ? Image(
                                  image: FileImage(File(_selectedCoverPath!)),
                                  fit: BoxFit.fitHeight,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.post_add,
                                      size: sH * 0.05,
                                      color: AppColors.borderColor
                                          .withOpacity(0.5),
                                    ),
                                    txt("Add Cover")
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  SpacingWidget(height: 0.02),
                  InkWell(
                    onTap: () => _addBookToApp(bookProvider),
                    child: Container(
                      height: sH * 0.065,
                      width: sW,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppColors.primaryButtonColor,
                      ),
                      child: Center(
                        child: txt(
                          "Add Book to App",
                          color: AppColors.whiteTextColor,
                          weight: FontWeight.w600,
                          size: sH * 0.018,
                        ),
                      ),
                    ),
                  ),
                  SpacingWidget(
                    height: 0.05,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

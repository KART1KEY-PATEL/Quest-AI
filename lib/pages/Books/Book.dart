import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/providers/book_provider.dart';
import 'package:questias/providers/category_provider.dart';
import 'package:questias/models/book_model.dart';
import 'package:questias/pages/Books/sub_pages/view_book.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';

class BookPage extends StatefulWidget {
  BookPage({super.key});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  String selectedCategory = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);

      await bookProvider.fetchBooks();
      await categoryProvider.fetchCategories();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // List<Color> colors = const [
  //   Color(0xFF2d0c1d), // dark-purple
  //   Color(0xFF2b1224), // dark-purple-2
  //   Color(0xFF291830), // dark-purple-3
  //   Color(0xFF1e162a), // dark-purple-4
  //   Color(0xFF231b35), // dark-purple-5
  //   Color(0xFF23223d), // space-cadet
  //   Color(0xFF1e3447), // prussian-blue
  //   Color(0xFF142135), // oxford-blue
  //   Color(0xFF161b2e), // oxford-blue-2
  //   Color(0xFF13152a), // oxford-blue-3
  // ];
  // List<Color> colors = const [
  //   Color(0xFFB8F2E6),
  //   Color(0xFFFFA69E),
  //   Color(0xFFFAF3DD),
  //   Color(0xFFAED9E0),
  //   Color(0xFFdde5b6),
  //   Color(0xFFf0ead2),
  //   Color(0xFFf0ead2),
  // ];
  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;

    final bookProvider = Provider.of<BookProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    List<BookModel> filteredBooks = selectedCategory == 'All'
        ? bookProvider.books
        : bookProvider.books
            .where((book) => book.category == selectedCategory)
            .toList();

    List<String> categories = [
      'All',
      ...categoryProvider.categories
          .where((category) => category != 'Add new category')
    ];

    return Scaffold(
      appBar: customAppBar(
        title: "EBooks",
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sW * 0.02,
                vertical: sH * 0.02,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: sH * 0.05,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          String category = categories[index];
                          bool isSelected = category == selectedCategory;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryButtonColor
                                        .withOpacity(0.7)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: AppColors.primaryButtonColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: sW * 0.03,
                                vertical: sW * 0.02,
                              ),
                              child: Center(
                                child: txt(
                                  category,
                                  weight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primaryButtonColor,
                                  size: sW * 0.037,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemCount: categories.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: filteredBooks.isEmpty
                            ? Center(
                                child: Text(
                                  'No books available',
                                  style: TextStyle(fontSize: sW * 0.04),
                                ),
                              )
                            : selectedCategory == "All"
                                ? ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 20,
                                    ),
                                    itemCount:
                                        categoryProvider.categories.length - 1,
                                    itemBuilder: (context, index) {
                                      List<BookModel> categoriedBooks =
                                          bookProvider.books
                                              .where(
                                                (book) =>
                                                    book.category ==
                                                    categoryProvider.categories
                                                        .elementAt(index),
                                              )
                                              .toList();
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          categoriedBooks.length == 0
                                              ? SizedBox()
                                              : txt(
                                                  categoryProvider.categories
                                                      .elementAt(index),
                                                  size: sW * 0.05,
                                                  isBold: true,
                                                ),
                                          SizedBox(
                                            height: sH * 0.02,
                                          ),
                                          SizedBox(
                                            height: sH * 0.25,
                                            child: ListView.separated(
                                              separatorBuilder:
                                                  (context, index) =>
                                                      SizedBox(width: 10),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: categoriedBooks.length,
                                              itemBuilder:
                                                  (context, bookIndex) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewPdf(
                                                          title:
                                                              categoriedBooks[
                                                                      bookIndex]
                                                                  .title!,
                                                          pdfUrl:
                                                              categoriedBooks[
                                                                      bookIndex]
                                                                  .bookUrl!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .secondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      // color: Colors.amber,
                                                    ),
                                                    width: sW * 0.4,
                                                    padding: EdgeInsets.all(
                                                        sW * 0.02),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: sH * 0.12,
                                                          width: sW,

                                                          // fit: BoxFit.cover,

                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            image:
                                                                DecorationImage(
                                                                    image:
                                                                        NetworkImage(
                                                                      categoriedBooks[
                                                                              bookIndex]
                                                                          .bookCoverUrl!,
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: sH * 0.01),
                                                        txt(
                                                          categoriedBooks[
                                                                  bookIndex]
                                                              .title!,
                                                          size: sW * 0.045,
                                                          isBold: true,
                                                          maxLine: 1,
                                                        ),
                                                        SizedBox(
                                                            height: sH * 0.005),
                                                        txt(
                                                          maxLine: 3,
                                                          color:
                                                              Color(0xff919191),
                                                          categoriedBooks[
                                                                  bookIndex]
                                                              .description!,
                                                          size: sW * 0.035,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: sH * 0.02,
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : GridView.builder(
                                    padding: EdgeInsets.all(10),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing:
                                          sW * 0.04, // Spacing between columns
                                      mainAxisSpacing:
                                          sH * 0.02, // Spacing between rows
                                      childAspectRatio: (sW * 0.31) /
                                          (sH *
                                              0.20), // Aspect ratio of the child
                                    ),
                                    itemCount: filteredBooks.length,
                                    itemBuilder: (context, index) {
                                      BookModel book = filteredBooks[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryColor,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: sW * 0.02,
                                          vertical: sH * 0.01,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: sH * 0.12,
                                              width: sW,

                                              // fit: BoxFit.cover,

                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                      book.bookCoverUrl!,
                                                    ),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            SizedBox(height: sH * 0.01),
                                            txt(
                                              book.title,
                                              size: sW * 0.045,
                                              isBold: true,
                                              maxLine: 1,
                                            ),
                                            SizedBox(height: sH * 0.005),
                                            txt(
                                              book.description,
                                              maxLine: 2,
                                              color: const Color(0xff919191),
                                              size: sW * 0.035,
                                            ),
                                            Spacer(),
                                            Container(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewPdf(
                                                        title: book.title!,
                                                        pdfUrl: book.bookUrl!,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: txt(
                                                  'Read',
                                                  color: Colors.white,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors
                                                      .primaryButtonColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addBook');
        },
        child: Icon(
          Icons.add,
          size: sH * 0.035,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/customAppBar.dart';
import 'package:questias/utils/textUtil.dart';

class BookPage extends StatelessWidget {
  BookPage({super.key});
  List<Color> colors = [
    Color(0xFFB8F2E6),
    Color(0xFFFFA69E),
    Color(0xFFFAF3DD),
    Color(0xFFAED9E0),
    Color(0xFFdde5b6),
    Color(0xFFf0ead2),
    Color(0xFFf0ead2),
  ];
  Map<String, Map<String, Map<String, String>>> upscBooks = {
    'History': {
      'India\'s Ancient Past': {
        'title': 'India\'s Ancient Past',
        'description':
            'A comprehensive guide to ancient Indian history by R.S. Sharma.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'Ancient India': {
        'title': 'Ancient India',
        'description': 'A detailed book on ancient Indian history by Lucent.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'Medieval India': {
        'title': 'Medieval India',
        'description':
            'A detailed book on medieval Indian history by Satish Chandra.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'History of Medieval India': {
        'title': 'History of Medieval India',
        'description':
            'A comprehensive book on medieval Indian history by J.L. Mehta.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'India\'s Struggle for Independence': {
        'title': 'India\'s Struggle for Independence',
        'description':
            'An in-depth look at modern Indian history by Bipan Chandra.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'Plassey to Partition': {
        'title': 'Plassey to Partition',
        'description':
            'A comprehensive book on modern Indian history by Sekhar Bandyopadhyay.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
    },
    'Geography': {
      'Certificate Physical and Human Geography': {
        'title': 'Certificate Physical and Human Geography',
        'description':
            'An excellent book for physical and human geography by Goh Cheng Leong.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'Fundamentals of Physical Geography': {
        'title': 'Fundamentals of Physical Geography',
        'description': 'A comprehensive guide on physical geography by NCERT.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'Oxford School Atlas': {
        'title': 'Oxford School Atlas',
        'description':
            'A comprehensive atlas for all geographical maps and data.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'World Geography': {
        'title': 'World Geography',
        'description':
            'An informative book on world geography by Majid Husain.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
    },
    'Polity': {
      'Indian Polity': {
        'title': 'Indian Polity',
        'description': 'A must-read book for Indian polity by M. Laxmikanth.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'Introduction to the Constitution of India': {
        'title': 'Introduction to the Constitution of India',
        'description': 'A detailed book on Indian constitution by D.D. Basu.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
    },
    'Economy': {
      'Indian Economy': {
        'title': 'Indian Economy',
        'description': 'An in-depth book on Indian economy by Ramesh Singh.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'Economics by Sriram IAS': {
        'title': 'Economics by Sriram IAS',
        'description':
            'A comprehensive guide on Indian economy for UPSC aspirants.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
    },
    'Environment': {
      'Environment By Shankar IAS': {
        'title': 'Environment By Shankar IAS',
        'description':
            'A comprehensive book on environmental issues and ecology.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'Environment and Ecology': {
        'title': 'Environment and Ecology',
        'description':
            'An in-depth book on environment and ecology by P.D. Sharma.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
    },
    'Science and Technology': {
      'Science and Technology in India': {
        'title': 'Science and Technology in India',
        'description':
            'A detailed book covering all aspects of science and technology relevant to UPSC.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'Science and Technology by Ravi Agrahari': {
        'title': 'Science and Technology by Ravi Agrahari',
        'description':
            'An excellent resource for understanding science and technology topics.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
    },
    'Current Affairs': {
      'Manorama Yearbook': {
        'title': 'Manorama Yearbook',
        'description':
            'A comprehensive guide for current affairs and general knowledge.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'India Year Book': {
        'title': 'India Year Book',
        'description':
            'An authoritative book on current affairs and important data published by the Government of India.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
    },
    'Ethics': {
      'Lexicon for Ethics, Integrity & Aptitude': {
        'title': 'Lexicon for Ethics, Integrity & Aptitude',
        'description':
            'A comprehensive guide on ethics, integrity, and aptitude for UPSC GS Paper IV.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
      'Ethics in Governance': {
        'title': 'Ethics in Governance',
        'description': 'A detailed book on ethics and governance issues.',
        'image': 'assets/images/lucent_bookcover.jpg',
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: customAppBar(
        title: "EBooks",
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: sH * 0.04,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    String section = upscBooks.keys.elementAt(index);
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryButtonColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: sW * 0.02,
                        vertical: sW * 0.02,
                      ),
                      child: Center(
                        child: txt(
                          section,
                          color: AppColors.primaryButtonColor,
                          size: sW * 0.035,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: upscBooks.keys.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: sH * 0.02,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, sectionIndex) {
                  String section = upscBooks.keys.elementAt(sectionIndex);
                  Map<String, Map<String, String>> books = upscBooks[section]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      txt(
                        section,
                        size: sW * 0.05,
                        isBold: true,
                      ),
                      SizedBox(
                        height: sH * 0.02,
                      ),
                      Container(
                        height: sH * 0.25,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: books.keys.length,
                          itemBuilder: (context, bookIndex) {
                            String bookTitle = books.keys.elementAt(bookIndex);
                            Map<String, String> bookDetails = books[bookTitle]!;
                            return Container(
                              decoration: BoxDecoration(
                                color: colors[bookIndex % colors.length],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: sW * 0.4,
                              padding: EdgeInsets.all(sW * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.asset(
                                      bookDetails['image']!,
                                      height: sH * 0.12,
                                      width: sW * 0.18,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: sH * 0.01),
                                  txt(
                                    bookDetails['title']!,
                                    size: sW * 0.04,
                                    isBold: true,
                                    maxLine: 1,
                                  ),
                                  SizedBox(height: sH * 0.005),
                                  txt(
                                    maxLine: 3,
                                    color: Color(0xff919191),
                                    bookDetails['description']!,
                                    size: sW * 0.03,
                                  ),
                                ],
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
                childCount: upscBooks.keys.length,
              ),
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

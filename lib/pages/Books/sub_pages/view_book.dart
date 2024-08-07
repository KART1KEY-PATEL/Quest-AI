import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:questias/utils/customAppBar.dart';

class ViewPdf extends StatefulWidget {
  final String title;
  final String pdfUrl;

  ViewPdf({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  String? localPdfPath;

  @override
  void initState() {
    super.initState();
    downloadAndSavePdf();
  }

  Future<void> downloadAndSavePdf() async {
    try {
      // Get the document directory
      final dir = await getApplicationDocumentsDirectory();

      // Define the path for the file to be saved
      final file = File('${dir.path}/temp.pdf');

      // Download the PDF
      final response = await http.get(Uri.parse(widget.pdfUrl));

      // Check if the download was successful
      if (response.statusCode == 200) {
        // Save the file locally
        await file.writeAsBytes(response.bodyBytes);

        // Update the state to use the local path
        setState(() {
          localPdfPath = file.path;
        });
      } else {
        print('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: widget.title),
      body: localPdfPath == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPdfPath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onRender: (pages) => print('Document rendered with $pages pages'),
              onError: (error) => print('Error while rendering PDF: $error'),
              onPageError: (page, error) =>
                  print('Error on page $page: $error'),
              onViewCreated: (PDFViewController pdfViewController) {
                print('PDF View created');
              },
            ),
    );
  }
}

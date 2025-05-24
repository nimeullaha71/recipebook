import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(RecipeBookApp());
}

class RecipeBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: RecipeHomePage(),
    );
  }
}

class RecipeHomePage extends StatefulWidget {
  @override
  _RecipeHomePageState createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  List<String> recipes = [
    'pasta.pdf',
    'chocolate_cake.pdf',
    'chicken_curry.pdf',
  ];

  Future<String> loadPDF(String assetPath) async {
    final ByteData data = await rootBundle.load('assets/$assetPath');
    final Uint8List bytes = data.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$assetPath');

    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  void openRecipe(String fileName) async {
    String filePath = await loadPDF(fileName);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PDFViewerScreen(pdfPath: filePath)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Book')),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.picture_as_pdf, color: Colors.orange),
            title: Text(recipes[index].replaceAll('.pdf', '').replaceAll('_', ' ')),
            onTap: () => openRecipe(recipes[index]),
          );
        },
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  PDFViewerScreen({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recipe Viewer")),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        fitEachPage: false,
        fitPolicy: FitPolicy.BOTH,
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class DiseaseAnalysis {
  final String diseaseName;
  final String affectedPercentage;
  final String possibleCause;
  final String chemicalCure;
  final String organicCure;
  final String yieldImpact;
  final String soilImpact;

  DiseaseAnalysis({
    this.diseaseName = "N/A",
    this.affectedPercentage = "N/A",
    this.possibleCause = "N/A",
    this.chemicalCure = "N/A",
    this.organicCure = "N/A",
    this.yieldImpact = "N/A",
    this.soilImpact = "N/A",
  });

  factory DiseaseAnalysis.fromString(String textResponse) {
    try {
      final map = <String, String>{};
      final lines = textResponse.split('\n');
      for (var line in lines) {
        final parts = line.split(':');
        if (parts.length > 1) {
          final key = parts[0].replaceAll('**', '').trim();
          final value = parts.sublist(1).join(':').trim();
          map[key] = value;
        }
      }
      return DiseaseAnalysis(
        diseaseName: map['Disease Name'] ?? "Could not determine disease name.",
        affectedPercentage: map['Percentage of Leaf Affected'] ?? "N/A",
        possibleCause: map['Possible Cause'] ?? "No cause provided.",
        chemicalCure: map['Chemical Cure'] ?? "No chemical cure provided.",
        organicCure: map['Organic Cure'] ?? "No organic cure provided.",
        yieldImpact: map['Yield Impact'] ?? "No yield impact information provided.",
        soilImpact: map['Soil Impact'] ?? "No soil impact information provided.",
      );
    } catch (e) {
      return DiseaseAnalysis(
        diseaseName: "Failed to parse analysis",
        possibleCause: "The response from the AI was not in the expected format. Raw response:\n\n$textResponse",
      );
    }
  }
}

class DiseaseDetectionPage extends StatefulWidget {
  const DiseaseDetectionPage({super.key});

  @override
  State<DiseaseDetectionPage> createState() => _DiseaseDetectionPageState();
}

class _DiseaseDetectionPageState extends State<DiseaseDetectionPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  DiseaseAnalysis? _analysisResult;
  bool _isLoading = false;
  String? _error;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _analysisResult = null;
          _error = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Failed to pick image. Please check permissions.";
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) {
      setState(() => _error = "Please select an image first.");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _analysisResult = null;
    });

    try {
      final apiKey = "AIzaSyDICq5Np1b_UkX888QjGGBgjUQrnxizp38";
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("GEMINI_API_KEY not found in .env file.");
      }

      final model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
      final prompt = TextPart(
          "Analyze the provided image of a plant leaf. Identify any diseases. "
          "Provide a detailed analysis in the following format, and only this format. Be specific and practical for a farmer.\n"
          "**Disease Name:** [Name of the disease]\n"
          "**Percentage of Leaf Affected:** [Estimated percentage, e.g., 25%]\n"
          "**Possible Cause:** [Briefly describe the likely cause]\n"
          "**Chemical Cure:** [Suggest specific pesticides, including application rates and methods.]\n"
          "**Organic Cure:** [Suggest specific organic or biological control methods.]\n"
          "**Yield Impact:** [Describe the potential impact on crop yield if left untreated and the expected outcome with treatment.]\n"
          "**Soil Impact:** [Describe how the recommended treatments (both chemical and organic) might affect long-term soil health.]");

      final imageBytes = await _image!.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([Content.multi([prompt, imagePart])]);

      if (response.text != null) {
        setState(() {
          _analysisResult = DiseaseAnalysis.fromString(response.text!);
        });
      } else {
        throw Exception("Received an empty response from the API.");
      }
    } catch (e) {
      setState(() {
        _error = "Failed to analyze image. Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identify Plant Disease'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _image != null
                  ? ClipRRect(borderRadius: BorderRadius.circular(15.0), child: Image.file(_image!, fit: BoxFit.cover))
                  : const Center(child: Text('Select an image to analyze', style: TextStyle(color: Colors.grey))),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _image == null || _isLoading ? null : _analyzeImage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Analyze Disease'),
            ),
            const SizedBox(height: 30),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            if (_analysisResult != null)
              _buildResultsCard(_analysisResult!),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCard(DiseaseAnalysis result) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Analysis Result', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
            const Divider(height: 20),
            _buildResultRow(Icons.bug_report, 'Disease Name', result.diseaseName),
            _buildResultRow(Icons.pie_chart, 'Affected', result.affectedPercentage),
            _buildResultRow(Icons.biotech, 'Possible Cause', result.possibleCause),
            _buildResultRow(Icons.science_outlined, 'Chemical Cure', result.chemicalCure),
            _buildResultRow(Icons.eco_outlined, 'Organic Cure', result.organicCure),
            _buildResultRow(Icons.trending_up, 'Yield Impact', result.yieldImpact),
            _buildResultRow(Icons.grass, 'Soil Impact', result.soilImpact),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(content, style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:armyapp/faq_service.dart';
import 'package:armyapp/models/faqmodel.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FAQScreen> {
  List<FAQ> _faqs = [];
  final OnlineService _onlineService = OnlineService();

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  Future<void> _loadFaqs() async {
    try {
      final faqs = await _onlineService.getFaqs();
      setState(() {
        _faqs = faqs.map((faqJson) => FAQ.fromJson(faqJson)).toList();
      });
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Frequently Asked Questions',
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[900],
      ),
      body: _faqs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _faqs.length,
              itemBuilder: (context, index) {
                return FAQTile(
                  faq: _faqs[index],
                );
              },
            ),
    );
  }
}

class FAQTile extends StatefulWidget {
  final FAQ faq;

  const FAQTile({super.key, required this.faq});

  @override
  _FAQTileState createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Icon(
            Icons.question_answer,
            color: Colors.green[900],
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
            widget.faq.question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
        ],
      ),
      onExpansionChanged: (value) {
        setState(() {
          _isExpanded = value;
        });
      },
      initiallyExpanded: _isExpanded,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                color: const Color.fromARGB(200, 246, 244, 244),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.faq.answer,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
